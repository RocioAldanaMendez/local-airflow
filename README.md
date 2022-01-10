### AffiniPay Airflow QA Docker Image

Airflow is an open source configuration-as-code job orchestration tool developed by AirBnB and written in Python. For detailed info on the Airflow experience, please see the docs: https://airflow.apache.org/docs/stable/.

While we utilize Managed Workflows for Apache Airflow in production, this is our in-house image for DAG dev and testing. It will mimic the capabilities of MWAA for use locally.

#### Docker

Make sure to install docker from either the official site (https://docs.docker.com/desktop/mac/install/) or with `brew install docker`.

#### AWS Credentials

Make sure your local AWS credentials for the AWS Analytics account are set up correctly in ~/.aws. This image requires Analytics account credential to be your default credential.

#### Docker build/run

To build the image:
```bash
docker build -t ap-airflow-qa:latest .
```

In docker-compose.yaml, change the local volume dags reference to reference your own local dags repo if needed. 

So:
```bash
      - ~/airflow/dags:/root/airflow/dags
```

Becomes:
```bash
      - ~/your/path/to/your/local/dags:/root/airflow/dags
```

To run the image as a local service with docker-compose:
```bash
docker-compose up
```
This will cause the Airflow image to run as a local background service as long as Docker is active. 

You can change the path used to load dags by adjusting the `volumes:` section of docker-compose.yaml.

Visit http://localhost:8080/home while running for all your Airflow interface needs.

To shell into the image for debug:
```bash
docker exec -it $(docker ps -q --filter ancestor=ap-airflow-qa:latest) /bin/bash
```

To stop the image, try below:
```bash
docker stop $(docker ps -q --filter ancestor=ap-airflow-qa:latest)
```
If this doesn't work, just list your containers and stop the image.

To run the image WITHOUT docker compose, set LOCAL_DAGS below to the local directory containing your DAGs and run:
```bash
LOCAL_DAGS=~/airflow/dags
docker run -it -p 8080:8080 -v $LOCAL_DAGS:/root/airflow/dags \
        -v ~/.aws:/root/.aws -v :/root/airflow -e qa=1 ap-airflow-qa:latest
```