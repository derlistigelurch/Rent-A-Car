# RENT-A-CAR
#### Python Version
* python 3.5.6 64-bit
---
#### Libraries
* cx_Oracle
* json
* datetime
---
#### Reihenfolge
1. Config-File anpassen
    *  **config/**
       * config.json
---
2. Tabellen anlegen
   * create_table_script.sql
---
3. Sequenzen erstellen
    * create_sequence_script.sql
---
4. Daten einfügen
    * insert_script.sql
---
5. Views anlegen
    * **views/**
        * view_autos_hauptstandort.sql
        * view_kundendaten.sql
        * view_rechnungen.sql
        * view_verfuegbare_autos.sql
---
6. Packages erstellen
    * **packages/**
        * pa_err.sql
        * pa_person.sql
        * pa_adresse.sql
        * pa_kunde.sql
        * pa_exemplar.sql
        * pa_schaeden.sql
        * pa_verleih.sql
---
7. Trigger erstellen
    * **trigger/**
        * tr_auto_verleihen.sql
        * tr_kunde_bearbeiten_adresse.sql
        * tr_kunde_bearbeiten_name.sql
        * tr_kunde_erstellen.sql
---
8. Index erzeugen
    * **index/**
        * index_adresse.sql
        * index_auto_details.sql
        * index_exemplar.sql
        * index_kunde.sql
        * index_mitarbeiter.sql
        * index_person.sql
        * index_postleitzah.sql
        * index_schaeden.sql
        * index_verleih.sql
