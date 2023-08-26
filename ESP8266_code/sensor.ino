#include <DFRobot_mmWave_Radar.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <ezTime.h>

#include "arduino_secrets.h"
const char* ssid = SECRET_SSID;
const char* password = SECRET_PASS;
const char* mqttuser = SECRET_MQTTUSER;
const char* mqttpass = SECRET_MQTTPASS;

const char* mqtt_server = "mqtt.cetools.org";
const char* host = "iot.io";

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int val;
int valpir = 0;
int valpirf = 0;
int valfinal = 0;
int storage[5] = { 0, 0, 0, 0, 0 };
int pirStorage[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
//int sum;
//float avg;

Timezone GB;

/*!
   @file DFRobot_mmWave_Radar.ino
   @ Detect if there is object or human motion in measuring range; Allows for configuring sensing area, sensor output delay, and resetting sensor to factory settings.
   @n Experimental phenomenon: When the sensor is enabled, print 0 or 1 on the serial port: 0 for no motion detected in the sensing area, 1 for object/human movement detected. 
   @copyright   Copyright (c) 2010 DFRobot Co.Ltd (http://www.dfrobot.com)
   @licence     The MIT License (MIT)
   @version  V1.0
   @date  2023-3-13
   @https://github.com/DFRobot
*/

//int LED_BLINK = 2;
int inputPin = D3;  //for PIR

SoftwareSerial mySerial(D1, D2);
DFRobot_mmWave_Radar sensor(&mySerial);

void setup() {
  Serial.begin(115200);
  mySerial.begin(115200);
  // pinMode(LED_BLINK, OUTPUT);
  pinMode(inputPin, INPUT);  //PIR

  sensor.factoryReset();       //Reset to factory settings
  sensor.DetRangeCfg(0, 0.9);    //Set sensing distance, up to 9m
  sensor.OutputLatency(0, 0);  //Set output delay

  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());  //wifi connecting

  waitForSync();
  Serial.println("UTC: " + UTC.dateTime());
  GB.setLocation("Europe/London");
  Serial.println("London time: " + GB.dateTime());  //getting time

  client.setServer(mqtt_server, 1884);
  client.setCallback(callback);  //publish data to MQTT
}

void loop() {
  // val=0;
  //Serial.println("-------------------------------");
  // Serial.print("Connecting to ");
  //Serial.println(host);
  float sum = 0;
  float avg = 0;
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;  //Connecting to wifi
  }

  Serial.println(GB.dateTime("H:i:s"));  // UTC.dateTime("l, d-M-y H:i:s.v T")

  // for (int i = 0; i < 5; i++) {
  val = sensor.readPresenceDetection();  //read mmWave output
  valpir = digitalRead(inputPin);        // read PIR output

  pirStorage[0] = pirStorage[1];
  pirStorage[1] = pirStorage[2];  
  pirStorage[2] = pirStorage[3];
  pirStorage[3] = pirStorage[4];
  pirStorage[4] = pirStorage[5];
  pirStorage[5] = pirStorage[6];
  pirStorage[6] = pirStorage[7];
 // pirStorage[7] = pirStorage[8];
  pirStorage[7] = valpir;

int i;
  for(i=0; i<8; i++){
Serial.print(pirStorage[i]);
  }
  
  //int pir = pirStorage[0] + pirStorage[1];
  if (((pirStorage[0]+pirStorage[1]) == 2) || ((pirStorage[1]+pirStorage[2]) == 2) || ((pirStorage[2]+pirStorage[3]) == 2)|| ((pirStorage[3]+pirStorage[4]) == 2)|| ((pirStorage[4]+pirStorage[5]) == 2)|| ((pirStorage[5]+pirStorage[6]) == 2)|| ((pirStorage[6]+pirStorage[7]) == 2)) {
    valpirf = 1;
  } else {
    valpirf = 0;
  }

  if (valfinal == 0) {
    if ((valpirf == 1) & (val == 1)) {
      valfinal = 1;
    }
  } else {
    if (val == 0) {
      valfinal = 0;
    }
  }

 // Serial.println(val);
 // Serial.println(valpir);
  //  goo[i] = val;

  storage[0] = storage[1];
  storage[1] = storage[2];
  storage[2] = storage[3];
  storage[3] = storage[4];
  storage[4] = val;

  //  sum = sum + val;
  // Serial.println(sum);
  delay(1000);
  sendMQTT();

  sum = storage[0] + storage[1] + storage[2] + storage[3] + storage[4];
  avg = sum / 5;
  Serial.println(avg);
  // sum = 0;
}

void sendMQTT() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  // snprintf (msg, 50, "%.0f", val);

  

  snprintf(msg, 50, "%ld", valfinal);
  Serial.print("Publish message: ");
  Serial.println(valfinal);
  client.publish("student/ucfnnbx/human/ifhuman", msg); 
  
  snprintf(msg, 50, "%ld", val);
  Serial.print("Publish message: ");
  //Serial.println(valfinal);
  client.publish("student/ucfnnbx/human/mmwave", msg); 
  
 /* snprintf(msg, 50, "%ld", valpir);
  Serial.print("Publish message: ");
 // Serial.println(valfinal);
  client.publish("student/ucfnnbx/human/pir", msg);

  snprintf(msg, 50, "%ld", valpirf);
  Serial.print("Publish message: ");
 // Serial.println(valfinal);
  client.publish("student/ucfnnbx/human/pirf", msg);
  
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {  // while not (!) connected....
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);

    // Attempt to connect
    if (client.connect(clientId.c_str(), mqttuser, mqttpass)) {
      Serial.println("connected");
      // ... and subscribe to messages on broker
      client.subscribe("student/ucfnnbx/human");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  /* Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();*/

  /*  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }*/
}