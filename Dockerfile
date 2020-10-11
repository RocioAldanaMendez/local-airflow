FROM python:3.7-buster

# get stable chrome (for selenium web scrapes)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

RUN apt-get update \
    && apt-get install -y \
        nmap \
        vim \
        google-chrome-stable \
        unzip \
        postgresql \
        postgresql-contrib \
        libffi-dev \
        sudo \
        groff \
        less

# unzip, install chromedriver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
ENV DISPLAY=:99

RUN pip install --upgrade pip
ADD docker/requirements.txt /root/
RUN pip install -r /root/requirements.txt

# all airflow dirs/files are installed in root/airflow
COPY docker/airflow.cfg /root/airflow/airflow.cfg
COPY dags /root/airflow/dags/
COPY scripts /root/airflow/scripts/

# start me up
COPY docker/entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
EXPOSE 8080

