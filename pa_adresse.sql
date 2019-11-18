SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_adresse
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_plz_count_bi
  /** Out: l_bi_plz_count_ou - Anzahl der gefundenen PLZ (0 oder 1)
  /** In: l_i_plz_in - Postleitzahl
  /** Developer: 
  /** Description: Checkt ob die angegebene PLZ schon vorhanden ist
  /**
  /**********************************************************************/
  PROCEDURE sp_get_plz_count_bi (l_i_plz_in IN INTEGER, l_bi_plz_count_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_plz
  /** Out: l_row_plz_ou - Returned die Rowid des neuen Datensatzes
  /** In: l_i_plz_in - Postleitzahl
  /** In: l_v_ortsname_in - Ortsname
  /** Developer: 
  /** Description: Speichert PLZ und Ortsname in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_plz_row (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_row_plz_ou OUT ROWID);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_adresse
  /** Out: l_i_adress_id_ou - Adress ID
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_i_plz_in - Postleitzahl
  /** Developer: 
  /** Description: Speichert die neue Adresse in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_adresse_row (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER, l_i_adress_id_ou OUT INTEGER);
END pa_adresse;
/

-- pa_adresse body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_adresse
AS
  /* sp_get_plz_count_bi definition ****************************************/
  PROCEDURE sp_get_plz_count_bi (l_i_plz_in IN INTEGER, l_bi_plz_count_ou OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_plz_count_ou
      FROM POSTLEITZAHL
      WHERE PLZ = l_i_plz_in;
    END sp_get_plz_count_bi;
  /*************************************************************************/
  
  /* sp_insert_plz definition **********************************************/
  PROCEDURE sp_insert_plz_row (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_row_plz_ou OUT ROWID)
  AS
    BEGIN
      INSERT INTO POSTLEITZAHL (PLZ, ORTSNAME) 
      VALUES (l_i_plz_in, l_v_ortsname_in)
      RETURNING ROWID 
      INTO l_row_plz_ou;
    END sp_insert_plz_row;
  /*************************************************************************/
  
  /* sp_insert_adresse definition ******************************************/
  PROCEDURE sp_insert_adresse_row (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER, l_i_adress_id_ou OUT INTEGER)
  AS
    l_i_adress_id INTEGER;
    BEGIN
      SELECT adresse_seq.NEXTVAL 
      INTO l_i_adress_id
      FROM DUAL;
      
      INSERT INTO ADRESSE (ADRESS_ID, STRASSE, HAUSNUMMER, TUERNUMMER, PLZ) 
      VALUES (l_i_adress_id, l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in)
      RETURNING l_i_adress_id
      INTO l_i_adress_id_ou;
    END sp_insert_adresse_row;
  /*************************************************************************/
END;
/
