REM $Header: 215187.1 sqltcommon12.sql 11.4.5.7 2013/04/05 carlos.sierra $
-- begin common
SET TERM OFF;
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('addm_reports', '6');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('ash_reports', 'BOTH');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('awr_reports', '6');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('bde_chk_cbo', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('c_dba_hist_parameter', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('c_gran_cols', 'SUBPARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('c_gran_hgrm', 'SUBPARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('c_gran_segm', 'SUBPARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('distributed_queries', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('domain_index_metadata', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('r_gran_cols', 'PARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('r_gran_hgrm', 'PARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('r_gran_segm', 'PARTITION');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('search_sql_by_sqltext', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('sql_monitor_reports', '12');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('sql_monitoring', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('sql_tuning_advisor', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('sql_tuning_set', 'Y');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('sqldx_reports_format', 'BOTH');
EXEC ^^tool_administer_schema..sqlt$a.set_sess_param('test_case_builder', 'Y');
SET TERM ON;
-- end common
