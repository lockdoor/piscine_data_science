all:
	docker compose up -d

build:
	docker compose up --build -d
# docker-compose logs --follow jupyter

down:
	docker compose down

exec:
	docker exec -it postgres bash

.PHONY: all up down

# docker stop $(docker ps -qa);
# docker rm $(docker ps -qa);
# docker rmi -f $(docker images -qa);
# docker volume rm $(docker volume ls -q);
# docker network rm $(docker network ls -q) 2>/dev/null;