# Based on carver/docker-skyline

FROM yandex/ubuntu:12.04

MAINTAINER Alexander Kushnarev <avkushnarev@gmail.com>

#The command order is intended to optimize for least-likely to change first, to speed up builds
RUN mkdir /var/log/skyline
RUN mkdir /var/run/skyline
RUN mkdir /var/log/redis
RUN mkdir /var/dump/

RUN apt-get install -y python-pip

#Redis
RUN add-apt-repository ppa:rwky/redis
RUN apt-get update
RUN apt-get install -y redis-server

#numpy needs python build tools
RUN apt-get install -y python-dev
RUN pip install numpy

#scipy requires universe
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y python-scipy

RUN pip install pandas
RUN pip install patsy
RUN pip install statsmodels
RUN pip install msgpack-python

RUN git clone https://github.com/etsy/skyline.git /opt/skyline

RUN pip install -r /opt/skyline/requirements.txt

RUN cp /opt/skyline/src/settings.py.example /opt/skyline/src/settings.py

#security updates
RUN apt-get upgrade -y

ADD skyline-start.sh /skyline-start.sh
RUN chmod +x /skyline-start.sh

ADD skyline-settings.py /opt/skyline/src/settings.py

WORKDIR /opt/skyline/bin

CMD ["/skyline-start.sh"]
