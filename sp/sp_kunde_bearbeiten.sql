-- Kunden bearbeiten
/*
 *  1. ID des bestehenden Kunden suchen, wenn vorhanden weitermachen, ansonsten abbrechen
 *  2. Daten des Kunden anpassen
 *    2.1 Name des Kunden anpassen
 *    2.2 Bei Adressänderung muss ggf. auf die PLZ Tabelle angepasst werden
 *      2.2.1 Neue PLZ bereits vorhanden? Wenn nicht, dann einfügen (PLZ, Ortsname) 
 *      2.2.2 Adresse bereits vorhanden? Wenn nicht Adresse einfügen (Strasse, Hausnummer, Türnummer)
*/
SET SERVEROUTPUT ON;
/
-- Adresse bearbeiten
CREATE OR REPLACE PROCEDURE sp_adresse_bearbeiten(l_i_plz_in      IN INTEGER, 
                                                  l_v_ortsname_in IN VARCHAR2,
                                                  l_v_strasse_in  IN VARCHAR2,
                                                  l_i_hausnr_in   IN INTEGER,
                                                  l_i_tuernr_in   IN INTEGER,
                                                  l_v_vorname_in  IN VARCHAR2,
                                                  l_v_nachname_in IN VARCHAR2)
AS
  l_i_adress_id INTEGER;
  l_i_kunde_id INTEGER;
  l_i_person_id INTEGER;
  BEGIN
  COMMIT;
  -- Kundennummer herausfinden
  -- FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER
  l_i_kunde_id := pa_kunde.f_get_kunde_id_i(l_v_vorname_in, l_v_nachname_in);
  -- Person_ID herausfinen
  -- FUNCTION f_get_person_id (l_i_kunde_id_in IN INTEGER) RETURN INTEGER
  l_i_person_id := pa_person.f_get_person_id(l_i_kunde_id);
  -- Adresse ändern
  -- PLZ bereits vorhanden? Wenn nicht, dann einfügen (PLZ, Ortsname)
  -- FUNCTION f_get_plz_count_bi(l_i_plz_in IN INTEGER) RETURN INTEGER
  IF pa_adresse.f_get_plz_count_bi(l_i_plz_in) < 1
  THEN
    -- PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2)
    pa_adresse.sp_insert_plz(l_i_plz_in, l_v_ortsname_in);
  END IF;
  -- Adresse bereits vorhanden? Wenn nicht Adresse einfügen (Strasse, Hausnummer, Türnummer)
  -- FUNCTION f_get_adress_count_bi (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
  IF pa_adresse.f_get_adress_count_bi(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in) < 1
  THEN  
    -- FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
    l_i_adress_id := pa_adresse.f_insert_adresse_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
  ELSE
    -- FUNCTION f_get_adress_id_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
    l_i_adress_id := pa_adresse.f_get_adress_id_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
  END IF;
  -- AdressId ändern
  -- PROCEDURE sp_update_adress_id (l_i_person_id_in IN INTEGER, l_i_adress_id_in IN INTEGER)
  pa_person.sp_update_adress_id(l_i_person_id, l_i_adress_id);
  DBMS_OUTPUT.PUT_LINE('Adresse geändert!');
  IF l_i_tuernr_in IS NULL
  THEN
    DBMS_OUTPUT.PUT_LINE('Neue Adresse: ' || l_v_strasse_in || ' ' || l_i_hausnr_in || ', ' || l_i_plz_in || ' ' || l_v_ortsname_in || ', Adress ID: ' || l_i_adress_id);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Neue Adresse: ' || l_v_strasse_in || ' ' || l_i_hausnr_in || '/' || l_i_tuernr_in || ', ' || l_i_plz_in || ' ' || l_v_ortsname_in || ', Adress ID: ' || l_i_adress_id);
  END IF;
  COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Kunde nicht gefunden!');
      ROLLBACK;
    WHEN OTHERS THEN
      --pa_err.sp_err_handling(SQLCODE, SQLERRM);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
END sp_adresse_bearbeiten;
/

-- Name bearbeiten
CREATE OR REPLACE PROCEDURE sp_name_bearbeiten(l_v_vorname_in       IN VARCHAR2,
                                               l_v_nachname_in      IN VARCHAR2,
                                               l_v_vorname_neu_in   IN VARCHAR2,
                                               l_v_nachanme_neu_in  IN VARCHAR2)
AS
  l_i_kunde_id INTEGER;
  l_i_person_id INTEGER;
  BEGIN
    COMMIT;
    -- Kundennummer herausfinden
    -- FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER
    l_i_kunde_id := pa_kunde.f_get_kunde_id_i(l_v_vorname_in, l_v_nachname_in);
    -- Person_ID herausfinen
    -- FUNCTION f_get_person_id (l_i_kunde_id_in IN INTEGER) RETURN INTEGER
    l_i_person_id := pa_person.f_get_person_id(l_i_kunde_id);
    -- Namen ändern
    -- PROCEDURE sp_change_name (l_i_person_id_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2)
    pa_person.sp_change_name(l_i_person_id, l_v_vorname_neu_in, l_v_nachanme_neu_in);
    DBMS_OUTPUT.PUT_LINE('Name geändert!');
    DBMS_OUTPUT.PUT_LINE('Alter Name: ' || l_v_vorname_in || ' ' || l_v_nachname_in || ', Kunden ID: ' || l_i_kunde_id);
    DBMS_OUTPUT.PUT_LINE('Neuer Name: ' || l_v_vorname_neu_in || ' ' || l_v_nachanme_neu_in || ', Kunden ID: ' || l_i_kunde_id); 
  COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Kunde nicht gefunden!');
      ROLLBACK;        
    WHEN OTHERS THEN
      --pa_err.sp_err_handling(SQLCODE, SQLERRM);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
END sp_name_bearbeiten;
/

COMMIT;
