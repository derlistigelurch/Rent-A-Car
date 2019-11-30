SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_schaeden
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_schaeden_id
  /** Out: l_i_schaeden_id - Schaden ID
  /** In: l_v_schaeden_in - Schaden Beschreibung
  /** Developer: 
  /** Description: Returned Schaden ID
  /**
  /**********************************************************************/
  PROCEDURE sp_get_schaeden_id (l_v_schaeden_in IN VARCHAR2, l_i_schaeden_id_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_get_schaeden_count
  /** Out: l_bi_schaeden_count_ou - Gibt es den Schaden bereits in der Tabelle? (0 oder 1)
  /** In: l_v_schaeden_in - Schaden Beschreibung
  /** Developer: 
  /** Description: Checkt ob es den Schaden bereits gibt
  /**
  /**********************************************************************/
  PROCEDURE sp_get_schaeden_count (l_v_schaeden_in IN VARCHAR2, l_bi_schaeden_count_ou OUT INTEGER);

  /*********************************************************************
  /**
  /** Procedure: sp_insert_schaden
  /** Out: l_i_schaeden_id_ou - Schaden ID
  /** In: l_v_schaeden_in -  Schaden Beschreibung
  /** Developer: 
  /** Description: Speichert eine neue Schadensart in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_schaden (l_v_schaeden_in IN VARCHAR2, l_i_schaeden_id_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_exemp_schaeden
  /** Out: l_row_exemp_schaeden_ou - Damit man später prüfen kann ob das insert richtig ausgeführt wurde
  /** In: l_i_exemplar_id - Exemplar ID
  /** In: l_i_schaeden_id_in - Schaden ID
  /** Developer: 
  /** Description: Checkt ob die angegebene PLZ schon vorhanden ist
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_exemp_schaeden (l_i_exemplar_id IN INTEGER, l_i_schaeden_id_in IN INTEGER, l_row_exemp_schaeden_ou OUT ROWID);
END pa_schaeden;
/

-- pa_schaeden body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_schaeden
AS
  /* sp_get_schaeden_id_i definition *****************************************/
  PROCEDURE sp_get_schaeden_id (l_v_schaeden_in IN VARCHAR2, l_i_schaeden_id_ou OUT INTEGER)
   AS
    BEGIN
      SELECT SCHAEDEN.SCHAEDEN_ID
      INTO l_i_schaeden_id_ou
      FROM SCHAEDEN
      WHERE SCHAEDEN.BESCHREIBUNG = l_v_schaeden_in;
    EXCEPTION
      WHEN OTHERS THEN
        l_i_schaeden_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_schaeden_id;
  /*************************************************************************/
  /* sp_get_schaeden_count definition **************************************/
  PROCEDURE sp_get_schaeden_count (l_v_schaeden_in IN VARCHAR2, l_bi_schaeden_count_ou OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_schaeden_count_ou
      FROM SCHAEDEN
      WHERE BESCHREIBUNG = l_v_schaeden_in;
    EXCEPTION
      WHEN OTHERS THEN
        l_bi_schaeden_count_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_schaeden_count;
  /*************************************************************************/
  
  /* sp_insert_schaden definition ******************************************/
  PROCEDURE sp_insert_schaden (l_v_schaeden_in IN VARCHAR2, l_i_schaeden_id_ou OUT INTEGER)
  AS
    BEGIN
      INSERT INTO SCHAEDEN (SCHAEDEN_ID, BESCHREIBUNG)
      VALUES (schaden_seq.NEXTVAL, l_v_schaeden_in)
      RETURNING SCHAEDEN_ID
      INTO l_i_schaeden_id_ou;
    EXCEPTION
      WHEN OTHERS THEN
        l_i_schaeden_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_schaden;
  /*************************************************************************/
  
  /* sp_insert_exemp_schaeden_i definition **********************************/
  PROCEDURE sp_insert_exemp_schaeden (l_i_exemplar_id IN INTEGER, l_i_schaeden_id_in IN INTEGER, l_row_exemp_schaeden_ou OUT ROWID)
  AS
    BEGIN
      INSERT INTO EXEMP_SCHAEDEN (KOMBO_ID, SCHAEDEN_ID, EXEMPLAR_ID) 
      VALUES (exemp_schaden_seq.NEXTVAL, l_i_schaeden_id_in, l_i_exemplar_id)
      RETURNING ROWID
      INTO l_row_exemp_schaeden_ou;
    EXCEPTION
      WHEN OTHERS THEN
        l_row_exemp_schaeden_ou := NULL;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_exemp_schaeden;
  /*************************************************************************/
END;
/
COMMIT;
