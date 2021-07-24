# ETL_currency-exchange-rate
Test task for Data Engineer position.

DWH and ETL.


## Requirements

* ###### Docker

* ###### Docker-compose
___

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

1. Clone this repository

   
2. Install the requirements

   
3. Get your access key on the site exchangeratesapi.io

Documentation of exchangeratesapi.io: https://exchangeratesapi.io/documentation/
   
4. Insert your access key into ./Dockerfile

        ENV EXCHANGE_RATE_ACCESS_KEY <your_access_key>

5. Build the docker containers:

        docker-compose up --build
___

## Mysql database diagram

You can see structure of currency_exchange_rate database on diagram_currency_exchange_rate.pdf

___
## Mysql database on your computer

If you don't want to use DB in the container, you can use your local mysql server.

1. Create db with dump.sql file:

From ./mysql_db run:

    mysql -uUSER -pPASSWORD -f currency_exchange_rate < dump.sql

2. Change environment variable in ./Dockerfile:
   
        ENV CURRENCY_MYSQL_CONN mysql+pymysql://<username>:<password>@localhost:<port>/currency_exchange_rate

3. _Also, you can remove mysql service from docker-compose.yaml_
_(This will save from running an extra container)_
___

## UI Link

    Airflow: localhost:8080
Standard username and password for airflow:
* username: airflow 
* password: airflow
___

## Problems:

You may have some problems with /logs/ directory.

If you have 

    'ValueError' Unable to configure handler 'processor': [Errno 13] Permission denied: '/opt/airflow/logs/scheduler'

enter the command `chmod -R 777 logs/` into terminal (out of containers).
