import http.server
import os
import sys

PORT = int(os.environ.get("PORT", "3000"))
DIST_DIR = os.path.join(os.path.dirname(__file__), "dist")

class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIST_DIR, **kwargs)

    def do_GET(self):
        # Support Single Page Application (SPA) HTML5 History router
        path = self.translate_path(self.path)
        if not os.path.exists(path) and not self.path.startswith("/api"):
            self.path = "/index.html"
        return super().do_GET()

if __name__ == "__main__":
    print(f"Starting Urumi Web Console on 0.0.0.0:{PORT} from {DIST_DIR}...")
    httpd = http.server.ThreadingHTTPServer(("0.0.0.0", PORT), SPAHandler)
    httpd.serve_forever()
