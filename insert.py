import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 
import pika
import sys
import json
import pandas as pd
import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras.models import load_model
from sklearn.preprocessing import StandardScaler
import random
import mysql.connector

model_soc = load_model('est.SoCNMC')
print("load model done")

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.exchange_declare(exchange='topic_logs', exchange_type='topic')

result = channel.queue_declare('', exclusive=True)
queue_name = result.method.queue


binding_keys = ['bms-raw']
for binding_key in binding_keys:
    channel.queue_bind(
        exchange='topic_logs', queue=queue_name, routing_key=binding_key)


print(' [*] Waiting for logs. To exit press CTRL+C')

def read_value(body):
    json_val = json.loads(body.decode("utf-8"))
    val = json_val["value"]
    data = pd.DataFrame.from_dict(val)
    data['soc'] = model_soc.predict(data['voltage'])
    data['soc'] = data['soc'].apply(lambda x:round(x,2))
    data.loc[data.soc > 100, 'soc'] = 100
    print(data)
    return data

def value_insert(data):
    mydb = mysql.connector.connect(host = 'localhost',user="energy",password='energypass',database="rabbit")
    mycursor = mydb.cursor()
    val = []
    for i in range (0, len(data)) :
      val.append(( int(data['modul'][i]),float(data['voltage'][i]),float(data['temperature'][i]),float(data['soc'][i]) ))
    sql = "INSERT INTO battery (modul,voltage,temperature,soc) VALUES (%s,%s,%s,%s)"
    mycursor.executemany(sql, val)
    mydb.commit()
    mycursor.close()
    mydb.close()
    print("success")

def send_value(data) :
    send_val = {}
    send = data.to_dict('records')
    send_val["value"] = send
    json_object = json.dumps(send_val, indent = 4) 
    result = str(json_object)
      
    routing_key = 'bms-value'
    channel.basic_publish(exchange='topic_logs', routing_key=routing_key, body=result)
    print("sent")

def callback(ch, method, properties, body):
    try :
      data = read_value(body)
      value_insert(data)
      send_value(data)
      
    except :
      print("error")

channel.basic_consume(
    queue=queue_name, on_message_callback=callback, auto_ack=True)

channel.start_consuming()