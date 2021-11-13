all: build push

build:
	docker build \
		-t gcr.io/web-online-ventures/johns-app:latest \
		--build-arg master_key=3ebb0cf1619a9ab0999316f43ab60c65 \
		-f config/docker/app/Dockerfile .

push:
	docker push gcr.io/web-online-ventures/mce:latest

backup:
	pg_dump -h localhost -p 4000 -U mce --no-owner --no-privileges --schema=public --clean --if-exists mce > tmp/db/prod.sql

import:
	psql -v ON_ERROR_STOP=1 -h localhost -p 5484 -U postgres mce -f tmp/db/prod.sql
