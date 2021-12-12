import os
import dotenv
import flask
import flask_cors

from src.common import settings
from src.notes import blueprint as notes_blueprint

dotenv.load_dotenv()

app = flask.Flask(__name__)
flask_cors.CORS(app)

app.register_blueprint(notes_blueprint, url_prefix=settings.API_V1_PREFIX)


@app.route('/health-check')
def health_check():
    return ('healthy!', 200)


@app.route('/<path:path>')
def handle_404(path):
    flask.abort(404)


if __name__ == '__main__':
    port = os.environ.get('FLASK_PORT', 5000)
    app.run(debug=True, host='0.0.0.0', port=port)
