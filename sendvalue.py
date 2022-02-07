import pika
import sys
import random
import json

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
channel.exchange_declare(exchange='topic_logs', exchange_type='topic')
routing_key = 'cluster2.kabinet1.modul1'

def rand_value() :
    data = {}
    value = []
    for x in range (0,10) :
        volt = round(random.uniform(3.9,4.1),2)
        temp = round(random.uniform(25,30),2)
        value.append({"cell_id":x+1,"voltage":volt,"temperature":temp})
    data["value"] = value
    json_object = json.dumps(data, indent = 4) 
    result = str(json_object) 
    return result

bms = rand_value()

print(bms)
channel.basic_publish(
    exchange='topic_logs', routing_key=routing_key, body=bms)
print(" [x] Sent %r:sent value" % (routing_key))
connection.close()