SPO sqltxtract.log;
@@sqltcommon1.sql
REM $Header: 215187.1 sqltxtract.sql 12.1.07 2014/03/15 Stelios.Charalambides@oracle.com carlos.sierra mauro.pagano $
REM
REM Copyright (c) 2000-2013, Oracle Corporation. All rights reserved.
REM
REM AUTHOR
REM   stelios.charalambides@oracle.com
REM   carlos.sierra@oracle.com
REM   Mauro Pagano
REM
REM SCRIPT
REM   sqlt/run/sqltxtract.sql
REM
REM DESCRIPTION
REM   Collects SQL tuning diagnostics data and generates a set of
REM   diagnostics files. It inputs one SQL_ID or HASH_VALUE of a
REM   known SQL that is memory resident or pre-captured by AWR.
REM
REM PRE-REQUISITES
REM   1. Use a dedicated SQL*Plus connection (not a shared one).
REM   2. User has been granted SQLT_USER_ROLE.
REM
REM PARAMETERS
REM   1. SQL_ID or HASH_VALUE of the SQL to be extracted (required)
REM   2. SQLTXPLAIN password (required).
REM
REM EXECUTION
REM   1. Navigate to sqlt main directory.
REM   2. Start SQL*Plus connecting as the application user of the SQL.
REM   3. Execute script sqltxtract.sql passing SQL_ID or HASH_VALUE
REM      of the one SQL. This SQL must be memory resident or
REM      pre-captured by AWR.
REM   4. Enter SQLTXPLAIN password when asked for it.
REM
REM EXAMPLE
REM   # cd sqlt
REM   # sqlplus apps
REM   SQL> START [path]sqltxtract.sql [SQL_ID]|[HASH_VALUE]
REM   SQL> START run/sqltxtract.sql 0w6uydn50g8cx
REM   SQL> START run/sqltxtract.sql 2524255098
REM
REM NOTES
REM   1. For possible errors see sqltxtract.log.
REM   2. For better output execute this script connected as the
REM      application user who issued the SQL.
REM
REM HISTORY
REM   2nd June 2019: Stelios Charalambides. Changed File format for final Zip file and added prompt for SQL description
REM   25th August 2019: Stelios Charalambides. Fixed an error with the description field.
REM 
@@sqltcommon2.sql

PRO Parameter 1:
PRO SQL_ID or HASH_VALUE of the SQL to be extracted (required)
PRO
DEF sql_id_or_hash_value_1 = '^1';

PRO
PRO Describe the characteristic of this run
PRO
PRO "F[AST]"             if you have a FAST run
PRO "S[LOW]"             if you have a SLOW run (default)
PRO "H[ASH]"             if this is a run with a HASH JOIN
PRO "N[L]"               if this is a run with a NESTED LOOP
PRO "C[OLUMN HISTOGRAM]" if this is a run with a Column Historgram in place
PRO 

WHENEVER SQLERROR EXIT SQL.SQLCODE;
ACC sql_desc PROMPT 'SQL Description [S]: ';
COL sql_desc NEW_V sql_desc_clean FOR A32;
set termout off
select NVL(SUBSTR(UPPER(TRIM('^^sql_desc')),1,1),'S') sql_desc from dual;
set termout on
BEGIN
  IF NVL('^^sql_desc_clean', 'S') NOT IN ('F', 'S', 'H','N','C') THEN
    RAISE_APPLICATION_ERROR(-20111, 'The first letter of your choice has to be "F", "S", "H", "N", or "C". You entered "^^sql_desc."');
  END IF;
END;
/
WHENEVER SQLERROR CONTINUE

PRO
SET TERM OFF;
COL sql_id_or_hash_value NEW_V sql_id_or_hash_value;
SELECT TRIM('^^sql_id_or_hash_value_1.') sql_id_or_hash_value FROM DUAL;
SET TERM ON;
@@sqltcommon3.sql
PRO Value passed:
PRO SQL_ID_OR_HASH_VALUE: "^^sql_id_or_hash_value."
PRO
EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqltxtract', 'script');
@@sqltcommon4.sql
SET TERM ON;
PRO
PRO NOTE:
PRO You used the XTRACT method connected as ^^connected_user..
PRO
PRO In case of a session disconnect please verify the following:
PRO 1. There are no errors in sqltxtract.log.
PRO 2. Your SQL ^^sql_id_or_hash_value. exists in memory or in AWR.
PRO 3. You connected as the application user that issued original SQL.
PRO 4. User ^^connected_user. has been granted SQLT_USER_ROLE.
PRO
PRO In case of errors ORA-03113, ORA-03114 or ORA-07445 please just
PRO re-try this SQLT method. This tool handles some of the errors behind
PRO a disconnect when executed a second time.
PRO
PRO To actually diagnose the problem behind the disconnect, read ALERT
PRO log and provide referenced traces to Support. After the root cause
PRO of the disconnect is fixed then reset SQLT corresponding parameter.
@@sqltcommon5.sql
EXEC ^^tool_administer_schema..sqlt$i.xtract(p_statement_id => :v_statement_id, p_sql_id_or_hash_value => '^^sql_id_or_hash_value.', p_password => 'Y');
WHENEVER SQLERROR CONTINUE;
SET TERM OFF ECHO OFF FEED OFF VER OFF SHOW OFF HEA OFF LIN 2000 NEWP NONE PAGES 0 SQLC MIX TAB ON TRIMS ON TI OFF TIMI OFF ARRAY 100 NUMF "" SQLP SQL> SUF sql BLO . RECSEP OFF APPI OFF SERVEROUT ON SIZE 1000000 FOR TRU;
SET SERVEROUT ON SIZE UNL FOR TRU;
PRO No fatal errors!
COL column_value FOR A2000;
COL filename NEW_V filename FOR A256;
SPO OFF;
@@sqltcommon6.sql
@@sqltgetfile.sql TEST_CASE_SQL
@@sqltgetfile.sql Q
@@sqltgetfile.sql TEST_CASE_SCRIPT
SPO ^^unique_id._xtract.log;
GET sqltxtract.log
.
SPO OFF;
@@sqltcommon7.sql
HOS zip -m ^^unique_id._xtract_^^sql_id_or_hash_value. sqltxtract.log sqltxtract2.log missing_file.txt
HOS zip -d ^^unique_id._xtract_^^sql_id_or_hash_value. sqltxtract.log sqltxtract2.log missing_file.txt
@@sqltcommon8.sql
@@sqltcommon10.sql
HOS zip -m ^^unique_id._log ^^unique_id._xtract.log sqltxhost.log
HOS zip -m ^^unique_id._xtract_^^sql_id_or_hash_value. ^^unique_id.*
SET TERM ON;
HOS unzip -l ^^unique_id._xtract_^^sql_id_or_hash_value.
PRO File ^^unique_id._xtract_^^sql_id_or_hash_value..zip for ^^sql_id_or_hash_value. has been created.
@@sqltcommon13.sql
HOS zip -m ^^unique_id._xtract_^^sql_id_or_hash_value. ^^unique_id.*

REM Stelios Charalambides 1st of June 2019. Rename the final ZIP file created to the new file format
var v_timestamp varchar2(32);
COL unique_timestamp_id NEW_V unique_timestamp_id FOR A32;
exec :v_timestamp := to_char(sysdate,'YYYYMMDD_HH24MI');
SELECT 'sqlt_'||:v_timestamp unique_timestamp_id FROM DUAL;
HOS RENAME ^^unique_id._xtract_^^sql_id_or_hash_value..zip ^^unique_timestamp_id._^^sql_id_or_hash_value._^^sql_desc_clean..zip
HOS mv     ^^unique_id._xtract_^^sql_id_or_hash_value..zip ^^unique_timestamp_id._^^sql_id_or_hash_value._^^sql_desc_clean..zip

@@sqltcommon9.sql
UNDEF sql_id_or_hash_value
UNDEF sql_id_or_hash_value_1
UNDEF 2
UNDEF enter_tool_password
PRO SQLTXTRACT completed.
