import urllib.request
import json

url = "http://127.0.0.1:80/api/v1/stores"
headers = {
    "Content-Type": "application/json",
    "X-API-Key": "admin-key-urumi-2026",
    "Host": "gateway.local"
}
data = json.dumps({
    "name": "Fashion Boutique",
    "id": "fashion",
    "category": "Fashion & Apparel"
}).encode()

req = urllib.request.Request(url, data=data, headers=headers, method="POST")
try:
    with urllib.request.urlopen(req) as resp:
        print("Status:", resp.status)
        print("Response:", json.loads(resp.read()))
except urllib.error.HTTPError as e:
    print("HTTP Error:", e.code, e.read().decode())
