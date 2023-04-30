import requests
import json

def writeBack(data):
    
    # Closing file

    f2 = open('Output3.json','w+')
    f2.write(str(data))
    f2.close()

f = open('joe.json')

# returns JSON object as 
# a dictionary
data = json.load(f)

# Iterating through the json
# list


# Closing file
f.close()
json_data = {'name': 'John', 'age': 30}
json_data_str = json.dumps(data)
url = 'http://127.0.0.2:8080'
response = requests.post(url,json=data)
writeBack(response.text)
