# Python Flask frontend

The Flask app serves the task UI and calls the Java API server-side. Set `BACKEND_API_URL` if the Java service is not at `http://localhost:8080`.

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open http://localhost:5000.
