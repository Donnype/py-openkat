
init:
	git submodule init
	git submodule update
	git -C openkat submodule init
	git -C openkat submodule update

clean:
	rm -f openkat/boefjes/katalogus.db
	rm -f openkat/rocky.db

build: clean build-boefjes build-rocky
	poetry build

build-boefjes:
	# Prepare clean Katalogus db
	cd openkat/boefjes && poetry run python -m alembic upgrade head
	cd openkat/boefjes && poetry run python -m seed

build-rocky:
	# Prepare clean Rocky db
	EMAIL="super@user.com" DJANGO_SUPERUSER_PASSWORD="superuser" poetry run make -C ./openkat build
	cd openkat && poetry run python manage.py two_factor_disable super@user.com
