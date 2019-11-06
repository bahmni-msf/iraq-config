DROP FUNCTION IF EXISTS get_parent_form_field_path;

CREATE FUNCTION get_parent_form_field_path (form_field_path VARCHAR(400))
RETURNS VARCHAR(400)
RETURN SUBSTRING_INDEX(form_field_path, '/', LENGTH(form_field_path) - LENGTH(REPLACE(form_field_path, '/', '')));
