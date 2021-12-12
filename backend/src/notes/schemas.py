import marshmallow as ma
from common import response_utils


class Note(ma.Schema):
    note_id = ma.fields.Integer()
    note    = ma.fields.String()


class NotePaginated(response_utils.PaginatedResponse):
    items = ma.fields.List(ma.fields.Nested(Note))
