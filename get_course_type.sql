CREATE or REPLACE FUNCTION get_course_type(course_id bigint)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT c.format
        INTO result 
        FROM mdl_course c
        WHERE c.id = course_id;

    IF result = 'singleactivity' THEN
        SELECT cfo.value INTO result
            FROM mdl_course_format_options cfo
            WHERE cfo.courseid = course_id;
        RETURN 'singleactivity scorm';
    ELSE
        RETURN result;
    END IF;    
END
$$ LANGUAGE plpgsql;
