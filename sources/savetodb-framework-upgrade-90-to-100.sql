-- =============================================
-- SaveToDB Framework for SQLite
-- Version 10.8, January 9, 2023
--
-- This script updates SaveToDB Framework 9 to version 10.0
--
-- Copyright 2017-2023 Gartle LLC
--
-- License: MIT
-- =============================================

SELECT CASE WHEN 1000 <= CAST(substr(HANDLER_CODE, 1, instr(HANDLER_CODE, '.') - 1) AS int) * 100 + CAST(substr(HANDLER_CODE, instr(HANDLER_CODE, '.') + 1) AS float) THEN 'SaveToDB Framework is up-to-date. Update skipped' ELSE HANDLER_CODE END AS check_version FROM handlers WHERE TABLE_NAME = 'savetodb_framework' AND COLUMN_NAME = 'version' AND EVENT_NAME = 'Information' LIMIT 1;

DELETE FROM handlers WHERE TABLE_SCHEMA IS NULL AND EVENT_NAME = 'Actions' AND TABLE_NAME IN ('columns', 'formats', 'handlers', 'objects', 'translations', 'workbooks') AND HANDLER_NAME = 'SaveToDB Online Help';
DELETE FROM handlers WHERE TABLE_SCHEMA IS NULL AND EVENT_NAME = 'Actions' AND TABLE_NAME IN ('columns', 'formats', 'handlers', 'objects', 'translations', 'workbooks') AND HANDLER_NAME = 'SaveToDB Framework Online Help';

UPDATE handlers SET HANDLER_TYPE = 'ATTRIBUTE' WHERE TABLE_SCHEMA IS NULL AND TABLE_NAME = 'handlers' AND COLUMN_NAME = 'HANDLER_CODE' AND EVENT_NAME IN ('Information', 'DoNotConvertFormulas') AND HANDLER_TYPE IS NULL;

CREATE TABLE IF NOT EXISTS columns (
    ID integer PRIMARY KEY AUTOINCREMENT NOT NULL
    , TABLE_SCHEMA nvarchar(128) NOT NULL
    , TABLE_NAME nvarchar(128) NOT NULL
    , COLUMN_NAME nvarchar(128) NOT NULL
    , ORDINAL_POSITION integer NOT NULL
    , IS_PRIMARY_KEY bit NULL
    , IS_NULLABLE bit NULL
    , IS_IDENTITY bit NULL
    , IS_COMPUTED bit NULL
    , COLUMN_DEFAULT nvarchar(256) NULL
    , DATA_TYPE nvarchar(128) NULL
    , CHARACTER_MAXIMUM_LENGTH integer NULL
    , PRECISION tinyint NULL
    , SCALE tinyint NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS ix_columns ON columns (TABLE_NAME, COLUMN_NAME);

CREATE UNIQUE INDEX IF NOT EXISTS ix_handlers ON handlers (TABLE_NAME, COLUMN_NAME, EVENT_NAME, HANDLER_NAME);

ALTER TABLE formats ADD APP nvarchar(50) NULL;

DROP INDEX IF EXISTS formats_table_name;
DROP INDEX IF EXISTS ix_formats;

CREATE UNIQUE INDEX IF NOT EXISTS ix_formats ON formats (TABLE_NAME, APP);

DELETE FROM handlers WHERE TABLE_NAME = 'objects' AND COLUMN_NAME = 'PROCEDURE_TYPE';

UPDATE handlers AS t
SET
    HANDLER_CODE = s.HANDLER_CODE
    , TARGET_WORKSHEET = s.TARGET_WORKSHEET
    , MENU_ORDER = s.MENU_ORDER
    , EDIT_PARAMETERS = s.EDIT_PARAMETERS
FROM
    (
    SELECT
        CAST(NULL AS nvarchar) AS TABLE_SCHEMA
        , CAST(NULL AS nvarchar) AS TABLE_NAME
        , CAST(NULL AS nvarchar) AS COLUMN_NAME
        , CAST(NULL AS nvarchar) AS EVENT_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_SCHEMA
        , CAST(NULL AS nvarchar) AS HANDLER_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_TYPE
        , CAST(NULL AS nvarchar) HANDLER_CODE
        , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
        , CAST(NULL AS int) AS MENU_ORDER
        , CAST(NULL AS bit) AS EDIT_PARAMETERS

    UNION ALL SELECT NULL, 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.0', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'EVENT_NAME', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'HANDLER_TYPE', 'ValidationList', NULL, NULL, 'VALUES', 'TABLE, VIEW, PROCEDURE, FUNCTION, CODE, HTTP, TEXT, MACRO, CMD, VALUES, RANGE, REFRESH, MENUSEPARATOR, PDF, REPORT, SHOWSHEETS, HIDESHEETS, SELECTSHEET, ATTRIBUTE', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'objects', 'TABLE_TYPE', 'ValidationList', NULL, NULL, 'VALUES', 'TABLE, VIEW, PROCEDURE, CODE, HTTP, TEXT, HIDDEN', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'HANDLER_CODE', 'DoNotConvertFormulas', NULL, NULL, 'ATTRIBUTE', NULL, NULL, NULL, NULL

    UNION ALL SELECT NULL, 'columns', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-columns.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'formats', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-formats.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'handlers', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-handlers.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'objects', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-objects.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'translations', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-translations.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'workbooks', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-workbooks.htm', NULL, 13, NULL

    ) s
WHERE
    s.TABLE_NAME IS NOT NULL
    AND t.TABLE_NAME = s.TABLE_NAME
    AND COALESCE(t.COLUMN_NAME, '') = COALESCE(s.COLUMN_NAME, '')
    AND t.EVENT_NAME = s.EVENT_NAME
    AND COALESCE(t.HANDLER_NAME, '') = COALESCE(s.HANDLER_NAME, '')
    AND COALESCE(t.HANDLER_TYPE, '') = COALESCE(s.HANDLER_TYPE, '')
    AND (
        NOT COALESCE(t.HANDLER_CODE, '') = COALESCE(s.HANDLER_CODE, '')
        OR NOT COALESCE(t.TARGET_WORKSHEET, '') = COALESCE(s.TARGET_WORKSHEET, '')
        OR NOT COALESCE(t.MENU_ORDER, -1) = COALESCE(s.MENU_ORDER, -1)
        OR NOT COALESCE(t.EDIT_PARAMETERS, 0) = COALESCE(s.EDIT_PARAMETERS, 0)
    );

INSERT INTO handlers
    ( TABLE_SCHEMA
    , TABLE_NAME
    , COLUMN_NAME
    , EVENT_NAME
    , HANDLER_SCHEMA
    , HANDLER_NAME
    , HANDLER_TYPE
    , HANDLER_CODE
    , TARGET_WORKSHEET
    , MENU_ORDER
    , EDIT_PARAMETERS
    )
SELECT
    s.TABLE_SCHEMA
    , s.TABLE_NAME
    , s.COLUMN_NAME
    , s.EVENT_NAME
    , s.HANDLER_SCHEMA
    , s.HANDLER_NAME
    , s.HANDLER_TYPE
    , s.HANDLER_CODE
    , s.TARGET_WORKSHEET
    , s.MENU_ORDER
    , s.EDIT_PARAMETERS
FROM
    (
    SELECT
        CAST(NULL AS nvarchar) AS TABLE_SCHEMA
        , CAST(NULL AS nvarchar) AS TABLE_NAME
        , CAST(NULL AS nvarchar) AS COLUMN_NAME
        , CAST(NULL AS nvarchar) AS EVENT_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_SCHEMA
        , CAST(NULL AS nvarchar) AS HANDLER_NAME
        , CAST(NULL AS nvarchar) AS HANDLER_TYPE
        , CAST(NULL AS nvarchar) HANDLER_CODE
        , CAST(NULL AS nvarchar) AS TARGET_WORKSHEET
        , CAST(NULL AS int) AS MENU_ORDER
        , CAST(NULL AS bit) AS EDIT_PARAMETERS

    UNION ALL SELECT NULL, 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.0', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'EVENT_NAME', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'HANDLER_TYPE', 'ValidationList', NULL, NULL, 'VALUES', 'TABLE, VIEW, PROCEDURE, FUNCTION, CODE, HTTP, TEXT, MACRO, CMD, VALUES, RANGE, REFRESH, MENUSEPARATOR, PDF, REPORT, SHOWSHEETS, HIDESHEETS, SELECTSHEET, ATTRIBUTE', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'objects', 'TABLE_TYPE', 'ValidationList', NULL, NULL, 'VALUES', 'TABLE, VIEW, PROCEDURE, CODE, HTTP, TEXT, HIDDEN', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'HANDLER_CODE', 'DoNotConvertFormulas', NULL, NULL, 'ATTRIBUTE', NULL, NULL, NULL, NULL

    UNION ALL SELECT NULL, 'columns', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-columns.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'formats', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-formats.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'handlers', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-handlers.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'objects', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-objects.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'translations', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-translations.htm', NULL, 13, NULL
    UNION ALL SELECT NULL, 'workbooks', NULL, 'Actions', NULL, 'Developer Guide', 'HTTP', 'https://www.savetodb.com/dev-guide/xls-workbooks.htm', NULL, 13, NULL

    ) s
    LEFT OUTER JOIN handlers t ON
        t.TABLE_NAME = s.TABLE_NAME
        AND COALESCE(t.COLUMN_NAME, '') = COALESCE(s.COLUMN_NAME, '')
        AND t.EVENT_NAME = s.EVENT_NAME
        AND COALESCE(t.HANDLER_NAME, '') = COALESCE(s.HANDLER_NAME, '')
        AND COALESCE(t.HANDLER_TYPE, '') = COALESCE(s.HANDLER_TYPE, '')
WHERE
    s.TABLE_NAME IS NOT NULL
    AND t.TABLE_NAME IS NULL;

-- print SaveToDB Framework updated
