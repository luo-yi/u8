import marshmallow as ma


class CommaSeperatedStrings(ma.fields.Field):
    list_type = str

    def _serialize(self, value, attr, obj, **kwargs):
        if value is None:
            return ""

        else:
            return ",".join(str(d) for d in value)

    def _deserialize(self, value, attr, data, **kwargs):
        if not value:
            return []

        else:
            try:
                return [self.list_type(x) for x in value.strip(',').split(',')]

            except ValueError as error:
                raise ma.ValidationError("Not a valid list.") from error


class CommaSeperatedIntegers(CommaSeperatedStrings):
    list_type = int
