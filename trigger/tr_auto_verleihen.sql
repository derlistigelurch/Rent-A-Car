/*********************************************************************
/**
/** Trigger: tr_as_i_auto_verleihen
/** Type: after statement
/** Type Extension: insert
/** Developer: 
/** Description: Zeigt an welches Exemplar an welchen Kunden verliehen wurde
/**
/*********************************************************************/
SET SERVEROUTPUT ON;
/

CREATE OR REPLACE TRIGGER tr_as_i_auto_verleihen
  AFTER INSERT ON VERLEIH FOR EACH ROW
  DECLARE
    l_v_rechnung VARCHAR2(255);
  BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Exemplar (ID '|| :new.EXEMPLAR_ID || ') an Kunden (ID' || :new.KUNDE_ID ||') von ' || TO_CHAR(:new.VERLIEHEN_AB, 'DD-MM-YYYY') || ' bis ' || TO_CHAR(:new.VERLIEHEN_BIS, 'DD-MM-YYYY') || ' verliehen!');
    DBMS_OUTPUT.PUT_LINE('!!RECHNUNG DRUCKEN!!');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
  END tr_as_i_auto_verleihen;
/

COMMIT;
