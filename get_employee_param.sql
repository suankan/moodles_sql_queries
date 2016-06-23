CREATE or REPLACE FUNCTION get_employee_param(user_id bigint, param_shortname text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT uid.data
    INTO result 
    FROM mdl_user_info_data uid 
        JOIN mdl_user_info_field uif 
            ON (uid.fieldid = uif.id) 
    WHERE
        uif.shortname = param_shortname 
            AND uid.userid = user_id;
    IF result = '' THEN
        RETURN 0;
    ELSE
        RETURN result;
    END IF;
END
$$ LANGUAGE plpgsql;
