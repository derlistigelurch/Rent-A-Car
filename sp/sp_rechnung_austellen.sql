-- Rechnung anzeigen
/*
 *  1. ID des bestehenden Kunden suchen, wenn vorhanden weitermachen, ansonsten abbrechen
 *  2. Rechnung anzeigen
 */
SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PROCEDURE sp_rechnung_anzeigen(l_v_vorname_in  IN VARCHAR2,
                                                 l_v_nachname_in IN VARCHAR2,
                                                 l_v_rechnung_ou OUT VARCHAR2)
AS
  l_i_kunde_id INTEGER;
  BEGIN
    --COMMIT;
    -- ID des bestehenden Kunden suchen, wenn vorhanden weitermachen, ansonsten abbrechen
    -- FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER
    l_i_kunde_id := pa_kunde.f_get_kunde_id_i(l_v_vorname_in, l_v_nachname_in);
    -- Rechnung anzeigen
    l_v_rechnung_ou := pa_verleih.f_get_rechnung_v(l_i_kunde_id);
    --COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Kunde exisitiert nicht, oder hat keine offene Rechnung!');
      ROLLBACK;   
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
END sp_rechnung_anzeigen;
/

COMMIT;
