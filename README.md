### Airflow in Docker Boilerplate

Airflow is an open source configuration-as-code job orchestration tool developed by AirBnB and written in Python. For detailed info on the Airflow experience, please see the docs: https://airflow.apache.org/docs/stable/.

This is my own personal Airflow boilerplate. I usually run a version of this locally in docker to test DAGs, etc. It has the following features:
- Installs headless Chrome and chromedriver for use in Selenium webscraping (I do a lot of this).
- Creates Postgres backend (it's better).
- Everything Airflow is installed in /root/airflow.
- Fernet key is created for connection encryption. Thanks puckel/docker-airflow for the syntax assist.
- Installs awscli, sometimes needed for debugging in an AWS env.
- This build will NOT remember job history if the container is stopped/restarted, so be warned. :)


#### Debugging

For local debug, the following commands are very useful:
```bash
docker build -t docker-airflow:local .
docker run -it -p 8080:8080 -v :/root/airflow docker-airflow:local
docker exec -it $(docker ps -q --filter ancestor=docker-airflow:local) /bin/bash
docker stop $(docker ps -q --filter ancestor=docker-airflow:local)
```

For K8s debug, the following commands are very useful.
```bash
kubectl port-forward deployment/docker-airflow 8080:8080 -n <namespace>
kubectl exec --stdin --tty $(kubectl get pods -n <namespace> -o jsonpath="{.items[0].metadata.name}") -n <namespace> -- /bin/bash 
```

Visit http://localhost:8080 while running for all your Airflow interface needs.
