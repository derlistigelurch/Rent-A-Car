/*********************************************************************
/**
/** Name: auto_details_preis_id_index
/** Table: AUTO_DETAILS
/** Attributes: PREIS_ID
/**
/*********************************************************************/
CREATE INDEX auto_details_preis_id_index
ON AUTO_DETAILS(PREIS_ID);

/*********************************************************************
/**
/** Name: auto_details_herst_id_index
/** Table: AUTO_DETAILS
/** Attributes: HERSTELLER_ID
/**
/*********************************************************************/
CREATE INDEX auto_details_herst_id_index
ON AUTO_DETAILS(HERSTELLER_ID);

/*********************************************************************
/**
/** Name: auto_details_modell_index
/** Table: AUTO_DETAILS
/** Attributes: MODELL_BESCHREIBUNG
/**
/*********************************************************************/
CREATE INDEX auto_details_modell_index
ON AUTO_DETAILS(MODELL_BESCHREIBUNG);

COMMIT;
