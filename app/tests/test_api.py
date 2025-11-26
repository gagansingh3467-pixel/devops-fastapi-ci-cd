from fastapi.testclient import TestClient
from app.app import app

client = TestClient(app)

def test_root():
    r = client.get("/")
    assert r.status_code == 200
    assert "message" in r.json()

def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"

def test_create_and_get_item():
    new_item = {"id": "2", "name": "Test", "price": 12.34}
    r = client.post("/items", json=new_item)
    assert r.status_code == 201

    get = client.get("/items/2")
    assert get.status_code == 200
    assert get.json()["name"] == "Test"
