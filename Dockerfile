ARG PYTHON_VERSION=3.8.6-slim-buster

FROM python:$PYTHON_VERSION

ARG MLFLOW_VERSION=1.11.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libyaml-cpp-dev=0.6.2-4 libyaml-dev=0.2.1-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install psycopg2-binary==2.8.6 mlflow[extras]==$MLFLOW_VERSION

ENTRYPOINT ["mlflow"]
CMD ["server"]
