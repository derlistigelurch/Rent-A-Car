SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_verleih
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_rechnung
  /** Out: l_v_rechnung_ou - Rechnung
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Gibt alle Rechnungsdaten aus
  /**
  /**********************************************************************/
  PROCEDURE sp_get_rechnung (l_i_kunde_id_in IN INTEGER, l_v_rechnung_ou OUT VARCHAR2);
END pa_verleih;
/

CREATE OR REPLACE PACKAGE BODY pa_verleih
AS
  /* sp_get_rechnung definition *******************************************/
  PROCEDURE sp_get_rechnung (l_i_kunde_id_in IN INTEGER, l_v_rechnung_ou OUT VARCHAR2)
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
    l_v_rechnung_ou := l_i_verleih_id || ',' || l_i_kunde_id || ',' || l_v_vorname || ',' || l_v_nachname || ',' || l_i_mitarbeiter_id || ',' || l_v_bezeichnung || ',' || l_v_modell_beschreibung || ',' || l_i_dauer || ',' || l_i_kosten_pro_tag || ',' || l_bi_bezahlt;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_v_rechnung_ou := 'Keine Rechnung gefunden';
      WHEN OTHERS THEN
        l_v_rechnung_ou := NULL;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_rechnung;
  /*************************************************************************/
END;
/
COMMIT;
