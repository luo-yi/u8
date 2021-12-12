import flask
from werkzeug.urls import url_encode
import marshmallow as ma


class PaginatedResponse(ma.Schema):
    offset        = ma.fields.Int(required=True)
    limit         = ma.fields.Int(required=True)
    total_items   = ma.fields.Int(required=True)
    next_href     = ma.fields.String()  # Populated automatically, included here for clarity.
    previous_href = ma.fields.String()  # Populated automatically, included here for clarity.

    @ma.pre_dump
    def set_next_href(self, data, **kwargs):
        offset, limit, total_items = data['offset'], data['limit'], data['total_items']

        if total_items > (offset + limit):
            new_offset = offset + limit
            data['next_href'] = _create_paginated_url(new_offset, limit)

        return data

    @ma.pre_dump
    def set_previous_href(self, data, **kwargs):
        offset, limit = data['offset'], data['limit']

        if offset > 0:
            new_offset = max(offset - limit, 0)
            data['previous_href'] = _create_paginated_url(new_offset, limit)

        return data


def _create_paginated_url(offset, limit):
    args = flask.request.args.copy()
    args['offset'], args['limit'] = offset, limit
    return '{}?{}'.format(flask.request.base_url, url_encode(args))
