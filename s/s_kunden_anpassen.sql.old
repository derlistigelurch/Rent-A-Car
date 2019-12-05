-- Kunden anpassen
--------------------------------------
/*
 * 1. KUNDEN_ID des bestehenden Kunden suchen
 * 2. Daten des Kunden anpassen
 * 2.1 Bei Adressänderung muss ggf. auf die PLZ Tabelle angepasst werden
 * 2.2 Adresse anpassen
 * 2.2.1 Gibt es die neue Postleitzahl bereits, wenn nicht einfügen
 * 2.3 Nachname anpassen
*/

SELECT * FROM PERSON;
SELECT * FROM KUNDE;
SELECT * FROM ADRESSE;
SELECT * FROM POSTLEITZAHL;

-- 1. KUNDEN_ID des bestehenden Kunden suchen
SELECT KUNDE_ID
FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
            JOIN ADRESSE ON ADRESSE.ADRESS_ID = PERSON.ADRESS_ID
WHERE PERSON.VORNAME = 'Tom' AND
      PERSON.NACHNAME = 'Turbo';
      
-- 2. Daten des Kunden anpassen
-- 2.1 Bei Adressänderung muss ggf. auf die PLZ Tabelle angepasst werden
-- 2.2 Gibt es die neue Postleitzahl bereits, wenn nicht einfügen
SELECT COUNT(*)
FROM POSTLEITZAHL
WHERE PLZ = 7081;

INSERT INTO POSTLEITZAHL ("PLZ", "ORTSNAME") VALUES (7081, 'Schützen am Gebirge');

-- 2.2 Adresse in Tabelle einfügen
INSERT INTO ADRESSE (ADRESS_ID, STRASSE, HAUSNUMMER, TUERNUMMER, PLZ) VALUES (adresse_seq.NEXTVAL, 'Hauptstrasse', 1, NULL, 7081);

-- 2.3 ADRESS_ID in Personen tabelle anpassen
SELECT PERSON.PERSON_ID
FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
WHERE KUNDE.KUNDE_ID = 2;

SELECT *
FROM PERSON
WHERE PERSON_ID = 4;

SELECT ADRESS_ID
FROM ADRESSE
WHERE  ROWNUM = 1
ORDER BY ADRESS_ID DESC;

UPDATE PERSON
SET ADRESS_ID = 7
WHERE PERSON_ID = 4;     
  
-- 2.3 Nachname anpassen
SELECT PERSON.PERSON_ID
FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
WHERE KUNDE.KUNDE_ID = 2;

UPDATE PERSON
SET NACHNAME = 'Mayer'
WHERE PERSON_ID = 4;
-------------------------------------
-- Überprüfen ob alles funktioniert
SELECT KUNDE.KUNDE_ID, PERSON.VORNAME, PERSON.NACHNAME, ADRESSE.STRASSE, ADRESSE.HAUSNUMMER, ADRESSE.TUERNUMMER, POSTLEITZAHL.PLZ, POSTLEITZAHL.ORTSNAME 
FROM KUNDE JOIN PERSON ON KUNDE.PERSON_ID = PERSON.PERSON_ID
           JOIN ADRESSE ON ADRESSE.ADRESS_ID = PERSON.ADRESS_ID
           JOIN POSTLEITZAHL ON ADRESSE.PLZ = POSTLEITZAHL.PLZ;
