FROM python:3.11-slim
RUN useradd -m -u 10001 appuser
WORKDIR /app
COPY app /app/app
RUN pip install --no-cache-dir fastapi==0.115.2 uvicorn==0.30.6
USER appuser
EXPOSE 7000
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","7000"]
