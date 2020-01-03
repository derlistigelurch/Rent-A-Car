SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_kunde
AS
  /*********************************************************************
  /**
  /** Function: f_get_kunde_id_i
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** Returns: ID des Kunden
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /*********************************************************************/
  -- FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_get_car_count_bi
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Returns: Anzahl der geliehenen Autos
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /*********************************************************************/
  FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_insert_kunde_i
  /** In: l_i_person_id_in - Person ID
  /** Returns: ID des Kunden
  /** Developer: 
  /** Description: Neuen Kunden anlegen
  /**
  /**********************************************************************/
  FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Procedure: sp_kunde_anlegen
  /** In: l_i_plz_in - Postleitzahl
  /** In: l_v_ortsname_in - Ortsname
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_v_vorname_in - Voname
  /** In: l_v_nachname_in - Nachname
  /** In: l_v_geb_datum_in - Geburtsdatum
  /** Developer: 
  /** Description: legt einen neuen Kunden an
  /**
  /**********************************************************************/
  PROCEDURE sp_kunde_anlegen(l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_v_geb_datum_in IN VARCHAR2);
  
  /*********************************************************************
  /**
  /** Procedure: sp_name_bearbeiten
  /** In: l_i_kunde_id_in - ID des Kunden
  /** In: l_v_vorname_neu_in - neuer Vorname
  /** In: l_v_nachanme_neu_in - neuer Nachname
  /** Developer: 
  /** Description: Name eines Kunden bearbeiten
  /**
  /**********************************************************************/
  PROCEDURE sp_name_bearbeiten(l_i_kunde_id_in IN INTEGER, l_v_vorname_neu_in IN VARCHAR2, l_v_nachanme_neu_in IN VARCHAR2);
  
  /*********************************************************************
  /**
  /** Procedure: sp_kunden_anzeigen
  /** Out: l_i_kunde_count_ou - Anzahl der gefundenen Kunden
  /** In: l_v_vorname_in - Vorname
  /** In: l_v_nachname_in - Nachname
  /** Developer: 
  /** Description: Alle Kunden mit passendem Vorname, Nachnamen anzeigen
  /**
  /**********************************************************************/
  PROCEDURE sp_kunden_anzeigen(l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_count_ou OUT INTEGER);
END pa_kunde;
/

-- pa_kunde body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_kunde
AS
  /* f_get_kunde_id_i definition *********************************************/
  /*FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2)
  RETURN INTEGER
  AS
    l_i_kunde_id INTEGER;
    BEGIN
      SELECT KUNDENNUMMER
      INTO l_i_kunde_id
      FROM kundendaten_view
      WHERE VORNAME = l_v_vorname_in 
            AND NACHNAME = l_v_nachname_in;
      RETURN l_i_kunde_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE NO_DATA_FOUND;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_get_kunde_id_i;*/
  /*************************************************************************/
  
  /* f_get_car_count_bi definition *******************************************/
  FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_bi_car_count INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_car_count
      FROM VERLEIH
      WHERE VERLEIH.KUNDE_ID = l_i_kunde_id_in 
            AND VERLEIH.RETOURNIERT = 0;
      RETURN l_bi_car_count;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_get_car_count_bi;
  /*************************************************************************/

  /* f_insert_kunde_i definition *******************************************/
  FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_kunde_id INTEGER;
    BEGIN    
      INSERT INTO  KUNDE (KUNDE_ID, PERSON_ID) 
      VALUES (kunden_seq.NEXTVAL, l_i_person_id_in)
      RETURNING KUNDE_ID
      INTO l_i_kunde_id;
      RETURN l_i_kunde_id;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_insert_kunde_i;
  /*************************************************************************/
  
  /* sp_kunde_anlegen definition *******************************************/
  PROCEDURE sp_kunde_anlegen(l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_v_geb_datum_in IN VARCHAR2)
  AS
    l_i_adress_id INTEGER;
    l_i_person_id INTEGER;
    l_i_kunde_id INTEGER;
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
      -- Adresse bereits vorhanden? Wenn nicht Adresse einfügen (Strasse, Hausnummer, Türnummer)
      -- FUNCTION f_get_adress_count_bi (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
      IF pa_adresse.f_get_adress_count_bi(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in) < 1
      THEN  
        -- FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
        l_i_adress_id := pa_adresse.f_insert_adresse_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
      ELSE
        -- FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
        l_i_adress_id := pa_adresse.f_get_adress_id_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
      END IF;
      -- Person anlegen (Vorname, Nachname, AdressID)
      -- FUNCTION f_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER) RETURN INTEGER
      l_i_person_id := pa_person.f_insert_person_i(l_v_vorname_in, l_v_nachname_in, l_v_geb_datum_in, l_i_adress_id);
      -- Kunde anlegen (KundeID, PersonID)
      -- FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER) RETURN INTEGER
      l_i_kunde_id := pa_kunde.f_insert_kunde_i(l_i_person_id);
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      DBMS_OUTPUT.PUT_LINE(TO_CHAR('Neuer Kunde ' || l_v_vorname_in|| ' ' || l_v_nachname_in || ' mit der KundenID ' || l_i_kunde_id || ' wurde angelegt!'));
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      COMMIT;
    EXCEPTION
      WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Die eingegebenen Daten haben das falsche Format!');
        ROLLBACK;
      WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('Die eingegebenen Daten haben das falsche Format!');
        ROLLBACK;
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Die Adresse konnte nicht gefunden werden!');
        DBMS_OUTPUT.PUT_LINE('Wahrscheinlich gab es einen Fehler beim speichern der Daten!');
        ROLLBACK;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
    END sp_kunde_anlegen;
  /*************************************************************************/
  
  /* sp_name_bearbeiten definition *******************************************/
  PROCEDURE sp_name_bearbeiten(l_i_kunde_id_in IN INTEGER, l_v_vorname_neu_in IN VARCHAR2, l_v_nachanme_neu_in IN VARCHAR2)
  AS
    l_i_person_id INTEGER;
    BEGIN
      COMMIT;
      -- Person_ID herausfinen
      -- FUNCTION f_get_person_id (l_i_kunde_id_in IN INTEGER) RETURN INTEGER
      l_i_person_id := pa_person.f_get_person_id(l_i_kunde_id_in);
      -- Namen ändern
      -- PROCEDURE sp_change_name (l_i_person_id_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2)
      pa_person.sp_change_name(l_i_person_id, l_v_vorname_neu_in, l_v_nachanme_neu_in);
      -- DBMS_OUTPUT.PUT_LINE('Name geändert!');
      -- DBMS_OUTPUT.PUT_LINE('Neuer Name: ' || l_v_vorname_neu_in || ' ' || l_v_nachanme_neu_in || ', Kunden ID: ' || l_i_kunde_id_in); 
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Kunde nicht gefunden!');
        ROLLBACK;        
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
    END sp_name_bearbeiten;
  /*************************************************************************/
  
  /* sp_kunden_anzeigen definition *****************************************/
  PROCEDURE sp_kunden_anzeigen(l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_count_ou OUT INTEGER)
  AS
    CURSOR kunde_cur IS SELECT * FROM KUNDENDATEN_VIEW WHERE VORNAME = l_v_vorname_in AND NACHNAME = l_v_nachname_in;
    x_no_kunden_data_found EXCEPTION;
    BEGIN
      SELECT COUNT(*) 
      INTO l_i_kunde_count_ou
      FROM KUNDENDATEN_VIEW 
      WHERE VORNAME = l_v_vorname_in 
            AND NACHNAME = l_v_nachname_in;
    
      IF l_i_kunde_count_ou > 0
      THEN
        FOR l_v_result_cv IN kunde_cur
        LOOP
          IF l_v_result_cv.TUERNUMMER IS NULL
          THEN
            DBMS_OUTPUT.PUT_LINE('| ID: ' || l_v_result_cv.KUNDENNUMMER || ' NAME: ' || l_v_result_cv.VORNAME || ' ' || l_v_result_cv.NACHNAME || ' GEB.DATUM: ' || l_v_result_cv.GEBURTSDATUM || ' ADRESSE: ' || l_v_result_cv.STRASSE || ' ' || l_v_result_cv.HAUSNUMMER || ' ' || l_v_result_cv.PLZ || ' ' || l_v_result_cv.ORTSNAME);
          ELSE
            DBMS_OUTPUT.PUT_LINE('| ID: ' || l_v_result_cv.KUNDENNUMMER || ' NAME: ' || l_v_result_cv.VORNAME || ' ' || l_v_result_cv.NACHNAME || ' GEB.DATUM: ' || l_v_result_cv.GEBURTSDATUM || ' ADRESSE: ' || l_v_result_cv.STRASSE || ' ' || l_v_result_cv.HAUSNUMMER || '/' || l_v_result_cv.TUERNUMMER || ' ' || l_v_result_cv.PLZ || ' ' || l_v_result_cv.ORTSNAME);
          END IF;
        END LOOP;
      ELSE
        RAISE x_no_kunden_data_found;
      END IF;
    EXCEPTION
      WHEN x_no_kunden_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Kein Kunde gefunden!');
        ROLLBACK;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
    END sp_kunden_anzeigen;
  /*************************************************************************/
END;
/

COMMIT;
