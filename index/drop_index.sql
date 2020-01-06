-- verleih --
DROP INDEX verleih_verliehen_von_index;
DROP INDEX verleih_verliehen_bis_index;
DROP INDEX verleih_exemplar_id_index;
DROP INDEX verleih_kunde_id_index;
DROP INDEX verleih_mitarbeiter_id_index;

-- exemplar --
DROP INDEX exemplar_status_id_index;
DROP INDEX exemplar_schaeden_id_index;
DROP INDEX exemplar_standort_id_index;
DROP INDEX exemplar_auto_details_id_index;
DROP INDEX exemplar_kennzeichen_index;

-- auto_details --
DROP INDEX auto_details_preis_id_index;
DROP INDEX auto_details_herst_id_index;
DROP INDEX auto_details_modell_index;

-- mitarbeiter --
DROP INDEX mitarbeiter_person_id_index;
DROP INDEX mitarbeiter_standort_id_index;

-- adresse --
DROP INDEX adresse_plz_index;

-- kunde --
DROP INDEX kunde_person_id_index;

-- person --
DROP INDEX person_adress_id_index;
DROP INDEX person_name_index;

-- postleitzahl --
DROP INDEX plz_ortsname_index;

-- schaeden -- 
DROP INDEX schaeden_beschreibung_index;

COMMIT;
