/*********************************************************************
/**
/** Name: exemplar_status_id_index
/** Table: EXEMPLAR
/** Attributes: STATUS_ID
/**
/*********************************************************************/
CREATE INDEX exemplar_status_id_index
ON EXEMPLAR(STATUS_ID);

/*********************************************************************
/**
/** Name: exemplar_schaeden_id_index
/** Table: EXEMPLAR
/** Attributes: SCHAEDEN_ID
/**
/*********************************************************************/
CREATE INDEX exemplar_schaeden_id_index
ON EXEMPLAR(SCHAEDEN_ID);

/*********************************************************************
/**
/** Name: exemplar_standort_id_index
/** Table: EXEMPLAR
/** Attributes: STANDORT_ID
/**
/*********************************************************************/
CREATE INDEX exemplar_standort_id_index
ON EXEMPLAR(STANDORT_ID);

/*********************************************************************
/**
/** Name: exemplar_auto_details_id_index
/** Table: EXEMPLAR
/** Attributes: AUTO_DETAILS_ID
/**
/*********************************************************************/
CREATE INDEX exemplar_auto_details_id_index
ON EXEMPLAR(AUTO_DETAILS_ID);

/*********************************************************************
/**
/** Name: exemplar_kennzeichen_index
/** Table: EXEMPLAR
/** Attributes: KENNZEICHEN
/**
/*********************************************************************/
CREATE INDEX exemplar_kennzeichen_index
ON EXEMPLAR(KENNZEICHEN);

COMMIT;
