-- =============================================
-- SaveToDB Framework for SQLite
-- Version 10.6, December 13, 2022
--
-- Copyright 2017-2022 Gartle LLC
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
