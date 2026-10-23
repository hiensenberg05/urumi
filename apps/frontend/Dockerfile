FROM python:3.12-slim

WORKDIR /app
COPY dist ./dist
COPY serve.py .

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=3s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:3000/')" || exit 1

CMD ["python3", "serve.py"]
