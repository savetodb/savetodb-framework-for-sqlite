-- =============================================
-- SaveToDB Framework for SQLite
-- Version 10.13, April 29, 2024
--
-- Copyright 2017-2024 Gartle LLC
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
