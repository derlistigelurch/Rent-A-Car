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
           l_i_kosten_pro_tag,
           l_i_kosten_insgesamt,
           l_bi_bezahlt
      FROM RECHNUNGEN_VIEW 
      WHERE KUNDE_ID = l_i_kunde_id_in
            AND BEZAHLT = 0;
    RETURN l_i_verleih_id || ',' || l_i_kunde_id || ',' || l_v_vorname || ',' || l_v_nachname || ',' || l_i_mitarbeiter_id || ',' || l_v_bezeichnung || ',' || l_v_modell_beschreibung || ',' || l_i_dauer || ',' || l_i_kosten_pro_tag || ',' || l_bi_bezahlt;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 'Keine Rechnung gefunden';
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_get_rechnung_v;
  /*************************************************************************/
END;
/
COMMIT;
