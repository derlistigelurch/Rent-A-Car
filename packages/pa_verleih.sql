/**********************************************************************
/*
/* Package: pa_verleih
/* Developer:
/* Description: Beinhaltet alle Verleih-Tabellen-Funktionen
/*
/**********************************************************************/
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
  /** In: l_i_kunde_id_in - ID des Kunden
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_d_verliehen_ab_in - Verleih Anfang
  /** In: l_d_verliehen_bis_in - Verleih Ende
  /** Developer: 
  /** Description: sp_auto_verleihen
  /**
  /**********************************************************************/
  PROCEDURE sp_auto_verleihen(l_i_kunde_id_in IN INTEGER, l_i_exemplar_id_in IN INTEGER, l_d_verliehen_ab_in IN VARCHAR2, l_d_verliehen_bis_in IN VARCHAR2);
  
  /*********************************************************************
  /**
  /** Procedure: sp_rechnung_anzeigen
  /** Out: l_v_rechnung_ou - Rechnung des Kunden
  /** IN: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Rechnung anzeigen
  /**
  /**********************************************************************/
  PROCEDURE sp_rechnung_anzeigen(l_i_kunde_id_in IN INTEGER, l_v_rechnung_ou OUT VARCHAR2);
  
  /*********************************************************************
  /**
  /** Procedure: sp_auto_zurueckgeben
  /** IN: l_i_kunde_id_in - ID des Kunden
  /** IN: l_bi_schaeden_in - 1 wenn es Schäden gibt, ansonsten etwas anderes
  /** IN: l_v_bezeichnung_in - Bezeichnung des Schadens
  /** Developer: 
  /** Description: Auto zurückgeben
  /**
  /**********************************************************************/
  PROCEDURE sp_auto_zurueckgeben(l_i_kunde_id_in IN INTEGER, l_bi_schaeden_in IN INTEGER DEFAULT 0, l_v_bezeichnung_in IN VARCHAR2 DEFAULT NULL);
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
    END f_get_rechnung_v;
  /*************************************************************************/
  /* sp_insert_exemplar definition *******************************************/
  PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER)
  AS
    l_i_nicht_retourniert INTEGER := 0;
    
    BEGIN
      INSERT INTO VERLEIH (VERLEIH_ID, EXEMPLAR_ID, KUNDE_ID, VERLIEHEN_AB, VERLIEHEN_BIS, RETOURNIERT, MITARBEITER_ID) 
      VALUES (verleih_seq.NEXTVAL, l_i_exemplar_id_in, l_i_kunde_id_in, l_d_verliehen_ab_in, l_d_verliehen_bis_in, l_i_nicht_retourniert, l_i_mitarbeiter_id_in);
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
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        FOR l_v_result_cv IN car_cur
        LOOP
          DBMS_OUTPUT.PUT_LINE('| ID: ' || l_v_result_cv.EXEMPLAR_ID || ' ' || l_v_result_cv.BEZEICHNUNG || ' ' || l_v_result_cv.MODELL_BESCHREIBUNG || ' PS: ' || l_v_result_cv.PS || ' Verbrauch: ' || l_v_result_cv.VERBRAUCH);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      ELSE
        RAISE x_no_cars_available;
      END IF;
    EXCEPTION
      WHEN x_no_cars_available THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Keine Fahrzeuge verfügbar!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK;
  END sp_autos_anzeigen;
  /*************************************************************************/
  
  /* sp_auto_verleihen definition ******************************************/
  PROCEDURE sp_auto_verleihen(l_i_kunde_id_in IN INTEGER, l_i_exemplar_id_in IN INTEGER, l_d_verliehen_ab_in IN VARCHAR2, l_d_verliehen_bis_in IN VARCHAR2)
  AS
    l_i_mitarbeiter_id INTEGER := 1;
    l_i_status_verliehen INTEGER := 1;
    x_too_many_cars EXCEPTION;
    BEGIN
    SAVEPOINT l_savepoint;
    -- FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
    IF pa_kunde.f_get_car_count_bi (l_i_kunde_id_in) > 0
    THEN
      RAISE x_too_many_cars;
    END IF;
    -- STATUS_ID in Exemplar Tabelle auf 1 (Verliehen) setzen
    -- PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER);
    pa_exemplar.sp_update_status(l_i_exemplar_id_in, l_i_status_verliehen);
    -- In Verleih Tabelle EXEMPLAR_ID, KUNDE_ID, VERLEIHEN_AB, VERLEIHEN_BIS, RETOURNIERT = 0 und MITARBEITER_ID einfügen
    -- PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER);
    pa_verleih.sp_insert_exemplar(l_i_exemplar_id_in, l_i_kunde_id_in, l_d_verliehen_ab_in, l_d_verliehen_bis_in, l_i_mitarbeiter_id);
    COMMIT;
    EXCEPTION
      WHEN x_too_many_cars THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Kunde hat schon ein Auto ausgeliehen!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Keinen Eintrag gefunden!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
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
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Für diesen Kunden gibt es keine Rechnung!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END sp_rechnung_anzeigen;
  /*************************************************************************/
  
  /* sp_auto_zurueckgeben definition ******************************************/
  PROCEDURE sp_auto_zurueckgeben(l_i_kunde_id_in IN INTEGER, l_bi_schaeden_in IN INTEGER DEFAULT 0, l_v_bezeichnung_in IN VARCHAR2 DEFAULT NULL)
  AS
    l_i_exemplar_id INTEGER;
    l_i_status_im_haus INTEGER := 2;
    l_i_status_kaputt INTEGER := 3;
    l_i_schaeden_id INTEGER;
    BEGIN
      SAVEPOINT l_savepoint;
      -- EXEMPLAR_ID herausfinden
      -- FUNCTION f_get_exemplar_id_i (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
      l_i_exemplar_id := pa_exemplar.f_get_exemplar_id_i(l_i_kunde_id_in);
      -- STATUS_ID in Exemplar Tabelle auf 2 (im Haus) setzen
      -- PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER);
      pa_exemplar.sp_update_status(l_i_exemplar_id, l_i_status_im_haus);
      -- In Verleih Tabelle RETOURNIERT auf 1 setzen
      -- PROCEDURE sp_auto_retournieren (l_i_exemplar_id_in IN INTEGER);
      pa_exemplar.sp_auto_retournieren(l_i_exemplar_id);
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      DBMS_OUTPUT.PUT_LINE('Auto (ID ' || l_i_exemplar_id ||') zurueckgegeben!');
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      -- Falls Schäden vorhanden
      IF l_bi_schaeden_in = 1
      THEN
      -- STATUS_ID in Exemplar Tabelle auf 2 (im Haus) setzen
        -- PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER);
        pa_exemplar.sp_update_status(l_i_exemplar_id, l_i_status_im_haus);
      -- Checken ob Schaden Bezeichnung in Schaeden Tabelle exisiert, falls nicht --> einfügen
        -- FUNCTION f_get_schaeden_count_bi (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;
        IF pa_schaeden.f_get_schaeden_count_bi(l_v_bezeichnung_in) < 1
        THEN
          -- FUNCTION f_insert_schaden_i (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;
          l_i_schaeden_id := pa_schaeden.f_insert_schaden_i(l_v_bezeichnung_in);
        ELSE 
          -- FUNCTION f_get_schaeden_id_i (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;
          l_i_schaeden_id := pa_schaeden.f_get_schaeden_id_i(l_v_bezeichnung_in);
        END IF;
      END IF;
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Kunde hat kein Auto, dass er zurückgeben könnte!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
    END sp_auto_zurueckgeben;
  /*************************************************************************/
END;
/

COMMIT;
