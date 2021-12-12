import flask
import flask_restful
from common import request_utils, response_utils
from .client import NoteClient
from . import schemas

blueprint = flask.Blueprint('notes', __name__)
api = flask_restful.Api(blueprint)


class NoteResource(flask_restful.Resource):

    def get(self, note_id=None):
        if note_id:
            return self._get(note_id)
        return self._get_list()

    @response_utils.response_schema(schemas.Note)
    def _get(self, note_id):
        client = NoteClient()

        try:
            note = client.get_note(note_id)

        except KeyError:
            flask.abort(404)

        return note

    @request_utils.request_schema(query=request_utils.PaginatedParams)
    @response_utils.response_schema(schemas.NotePaginated)
    def _get_list(self, request_params):
        offset = request_params.query.get('offset')
        limit = request_params.query.get('limit')

        client = NoteClient()
        notes = client.paginate(offset, limit)

        return {
            'offset': offset,
            'limit': limit,
            'total_items': client.total_notes,
            'items': notes,
        }


api.add_resource(NoteResource, '/notes', '/notes/<int:note_id>')
