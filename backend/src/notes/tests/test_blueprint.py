import unittest
from parameterized import parameterized
from app import app


class TestNotes(unittest.TestCase):

    def setUp(self):
        self.app = app
        self.app.config['TESTING'] = True
        self.client = app.test_client()

    @parameterized.expand((
        ['/v1/notes', 200],
        ['/v1/notes/10', 200],
        ['/v1/notes/100', 404],
    ))
    def test_status_codes(self, path, status_code):
        response = self.client.get(path)
        self.assertEqual(response.status_code, status_code)
