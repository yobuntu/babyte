export PROJECT_NAME = babyte
export FLASK_APP = $(PROJECT_NAME)

# Python env
VENV = $(PWD)/.env
PIP = $(VENV)/bin/pip
PYTHON = $(VENV)/bin/python
PYTEST = $(VENV)/bin/py.test
FLASK = $(VENV)/bin/flask

URL_PROD = https://babyte.kozea.fr
