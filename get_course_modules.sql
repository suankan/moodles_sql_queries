CREATE or REPLACE FUNCTION get_course_modules(course_id bigint) RETURNS text AS $$
DECLARE
    result text;
    module text;
BEGIN
    result := '';
    FOR module IN 
        SELECT distinct m.name
        FROM mdl_modules m
                JOIN mdl_course_modules cm ON (cm.module = m.id)
        WHERE cm.course = course_id
    LOOP
        result := module || ';' || result;
    END LOOP;
    RETURN result;
END
$$ LANGUAGE plpgsql;

