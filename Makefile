# Variables
PROJECT_NAME = votre_nom_de_projet
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_RUN = $(DOCKER_COMPOSE) run --rm web

# Commandes
.PHONY: build up down logs migrate makemigrations shell test createsuperuser collectstatic runserver clean prune clean-db clean-temp start-db create-tenant drop-tenant migrate-schemas migrate-tenant create-superuser-tenant

# Construire les images
build:
	$(DOCKER_COMPOSE) build

# Démarrer tous les services
up:
	$(DOCKER_COMPOSE) up

# Arrêter tous les services
down:
	$(DOCKER_COMPOSE) down

# Afficher les logs
logs:
	$(DOCKER_COMPOSE) logs -f

# Exécuter les migrations
migrate:
	$(DOCKER_COMPOSE_RUN) python manage.py migrate

# Construire les migrations
makemigrations:
	$(DOCKER_COMPOSE_RUN) python manage.py makemigrations

# Ouvrir un shell dans le conteneur web
shell:
	$(DOCKER_COMPOSE_RUN) python manage.py shell

# Exécuter les tests
test:
	$(DOCKER_COMPOSE_RUN) python manage.py test

# Créer un superutilisateur
createsuperuser:
	$(DOCKER_COMPOSE_RUN) python manage.py createsuperuser

# Collecter les fichiers statiques
collectstatic:
	$(DOCKER_COMPOSE_RUN) python manage.py collectstatic --noinput

# Exécuter le serveur de développement
runserver:
	$(DOCKER_COMPOSE_RUN) python manage.py runserver 0.0.0.0:8000

# Nettoyer les fichiers temporaires et les conteneurs
clean:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

# Prune pour tout effacer
prune:
	docker system prune -af --volumes

# Nettoyer uniquement la base de données
clean-db:
	$(DOCKER_COMPOSE) down --volumes
	$(DOCKER_COMPOSE) up -d db
	@echo "Base de données réinitialisée."

# Nettoyer les fichiers temporaires
clean-temp:
	docker volume prune -f
	docker network prune -f
	@echo "Fichiers temporaires nettoyés."

# Démarrer uniquement le service de base de données
start-db:
	$(DOCKER_COMPOSE) up db

# Créer un schéma pour un locataire
create-tenant:
	$(DOCKER_COMPOSE_RUN) python manage.py create_tenant $(name)

# Supprimer un schéma pour un locataire
drop-tenant:
	$(DOCKER_COMPOSE_RUN) python manage.py drop_tenant $(name)

# Migrer tous les schémas
migrate-schemas:
	$(DOCKER_COMPOSE_RUN) python manage.py migrate_schemas --shared

# Migrer un schéma spécifique
migrate-tenant:
	$(DOCKER_COMPOSE_RUN) python manage.py migrate_schemas --tenant $(name)

# Créer un superutilisateur pour un locataire
create-superuser-tenant:
	$(DOCKER_COMPOSE_RUN) python manage.py createsuperuser --tenant $(name)
