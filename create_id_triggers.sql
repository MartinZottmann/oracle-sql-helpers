SELECT
    'CREATE OR REPLACE TRIGGER ' || USER || '.' || SUBSTR('TG_ID_' || T.TABLE_NAME, 1, 30) || CHR(13) || CHR(10) ||
    '    BEFORE INSERT OR UPDATE OF ID' || CHR(13) || CHR(10) ||
    '    ON ' || TABLE_NAME || CHR(13) || CHR(10) ||
    '    FOR EACH ROW' || CHR(13) || CHR(10) ||
    'BEGIN' || CHR(13) || CHR(10) ||
    '    IF :NEW.ID IS NOT NULL AND :OLD.ID <> :NEW.ID THEN' || CHR(13) || CHR(10) ||
    '        RAISE_APPLICATION_ERROR(-20501, ''ID COLUMN READ-ONLY'');' || CHR(13) || CHR(10) ||
    '    END IF;' || CHR(13) || CHR(10) ||
    '    IF INSERTING THEN ' || CHR(13) || CHR(10) ||
    '        SELECT ' || USER || '.' || SUBSTR('SQ_ID_' || T.TABLE_NAME, 1, 30) || '.NEXTVAL INTO :NEW.ID FROM DUAL;' || CHR(13) || CHR(10) ||
    '    END IF;' || CHR(13) || CHR(10) ||
    'END;' || CHR(13) || CHR(10) ||
    '/' || CHR(13) || CHR(10) AS COMMANDS
FROM USER_TABLES T
WHERE
    EXISTS (
        SELECT NULL
        FROM USER_TAB_COLUMNS C
        WHERE
            C.TABLE_NAME = T.TABLE_NAME
            AND C.COLUMN_NAME = 'ID'
    )
    AND EXISTS (
        SELECT NULL
        FROM USER_SEQUENCES S
        WHERE
            S.SEQUENCE_NAME = SUBSTR('SQ_ID_' || T.TABLE_NAME, 1, 30)
    )
    AND NOT EXISTS (
        SELECT NULL
        FROM USER_TRIGGERS Z
        WHERE
            Z.TRIGGER_NAME = SUBSTR('TG_ID_' || T.TABLE_NAME, 1, 30)
    )
ORDER BY 1;