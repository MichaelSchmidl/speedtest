# speedtest
monitor your internet connection with a RASPBERRY PI e.g.
I provide a couple of scripts which enables you to monitor the up- and downstream speed every 15min, log the measured values and generate a graphical interpretation.

For best results use a RaspberryPI 3b or better. You will have to connect the PI over a LAN cable. <b>DO NOT USE WLAN!</b>

These prerequisities are required on the PI:

<code><b>sudo apt-get install git curl gnuplot speedtest-cli</b></code>

Next you can clone this repository by using:

<code><b>git clone https://github.com/mike5ch/speedtest.git</b></code>

For notification I use the PUSHOVER.NET service to send error notifications and graphs to my iPhone. My current problems with KABEL DEUTSCHLAND produced the following notifications:

<img src="IMG_0309.PNG">
