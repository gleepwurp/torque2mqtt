# torque2mqtt

With an Android Phone, the Torque App (I've only tested with Torque Pro, but I think it'll work with Torque Lite) and a OBD2 Bluetooth/Wifi Adapter, you can get data about your car (speed, location, coolant temperature, odometer reading, etc, etc) into MQTT.

It’s a simple Python Service that can be used as a Torque Web Endpoint. It publishes your Torque statistics to an MQTT topic.

I don’t think it REQUIRES Torque Pro, however, I’ve not tested at all with Torque Lite. So if you try it with Lite, please let me know if it works.

This is a first pass implementation. Some units can be converted to imperial, but more work is likely needed. By default, all units are metric (from Torque). Adding `imperial: True` to your config will attempt to convert to Imperial units.

This implementation has no security, authentication, or verification.

Pull Requests are VERY welcome!

# config.yaml example
```
server:
  ip: 0.0.0.0
  port: 5000

mqtt:
  host: 192.168.0.100
  port: 1883
  username: username
  password: password
  prefix: torque

imperial: True
```

# Running From Source Tree

run with `python3 server.py -c /directory/containing/config.yaml`

See config.yaml.example for configuration elements.

# Running From Docker

Docker Builds are available here:
https://hub.docker.com/r/dlashua/torque2mqtt

`docker run -d -v /path/to/config:/config -p 5000:5000 dlashua/torque2mqtt`

# Running with docker-compose

```
version: "3.4"

services:
  torque2mqtt:
    image: dlashua/torque2mqtt
    restart: unless-stopped
    container_name: torque2mqtt
    ports:
      - 5000:5000
    volumes:
      - ./config:/config
```

## How it works

Taking the server IP and port, the application listens for Torque logs sent from
the android application, provided you have set the http address and port to this
webserver (Torque --> Settings --> Data Logging & Upload --> Enable Upload to Webserver,
and update the webserver URL to point to this project's webserver).

As the webserver receives updates from the Torque application on your android device,
it will parse and send it to the MQTT server you have defined (under mqtt: in your
config file).

NB: If you wish to do so on the road, you can open up the port to the Internet, so
  you can upload from your cell phone, or use a proxying/vpn application that is
  much more secure, such as TailScale, OpenVPN, etc.

## MQTT Organization

The Torque information is organized as follows in MQTT:

torque -- vehicle -- sensor -- <individual topics per sensor>

This should allow segregation of the torque data, per vehicle.


## Home-Assistant Discovery option

If the Autodiscovery flag is set to "true" in the configuration file,
the webserver will automatically generate the required autodiscovery items
required to generate the corresponding entities in Home-Assistant.


## Building the Docker image

on the project's root directory:

```bash
docker build -t torque2mqtt:latest .
```


## References

* This repo is the original for this fork: https://github.com/dlashua/torque2mqtt

Additional references:
* https://github.com/econpy/torque