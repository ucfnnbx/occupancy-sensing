# Occupancy Sensing
An occupancy sensing system with an integration of mmWave sensor and PIR sensor is developed. The reason for integrating two sensors is to complement the respective defects and combine their advantages. The multipath rays of mmWaves are found to derease the occupancy detection accuracy inevitably, which can be greatly improved by bringing in PIR. Although a PIR sensor has its own drawbacks like only able to detect moving people, this can be compensated with mmWave sensing features. Only when both sensors are triggered, a positive occupancy result will be output. 

For a workplace at table scenario, ideal locations to mount the sensor are on the ceiling or in front of the table. The sensing distance can be configured from 0 to 10 meters. 

An Android application is developed to showcase the communication of real-time sensor data with people. With this app, people can check the occupancy status of places that have sensor deployed wherever they are. All the past data are stored in a cloud database for people who has administration to access on a Grafana dashboard. 

<p align="center">
<img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/mobile_app.png" width="150">
</p>

To aid visualization of the sensor working machenisms, a light displayer is built. This is to help understand the reason why I integrated two kinds of sensor in order to give a more reliable result. 
