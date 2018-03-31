/*
SKT kontrol için hazırlanan EVENT tarafından çağrılacak
çağırılacak procedure burada bulunmaktadır:
 */
CREATE PROCEDURE skt_bitis_proc ()
  BEGIN
    DECLARE v_bitis INTEGER;
    DECLARE v_fark INTEGER;
    DECLARE v_id INTEGER;

    SELECT bitis, id INTO v_bitis, v_id
      FROM rey_skts
    ORDER BY id LIMIT 1;

    -- Bitiş süresinin hesaplanması
    SET v_fark = v_bitis - UNIX_TIMESTAMP(NOW());

    -- ReySkt tablosundan verilerin silinmesi
    IF v_fark <= 0 THEN
      DELETE FROM rey_skts
        WHERE id = v_id;
    END IF;

  END;