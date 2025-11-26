import os
import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response

logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"))
logger = logging.getLogger("app")

app = FastAPI(title="devops-sample-service")

items = {"1": {"id": "1", "name": "Sample Item", "price": 9.99}}

class Item(BaseModel):
    id: str
    name: str
    price: float

REQUEST_COUNT = Counter(
    "app_requests_total", "Total HTTP requests", ["method", "endpoint", "http_status"]
)

@app.middleware("http")
async def metrics_middleware(request, call_next):
    response = await call_next(request)
    try:
        REQUEST_COUNT.labels(
            method=request.method,
            endpoint=request.url.path,
            http_status=response.status_code
        ).inc()
    except Exception:
        logger.exception("Failed to increment metrics")
    return response

@app.get("/")
def read_root():
    return {"message": "DevOps-ready FastAPI service"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/items/{item_id}", response_model=Item)
def get_item(item_id: str):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return items[item_id]

@app.post("/items", response_model=Item, status_code=201)
def create_item(item: Item):
    if item.id in items:
        raise HTTPException(status_code=409, detail="Item already exists")
    items[item.id] = item.dict()
    return items[item.id]

@app.get("/metrics")
def metrics():
    data = generate_latest()
    return Response(content=data, media_type=CONTENT_TYPE_LATEST)
