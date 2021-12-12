import functools
import flask
import marshmallow as ma


class RequestParams(object):

    def __init__(self):
        self.query = dict()
        self.body = dict()

    def load_query_params(self, data, schema):
        self.query = schema().load(data)

    def load_body_params(self, data, schema):
        self.body = schema().load(data)


def request_schema(query=None, body=None):

    def decorator(method):

        @functools.wraps(method)
        def wrapper(self, *args, **kwargs):
            request_params = RequestParams()

            try:
                if query:
                    query_params = flask.request.args.to_dict(flat=True)
                    request_params.load_query_params(query_params, query)

                if body:
                    body_params = flask.request.json
                    request_params.load_body_params(body_params, body)

            except ma.ValidationError as e:
                flask.abort(400, e.messages)

            return method(self, request_params, *args, **kwargs)

        return wrapper

    return decorator
