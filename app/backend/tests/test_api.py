from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_checkin_checkout_and_list():
    resp = client.post('/checkin', json={'user': 'alice'})
    assert resp.status_code == 200
    data = resp.json()
    assert data['user'] == 'alice'
    assert data['event_type'] == 'checkin'

    resp = client.post('/checkout', json={'user': 'alice'})
    assert resp.status_code == 200
    data = resp.json()
    assert data['event_type'] == 'checkout'

    resp = client.get('/events')
    assert resp.status_code == 200
    assert isinstance(resp.json(), list)
