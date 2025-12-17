from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import sqlite3
from datetime import datetime
from typing import List

DBPATH = 'data/events.db'

def init_db():
    conn = sqlite3.connect(DBPATH)
    conn.execute('''CREATE TABLE IF NOT EXISTS events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT,
        event_type TEXT,
        timestamp TEXT
    )''')
    conn.commit()
    conn.close()

init_db()

app = FastAPI(title='Attendance Backend')

class EventIn(BaseModel):
    user: str

class EventOut(BaseModel):
    id: int
    user: str
    event_type: str
    timestamp: str

@app.post('/checkin', response_model=EventOut)
def checkin(ev: EventIn):
    ts = datetime.utcnow().isoformat()
    conn = sqlite3.connect(DBPATH)
    cur = conn.cursor()
    cur.execute('INSERT INTO events (user, event_type, timestamp) VALUES (?,?,?)', (ev.user, 'checkin', ts))
    conn.commit()
    id = cur.lastrowid
    conn.close()
    return {'id': id, 'user': ev.user, 'event_type': 'checkin', 'timestamp': ts}

@app.post('/checkout', response_model=EventOut)
def checkout(ev: EventIn):
    ts = datetime.utcnow().isoformat()
    conn = sqlite3.connect(DBPATH)
    cur = conn.cursor()
    cur.execute('INSERT INTO events (user, event_type, timestamp) VALUES (?,?,?)', (ev.user, 'checkout', ts))
    conn.commit()
    id = cur.lastrowid
    conn.close()
    return {'id': id, 'user': ev.user, 'event_type': 'checkout', 'timestamp': ts}

@app.get('/events', response_model=List[EventOut])
def list_events():
    conn = sqlite3.connect(DBPATH)
    cur = conn.cursor()
    cur.execute('SELECT id, user, event_type, timestamp FROM events ORDER BY id DESC LIMIT 100')
    rows = cur.fetchall()
    conn.close()
    return [{'id': r[0], 'user': r[1], 'event_type': r[2], 'timestamp': r[3]} for r in rows]
