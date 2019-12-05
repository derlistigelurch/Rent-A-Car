SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_verleih
AS
  /*********************************************************************
  /**
  /** Function: f_get_rechnung_v
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Returns: Rechnungsdaten
  /** Developer: 
  /** Description: Gibt alle Rechnungsdaten aus
  /**
  /*********************************************************************/
  FUNCTION f_get_rechnung_v (l_i_kunde_id_in IN INTEGER) RETURN VARCHAR2;
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_exemplar
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_i_kunde_id_in - ID des Kunden
  /** In: l_d_verliehen_ab_in - Zeitpunkt ab dem das Auto verliehen wird
  /** In: l_d_verliehen_bis_in - Zeitpunkt an dem das Auto zurückgegben wird
  /** In: l_i_mitarbeiter_id_in - Mitarbeiter ID
  /** Developer: 
  /** Description: Auto verleihen
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_autos_anzeigen
  /** Out: l_i_car_count_ou - Anzahl der gefundenen Autos
  /** Developer: 
  /** Description: Alle Autos verfügbaren anzeigen
  /**
  /**********************************************************************/
  PROCEDURE sp_autos_anzeigen(l_i_car_count_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_auto_verleihen
  /** Out: l_i_car_count_ou - Anzahl der gefundenen Autos
  /** In: l_v_vorname_in - Exemplar ID
  /** In: l_v_nachname_in - Exemplar ID
  /** In: l_i_exemplar_id - Exemplar ID
  /** In: l_d_verliehen_ab_in - Exemplar ID
  /** In: l_d_verliehen_bis_in - Exemplar ID
  /** Developer: 
  /** Description: sp_auto_verleihen
  /**
  /**********************************************************************/
  PROCEDURE sp_auto_verleihen(l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_exemplar_id_in IN INTEGER, l_d_verliehen_ab_in IN VARCHAR2, l_d_verliehen_bis_in IN VARCHAR2);
  
  /*********************************************************************
  /**
  /** Procedure: sp_auto_verleihen
  /** Out: l_v_rechnung_ou - Anzahl der gefundenen Autos
  /** IN: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Rechnung anzeigen
  /**
  /**********************************************************************/
  PROCEDURE sp_rechnung_anzeigen(l_i_kunde_id_in IN INTEGER, l_v_rechnung_ou OUT VARCHAR2);
END pa_verleih;
/

CREATE OR REPLACE PACKAGE BODY pa_verleih
AS
  /* f_get_rechnung_v definition *******************************************/
  FUNCTION f_get_rechnung_v (l_i_kunde_id_in IN INTEGER) 
  RETURN VARCHAR2
  AS
    l_i_verleih_id INTEGER;
    l_i_kunde_id INTEGER;
    l_v_vorname VARCHAR2(30);
    l_v_nachname VARCHAR2(30);
    l_i_mitarbeiter_id INTEGER;
    l_v_bezeichnung VARCHAR2(200);
    l_v_modell_beschreibung VARCHAR2(200);
    l_i_dauer INTEGER;
    l_i_kosten_pro_tag INTEGER;
    l_i_kosten_insgesamt INTEGER;
    l_bi_bezahlt INTEGER;
    BEGIN
      SELECT VERLEIH_ID,
             KUNDE_ID,
             VORNAME,
             NACHNAME,
             MITARBEITER_ID,
             BEZEICHNUNG,
             MODELL_BESCHREIBUNG,
             DAUER, 
             KOSTEN_INSGESAMT, 
             KOSTEN_PRO_TAG,
             BEZAHLT          
      INTO l_i_verleih_id,
           l_i_kunde_id,
           l_v_vorname,
           l_v_nachname,
           l_i_mitarbeiter_id,
           l_v_bezeichnung,
           l_v_modell_beschreibung,
           l_i_dauer,
           l_i_kosten_insgesamt, 
           l_i_kosten_pro_tag,
           l_bi_bezahlt
      FROM RECHNUNGEN_VIEW
      WHERE KUNDE_ID = l_i_kunde_id_in
            AND BEZAHLT = 0;
    RETURN l_i_verleih_id || ',' || l_i_kunde_id || ',' || l_v_vorname || ',' || l_v_nachname || ',' || l_i_mitarbeiter_id || ',' || l_v_bezeichnung || ',' || l_v_modell_beschreibung || ',' || l_i_dauer || ',' || l_i_kosten_pro_tag || ',' || l_i_kosten_insgesamt || ',' || l_bi_bezahlt;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE NO_DATA_FOUND;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_get_rechnung_v;
  /*************************************************************************/
  /* sp_insert_exemplar definition *******************************************/
  PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER)
  AS
    l_i_nicht_retourniert INTEGER := 0;
    
    BEGIN
      INSERT INTO VERLEIH (VERLEIH_ID, EXEMPLAR_ID, KUNDE_ID, VERLIEHEN_AB, VERLIEHEN_BIS, RETOURNIERT, MITARBEITER_ID) 
      VALUES (verleih_seq.NEXTVAL, l_i_exemplar_id_in, l_i_kunde_id_in, l_d_verliehen_ab_in, l_d_verliehen_bis_in, l_i_nicht_retourniert, l_i_mitarbeiter_id_in);
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END sp_insert_exemplar;
  /*************************************************************************/
  
  /* sp_autos_anzeigen definition ***********************************/
  PROCEDURE sp_autos_anzeigen(l_i_car_count_ou OUT INTEGER)
  AS
    CURSOR car_cur IS SELECT * FROM AUTOS_HAUPTSTANDORT_VIEW;
    x_no_cars_available EXCEPTION;
    BEGIN
      SELECT COUNT(*) 
      INTO l_i_car_count_ou
      FROM AUTOS_HAUPTSTANDORT_VIEW;
    
      IF l_i_car_count_ou > 0
      THEN
        FOR l_v_result_cv IN car_cur
        LOOP
          DBMS_OUTPUT.PUT_LINE('| ' || l_v_result_cv.EXEMPLAR_ID || ' ' || l_v_result_cv.BEZEICHNUNG || ' ' || l_v_result_cv.MODELL_BESCHREIBUNG || ' ' || l_v_result_cv.PS || ' ' || l_v_result_cv.VERBRAUCH);
        END LOOP;
      ELSE
        RAISE x_no_cars_available;
      END IF;
    EXCEPTION
      WHEN x_no_cars_available THEN
        DBMS_OUTPUT.PUT_LINE('Keine Fahrzeuge verfügbar!');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
  END sp_autos_anzeigen;
  /*************************************************************************/
  
  /* sp_auto_verleihen definition ******************************************/
  PROCEDURE sp_auto_verleihen(l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_exemplar_id_in IN INTEGER, l_d_verliehen_ab_in IN VARCHAR2, l_d_verliehen_bis_in IN VARCHAR2)
  AS
    l_i_mitarbeiter_id INTEGER := 1;
    l_i_kunde_id INTEGER;
    l_i_status_verliehen INTEGER := 1;
    x_too_many_cars EXCEPTION;
    BEGIN
    -- KUNDEN_ID mit Vorname und Nachname herausfinden
    -- FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER
    l_i_kunde_id := pa_kunde.f_get_kunde_id_i(l_v_vorname_in, l_v_nachname_in);
    -- Überprüfen ob die KUNDEN_ID bereits in der Verleih Tabelle vorhanden ist, wenn ja abbrechen
    -- FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER) RETURN INTEGER
    IF pa_kunde.f_get_car_count_bi (l_i_kunde_id) > 0
    THEN
      RAISE x_too_many_cars;
    END IF;
    -- STATUS_ID in Exemplar Tabelle auf 1 (Verliehen) setzen (TODO: Trigger)
    -- PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER);
    pa_exemplar.sp_update_status(l_i_exemplar_id_in, l_i_status_verliehen);
    -- In Verleih Tabelle EXEMPLAR_ID, KUNDE_ID, VERLEIHEN_AB, VERLEIHEN_BIS, RETOURNIERT = 0 und MITARBEITER_ID einfügen
    -- PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER);
    pa_verleih.sp_insert_exemplar(l_i_exemplar_id_in, l_i_kunde_id, l_d_verliehen_ab_in, l_d_verliehen_bis_in, l_i_mitarbeiter_id);
    DBMS_OUTPUT.PUT_LINE('Fahrzeug (ID ' || l_i_exemplar_id_in || ') an Kunden (ID ' || l_i_kunde_id || ') verliehen!');
    COMMIT;
    EXCEPTION
      WHEN x_too_many_cars THEN
        DBMS_OUTPUT.PUT_LINE('Kunde hat schon ein Auto ausgeliehen!');
        ROLLBACK;
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Keinen Eintrag gefunden!');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
  END sp_auto_verleihen;
  /*************************************************************************/
  
  /* sp_rechnung_anzeigen definition ******************************************/
  PROCEDURE sp_rechnung_anzeigen(l_i_kunde_id_in IN INTEGER, l_v_rechnung_ou OUT VARCHAR2)
  AS
    BEGIN
      -- FUNCTION f_get_rechnung_v (l_i_kunde_id_in IN INTEGER) RETURN VARCHAR2;
      l_v_rechnung_ou := pa_verleih.f_get_rechnung_v(l_i_kunde_id_in);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Für diesen Kunden gibt es keine offene Rechnung!');
        ROLLBACK;   
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
  END sp_rechnung_anzeigen;
  /*************************************************************************/
END;
/

COMMIT;
