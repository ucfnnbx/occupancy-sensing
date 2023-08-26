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
//int inputPin = D3;  //for PIR

//SoftwareSerial mySerial(D1, D2);
//DFRobot_mmWave_Radar sensor(&mySerial);

void setup() {
  Serial.begin(115200);
 // mySerial.begin(115200);
  // pinMode(LED_BLINK, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(14, OUTPUT);
    //PIR

  
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
  
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;  //Connecting to wifi
  }

 // Serial.println(GB.dateTime("H:i:s"));  // UTC.dateTime("l, d-M-y H:i:s.v T")

  // for (int i = 0; i < 5; i++) {
 
  delay(1000);
  sendMQTT();

 
  // snprintf (msg, 50, "%.0f", val);
}

void sendMQTT() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  // snprintf (msg, 50, "%.0f", val);

  
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
      client.subscribe("student/ucfnnbx/human/ifhuman");
      client.subscribe("student/ucfnnbx/human/mmwave");
      client.subscribe("student/ucfnnbx/human/pir");
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
   Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  /*  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }*/

 /* if ((char)payload[0] == '1') {
    digitalWrite(12, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(12, LOW);  // Turn the LED off by making the voltage HIGH
  }*/

  if (strcmp(topic,"student/ucfnnbx/human/ifhuman")==0){
  
if ((char)payload[0] == '1') {
    digitalWrite(12, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(12, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

if (strcmp(topic,"student/ucfnnbx/human/mmwave")==0){
if ((char)payload[0] == '1') {
    digitalWrite(13, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(13, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

if (strcmp(topic,"student/ucfnnbx/human/pir")==0){
if ((char)payload[0] == '1') {
    digitalWrite(14, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(14, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

}


/*void callback(char* topic, byte* payload, unsigned int length) {  
 /*  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();*/
/*
if (strcmp(topic,"ifhuman")==1){
 /* Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }*/
/*if ((char)payload[0] == '1') {
    digitalWrite(12, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(12, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

if (strcmp(topic,"mmwave")==1){
if ((char)payload[0] == '1') {
    digitalWrite(13, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(13, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

if (strcmp(topic,"pir")==1){
if ((char)payload[0] == '1') {
    digitalWrite(14, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(14, LOW);  // Turn the LED off by making the voltage HIGH
  }
}

}*/

    // Switch on the LED if an 1 was received as first character
 /* if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because it is active low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }*/
