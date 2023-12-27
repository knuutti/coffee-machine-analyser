import requests
import datetime

file = open("kahvidata.txt", 'r')
data = file.read().splitlines()

for row in data[1:]:
    row = row.split(";")
    url = "http://localhost:8000/data/"
    myobj = {"timestamp": datetime.strptime(row[1].split(".")[0], "), "coffee": float(row[0])}
    #print(myobj)
    requests.post(url, json = myobj)