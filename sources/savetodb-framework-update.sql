-- =============================================
-- SaveToDB Framework for SQLite
-- Version 10.13, April 29, 2024
--
-- This script updates SaveToDB Framework 10 to the latest version
--
-- Copyright 2017-2024 Gartle LLC
--
-- License: MIT
-- =============================================

SELECT CASE WHEN 1013 <= CAST(substr(HANDLER_CODE, 1, instr(HANDLER_CODE, '.') - 1) AS int) * 100 + CAST(substr(HANDLER_CODE, instr(HANDLER_CODE, '.') + 1) AS float) THEN 'SaveToDB Framework is up-to-date. Update skipped' ELSE HANDLER_CODE END AS check_version FROM handlers WHERE TABLE_NAME = 'savetodb_framework' AND COLUMN_NAME = 'version' AND EVENT_NAME = 'Information' LIMIT 1;

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

    UNION ALL SELECT NULL, 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.13', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'EVENT_NAME', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBinary, DataTypeBinary16, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, HideByDefault, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList, WhereByDefault', NULL, NULL, NULL

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

    UNION ALL SELECT NULL, 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.13', NULL, NULL, NULL
    UNION ALL SELECT NULL, 'handlers', 'EVENT_NAME', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBinary, DataTypeBinary16, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, HideByDefault, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList, WhereByDefault', NULL, NULL, NULL

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
