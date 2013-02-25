SELECT
    'CREATE SEQUENCE ' || USER || '.' || SUBSTR('SQ_ID_' || T.TABLE_NAME, 1, 30) || CHR(13) || CHR(10) ||
    '    START WITH 1 ' || CHR(13) || CHR(10) ||
    '    MAXVALUE 999999999999999999999999999' || CHR(13) || CHR(10) ||
    '    MINVALUE 1' || CHR(13) || CHR(10) ||
    '    NOCYCLE' || CHR(13) || CHR(10) ||
    '    NOCACHE' || CHR(13) || CHR(10) ||
    '    NOORDER;' || CHR(13) || CHR(10) AS COMMANDS
FROM USER_TABLES T
WHERE
    EXISTS (
        SELECT 1
        FROM USER_TAB_COLUMNS C
        WHERE
            C.TABLE_NAME = T.TABLE_NAME
            AND C.COLUMN_NAME = 'ID'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM USER_SEQUENCES S
        WHERE
            S.SEQUENCE_NAME = SUBSTR('SQ_ID_' || T.TABLE_NAME, 1, 30)
    )
ORDER BY 1;