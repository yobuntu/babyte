include config.Makefile
-include config.custom.Makefile

BASEVERSION ?= v1
BASEROOT ?= https://raw.githubusercontent.com/Kozea/MakeCitron/$(BASEVERSION)/
BASENAME := base.Makefile
ifeq ($(MAKELEVEL), 0)
RV := $(shell wget -q -O $(BASENAME) $(BASEROOT)$(BASENAME) || echo 'FAIL')
ifeq (,$(RV))
include $(BASENAME)
else
$(error Unable to download $(BASEROOT)$(BASENAME))
endif
$(info $(INFO))
else
include $(BASENAME)
endif


all: install serve
	$(LOG)

install:
	test -d $(VENV) || virtualenv -p python3 $(VENV)
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
	$(LOG)

check-outdated:
	$(PIP) list --outdated --format=columns

check: check-python check-outdated
	$(LOG)

build:

env:
	$(RUN)

run:
	env TESTING=1 FLASK_DEBUG=1 $(VENV)/bin/flask run --host=0.0.0.0

serve: run
	$(LOG)

deploy-test:
	$(LOG)
	@echo "Communicating with Junkrat..."
	@wget --no-verbose --content-on-error -O- --header="Content-Type:application/json" --post-data=$(subst $(newline),,$(JUNKRAT_PARAMETERS)) $(JUNKRAT) | tee $(JUNKRAT_RESPONSE)
	if [[ $$(tail -n1 $(JUNKRAT_RESPONSE)) != "Success" ]]; then exit 9; fi
	wget --user=$(CI_PROJECT_NAME) --password=$(PASSWD) --no-verbose --content-on-error -O- $(URL_TEST)

deploy-prod:
	$(LOG)
	@echo "Communicating with Junkrat..."
	@wget --no-verbose --content-on-error -O- --header="Content-Type:application/json" --post-data=$(subst $(newline),,$(JUNKRAT_PARAMETERS)) $(JUNKRAT) | tee $(JUNKRAT_RESPONSE)
	if [[ $$(tail -n1 $(JUNKRAT_RESPONSE)) != "Success" ]]; then exit 9; fi
	wget --no-verbose --content-on-error -O- $(URL_PROD)
