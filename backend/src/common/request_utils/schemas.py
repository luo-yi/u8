import marshmallow as ma
from common.ma_utils import validation as ma_validation


class PaginatedParams(ma.Schema):
    offset = ma.fields.Int(missing=0, validate=[ma_validation.min_value(0)])
    limit  = ma.fields.Int(missing=10, validate=[ma_validation.min_value(5), ma_validation.max_value(100)])


class SortedParams(ma.Schema):
    sort_by  = ma.fields.String(required=False)
    order_by = ma.fields.String(required=False)


class SortedPaginatedParams(PaginatedParams, SortedParams):
    pass
