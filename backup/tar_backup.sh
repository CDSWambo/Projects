#script tar per backup e aggiornamenti del file creato


#!/usr/bin/env bash


source="*path*"

backup_dir="backup"

backup="backup/backup$(date +%Y%m%d).tar"


#creazione backup_dir

if [ ! -d "$backup_dir" ]; then
        mkdir "$backup_dir"
fi

#tar iniziale dir

if [ ! -f "$backup" ]; then
        tar -cvpf "$backup" "$source"  #&& tar -tf $backup


else
        #aggiornarlo in caso di modifiche

        tar -uvpf "$backup" "$source" #&& tar -tf $backup

fi