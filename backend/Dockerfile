FROM python:3.8.6-slim-buster as builder

RUN mkdir /app
WORKDIR /app

RUN pip install pipenv

COPY ./Pipfile ./
COPY ./Pipfile.lock ./

RUN python -m pipenv lock -r > requirements.txt

RUN python -m venv /opt/venv

RUN /opt/venv/bin/pip install -r requirements.txt

COPY . /app