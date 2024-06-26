Idee per un backup incrementale usando tar e find. Da aggiungere, in caso, al crontab. Piccolo paragrafo riguardo rsync con i suoi comandi più utili in caso lo si voglia implementare.




il backup, una volta creato/aggiornato, lo si può gzippare con gzip *nome backup*.

si può anche sommare a find, per eliminare backup vecchi. Esempio:

find "/example/path*" -mtime +7 -exec rm -rf {} \;

questo esempio sopra elimina tutti i file più vecchi di 7 giorni. Ovviamente la finestra di tempo è personalizzabile. Se ci fosse stato un - al posto del + sarebbero stati tutti i file più recenti di...

------

rsync -auvP *source* *dest*

a: archive. Preserva i metadata e i permessi, per esempio

u: aggiorna il file di destinazione con solo i nuovi file della sorgente

v: verbose

P: partial. Se la connessione cade riprende da dove si era bloccato


altro utile parametro è "--delete-after", così da eliminare i file sulla destinazione DOPO che il trasferimento si sia concluso con successo. Utile per quando si aggiorna un sito web, cosicché il downtime è minimo.

"--dry-run" emula quel che andrà a fare