FROM python:3.10.1-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libyaml-cpp-dev=0.6.2-4 libyaml-dev=0.2.1-1 default-libmysqlclient-dev=1.0.5 gcc=4:8.3.0-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --progress-bar=off -U --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

ENTRYPOINT ["mlflow"]
CMD ["server"]
