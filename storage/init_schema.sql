CREATE TABLE IF NOT EXISTS audit_records (
  id SERIAL PRIMARY KEY,
  request_id TEXT,
  created_at TIMESTAMP DEFAULT now(),
  status TEXT
);
