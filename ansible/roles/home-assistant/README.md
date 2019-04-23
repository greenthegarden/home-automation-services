http://home-assistant:8123


https://www.home-assistant.io/docs/installation/docker/

docker run -d --name="home-assistant" -v /PATH_TO_YOUR_CONFIG:/config -v /etc/localtime:/etc/localtime:ro --net=host homeassistant/home-assistant