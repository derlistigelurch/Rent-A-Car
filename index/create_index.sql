-- VERLEIH INDEX --
CREATE INDEX verleih_verliehen_von_index
ON VERLEIH(VERLIEHEN_AB);

CREATE INDEX verleih_verliehen_bis_index
ON VERLEIH(VERLIEHEN_BIS);

CREATE INDEX verleih_exemplar_id_index
ON VERLEIH(EXEMPLAR_ID);

CREATE INDEX verleih_kunde_id_index
ON VERLEIH(KUNDE_ID);

CREATE INDEX verleih_mitarbeiter_id_index
ON VERLEIH(MITARBEITER_ID);

-- EXEMPLAR INDEX --
CREATE INDEX exemplar_status_id_index
ON EXEMPLAR(STATUS_ID);

CREATE INDEX exemplar_schaeden_id_index
ON EXEMPLAR(SCHAEDEN_ID);

CREATE INDEX exemplar_standort_id_index
ON EXEMPLAR(STANDORT_ID);

CREATE INDEX exemplar_auto_details_id_index
ON EXEMPLAR(AUTO_DETAILS_ID);

CREATE INDEX exemplar_kennzeichen_index
ON EXEMPLAR(KENNZEICHEN);

-- AUTO_DETAILS INDEX --
CREATE INDEX auto_details_preis_id_index
ON AUTO_DETAILS(PREIS_ID);

CREATE INDEX auto_details_herst_id_index
ON AUTO_DETAILS(HERSTELLER_ID);

CREATE INDEX auto_details_modell_index
ON AUTO_DETAILS(MODELL_BESCHREIBUNG);

-- MITARBEITER INDEX --
CREATE INDEX mitarbeiter_person_id_index
ON MITARBEITER(PERSON_ID);

CREATE INDEX mitarbeiter_standort_id_index
ON MITARBEITER(STANDORT_ID);

-- ADRESSE INDEX --
CREATE INDEX adresse_plz_index
ON ADRESSE(PLZ);

-- KUNDE INDEX --
CREATE INDEX kunde_person_id_index
ON KUNDE(PERSON_ID);

-- PERSON INDEX --
CREATE INDEX person_adress_id_index
ON PERSON(ADRESS_ID);

CREATE INDEX person_name_index
ON PERSON(NACHNAME, VORNAME);

-- POSTLEITZAHL INDEX --
CREATE INDEX plz_ortsname_index
ON POSTLEITZAHL(ORTSNAME);

-- SCHAEDEN INDEX --
CREATE INDEX schaeden_beschreibung_index
ON SCHAEDEN(BESCHREIBUNG);

COMMIT;