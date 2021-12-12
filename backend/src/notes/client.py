
class NoteClient(object):

    def __init__(self, total_notes=84):
        self.notes     = list()
        self.notes_map = dict()

        for x in range(total_notes):
            user = {
                'note_id': x,
                'note': 'Note #{}'.format(x),
            }
            self.notes.append(user)
            self.notes_map[x] = user

    @property
    def total_notes(self):
        return len(self.notes)

    def paginate(self, offset, limit):
        return self.notes[offset:offset + limit]

    def get_note(self, note_id):
        return self.notes_map[note_id]
