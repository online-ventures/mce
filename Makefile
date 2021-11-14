deploy:
	echo 'deploying...'

sha = $(git rev-parse HEAD)
image = gcr.io/web-online-ventures/mce:$(sha)

build:
	docker build -t $(image) -f config/docker/app/Dockerfile .

push:
	docker push $(image)

restart:
	kubectl set image deploy/mce app=$(image)

backup:
	pg_dump -h localhost -p 4000 -U mce --no-owner --no-privileges --schema=public --clean --if-exists mce > tmp/db/prod.sql

import:
	psql -v ON_ERROR_STOP=1 -h localhost -p 5484 -U postgres mce -f tmp/db/prod.sql
