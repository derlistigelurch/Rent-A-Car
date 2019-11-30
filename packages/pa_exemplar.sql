SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_exemplar
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_exemplar_id
  /** Out: l_i_exemplar_id_ou - Exemplar ID
  /** In: l_v_hersteller_in - Hersteller des Exemplares (Opel)
  /** In: l_v_modell_in - Modellbezeichnung (Astra)
  /** Developer: 
  /** Description: Ausgabe der Exemplar ID
  /**
  /**********************************************************************/
  PROCEDURE sp_get_exemplar_id (l_v_hersteller_in IN VARCHAR2, l_v_modell_in IN VARCHAR2, l_i_exemplar_id_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_update_status
  /** Out: l_i_affected_rows_ou - Damit später überprüft werden kann ob das update erfolgreich war
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_i_status_id - Neuer Status
  /** Developer: 
  /** Description: Status eines Exemplares ändern
  /**
  /**********************************************************************/
  PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER, l_i_affected_rows_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_update_schaden
  /** Out: l_i_affected_rows_ou - Damit später überprüft werden kann ob das update erfolgreich war
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_i_schaden_id_in - Neuer Schaden-Status
  /** Developer: 
  /** Description: Schaden-Status eines Exemplares ändern
  /**
  /**********************************************************************/
  PROCEDURE sp_update_schaden (l_i_exemplar_id_in IN INTEGER, l_i_schaden_id_in IN INTEGER, l_i_affected_rows_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_verfuegbarkeit_pruefen
  /** Out: l_bi_verfuegbarkeit_out - Fahrzeug verfügbar? 0 oder 1
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** Developer: 
  /** Description: Prüft ob ein Exemplar am Hauptstandort verfügbar ist
  /**
  /**********************************************************************/
  PROCEDURE sp_verfuegbarkeit_pruefen (l_i_exemplar_id_in IN INTEGER, l_bi_verfuegbarkeit_out OUT INTEGER);
END pa_exemplar;
/

-- pa_exemplar body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_exemplar
AS
  /* sp_get_exemplar_id definition *****************************************/
  PROCEDURE sp_get_exemplar_id (l_v_hersteller_in IN VARCHAR2, l_v_modell_in IN VARCHAR2, l_i_exemplar_id_ou OUT INTEGER)
  AS
    BEGIN
      SELECT EXEMPLAR_ID
      INTO l_i_exemplar_id_ou
      FROM EXEMPLAR JOIN AUTO_DETAILS ON AUTO_DETAILS.DETAIL_ID = EXEMPLAR.AUTO_DETAILS_ID
                    JOIN HERSTELLER ON HERSTELLER.HERSTELLER_ID = AUTO_DETAILS.HERSTELLER_ID
      WHERE HERSTELLER.BEZEICHNUNG = l_v_hersteller_in AND
            AUTO_DETAILS.MODELL_BESCHREIBUNG = l_v_modell_in;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_i_exemplar_id_ou := 0;
      WHEN OTHERS THEN
        l_i_exemplar_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_exemplar_id;
  /*************************************************************************/
  
  /* sp_update_status definition *******************************************/
  PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER, l_i_affected_rows_ou OUT INTEGER)
  AS
    BEGIN
      UPDATE EXEMPLAR
      SET STATUS_ID = l_i_status_id_in
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
      l_i_affected_rows_ou := SQL%ROWCOUNT;
    EXCEPTION
        WHEN OTHERS THEN
          l_i_affected_rows_ou := -1;
          pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_update_status;
  /*************************************************************************/
  
  /* sp_update_schaden definition *****************************************/
  PROCEDURE sp_update_schaden (l_i_exemplar_id_in IN INTEGER, l_i_schaden_id_in IN INTEGER, l_i_affected_rows_ou OUT INTEGER)
  AS
    BEGIN
      UPDATE EXEMPLAR
      SET SCHAEDEN_ID = l_i_schaden_id_in
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
      l_i_affected_rows_ou := SQL%ROWCOUNT;
    EXCEPTION
        WHEN OTHERS THEN
          l_i_affected_rows_ou := -1;
          pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_update_schaden;
  /*************************************************************************/
  
  /* sp_verfuegbarkeit_pruefen definition **********************************/
  PROCEDURE sp_verfuegbarkeit_pruefen (l_i_exemplar_id_in IN INTEGER, l_bi_verfuegbarkeit_out OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_verfuegbarkeit_out
      FROM EXEMPLAR
      WHERE STANDORT_ID = 1 AND --Hauptstandort
            EXEMPLAR_ID = l_i_exemplar_id_in;
    EXCEPTION
      WHEN OTHERS THEN
        l_bi_verfuegbarkeit_out := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_verfuegbarkeit_pruefen;
  /*************************************************************************/  
END;
/
COMMIT;
