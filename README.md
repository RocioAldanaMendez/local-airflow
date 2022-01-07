### AffiniPay Airflow QA Docker Image

Airflow is an open source configuration-as-code job orchestration tool developed by AirBnB and written in Python. For detailed info on the Airflow experience, please see the docs: https://airflow.apache.org/docs/stable/.

While we utilize Managed Workflows for Apache Airflow in production, this is our in-house image for DAG dev and testing. It will mimic the capabilities of MWAA for use locally.

#### Docker

Make sure to install docker from either the official site (https://docs.docker.com/desktop/mac/install/) or with `brew install docker`.

#### AWS Credentials

Make sure your AWS credentials for the AWS Analytics account are set up correctly in ~/.aws. This image assumes Analytics is your default credential.

#### Building and Running

To build the image:
```bash
docker build -t ap-airflow-qa:latest .
```

To run the image, set LOCAL_DAGS below to the local directory containing your DAGs.
```bash
LOCAL_DAGS=~/airflow/dags
docker run -it -p 8081:8080 -v $LOCAL_DAGS:/root/airflow/dags \
        -v ~/.aws:/root/.aws -v :/root/airflow -e qa=1 ap-airflow-qa:latest
```
(Note here I forward to 8081 to avoid clashing with local background service run, but you can use any port you'd like.)

To shell into the image for debug:
```bash
docker exec -it $(docker ps -q --filter ancestor=ap-airflow-qa:latest) /bin/bash
```

To stop the image, try below or ctrl+c in terminal:
```bash
docker stop $(docker ps -q --filter ancestor=ap-airflow-qa:local)
```

To run the image as a local service with docker-compose:
```bash
docker-compose up
```

Visit http://localhost:8081/home while running for all your Airflow interface needs.
