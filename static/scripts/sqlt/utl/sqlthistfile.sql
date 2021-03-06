SPO sqlthistfile.log;
SET DEF ON TERM OFF ECHO ON FEED OFF VER OFF HEA ON LIN 200 PAGES 100 TRIMS ON TI OFF TIMI OFF APPI OFF SERVEROUT ON SIZE 1000000 NUMF "" SQLP SQL>;
SET SERVEROUT ON SIZE UNL;
REM $Header: 215187.1 sqlthistfile.sql 11.4.5.0 2012/11/21 carlos.sierra $
REM
REM Copyright (c) 2000-2013, Oracle Corporation. All rights reserved.
REM
REM AUTHOR
REM   carlos.sierra@oracle.com
REM
REM SCRIPT
REM   sqlt/utl/sqlthistfile.sql
REM
REM DESCRIPTION
REM   Extracts a file out of the SQLT repository.
REM
REM PRE-REQUISITES
REM   1. Execute SQLT (any method), or import a SQLT
REM      repository from another system.
REM   2. Connect as SYS, SYSTEM, or the USER
REM      that created the file to be extracted.
REM
REM PARAMETERS
REM   1. Statement ID (required)
REM      A list of available statement_ids is presented.
REM   2. File Name (required)
REM      A list of available filenames is presented.
REM
REM EXECUTION
REM   1. Navigate to sqlt main directory.
REM   2. Start SQL*Plus connecting as a qualified user.
REM   3. Execute script sqlthistfile.sql passing statement_id
REM      and filename.
REM      Parameters can be passed inline or when requested.
REM
REM EXAMPLE
REM   # cd sqlt
REM   # sqlplus apps
REM   SQL> START [path]sqlthistfile.sql [statement_id] [filename]
REM   SQL> START utl/sqlthistfile.sql 18068 sqlt_s18068_10053_explain.trc
REM   SQL> START utl/sqlthistfile.sql 18068
REM   SQL> START utl/sqlthistfile.sql
REM
REM NOTES
REM   1. For possible errors see sqlthistfile.log
REM   2. You can import the reports from another system.
REM      Review readme generated by SQLT for impdp syntax.
REM
-- begin common
DEF _SQLPLUS_RELEASE
SELECT USER FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') current_time FROM DUAL;
SELECT * FROM v$version;
SELECT * FROM v$instance;
SELECT name, value FROM v$parameter2 WHERE name LIKE '%dump_dest';
SELECT directory_name||' '||directory_path directories FROM dba_directories WHERE directory_name LIKE 'SQLT$%' OR directory_name LIKE 'TRCA$%' ORDER BY 1;
-- end common
SET TERM ON ECHO OFF;
SELECT LPAD(s.statement_id, 5, '0') staid,
       SUBSTR(s.method, 1, 3) method,
       SUBSTR(s.instance_name_short, 1, 8) instance,
       SUBSTR(s.sql_text, 1, 60) sql_text
  FROM sqltxplain.sqlt$_sql_statement s
 WHERE USER IN ('SYS', 'SYSTEM', s.username)
   AND EXISTS (
SELECT NULL
  FROM sqltxplain.sqli$_file f
 WHERE s.statement_id = f.statement_id
   AND USER IN ('SYS', 'SYSTEM', f.username))
 ORDER BY
       s.statement_id;
PRO
PRO Parameter 1:
PRO STATEMENT_ID (required)
PRO
DEF statement_id = '&1';
PRO
COL filename FOR A68;
COL file_size FOR A10;
SELECT filename,
       LPAD(CASE
       WHEN file_size > 1e6 THEN ROUND(file_size/1e6, 1)||' MB'
       WHEN file_size > 1e3 THEN ROUND(file_size/1e3, 1)||' KB'
       ELSE file_size||'  B' END, 10) file_size
  FROM sqltxplain.sqli$_file
 WHERE statement_id = TO_NUMBER(TRIM('&&statement_id.'))
   AND USER IN ('SYS', 'SYSTEM', username)
 ORDER BY
       filename;
PRO
PRO Parameter 2:
PRO FILENAME (required)
PRO
DEF filename = '&2';
PRO
PRO Values passed to sqlthistfile:
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO STATEMENT_ID: "&&statement_id."
PRO FILENAME    : "&&filename."
PRO
PRO ... extracting &&filename.
PRO
SET TERM OFF ECHO OFF FEED OFF VER OFF SHOW OFF HEA OFF LIN 2000 NEWP NONE PAGES 0 SQLC MIX TAB ON TRIMS ON TI OFF TIMI OFF ARRAY 100 NUMF "" SQLP SQL> SUF sql BLO . RECSEP OFF APPI OFF SERVEROUT ON SIZE 1000000 FOR TRU;
SET SERVEROUT ON SIZE UNL FOR TRU;
PRO No fatal errors!
SPO OFF;
--
SPO &&filename.;
SELECT * FROM TABLE(sqltxadmin.sqlt$r.display_file(TRIM('&&filename.'), TO_NUMBER(TRIM('&&statement_id.'))));
SPO OFF;
--
CL COL;
UNDEFINE 1 2 statement_id filename;
SET DEF ON TERM ON ECHO OFF FEED 6 VER ON SHOW OFF HEA ON LIN 80 NEWP 1 PAGES 14 SQLC MIX TAB ON TRIMS OFF TI OFF TIMI OFF ARRAY 15 NUMF "" SQLP SQL> SUF sql BLO . RECSEP WR APPI OFF SERVEROUT OFF;
PRO
PRO SQLTHISTFILE completed.
