# Occupancy Sensing
An occupancy sensing system with an integration of basic PIR and mmWave sensor modules. Occupancy data was utilized by a lighting system and a mobile application for remote monitoring, which has the potential to improve energy efficiency and space utilization management in workplaces. Compared to using a mmWave sensor alone, bringing in a PIR sensor could greatly improve the sensing accuracy in cases where mmWave sensor may be frequently false triggered due to reflections or non-human objects. The sensing system was tested with different deployments to ensure it can deliver reproducible results across different implementations. 

## Installing method
Ceiling mounting is the most suitable installation method because it keeps the sensor unblocked and unobtrusive, while giving a high measuring accuracy. Wall mounting is more suitable for intensive workplaces, but the sensor may be easily blocked or removed by people. Below is an example of a wall-mounted sensor. The sensor's detection range can be configured from 0-9 meters, with a beam angle of 100° × 40°.

<p align="center">
<img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/Exhibition.png" width="250"><img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/List_view.png" width="250"><img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/Bookmarked.png" width="250">
</p>
 
## Android Mobile Application
Based on the sensor system, this app allows user to remote monitor the occupancy data. It has functions including 'bookmark favorite places', 'view real-time data in graphs', and 'find the sensor location'. 
All the past data are stored in a cloud database for people who has administration to access on a Grafana dashboard. A video demo can be found in above file named 'mobile app demo'.

<p align="center">
<img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/Grid_view.png" width="250">
</p>

To aid visualization of the sensor working machenisms, a light displayer is built. This is to help understand the reason why I integrated two kinds of sensor in order to give a more reliable result. 

<p align="center">
<img
src="https://github.com/ucfnnbx/occupancy-sensing/blob/main/readme_images/light%20displayer.jpg" width="250">
</p>

## How To Install The App
1. Download folder 'mobile application/occupancy'.
2. Open folder with Android Studio or Visual Studio Code IDE.
3. Get packages: From the terminal: Run flutter pub get . From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml indicated by the Download icon. From Android Studio/IntelliJ: Click Pub get in the action ribbon at the top of pubspec.yaml.
4. Build the project with Android emulator, ios simulator or physical device connected

## View Grafana Dashboards
Contact me to get access to all the past data on Grafana dashboards.


