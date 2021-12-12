import functools
import flask


def response_schema(schema):

    def decorator(method):

        @functools.wraps(method)
        def wrapper(self, *args, **kwargs):
            response = method(self, *args, **kwargs)
            serialized_response = schema().dump(response)
            return flask.jsonify(serialized_response)

        return wrapper

    return decorator
