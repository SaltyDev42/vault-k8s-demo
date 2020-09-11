from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

## db table Class
class ccn_fpe(db.Model):
#    __tablename__ = 'ccn'

    _id = db.Column(db.Integer, primary_key=True)
    tweak = db.Column(db.String())
    cc = db.Column(db.String())

    def __init__(self, cc, tweak):
        self.tweak = tweak
        self.cc    = cc

    def __repr__(self):
        return f"<{__name__}.Car cc={self.cc}, tweak={self.tweak} @ {hex(id(self))}>"
