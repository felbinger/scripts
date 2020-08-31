#!/bin/bash
date=$(date +"%Y-%m-%d")

# database configuration
# database host: default = localhost
db_host="localhost"
# database username
# its useful to create a user (for example: backup) which has only read and lock permissions
# (SELECT, LOCK TABLES, REFERENCE) on every database that is included in this backup
db_user="USERNAME"
# database password
db_pass="PASSWORD"
# list with databases which should be included in the backup
# stored as .sql file
db_names=("DB1" "DB2")
# folder list get also included in the backup (e.g. "/var/www" "/home/user")
# stored as tar.gz file
folder_paths=("Folder1" "Folder2")
# path where the backups should be stored (e.g. /var/backups)
backup_path="BACKUPPATH"

function backup() {
  for db_name in ${db_names[*]}; do
    if [ -e ${backup_path}/${db_name}${date}.sql ]; then
      echo -e "\e[33m[${db_name}] database backup skipped!\e[39m"
    else
      echo -e "\e[33m[${db_name}] database backup initialized\e[39m"
      # Check if the last character of backup_path is a "/", if not add it.
      if [ "${backup_path:${#backup_path}-1:1}" != "/" ]; then
        backup_path=${backup_path}/
      fi
      sudo mysqldump --lock-tables -h ${db_host} -u ${db_user} -p${db_pass} ${db_name} > ${backup_path}${db_name}${date}.sql
      if [ $? == 0 ]; then
        echo -e "\e[32m[${db_name}] database backup successful!\e[39m"
      else
        echo -e "\e[91m[${db_name}] database backup failed!\e[39m"
      fi
    fi
  done
  for folder_path in ${folder_paths[*]}; do
    # Check if the last character of backup_path is a "/", if yes delete it.
    if [ "${folder_path:${#folder_path}-1:1}" == "/" ]; then
      folder_path="${folder_path::-1}"
    fi
    echo -e "\e[33m[${folder_path}] backup initialized\e[39m"
    if [ -e ${backup_path}/${folder_path}${date}.tar.gz ]; then
      echo -e "\e[33m[${folder_path}] backup skipped!\e[39m"
    else
      tar cPzf ${backup_path}/${folder_path}${date}.tar.gz ${folder_path}
      if [ $? == 0 ]; then
        echo -e "\e[32m[${folder_path}] backup successful!\e[39m"
      else
        echo -e "\e[91m[${folder_path}] backup failed!\e[39m"
      fi
    fi
  done
}

backup
