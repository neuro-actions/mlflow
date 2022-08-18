FROM continuumio/miniconda3:4.12.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libyaml-cpp-dev=0.6.3-9 libyaml-dev=0.2.2-1 default-libmysqlclient-dev=1.0.7 gcc=4:10.2.1-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --progress-bar=off -U --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

ENTRYPOINT ["mlflow"]
