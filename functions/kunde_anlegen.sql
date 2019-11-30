SET SERVEROUTPUT ON;
/
DECLARE
  kunde_auto_count integer;
  kunde_car_count integer;
  adress_count integer;
  plz_count integer;
  insert_check rowid;
  
  adresse_plz integer := 7540;
  adresse_hsnr integer := 1;  
  adresse_trnr integer;
  adresse_strasse varchar2(30) := 'Nr.';
  adresse_ortsname varchar2(30) := 'Güssing';
  
  person_geb date := sysdate;
  person_vorname varchar2(30) := 'Hans';
  person_nachname varchar2(30) := 'Dampf';
  
  personId integer;
  kundeId integer;
  adressId integer;
BEGIN  
-- kunde anlegen
  pa_adresse.sp_get_plz_count (adresse_plz, plz_count);
  IF plz_count < 1 THEN
    pa_adresse.sp_insert_plz(adresse_plz, adresse_ortsname, insert_check);
    IF insert_check is null THEN
      dbms_output.put_line('insert failed');
      return;
    END IF;
  END IF;
  IF adresse_trnr is NULL THEN
    adresse_trnr := NULL;
  END IF;  
  pa_adresse.sp_insert_adresse(adresse_strasse, adresse_hsnr, adresse_trnr, adresse_plz, adressId);
  IF adressId < 0 THEN
    dbms_output.put_line('insert failed');
  ELSE
    pa_person.sp_insert_person(person_vorname, person_nachname, person_geb, adressId, personId);
  END IF;
  IF personId < 0 THEN
    dbms_output.put_line('insert failed');
    return;
  ELSE
    pa_kunde.sp_insert_kunde(personId, kundeId);
    dbms_output.put_line(kundeId);
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('something went wrong -1');
      pa_err.sp_err_handling(SQLCODE, SQLERRM);
END;
/

SELECT * FROM ADRESSE;
SELECT * FROM KUNDE;
SELECT * FROM PERSON;

