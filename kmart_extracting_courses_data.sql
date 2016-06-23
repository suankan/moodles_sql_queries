CREATE or REPLACE FUNCTION get_portal_group(course_id bigint) RETURNS text AS $$
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


COPY ( 
SELECT
    c.id as "Totara Course ID",
    c.fullname as "Fullname",
    cc.name as "Category",
    c.shortname as "Shortname",
    c.idnumber as "Course ID Number",
    CASE c.coursetype
        WHEN 0 THEN 'E-learning'
        WHEN 1 THEN 'Blended'
        WHEN 2 THEN 'Face-to-face'
    END as "Course type",
    get_portal_group(c.id) as "Portal Group",
    get_course_modules(c.id) as "Course modules",
    CASE c.audiencevisible
        WHEN 3 THEN 'No users'
        WHEN 0 THEN 'Enrolled users only'
        WHEN 1 THEN 'Enrolled users and members of the selected audiences'
        WHEN 2 THEN 'All users'
    END as "Visibility"
FROM
    mdl_course c
    JOIN mdl_course_categories cc ON (c.category = cc.id)
) TO '/home/suankan/courses.csv' 
       (FORMAT CSV, DELIMITER ',', FORCE_QUOTE *, HEADER);
