# TP4

Le but de ce TP est de vous faire manipuler les pipelines CI/CD

Nous allons voir ensemble comment réaliser votre premier job afin de build une application GO.

Dans un premier temps, créer un job nommé build-go qui s'executera pendant le stage de build:

```
build_go:
  stage: build
```

Afin de réaliser notre build, nous avons besoin d'un compilateur go. Il est possible d'utiliser des images docker à l'interieur des jobs afin de réaliser certaine action. Dans notre cas, nous allons utiliser une image golang:1.19 afin de compiler notre code.

```
build_go:
  stage: build
  image: golang:1.19
```

Il nous faut maintenant lister les commandes à executer dans le conteneur afin de build notre code. On va utiliser l'instruction script pour cela: 
```
build_go:
  stage: build
  image: golang:1.19
  script: 
    - go mod download
    - CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping
```
**Astuce:** Par defaut, GitLab CI/CD va automatiquement cloner notre repository git et le placer dans le conteneur que l'on souhaite utiliser 

A vous de jouer !

## Exo 1

Réaliser un job test_go qui s'executera au moment du stage test et qui sera basé sur l'image golang:1.19. La commande permettant de lancer des tests en GO est:

```
go test -v ./...
```

## Exo 2

Réaliser à l'aide de la [documentation suivante](https://docs.gitlab.com/ci/docker/using_kaniko/) un job publish_go permettant de créer et envoyé dans le conteneur registry de gitlab une image à partir d'un dockerfile

Rendez vous dans Deploy => container registry dans votre projet GitLab afin de verifier l'existance de votre image.

## Exo 3

Afin de ne pas polluer les images docker utilisées en production avec les autres images, il est necessaire de ne pas les référencer de la même façon dans le conteneur registry. 

Comment fonctionne le réferencement ?

GitLab propose une série de variable pré defini permettant d'acceder à certaine valeur. C'est le cas de la variable ${CI_REGISTRY_IMAGE} qui est en faite l'adresse du container registry de notre projet.

Un référencement ce compose de la manière suivante :

```
Adresse_registry/nom_image:tag
```

par exemple:

```
"${CI_REGISTRY_IMAGE}:${CI_COMMIT_TAG}"
```
En utilisant les variables suivantes, diviser le job publish_go en deux jobs publish_release et publish_snapshot. 

```
DOCKER_SNAPSHOT_IMAGE: "${CI_REGISTRY_IMAGE}/snapshot:${CI_COMMIT_REF_SLUG}-${CI_COMMIT_SHORT_SHA}"
DOCKER_RELEASE_IMAGE: "${CI_REGISTRY_IMAGE}/${CI_PROJECT_PATH}-${CI_COMMIT_REF_NAME}"
```

Les deux jobs créés devront s'executer manuellement.  
Le job publish_release ne pourra être executé que sur la branche main  
Le job publish_snapshot ne pourra être executé que sur la branche develop  

Afin de tester le bon fonctionnement de votre pipeline, vous devrez l'executer sur la branche main et develop.

## Exo 4

A l'aide de la [documentation suivante](https://docs.gitlab.com/ci/yaml/workflow/), réaliser un workflow permettant le déclanchement de la pipeline uniquement sur des évenements de type "Push".

Pour tester le mecanisme, essayez de lancer la pipeline manuellement en allant dans Build => pipelines, puis en cliquant sur New pipeline et après avoir choisi sa branche, New pipeline.

## Exo 5

A l'aide de la [documentation suivante](https://docs.gitlab.com/user/application_security/sast/gitlab_advanced_sast/), intégrer les tests SAST à votre pipeline.