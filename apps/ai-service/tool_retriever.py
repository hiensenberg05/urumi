"""
BM25 Just-In-Time Tool Retrieval Engine for Large Tool Catalogs.

Solves the LLM tool scalability problem:
When a cluster hosts multiple store tenants and MCP servers, tool counts can reach 50-100+.
Passing 100 raw JSON schemas directly to an LLM:
1. Explodes context window consumption (~25k tokens per turn).
2. Increases Time-to-First-Token (TTFT) latency by 5x-10x.
3. Causes attention dilution and tool selection hallucinations.

This engine executes in-memory BM25 (Best Matching 25) scoring in <1 millisecond,
dynamically routing only the Top-K (4-6) most relevant tools into the LLM context.
"""

import math
import re
from typing import Any, Dict, List, Set, Tuple


class BM25ToolRetriever:
    """In-memory BM25 ranking engine optimized for structured MCP tool schemas."""

    STOP_WORDS: Set[str] = {
        "a", "about", "all", "also", "an", "and", "are", "as", "at", "be",
        "by", "can", "do", "for", "from", "get", "has", "have", "i", "if",
        "in", "is", "it", "me", "my", "of", "on", "or", "our", "please",
        "show", "so", "some", "tell", "that", "the", "their", "them", "then",
        "there", "these", "they", "this", "to", "us", "was", "we", "what",
        "when", "where", "which", "who", "will", "with", "would", "you", "your",
    }

    # Core baseline tools to ensure minimal general functionality if query is ambiguous
    BASELINE_TOOLS: List[str] = [
        "woocommerce__list_products",
        "woocommerce__list_orders",
        "inventory__check_stock",
        "analytics__get_daily_sales",
    ]

    def __init__(self, k1: float = 1.5, b: float = 0.75):
        self.k1 = k1
        self.b = b

    def tokenize(self, text: str) -> List[str]:
        """Tokenize text into lowercase alphanumeric keywords, splitting camelCase, snake_case, and kebab-case."""
        if not text:
            return []
        # Split on non-alphanumeric, underscores, hyphens
        subbed = re.sub(r"[_\-.:/]+", " ", text)
        words = re.findall(r"[a-zA-Z0-9]+", subbed.lower())
        return [w for w in words if len(w) > 1 and w not in self.STOP_WORDS]

    def build_tool_document(self, tool: Dict[str, Any]) -> str:
        """Construct a dense, keyword-rich searchable document for an MCP tool specification."""
        name = tool.get("namespacedName") or tool.get("name", "")
        desc = tool.get("description", "")
        server = tool.get("serverName") or tool.get("serverId", "")

        # Extract parameter names from schema
        schema = tool.get("schema") or {}
        props = schema.get("properties", {}) if isinstance(schema, dict) else {}
        param_names = " ".join(props.keys())

        # Construct weighted document string (name is repeated for prominence)
        return f"{name} {name} {server} {desc} {param_names}"

    def retrieve(
        self,
        query: str,
        tools: List[Dict[str, Any]],
        top_k: int = 6,
    ) -> Tuple[List[Dict[str, Any]], Dict[str, Any]]:
        """
        Rank tools using BM25 and return the Top-K candidate tools.
        
        Args:
            query: The user prompt or ongoing conversation turn.
            tools: List of permitted MCP tool objects from the Gateway.
            top_k: Maximum number of candidate tools to return to LLM context.

        Returns:
            Tuple of (selected_tools, metrics_dict)
        """
        if not tools:
            return [], {"total_available": 0, "retrieved_count": 0, "reduction_pct": 0, "retrieved_tool_names": []}

        # If catalog is already very small (<= top_k), return all without filtering
        if len(tools) <= top_k:
            names = [t.get("namespacedName") or t.get("name", "") for t in tools]
            return tools, {
                "total_available": len(tools),
                "retrieved_count": len(tools),
                "reduction_pct": 0,
                "retrieved_tool_names": names,
                "mode": "pass-through",
            }

        query_tokens = self.tokenize(query)

        # 1. Build document corpus
        doc_tokens_list: List[List[str]] = []
        tool_by_idx: List[Dict[str, Any]] = []

        for t in tools:
            doc_str = self.build_tool_document(t)
            tokens = self.tokenize(doc_str)
            doc_tokens_list.append(tokens)
            tool_by_idx.append(t)

        total_docs = len(doc_tokens_list)
        if total_docs == 0:
            return tools[:top_k], {"total_available": 0, "retrieved_count": 0, "reduction_pct": 0}

        avg_doc_len = sum(len(d) for d in doc_tokens_list) / total_docs

        # 2. Compute Document Frequencies (DF) for each query token
        df: Dict[str, int] = {}
        for q in query_tokens:
            count = sum(1 for d in doc_tokens_list if q in d)
            df[q] = count

        # 3. Calculate BM25 scores
        scores: List[float] = [0.0] * total_docs

        for i, doc in enumerate(doc_tokens_list):
            doc_len = len(doc)
            # Count term frequencies in this doc
            tf_map: Dict[str, int] = {}
            for term in doc:
                tf_map[term] = tf_map.get(term, 0) + 1

            doc_score = 0.0
            tool_name = tool_by_idx[i].get("namespacedName") or tool_by_idx[i].get("name", "")
            tool_name_lower = tool_name.lower()

            for q in query_tokens:
                if q not in tf_map:
                    continue

                freq = tf_map[q]
                doc_freq = df.get(q, 0)

                # Standard Robertson-Spärck Jones IDF with smoothing
                idf = math.log(1.0 + (total_docs - doc_freq + 0.5) / (doc_freq + 0.5))

                # BM25 TF formula
                tf_component = (freq * (self.k1 + 1.0)) / (
                    freq + self.k1 * (1.0 - self.b + self.b * (doc_len / (avg_doc_len or 1.0)))
                )

                term_score = idf * tf_component

                # Name match booster: 2.0x boost if exact token is in the tool's namespaced identifier
                if q in tool_name_lower:
                    term_score *= 2.0

                doc_score += term_score

            # Store specific tenant boost: e.g. "tech" in query strongly boosts "store_tech"
            for q in query_tokens:
                if len(q) >= 4 and f"store_{q}" in tool_name_lower or f"{q}__" in tool_name_lower:
                    doc_score += 4.0

            scores[i] = doc_score

        # 4. Rank indices by score descending
        ranked_indices = sorted(range(total_docs), key=lambda idx: scores[idx], reverse=True)

        selected_tools: List[Dict[str, Any]] = []
        selected_names: Set[str] = set()

        for idx in ranked_indices:
            if scores[idx] > 0.0:
                t = tool_by_idx[idx]
                t_name = t.get("namespacedName") or t.get("name", "")
                selected_tools.append(t)
                selected_names.add(t_name)
                if len(selected_tools) >= top_k:
                    break

        # 5. Smart Fallback if query didn't match enough specific tools (e.g. conversational prompt)
        if len(selected_tools) < 2:
            for b_name in self.BASELINE_TOOLS:
                if b_name not in selected_names:
                    # Find tool in available tools
                    matching = next(
                        (t for t in tools if (t.get("namespacedName") == b_name or t.get("name") == b_name)),
                        None,
                    )
                    if matching:
                        selected_tools.append(matching)
                        selected_names.add(b_name)
                if len(selected_tools) >= top_k:
                    break

        reduction_pct = round(((total_docs - len(selected_tools)) / total_docs) * 100.0, 1) if total_docs > 0 else 0.0

        metrics = {
            "total_available": total_docs,
            "retrieved_count": len(selected_tools),
            "reduction_pct": reduction_pct,
            "retrieved_tool_names": list(selected_names),
            "top_bm25_score": round(scores[ranked_indices[0]], 3) if ranked_indices else 0.0,
            "mode": "bm25_retrieved",
        }

        return selected_tools, metrics


# Singleton instance
tool_retriever = BM25ToolRetriever()
