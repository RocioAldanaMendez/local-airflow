#!/bin/bash

# create some env vars (thanks puckel)
: "${AIRFLOW_HOME:="/root/airflow"}"
: "${AIRFLOW__CORE__FERNET_KEY:=${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}}"
export \
  AIRFLOW_HOME \
  AIRFLOW__CORE__FERNET_KEY

# set up postgres backend
service postgresql start
sudo -u postgres psql -c "create database airflow;"
sudo -u postgres psql -c "create user airflow with password 'airflow';"
sudo -u postgres psql -c "grant all privileges on database airflow to airflow;"
airflow initdb

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# start me up
(airflow scheduler &) && airflow webserver
