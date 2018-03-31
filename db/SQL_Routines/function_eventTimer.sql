/*
Burada bulunan fonksiyon, EVENT ' lerin zamanlamasında kullanılacaktır.
 */
CREATE FUNCTION event_time(saat TIME)
  RETURNS DATETIME
  BEGIN
    DECLARE v_fark INTEGER;

    SET v_fark = time_to_sec(saat) - time_to_sec(current_time);

    IF v_fark > 0 THEN
      RETURN DATE_ADD(NOW(), INTERVAL v_fark SECOND);
    ELSE
      SET v_fark = (24*60*60) + v_fark;
      RETURN DATE_ADD(NOW(), INTERVAL v_fark SECOND);
    END IF;
  END;