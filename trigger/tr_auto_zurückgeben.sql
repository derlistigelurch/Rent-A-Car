/*********************************************************************
/**
/** Trigger: tr_bs_autozurueckgeben
/** Type: after statement
/** Type Extension: update
/** Developer: 
/** Description: Gibt die Rechnung eines Kunden aus bevor das Auto zurückgegeben wird
/**
/*********************************************************************/
SET SERVEROUTPUT ON;
/

CREATE OR REPLACE TRIGGER tr_bs_autozurueckgeben
  AFTER UPDATE OF RETOURNIERT ON VERLEIH FOR EACH ROW
  BEGIN
  IF :old.RETOURNIERT = 0
    THEN
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      DBMS_OUTPUT.PUT_LINE('Auto (ID: ' || :new.EXEMPLAR_ID || ') zurückgegeben!');
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    END IF;
  END tr_bs_autozurueckgeben;
/
COMMIT;
