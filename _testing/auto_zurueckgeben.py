""" 
    TODO:
        1. KUNDEN_ID herausfinden 
                - (pa_kunde.sp_kunden_anzeigen)
        2. EXEMPLAR_ID herausfinden 
                - (SELECT * FROM RECHNUNGEN_VIEW WHERE KUNDEN_ID = l_i_kunde_id_in AND RETOURNIERT = 0)
        3. STATUS_ID in Exemplar Tabelle auf 3 (im Haus) setzen 
                - (pa_exemplar.sp_update_status(l_i_exemplar_id_in, 3))
        4. In Verleih Tabelle RETOURNIERT auf 1 setzen (Trigger?)
        5. Falls Schäden vorhanden: (Python)
        5.1 Checken ob Schaden Bezeichnung in Schaeden Tabelle exisiert, falls nicht --> einfügen 
                - (pa_schaeden.f_get_schaeden_count_bi(l_v_bezeichnung_in)) --> (pa_schaeden.get_schaden_id(l_v_bezeichnung_in))
                - (pa_schaeden.f_insert_schaden_i(l_v_bezeichnung_in))
        5.2 EXEMPLAR_ID und SCHAEDEN_ID in EXEMP_SCHAEDEN einfügen 
                - (pa_schaeden.sp_insert_exemp_schaeden(l_i_exemplar_id_in, l_i_schaden_id))
        5.3 SCHADEN_ID in Exemplar Tabelle updaten
                - (pa_schaeden.sp_update_schaden(l_i_exemplar_id_in, l_i_schaden_id))
"""