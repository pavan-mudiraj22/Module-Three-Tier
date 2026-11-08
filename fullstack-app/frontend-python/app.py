import os

import requests
from flask import Flask, flash, redirect, render_template, request, url_for

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "local-development-only")
BACKEND_API_URL = os.environ.get("BACKEND_API_URL", "http://localhost:8080").rstrip("/")


def api_request(method, path, **kwargs):
    response = requests.request(method, f"{BACKEND_API_URL}{path}", timeout=5, **kwargs)
    response.raise_for_status()
    return response


@app.get("/")
def index():
    try:
        tasks = api_request("GET", "/api/tasks").json()
    except requests.RequestException:
        tasks = []
        flash("Could not reach the Java API. Check that the backend is running.", "error")
    return render_template("index.html", tasks=tasks)


@app.post("/tasks")
def create_task():
    title = request.form.get("title", "").strip()
    if not title:
        flash("Enter a task title.", "error")
        return redirect(url_for("index"))
    try:
        api_request("POST", "/api/tasks", json={"title": title})
        flash("Task added.", "success")
    except requests.RequestException:
        flash("Could not add task. Check the Java API.", "error")
    return redirect(url_for("index"))


@app.post("/tasks/<int:task_id>/toggle")
def toggle_task(task_id):
    completed = request.form.get("completed") == "true"
    try:
        api_request("PATCH", f"/api/tasks/{task_id}", json={"completed": not completed})
    except requests.RequestException:
        flash("Could not update task. Check the Java API.", "error")
    return redirect(url_for("index"))


@app.post("/tasks/<int:task_id>/delete")
def delete_task(task_id):
    try:
        api_request("DELETE", f"/api/tasks/{task_id}")
    except requests.RequestException:
        flash("Could not delete task. Check the Java API.", "error")
    return redirect(url_for("index"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")), debug=False)
