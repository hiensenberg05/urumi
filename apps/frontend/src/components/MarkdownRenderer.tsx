import React from 'react';

interface MarkdownRendererProps {
  content: string;
}

export const MarkdownRenderer: React.FC<MarkdownRendererProps> = ({ content }) => {
  if (!content) return null;

  // Split text into lines
  const lines = content.split('\n');
  const elements: React.ReactNode[] = [];
  let index = 0;

  // Inline formatter for bold, italic, and inline code
  const renderInline = (text: string): React.ReactNode => {
    if (!text) return null;

    // Pattern for inline tokens: code, bold, italic
    const parts: React.ReactNode[] = [];
    let remaining = text;
    let key = 0;

    while (remaining.length > 0) {
      // Inline Code: `code`
      const codeMatch = remaining.match(/^`([^`]+)`/);
      if (codeMatch) {
        parts.push(
          <code
            key={key++}
            className="px-1.5 py-0.5 rounded bg-brand-surface border border-brand-border text-emerald-300 font-mono text-[11px]"
          >
            {codeMatch[1]}
          </code>
        );
        remaining = remaining.slice(codeMatch[0].length);
        continue;
      }

      // Bold: **text** or __text__
      const boldMatch = remaining.match(/^\*\*([^*]+)\*\*/);
      if (boldMatch) {
        parts.push(
          <strong key={key++} className="font-semibold text-slate-100">
            {renderInline(boldMatch[1])}
          </strong>
        );
        remaining = remaining.slice(boldMatch[0].length);
        continue;
      }

      // Italic: *text* (single asterisk)
      const italicMatch = remaining.match(/^\*([^*]+)\*/);
      if (italicMatch) {
        parts.push(
          <em key={key++} className="italic text-slate-300">
            {renderInline(italicMatch[1])}
          </em>
        );
        remaining = remaining.slice(italicMatch[0].length);
        continue;
      }

      // Plain text character
      const nextSpecial = remaining.search(/[`*]/);
      if (nextSpecial === -1) {
        parts.push(remaining);
        break;
      } else if (nextSpecial > 0) {
        parts.push(remaining.slice(0, nextSpecial));
        remaining = remaining.slice(nextSpecial);
      } else {
        parts.push(remaining[0]);
        remaining = remaining.slice(1);
      }
    }

    return <>{parts}</>;
  };

  while (index < lines.length) {
    const line = lines[index];
    const trimmed = line.trim();

    // 1. Empty lines
    if (!trimmed) {
      index++;
      continue;
    }

    // 2. Code Block: ```...```
    if (trimmed.startsWith('```')) {
      const codeLines: string[] = [];
      const lang = trimmed.slice(3).trim();
      index++;
      while (index < lines.length && !lines[index].trim().startsWith('```')) {
        codeLines.push(lines[index]);
        index++;
      }
      index++; // skip closing ```
      elements.push(
        <div key={elements.length} className="my-2.5 rounded-lg border border-brand-border bg-[#03060c] overflow-hidden">
          {lang && (
            <div className="px-3 py-1 bg-brand-surface/40 border-b border-brand-border/60 text-[10px] font-mono text-slate-400 uppercase tracking-wider">
              {lang}
            </div>
          )}
          <pre className="p-3 text-[11.5px] font-mono text-slate-200 overflow-x-auto leading-relaxed">
            {codeLines.join('\n')}
          </pre>
        </div>
      );
      continue;
    }

    // 3. Markdown Table: starts with | or contains | separators
    if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
      const tableLines: string[] = [];
      while (index < lines.length && lines[index].trim().startsWith('|') && lines[index].trim().endsWith('|')) {
        tableLines.push(lines[index].trim());
        index++;
      }

      if (tableLines.length >= 2) {
        const rawHeaders = tableLines[0].split('|').slice(1, -1);
        const headers = rawHeaders.map(h => h.trim());
        // Second line is separator |---|---|
        const bodyLines = tableLines.slice(2);
        const rows = bodyLines.map(rowLine => rowLine.split('|').slice(1, -1).map(c => c.trim()));

        elements.push(
          <div key={elements.length} className="my-3 overflow-x-auto rounded-lg border border-brand-border bg-[#050810]">
            <table className="w-full text-left text-xs border-collapse">
              <thead>
                <tr className="border-b border-brand-border bg-brand-surface/70 text-slate-200">
                  {headers.map((h, hi) => (
                    <th key={hi} className="px-3.5 py-2.5 font-semibold text-[11px] tracking-wide text-slate-300 uppercase font-mono">
                      {renderInline(h)}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-brand-border/40 font-sans text-xs">
                {rows.map((r, ri) => (
                  <tr key={ri} className="hover:bg-brand-surface/20 transition-colors">
                    {r.map((cell, ci) => (
                      <td key={ci} className="px-3.5 py-2 text-slate-200">
                        {renderInline(cell)}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        );
        continue;
      }
    }

    // 4. Headings: #, ##, ###, ####
    if (trimmed.startsWith('#')) {
      const level = trimmed.match(/^#+/)?.[0].length || 1;
      const title = trimmed.replace(/^#+\s*/, '');
      if (level <= 2) {
        elements.push(
          <h2 key={elements.length} className="text-sm font-bold text-slate-100 mt-3 mb-1.5 flex items-center gap-2">
            {renderInline(title)}
          </h2>
        );
      } else {
        elements.push(
          <h3 key={elements.length} className="text-xs font-semibold text-emerald-400 mt-2.5 mb-1 flex items-center gap-1.5">
            {renderInline(title)}
          </h3>
        );
      }
      index++;
      continue;
    }

    // 5. Bullet Lists: - item, * item, • item
    if (trimmed.startsWith('- ') || trimmed.startsWith('* ') || trimmed.startsWith('• ')) {
      const listItems: string[] = [];
      while (
        index < lines.length &&
        (lines[index].trim().startsWith('- ') || lines[index].trim().startsWith('* ') || lines[index].trim().startsWith('• '))
      ) {
        listItems.push(lines[index].trim().replace(/^[-*•]\s*/, ''));
        index++;
      }

      elements.push(
        <ul key={elements.length} className="my-2 space-y-1 text-xs">
          {listItems.map((item, li) => (
            <li key={li} className="flex items-start gap-2 text-slate-200 leading-relaxed">
              <span className="text-emerald-400 mt-0.5 text-sm leading-none">•</span>
              <span className="flex-1">{renderInline(item)}</span>
            </li>
          ))}
        </ul>
      );
      continue;
    }

    // 6. Horizontal Rule: --- or ***
    if (trimmed === '---' || trimmed === '***') {
      elements.push(<hr key={elements.length} className="my-3 border-brand-border/60" />);
      index++;
      continue;
    }

    // 7. Standard Paragraph
    elements.push(
      <p key={elements.length} className="my-1.5 text-xs text-slate-200 leading-relaxed font-sans">
        {renderInline(trimmed)}
      </p>
    );
    index++;
  }

  return <div className="space-y-1">{elements}</div>;
};
