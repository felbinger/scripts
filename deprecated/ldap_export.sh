#!/bin/bash

BACKUP_BASE_DIR='/home/backups'
COMPOSE='/home/admin/services/main/docker-compose.yml'
ENV_FILE='/home/admin/services/main/.ldap.env'
CONTAINER_NAME='ldap'
BASE_DN='dc=domain,dc=de'
BIND_DN='cn=admin,dc=domain,dc=de'
BIND_PW=$(grep 'LDAP_ADMIN_PASSWORD' ${ENV_FILE} | cut -d '=' -f2 | tr -d \')

CONTAINER_ID=$(sudo docker-compose -f ${COMPOSE} ps -q ${CONTAINER_NAME})
CONTAINER_FULL_NAME=$(sudo docker ps --filter "id=${CONTAINER_ID}" --format '{{ .Names }}')
BACKUP_DIR="${BACKUP_BASE_DIR}/$(date '+%Y-%m-%d')/${CONTAINER_FULL_NAME}"

sudo docker-compose -f ${COMPOSE} exec -T ${CONTAINER_NAME} \
  ldapsearch -b ${BASE_DN} -D ${BIND_DN} -x -w ${BIND_PW} | \
  sudo tee "${BACKUP_DIR}.ldif" > /dev/null
