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

COPY ( 
    SELECT
        get_employee_param(u.id, 'employeeid') as "Employee ID",
        u.firstname || ' ' || u.lastname as "Name",
        get_employee_param(u.id, 'employeestatus') as "Employee Status",
        get_employee_param(u.id, 'managernumber') as "Manager Number",
        get_employee_param(u.id, 'state') as "State",
        get_employee_param(u.id, 'employeecode') as "Employee Code",
        get_employee_param(u.id, 'city') as "Store Location",
        get_employee_param(u.id, 'zipcode') as "Cost Centre",
        get_employee_param(u.id, 'a') as "Active Employee",
        get_employee_param(u.id, 'e') as "Enabled in the system",
        to_timestamp(get_employee_param(u.id, 'startdate')::bigint) as "Start Date",
        to_timestamp(get_employee_param(u.id, 'enddate')::bigint) as "End Date",
        get_employee_param(u.id, 'emailaddress') as "Email Address",
        get_employee_param(u.id, 'domaincode') as "Domain Code",
        get_employee_param(u.id, 'organisationcode') as " Organisation Code",
        get_employee_param(u.id, 'jobcode') as " Job Code",
        get_employee_param(u.id, 'usersource') as "User Source",
        get_employee_param(u.id, 'zone') as "Zone",
        get_employee_param(u.id, 'employeetype') as "Employee Type"
    FROM
        mdl_user u;
) TO '/home/suankan/employees.csv' 
       (FORMAT CSV, DELIMITER ',', FORCE_QUOTE *, HEADER);

DROP FUNCTION get_employee_param(user_id bigint, param_shortname text);
