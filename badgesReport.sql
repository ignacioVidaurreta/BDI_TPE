CREATE OR REPLACE FUNCTION BadgesReport
(
        usuarioDesde IN UserTP.Id%type,
        usuarioHasta IN UserTP.Id%type
) RETURNS VOID AS $$

DECLARE

BEGIN
        PERFORM DBMS_OUTPUT.DISABLE();
        PERFORM DBMS_OUTPUT.ENABLE();
        PERFORM DBMS_OUTPUT.SERVEROUTPUT ('t');
        PERFORM DBMS_OUTPUT.PUT_LINE ('BADGES REPORT');
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        PERFORM BadgesReport(1, 2);
END;
$$;