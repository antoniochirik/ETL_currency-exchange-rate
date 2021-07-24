FROM apache/airflow:2.1.2

# you need to define the access_key variable
# which is your access key for
# site api.exchangeratesapi.io
ENV EXCHANGE_RATE_ACCESS_KEY <your_access_key>

# standard connection to mysql container. DB is currency_exchange_rate
ENV CURRENCY_MYSQL_CONN mysql+pymysql://root:python_SCRIPT12@mysql:3306/currency_exchange_rate

RUN pip install pymysql
