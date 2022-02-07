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


binding_keys = ['cluster1.#','cluster2.#']
for binding_key in binding_keys:
    channel.queue_bind(
        exchange='topic_logs', queue=queue_name, routing_key=binding_key)
    print("binding keys :")
    print(binding_keys)
    print("queue name")
    print(queue_name)


print(' [*] Waiting for logs. To exit press CTRL+C')



def callback(ch, method, properties, body):
    try :
      json_val = json.loads(body.decode("utf-8"))
      val = json_val["value"]
      data = pd.DataFrame.from_dict(val)
      data['soc'] = model_soc.predict(data['voltage'])
      data['soc'] = data['soc'].apply(lambda x:round(x,2))
      data.loc[data.soc > 100, 'soc'] = 100
      print(data)

      mydb = mysql.connector.connect(host = 'localhost',user="energy",password='energypass',database="rabbit")
      mycursor = mydb.cursor()
      val = []
      for i in range (0, len(data)) :
        val.append(( int(data['cell_id'][i]),float(data['voltage'][i]),float(data['temperature'][i]),float(data['soc'][i]) ))
      sql = "INSERT INTO battery (cell_id,voltage,temperature,soc) VALUES (%s,%s,%s,%s)"
      mycursor.executemany(sql, val)
      mydb.commit()
      mycursor.close()
      mydb.close()
      print("success")
    except :
      print("error")


channel.basic_consume(
    queue=queue_name, on_message_callback=callback, auto_ack=True)

channel.start_consuming()