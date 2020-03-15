DECLARE
   CURSOR C1 IS 
    SELECT alert_id, 
           primary_entity_level_code, 
           primary_entity_number
      FROM CM_27FEB20; 

    BEGIN
     FOR i iN C1 LOOP
      UPDATE fsk_alert 
         SET alert_status_code = 'CLS'
      WHERE  ALERT_ID   = i.alert_id; 


      INSERT INTO fsk_alert_event values (COLBANDAV.FSK_SEQ.NEXTVAL, i.alert_id, 'CLS', 'ALE', SYSDATE, 'sas', '.');
      INSERT INTO fsk_comment values (COLBANDAV.FSK_SEQ.NEXTVAL, 
                                     'ALT', i.alert_id, 
                                     'CMA: Febrero de 2020', 
                                     'GEN', 
                                     SYSDATE, 
                                     'sas',
                                     'sas',
                                     SYSDATE,
                                     'N',
                                     '.'); 
      INSERT INTO fsk_alert_event values (COLBANDAV.FSK_SEQ.NEXTVAL, i.alert_id, 'CMT', COLBANDAV.FSK_SEQ.CURRVAL - 1, SYSDATE, 'sas', '.');
      UPDATE fsk_alerted_entity 
         SET aggregate_amt = (aggregate_amt / alerts_cnt) * (alerts_cnt - 1),
             alerts_cnt = alerts_cnt - 1                         
       where alerted_entity_number = i.primary_entity_number
         and alerted_entity_level_code = i.primary_entity_level_code;

      DELETE FROM fsk_alerted_entity
         WHERE alerted_entity_number = i.primary_entity_number
      and alerted_entity_level_code = i.primary_entity_level_code
      and alerts_cnt = 0; 


  END LOOP;
  COMMIT;
  END;

/