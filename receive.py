import pika
import sys
import json

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.exchange_declare(exchange='topic_logs', exchange_type='topic')

result = channel.queue_declare('', exclusive=True)
queue_name = result.method.queue

#binding_keys = sys.argv[1:]
#if not binding_keys:
#    sys.stderr.write("Usage: %s [binding_key]...\n" % sys.argv[0])
#    sys.exit(1)

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
      x = body
      y = body.decode("utf-8")
      z = json.loads(y)
      print(type(z))
      val = z["value"]
      for i in val :
        print (i)
    except :
      print(body)
      print("false")


channel.basic_consume(
    queue=queue_name, on_message_callback=callback, auto_ack=True)

channel.start_consuming()