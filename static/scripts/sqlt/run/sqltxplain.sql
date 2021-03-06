SPO sqltxplain.log;
@@sqltcommon1.sql
REM $Header: 215187.1 sqltxplain.sql 12.1.01 2013/08/19 carlos.sierra mauro.pagano $
REM
REM Copyright (c) 2000-2013, Oracle Corporation. All rights reserved.
REM
REM AUTHOR
REM   carlos.sierra@oracle.com
REM   mauro.pagano@oracle.com
REM
REM SCRIPT
REM   sqlt/run/sqltxplain.sql
REM
REM DESCRIPTION
REM   Collects SQL tuning diagnostics data and generates a set of
REM   diagnostics files. It inputs a file which contains one SQL
REM   statement. If the SQL contains binds, they could be manually
REM   replaced with literals of the same datatype.
REM
REM PRE-REQUISITES
REM   1. Use a dedicated SQL*Plus connection (not a shared one).
REM   2. User has been granted SQLT_USER_ROLE.
REM
REM PARAMETERS
REM   1. Name of the file which contains one SQL (required)
REM   2. SQLTXPLAIN password (required).
REM
REM EXECUTION
REM   1. Place your file with one SQL into sqlt/input directory
REM   2. Navigate to sqlt main directory.
REM   3. Start SQL*Plus connecting as the application user of the SQL.
REM   4. Execute script sqltxplain.sql passing directory path and
REM      name of file with one SQL.
REM   5. Enter SQLTXPLAIN password when asked for it.
REM
REM EXAMPLE
REM   # cd sqlt
REM   # sqlplus apps
REM   SQL> START [path]sqltxplain.sql [path]filename
REM   SQL> START run/sqltxplain.sql input/sample/sql1.sql
REM
REM NOTES
REM   1. For possible errors see sqltxplain.log.
REM   2. For better output execute this script connected as the
REM      application user who issued the SQL.
REM
@@sqltcommon2.sql
PRO WARNING:
PRO You are using SQLT XPLAIN method.
PRO
PRO If you were requested by Oracle Support to use
PRO XTRACT or XECUTE, then do not use this XPLAIN method.
PRO
PRO Be aware that XPLAIN method cannot perform bind peeking
PRO thus you will get an EXPLAIN PLAN instead of actual
PRO EXECUTION PLAN.
PRO
PRO Replacing bind variables with literal values does not
PRO guarantee the generated plan to be the same than the one
PRO produced by XTRACT or XECUTE. Thus the plan generated by
PRO XPLAIN might not be useful to progress your issue.
PRO
PRO Parameter 1:
PRO Name of file that contains SQL to be explained (required)
PRO
DEF file_with_one_sql = '^1';
@@sqltcommon3.sql
PRO Value passed:
PRO FILE_WITH_ONE_SQL: "^^file_with_one_sql."
PRO
EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqltxplain', 'script');
PRO
PRO WARNING:
PRO You are using SQLT XPLAIN method.
PRO
PRO If you were requested by Oracle Support to use
PRO XTRACT or XECUTE, then do not use this XPLAIN method.
PRO
PRO Be aware that XPLAIN method cannot perform bind peeking
PRO thus you will get an EXPLAIN PLAN instead of actual
PRO EXECUTION PLAN.
PRO
PRO Replacing bind variables with literal values does not
PRO guarantee the generated plan to be the same than the one
PRO produced by XTRACT or XECUTE. Thus the plan generated by
PRO XPLAIN might not be useful to progress your issue.
PRO
@@sqltcommon4.sql
COL explain_plan_for NEW_V explain_plan_for FOR A80;
SELECT 'EXPLAIN PLAN SET statement_id = '''||:v_statement_id||''' INTO ^^tool_repository_schema..sqlt$_sql_plan_table FOR' explain_plan_for FROM DUAL;
COL prev_sql_id NEW_V prev_sql_id FOR A16;
COL prev_child_number NEW_V prev_child_number;
SELECT prev_sql_id, prev_child_number FROM sys.sqlt$_my_v$session;
DEL 1 LAST
DELETE ^^tool_repository_schema..sqlt$_sql_plan_table WHERE statement_id IS NULL;
EXEC ^^tool_administer_schema..sqlt$i.xplain_begin(p_statement_id => :v_statement_id);
SET TERM ON SUF "";
PRO
PRO ... reading file ^^file_with_one_sql. ...
PRO
PRO In case of a disconnect review sqltxplain.log
PRO
SET ECHO ON;
WHENEVER OSERROR EXIT
GET ^^file_with_one_sql.
.
SET TERM OFF ECHO ON VER ON SERVEROUT OFF SUF sql;
C/;/
0 ^^explain_plan_for.
L
/
WHENEVER OSERROR CONTINUE
SET TERM ON ECHO OFF VER OFF;
PRO
PRO NOTE:
PRO You used the XPLAIN method connected as ^^connected_user..
PRO
PRO WARNING:
PRO You are using SQLT XPLAIN method.
PRO
PRO If you were requested by Oracle Support to use
PRO XTRACT or XECUTE, then do not use this XPLAIN method.
PRO
PRO Be aware that XPLAIN method cannot perform bind peeking
PRO thus you will get an EXPLAIN PLAN instead of actual
PRO EXECUTION PLAN.
PRO
PRO Replacing bind variables with literal values does not
PRO guarantee the generated plan to be the same than the one
PRO produced by XTRACT or XECUTE. Thus the plan generated by
PRO XPLAIN might not be useful to progress your issue.
PRO
PRO In case of a session disconnect please verify the following:
PRO 1. There are no errors in sqltxplain.log.
PRO 2. You connected as the application user that issued original SQL.
PRO 3. File ^^file_with_one_sql. exists and contains ONE valid DML statement.
PRO 4. User ^^connected_user. has been granted SQLT_USER_ROLE.
@@sqltcommon5.sql
SELECT prev_sql_id, prev_child_number FROM sys.sqlt$_my_v$session;
SELECT sql_text FROM sys.sqlt$_my_v$sql WHERE sql_id = '^^prev_sql_id.' AND child_number = TO_NUMBER('^^prev_child_number.');
SET SERVEROUT ON SIZE 1000000;
SET SERVEROUT ON SIZE UNL;
SET TERM ON;
EXEC ^^tool_administer_schema..sqlt$i.xplain_end(p_statement_id => :v_statement_id, p_string => q'[^^explain_plan_for.]', p_sql_id => '^^prev_sql_id.', p_input_filename => '^^file_with_one_sql.', p_password => 'Y');
WHENEVER SQLERROR CONTINUE;
SET TERM OFF ECHO OFF FEED OFF VER OFF SHOW OFF HEA OFF LIN 2000 NEWP NONE PAGES 0 SQLC MIX TAB ON TRIMS ON TI OFF TIMI OFF ARRAY 100 NUMF "" SQLP SQL> SUF sql BLO . RECSEP OFF APPI OFF SERVEROUT ON SIZE 1000000 FOR TRU;
SET SERVEROUT ON SIZE UNL FOR TRU;
PRO No fatal errors!
COL column_value FOR A2000;
COL filename NEW_V filename FOR A256;
SPO OFF;
@@sqltcommon6.sql
SPO ^^unique_id._xplain.log;
GET sqltxplain.log
.
SPO OFF;
SET TERM ON;
PRO ### copy command below will error out on windows. disregard error.
SET TERM OFF;
HOS cp ^^file_with_one_sql. q.sql
SET TERM ON;
PRO ### copy command below will error out on linux and unix. disregard error.
SET TERM OFF;
HOS copy ^^file_with_one_sql. q.sql
@@sqltcommon7.sql
HOS zip -j ^^unique_id._xplain ^^file_with_one_sql.
HOS zip -m ^^unique_id._xplain sqltxplain.log sqltxplain2.log missing_file.txt
HOS zip -d ^^unique_id._xplain sqltxplain.log sqltxplain2.log missing_file.txt
@@sqltcommon8.sql
HOS zip -m ^^unique_id._log ^^unique_id._xplain.log sqltxhost.log
HOS zip -m ^^unique_id._xplain ^^unique_id.*
SET TERM ON;
HOS unzip -l ^^unique_id._xplain
PRO File ^^unique_id._xplain.zip for ^^file_with_one_sql. has been created.
@@sqltcommon13.sql
HOS zip -m ^^unique_id._xplain ^^unique_id.*
@@sqltcommon9.sql
UNDEF 2
UNDEF enter_tool_password
PRO SQLTXPLAIN completed.
