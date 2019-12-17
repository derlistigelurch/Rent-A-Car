SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_exemplar
AS
  /*********************************************************************
  /**
  /** Function: f_get_exemplar_id_i
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Returns: Exemplar ID
  /** Developer: 
  /** Description: Ausgabe der Exemplar ID
  /**
  /*********************************************************************/
  FUNCTION f_get_exemplar_id_i (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Procedure: sp_update_status
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_i_status_id_in - Neuer Status
  /** Developer: 
  /** Description: Status eines Exemplares ändern
  /**
  /**********************************************************************/
  PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_update_schaden
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** In: l_i_schaden_id_in - Neuer Schaden-Status
  /** Developer: 
  /** Description: Schaden-Status eines Exemplares ändern
  /**
  /**********************************************************************/
  PROCEDURE sp_update_schaden (l_i_exemplar_id_in IN INTEGER, l_i_schaden_id_in IN INTEGER);

  /*********************************************************************
  /**
  /** Procedure: sp_auto_retournieren
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** Developer: 
  /** Description: Änder den retourniert Status auf 1
  /**
  /**********************************************************************/
  PROCEDURE sp_auto_retournieren (l_i_exemplar_id_in IN INTEGER);
  
  /*********************************************************************
  /**
  /** Function: f_verfuegbarkeit_pruefen
  /** In: l_i_exemplar_id_in - Exemplar ID
  /** Returns: 0 oder 1
  /** Developer: 
  /** Description: Fahrzeug verfügbar?
  /**
  /*********************************************************************/
  FUNCTION f_verfuegbarkeit_pruefen (l_i_exemplar_id_in IN INTEGER) RETURN INTEGER;
END pa_exemplar;
/

-- pa_exemplar body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_exemplar
AS
  /* f_get_exemplar_id_i definition *****************************************/
  FUNCTION f_get_exemplar_id_i (l_i_kunde_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_exemplar_id INTEGER;
    BEGIN
      SELECT EXEMPLAR_ID
      INTO l_i_exemplar_id
      FROM rechnungen_view
      WHERE KUNDE_ID = l_i_kunde_id_in
            AND BEZAHLT = 0;
      RETURN l_i_exemplar_id;
    /*EXCEPTION
      WHEN NO_DATA_FOUND THEN
        --RETURN 0;
        RAISE NO_DATA_FOUND;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_get_exemplar_id_i;
  /*************************************************************************/
  
  /* sp_update_status definition *******************************************/
  PROCEDURE sp_update_status (l_i_exemplar_id_in IN INTEGER, l_i_status_id_in IN INTEGER)
  AS
    BEGIN
      UPDATE EXEMPLAR
      SET STATUS_ID = l_i_status_id_in
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
    /*EXCEPTION
        WHEN OTHERS THEN
          pa_err.sp_err_handling(SQLCODE, SQLERRM);
          RAISE;*/
    END sp_update_status;
  /*************************************************************************/
  
  /* sp_update_schaden definition *****************************************/
  PROCEDURE sp_update_schaden (l_i_exemplar_id_in IN INTEGER, l_i_schaden_id_in IN INTEGER)
  AS
    BEGIN
      UPDATE EXEMPLAR
      SET SCHAEDEN_ID = l_i_schaden_id_in
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
    /*EXCEPTION
        WHEN OTHERS THEN
          pa_err.sp_err_handling(SQLCODE, SQLERRM);
          RAISE;*/
    END sp_update_schaden;
  /*************************************************************************/
  
  /* f_verfuegbarkeit_pruefen definition ***********************************/
  FUNCTION f_verfuegbarkeit_pruefen (l_i_exemplar_id_in IN INTEGER) 
  RETURN INTEGER
  AS
    l_bi_verfuegbarkeit INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_verfuegbarkeit
      FROM autos_hauptstandort_view
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
      RETURN l_bi_verfuegbarkeit;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_verfuegbarkeit_pruefen;
  /*************************************************************************/
  
  /* sp_auto_retournieren definition ***********************************/
  PROCEDURE sp_auto_retournieren (l_i_exemplar_id_in IN INTEGER)
  AS
    l_i_retourniert INTEGER := 1;
    BEGIN
      UPDATE VERLEIH
      SET RETOURNIERT = l_i_retourniert
      WHERE EXEMPLAR_ID = l_i_exemplar_id_in;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END sp_auto_retournieren;
  /*************************************************************************/
END;
/

COMMIT;
