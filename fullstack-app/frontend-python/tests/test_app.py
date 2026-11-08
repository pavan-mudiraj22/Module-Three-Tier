import unittest
from unittest.mock import Mock, patch

import requests

import app as frontend


class FrontendRoutesTest(unittest.TestCase):
    def setUp(self):
        frontend.app.config["TESTING"] = True
        self.client = frontend.app.test_client()

    @patch("app.api_request")
    def test_index_displays_tasks(self, api_request):
        api_request.return_value.json.return_value = [
            {"id": 1, "title": "Test task", "completed": False}
        ]
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Test task", response.data)

    @patch("app.api_request")
    def test_create_task_posts_to_backend(self, api_request):
        response = self.client.post("/tasks", data={"title": "New task"})
        self.assertEqual(response.status_code, 302)
        api_request.assert_called_once_with("POST", "/api/tasks", json={"title": "New task"})

    @patch("app.api_request", side_effect=requests.ConnectionError())
    def test_index_shows_backend_unavailable_message(self, api_request):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Could not reach the Java API", response.data)


if __name__ == "__main__":
    unittest.main()
