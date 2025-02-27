import requests

url = 'https://magicloops.dev/api/loop/Magic_loops_API_KEY_/run'
payload = { "question": "¿Cuáles son algunas atracciones populares en Mexicali?" }

response = requests.get(url, json=payload)
responseJson = response.json()
print(responseJson)