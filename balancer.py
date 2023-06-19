import requests
import asyncio
import time

first_server_events = {}
second_server_events = {}

def background(f):
    def wrapped(*args, **kwargs):
        return asyncio.get_event_loop().run_in_executor(None, f, *args, **kwargs)

    return wrapped

@background
def send_request(arg):
    resp = requests.get('http://localhost:8080/')
    if resp.text() == "First Server":
        first_server_events[arg] = resp.text()
    else:
        second_server_events[arg] = resp.text()



for i in range(100):
    send_request(i)


time.sleep(5)
print(first_server_events)
print(second_server_events)
