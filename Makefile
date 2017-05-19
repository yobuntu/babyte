include Makefile.config
-include Makefile.custom.config

all: install serve

install:
	test -d $(VENV) || virtualenv $(VENV)
	$(PIP) install --upgrade --no-cache pip setuptools -e .[test]

install-db:
	$(VENV)/bin/flask init_db

install-dev:
	$(PIP) install --upgrade devcore

clean:
	rm -fr dist

clean-install: clean
	rm -fr $(VENV)
	rm -fr *.egg-info

lint:
	$(PYTEST) --no-cov --flake8 -m flake8
	$(PYTEST) --no-cov --isort -m isort

check-python: lint

check-outdated:
	$(PIP) list --outdated --format=columns

check: check-python check-outdated

build:

env:
	$(RUN)

run:
	env FLASK_DEBUG=1 $(VENV)/bin/flask run

serve: run

