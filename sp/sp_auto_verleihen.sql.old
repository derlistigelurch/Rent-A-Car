-- Auto verleihen
/*
 * 1. Überprüfen ob Kunde bereits ein Auto ausgeliehen hat
 * 1.1 KUNDEN_ID mit Vorname und Nachname herausfinden
 * 1.2 Überprüfen ob die KUNDEN_ID bereits in der Verleih Tabelle vorhanden ist, wenn ja abbrechen
 * 2. STATUS_ID in Exemplar Tabelle auf 1 (Verliehen) setzen
 * 3. In Verleih Tabelle EXEMPLAR_ID, KUNDE_ID, VERLEIHEN_AB, VERLEIHEN_BIS, RETOURNIERT = 0 und MITARBEITER_ID einfügen
 */

-- Verfügbare Autos anzeigen
SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PROCEDURE sp_autos_anzeigen(l_i_car_count_ou OUT INTEGER)
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
/

-- Auto verleihen
CREATE OR REPLACE PROCEDURE sp_auto_verleihen(l_v_vorname_in  IN VARCHAR2,
                                               l_v_nachname_in IN VARCHAR2,
                                               l_i_exemplar_id IN INTEGER,
                                               l_d_verliehen_von IN VARCHAR2,
                                               l_d_verliehen_bis IN VARCHAR2)
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
  pa_exemplar.sp_update_status(l_i_exemplar_id, l_i_status_verliehen);
  -- In Verleih Tabelle EXEMPLAR_ID, KUNDE_ID, VERLEIHEN_AB, VERLEIHEN_BIS, RETOURNIERT = 0 und MITARBEITER_ID einfügen
  -- PROCEDURE sp_insert_exemplar (l_i_exemplar_id_in IN INTEGER, l_i_kunde_id_in IN INTEGER, l_d_verliehen_ab_in IN DATE, l_d_verliehen_bis_in IN DATE, l_i_mitarbeiter_id_in IN INTEGER);
  pa_verleih.sp_insert_exemplar(l_i_exemplar_id, l_i_kunde_id, l_d_verliehen_von, l_d_verliehen_bis, l_i_mitarbeiter_id);
  DBMS_OUTPUT.PUT_LINE('Fahrzeug (ID ' || l_i_exemplar_id || ') an Kunden (ID ' || l_i_kunde_id || ') verliehen!');
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
/

COMMIT;
