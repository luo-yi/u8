from marshmallow import validate


def min_length(min_length):
    error = 'Value must be at least {} characters in length.'.format(min_length)
    return validate.Length(min=min_length, error=error)


def max_length(maxlength):
    error = 'Value cannot be longer than {} characters in length.'.format(min_length)
    return validate.Length(min=min_length, error=error)


def min_value(min_value):
    error = 'Value must be greater than or equal to {}.'.format(min_value)
    return validate.Range(min=min_value, error=error)


def max_value(max_value):
    error = 'Value must not be greater than {}.'.format(max_value)
    return validate.Range(max=max_value, error=error)
