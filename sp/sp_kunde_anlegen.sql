-- Kunde anlegen
/*
 *  1. Adresse einfügen
 *    1.1 PLZ bereits vorhanden? Wenn nicht, dann einfügen (PLZ, Ortsname)
 *    1.2 Adresse einfügen (Strasse, Hausnummer, Türnummer)
 *  2. Person anlegen (Vorname, Nachname, AdressID)
 *  3. Kunde anlegen (KundeID, PersonID)
 */
SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PROCEDURE sp_kunde_anlegen(l_i_plz_in       IN INTEGER,
                                             l_v_ortsname_in  IN VARCHAR2,
                                             l_v_strasse_in   IN VARCHAR2,
                                             l_i_hausnr_in    IN INTEGER,
                                             l_i_tuernr_in    IN INTEGER,
                                             l_v_vorname_in   IN VARCHAR2,
                                             l_v_nachname_in  IN VARCHAR2,
                                             l_v_geb_datum_in IN VARCHAR2)
AS
  l_v_adress_id INTEGER;
  l_i_person_id INTEGER;
  l_i_kunde_id INTEGER;
  --l_v_output VARCHAR2(255);
BEGIN
  COMMIT;
  -- Adresse einfügen
  -- PLZ bereits vorhanden? Wenn nicht, dann einfügen (PLZ, Ortsname)
  -- FUNCTION f_get_plz_count_bi(l_i_plz_in IN INTEGER) 
  IF pa_adresse.f_get_plz_count_bi(l_i_plz_in) < 1
  THEN
    -- PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2)
    pa_adresse.sp_insert_plz(l_i_plz_in, l_v_ortsname_in);
  END IF;
  -- Adresse einfügen (Strasse, Hausnummer, Türnummer)
  -- FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER)
  l_v_adress_id := pa_adresse.f_insert_adresse_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
  -- Person anlegen (Vorname, Nachname, AdressID)
  -- FUNCTION f_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER)
  l_i_person_id := pa_person.f_insert_person_i(l_v_vorname_in, l_v_nachname_in, SYSDATE, l_v_adress_id);
  -- Kunde anlegen (KundeID, PersonID)
  -- FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER)
  l_i_kunde_id := pa_kunde.f_insert_kunde_i(l_i_person_id);
  dbms_output.put_line(TO_CHAR('Neuer Kunde ' || l_v_vorname_in|| ' ' || l_v_nachname_in || ' mit der KundenID ' || l_i_kunde_id || ' wurde angelegt!'));
  COMMIT;
  EXCEPTION
    WHEN VALUE_ERROR THEN
      dbms_output.put_line('Die eingegebenen Daten haben das falsche Format!');
      ROLLBACK;
    WHEN INVALID_NUMBER THEN
      dbms_output.put_line('Die eingegebenen Daten haben das falsche Format!');
      ROLLBACK;
    WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      ROLLBACK;
END sp_kunde_anlegen;
/
COMMIT;
