from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse

app = FastAPI()

@app.get("/health")
def health():
    return PlainTextResponse("HEALTHY")

@app.get("/ready")
def ready():
    return PlainTextResponse("READY")

@app.post("/infer")
def infer(req: Request):
    return {"result": "inference successful", "status": "ok"}
