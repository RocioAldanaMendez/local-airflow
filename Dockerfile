FROM python:3.7-buster

RUN apt-get update \
    && apt-get install -y \
        nmap \
        vim \
        unzip \
        postgresql \
        postgresql-contrib \
        libffi-dev \
        sudo \
        groff \
        less

RUN pip install --upgrade pip
ADD docker/requirements.txt /root/
RUN pip install -r /root/requirements.txt

# all airflow dirs/files are installed in root/airflow
COPY docker/airflow.cfg /root/airflow/airflow.cfg
COPY docker/webserver_config.py /root/airflow/webserver_config.py

# start me up
COPY docker/entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
EXPOSE 8080

