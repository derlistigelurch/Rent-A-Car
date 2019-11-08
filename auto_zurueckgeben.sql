-- Auto zurückgeben
--------------------------------------
/*
 * 1. KUNDEN_ID herausfinden
 * 2. EXEMPLAR_ID herausfinden
 * 3. STATUS_ID in Exemplar Tabelle auf 3 (im Haus) setzen
 * 4. In Verleih Tabelle RETOURNIERT auf 1 setzen
 * 5. Falls Schäden vorhanden:
 * 5.1 Checken ob Schaden Bezeichnung in Schaeden Tabelle exisiert, falls nicht --> einfügen
 * 5.2 EXEMPLAR_ID und SCHAEDEN_ID in EXEMP_SCHAEDEN einfügen
 * 5.3 SCHADEN_ID in Exemplar Tabelle updaten
*/

SELECT * FROM KUNDE;
SELECT * FROM PERSON;
SELECT * FROM EXEMPLAR;
SELECT * FROM VERLEIH;
SELECT * FROM SCHAEDEN;
SELECT * FROM STATUS;
SELECT * FROM EXEMP_SCHAEDEN;

-- 1. KUNDEN_ID herausfinden
SELECT KUNDE.KUNDEN_ID
FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
WHERE PERSON.VORNAME = 'Tom' AND
      PERSON.NACHNAME = 'Turbo';
      
-- 2. EXEMPLAR_ID herausfinden
SELECT EXEMPLAR_ID 
FROM VERLEIH
WHERE KUNDE_ID = 2;

-- 3. STATUS_ID in Exemplar Tabelle auf 3 (im Haus) setzen
UPDATE EXEMPLAR
SET STATUS_ID = 3 -- im Haus
WHERE EXEMPLAR_ID = 5;
  
-- 4. In Verleih Tabelle RETOURNIERT auf 1 setzen  
UPDATE VERLEIH
SET RETOURNIERT = 1
WHERE EXEMPLAR_ID = 5;
  
-- 5. Falls Schäden vorhanden:
-- 5.1 Checken ob Schaden Bezeichnung in Schaeden Tabelle exisiert...
SELECT COUNT(*)
FROM SCHAEDEN
WHERE BESCHREIBUNG = 'Reifenschaden';
-- ...falls nicht --> einfügen
INSERT INTO SCHAEDEN (SCHAEDEN_ID, BESCHREIBUNG) VALUES (schaden_seq.NEXTVAL, 'Reifenschaden');

-- 5.2 EXEMPLAR_ID und SCHAEDEN_ID in EXEMP_SCHAEDEN einfügen
INSERT INTO EXEMP_SCHAEDEN (KOMBO_ID, SCHAEDEN_ID, EXEMPLAR_ID) VALUES (exemp_schaden_seq.NEXTVAL, 6, 5);

-- 5.3 SCHADEN_ID in Exemplar Tabelle updaten
UPDATE EXEMPLAR
SET SCHAEDEN_ID = 6
WHERE EXEMPLAR_ID = 5;
-------------------------------------
-- Überprüfen ob alles funktioniert
SELECT SCHAEDEN.BESCHREIBUNG, EXEMPLAR.KENNZEICHEN, HERSTELLER.BEZEICHNUNG, AUTO_DETAILS.MODELL_BESCHREIBUNG
FROM EXEMP_SCHAEDEN JOIN SCHAEDEN ON SCHAEDEN.SCHAEDEN_ID = EXEMP_SCHAEDEN.SCHAEDEN_ID
                    LEFT JOIN EXEMPLAR ON SCHAEDEN.SCHAEDEN_ID = EXEMPLAR.SCHAEDEN_ID
                    LEFT JOIN AUTO_DETAILS ON AUTO_DETAILS.DETAIL_ID = EXEMPLAR.AUTO_DETAILS_ID
                    LEFT JOIN HERSTELLER ON HERSTELLER.HERSTELLER_ID = AUTO_DETAILS.HERSTELLER_ID;

