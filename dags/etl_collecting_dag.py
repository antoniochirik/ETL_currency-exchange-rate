import datetime as dt
import os
import requests

from airflow import DAG
from airflow.decorators import task
from sqlalchemy import create_engine, MetaData, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import scoped_session, sessionmaker


dag_args = {
    'owner': 'airflow',
    'start_date': dt.datetime(2021, 7, 18),
    'retries': 1,
    'retry_delay': dt.timedelta(minutes=1),
    'depends_on_past': False
}


EURO_RATE_URL = 'http://api.exchangeratesapi.io/v1/latest'
ACCESS_KEY = os.getenv('EXCHANGE_RATE_ACCESS_KEY')
DB_URL = os.getenv('CURRENCY_MYSQL_CONN')
SYMBOLS = ('USD', 'CNY', 'RUB')
EURO_RATE_REQUEST_PARAMS = {
            'access_key': ACCESS_KEY,
            'symbols': ', '.join(code for code in SYMBOLS)
        }
REQUEST_EXCEPTION = 'Проблемы с ответом от сервера. {ex}'
CURRENCY_EXCEPTION = 'В ответе запроса не хватает данных о валюте {currency}'
TYPE_EXCEPTION = 'Вместо стоимости валюты пришло что-то другое: {type}'
DB_EXCEPTION = 'Проблема с подключением к базе {ex}'


def create_db_connection():
    """ Database connection """
    base = declarative_base()
    try:
        engine = create_engine(DB_URL)
        metadata = MetaData(bind=engine)
        session = scoped_session(sessionmaker(bind=engine,
                                              autocommit=False,
                                              autoflush=False))
    except Exception as ex:
        raise Exception(DB_EXCEPTION.format(ex=ex))

    # mapping base class and DB table euro_rate
    class EuroRate(base):
        __table__ = Table('euro_rate', metadata, autoload=True)

    return EuroRate, session


def check_currencies(symbol, currencies):
    """ Checks all currencies from the requested list are in the response """
    if symbol not in currencies:
        message = CURRENCY_EXCEPTION.format(
            currency=symbol
        )
        raise Exception(message)


def check_rate_datatype(symbol, currencies):
    """ Checks the data types of currencies """
    if (not isinstance(currencies[symbol], float) and
            not isinstance(currencies[symbol], int)):
        message = TYPE_EXCEPTION.format(
            type=type(currencies[symbol])
        )
        raise Exception(message)


def extract_rates(response):
    """ Converting currency data from site response """
    euro_rates = response.json()
    return euro_rates['rates']


def request_to_site(request_params):
    """ Request to the site API """
    try:
        response = requests.get(EURO_RATE_URL,
                                params=request_params)
    except requests.RequestException as ex:
        raise Exception(REQUEST_EXCEPTION.format(ex=ex))
    return response


with DAG(dag_id='euro_rate_collecting',
         default_args=dag_args,
         schedule_interval='0 5 * * *') as dag:

    @task
    def validate_euro_rate(currencies):
        """ Validation of the response from the site """
        for symbol in SYMBOLS:
            check_currencies(symbol, currencies)
            check_rate_datatype(symbol, currencies)
        return currencies

    @task
    def getting_euro_rate(request_params):
        """ Receiving data from the site's API """
        response = request_to_site(request_params)
        euro_rates = extract_rates(response)
        return euro_rates

    @task
    def add_rates_to_table(data):
        """ Adding data to euro_rate table """
        EuroRate, session = create_db_connection()
        session.add(EuroRate(**data))
        session.commit()

    received_rates = getting_euro_rate(EURO_RATE_REQUEST_PARAMS)
    validated_rates = validate_euro_rate(received_rates)
    add_rates_to_table(validated_rates)
