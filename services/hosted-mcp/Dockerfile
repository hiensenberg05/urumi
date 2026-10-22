FROM urumi/inventory-mcp:v1.1.1

WORKDIR /app

COPY server.py .

EXPOSE 8005

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8005/health')" || exit 1

CMD ["python3", "server.py"]
