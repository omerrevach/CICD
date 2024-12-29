FROM python:3.11-slim

RUN apt-get update && apt-get install -y git docker.io curl && \
    curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN pip install --no-cache-dir pylint bandit Flask
