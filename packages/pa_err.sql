/**********************************************************************
/*
/* Package: pa_err
/* Developer:
/* Description: Beinhaltet alle Funktionen die benötigt werden um Fehler zu protokollieren
/*
/**********************************************************************/
CREATE OR REPLACE PACKAGE pa_err
AS
  /*********************************************************************
  /**
  /** Procedure: sp_err_handling
  /** In: i_n_err_code - Fehlercode
  /** In: i_v_err_msg - Fehlermeldung
  /** Developer: 
  /** Description: Speichert die Fehlermeldung + Fehlercode in eine Tabelle
  /**
  /**********************************************************************/
  PROCEDURE sp_err_handling (i_n_err_code IN NUMBER, i_v_err_msg IN VARCHAR2);
  END pa_err;
/

CREATE OR REPLACE PACKAGE BODY pa_err
AS
  /* sp_err_handling definition *******************************************/
  PROCEDURE sp_err_handling (i_n_err_code IN NUMBER, i_v_err_msg IN VARCHAR2)
  AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
      INSERT INTO ERR_TABLE (ERR_ID, ERR_CODE, ERR_MSG) 
      VALUES (err_table_seq.NEXTVAL, i_n_err_code, i_v_err_msg);
      COMMIT;
    END sp_err_handling;
  /*************************************************************************/
END;
/

COMMIT;
