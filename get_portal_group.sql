CREATE or REPLACE FUNCTION get_portal_group(course_id bigint)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT cid.data
    INTO result 
    FROM mdl_course_info_data cid
    JOIN mdl_course_info_field cif
            ON (cid.fieldid = cif.id)
    WHERE
        cif.shortname = 'portalgroup'
        AND cid.courseid = course_id;
    IF result is NULL THEN
        RETURN '';
    ELSE
        RETURN result;
    END IF;
END
$$ LANGUAGE plpgsql;

