# ETL_currency-exchange-rate
Test task for Data Engineer position.

DWH and ETL.


## Requirements

* ###### Docker

* ###### Docker-compose
  _ATTENTION: You need the latest version of docker-compose!_

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

1. Clone this repository

   
2. Install the requirements

   
3. Get your access key on the site exchangeratesapi.io

Documentation of exchangeratesapi.io: https://exchangeratesapi.io/documentation/
   
4. Insert your access key into ./.env file

        EXCHANGE_RATE_ACCESS_KEY=<your_access_key>

5. Build the docker containers:

        docker-compose up --build

## Mysql database diagram

You can see structure of currency_exchange_rate database on diagram_currency_exchange_rate.pdf

## Mysql database on your computer

If you don't want to use DB in the container, you can use your local mysql server.

1. Create db with dump.sql file:

From ./mysql_db run:

    mysql -uUSER -pPASSWORD -f currency_exchange_rate < dump.sql

2. Change environment variable in ./.env:
   
        CURRENCY_MYSQL_CONN=mysql+pymysql://<username>:<password>@localhost:<port>/currency_exchange_rate

3. _Also, you can remove mysql service from docker-compose.yaml_
_(This will save from running an extra container)_

## UI Link

    Airflow: localhost:8080
Standard username and password for airflow:
* username: airflow 
* password: airflow

## Problems:

If you have not the latest version of docker-compose, you may catch error:

    ERROR: The Compose file './docker-compose.yaml' is invalid because:
    Invalid top-level property "x-airflow-common". Valid top-level sections for this Compose file are: version, services, networks, volumes, and extensions starting with "x-".

You need to upgrade docker-compose.
How to upgrade: https://stackoverflow.com/questions/49839028/how-to-upgrade-docker-compose-to-latest-version

---
Also, you may have some problems with /logs/ directory.
On Linux, the mounted volumes in container use the native Linux filesystem user/group permissions, so you have to make sure the container and host computer have matching file permissions.

If you have 

    'ValueError' Unable to configure handler 'processor': [Errno 13] Permission denied: '/opt/airflow/logs/scheduler'

enter the command `chmod -R 777 logs/` into terminal (out of containers).
