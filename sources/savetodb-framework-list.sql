-- =============================================
-- SaveToDB Framework for SQLite
-- Version 10.8, January 9, 2023
--
-- Copyright 2017-2023 Gartle LLC
--
-- License: MIT
-- =============================================

SELECT
    t.name
FROM
    sqlite_master t
WHERE
    t.name IN ('columns', 'objects', 'handlers', 'translations', 'formats', 'workbooks', 'queries')
ORDER BY
    t.name
