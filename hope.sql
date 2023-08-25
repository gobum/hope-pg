--
-- hope.sql - the Postgre test script library
--    Author: Leadzen (李战)
--    Copyright (c) 2000-2023, Gobum Global Development Group
--

\set QUIET 1            \\--关闭元命令的所有回显信息
\set ON_ERROR_STOP 0    \\--需要关闭出错停止
\pset pager 0           \\--需要关闭分页，以防干扰测试报告输出

-- 测试报告输出颜色和格式控制
\set z '\033[0m'
\set d '\033[0;30m'
\set b '\033[0;36m'
\set g '\033[0;32m'
\set r '\033[0;31m'
\set y '\033[0;33m'
\set t :g'[✔] '
\set f :r'[✘] '
\set u :y'[?] '

-- 字符串常量
\set s_include '''Include Script File.\n'''
\set s_hope '''\nHope: '''
\set s_pass '''Hope to execute SQL passed.\n'''
\set s_fail '''Hope to execute SQL failed.\n'''
\set s_assert '''Check assertion.\n'''
\set s_rows 'Hope Rows:EXPR''\n'''
\set s_cols 'Hope Columns:EXPR''\n'''
\set s_var 'Hope Set Variable''\n'''
\set s_done :z'''Done.\n\n'''

\set e_include    '''\n:Include\n'''
\set e_hope       ''':Hope\n'''
\set e_pass       ''':Pass\n'''
\set e_fail       ''':Fail\n'''
\set e_assert     ''':Assert\n'''
\set e_rows       ''':Rows\n'''
\set e_cols       ''':Columns\n'''
\set e_var        ''':Variable\n'''
\set e_done       ''':Done\n'''

-- 状态变量
-- :error   测试用例无法检测的错误
-- :JOB     是否处于测试用例中，:Hope -> 1, :Done -> 0
-- :CMD     当前是否有未输出的 SQL 语句，
-- :DID     当前测试用例是否已经封闭
-- :ACT     当前测试用例是否已有部分行动
-- :ROW     当前测试用例用于测试 SQL 的返回记录行数
-- :COL     当前测试用例用于测试 SQL 的返回记录列数
-- :ASS     当前测试用例用于测试断言
-- :VAR     当前测试用于设置变量

\set to_job '\\set JOB 1 \\set END 0 \\set CMD 1 \\set DID 0 \\set ACT 0 \\set ROW 0 \\set COL 0 \\set ASS 0 '
\set to_act '\\set ACT 1 '
\set to_did '\\set DID 1 \\set ACT 1'
\set to_end '\\set END 1 \\set JOB 0 \\set CMD 1 \\set DID 1 \\set ACT 1 \\set ROW 0 \\set COL 0 \\set ASS 0 '
:to_end

------------------------------------------------------------------------------------------------
-- 时间计量开关（性能测试）
\set t0 '\\timing 0 '   \\--关闭计时器
\set t1 '\\timing 1 '   \\--打开计时器

\set log '\\echo -n '
\set err '\\echo -n ' :y

\set cmd '\\if :CMD ' :log:b ' \\p ' :log:z ' \\set CMD 0 \\endif '

\set exe '\\if :ACT \\r \\else ' :t1 :log:d '\\g' :log:z :t0 ' \\endif '
\set des :t1 :log:d '\\gdesc ' :log:z :t0
\set gxe :t1 :log:d '\\set ROW_COUNT 0 \\gset' :log:z :t0
\set cnt ' \\\\select :ROW_COUNT:EXPR as assert \\gset '
\set row :exe :cnt
\set col :des :cnt
\set one :gxe '\\\\ select :ROW_COUNT <>1 error \\gset '
\set do_pass :cmd :exe ' \\if :ERROR ' :log :f:s_pass:z ' \\else ' :log :t:s_pass:d ' \\endif\\\\'
\set do_fail :cmd :exe ' \\if :ERROR ' :log :t:s_fail:z ' \\else ' :log :f:s_fail:d ' \\endif\\\\'
\set do_row '\\if :ERROR ' :log :u:s_rows:z ' \\else ' :row ' \\if :ERROR ' :log :u:s_rows:z ' \\elif :assert ' :log :t:s_rows:z ' \\else ' :log :f:s_rows:z '\\endif \\endif\\\\ '
\set do_col '\\if :ERROR ' :log :u:s_cols:z ' \\else ' :col ' \\if :ERROR ' :log :u:s_cols:z ' \\elif :assert ' :log :t:s_cols:z ' \\else ' :log :f:s_cols:z '\\endif \\endif\\\\ '
\set do_ass :cmd :one ' \\if :error ' :log :u:s_assert:z ' \\elif :assert ' :log :t:s_assert:z ' \\else ' :log :f:s_assert:z ' \\endif\\\\' 
\set do_var :cmd :one '\\if :error ' :log :f:s_var:z ' \\else ' :log :t:s_var:z '\\endif\\\\'

-- :Include 引用其他SQL文件
\set Include '\\if :JOB ' :err :e_include:z ' \\q \\else ' :log :s_include ' \\endif \\ir '

-- :Hope  开始一个测试用例 E_HOP ? WRONG : E_HOP->0, E_END->1, E_EXE->1, E_ASS->1, E_ROW->1, E_VAR->
\set Hope '\\if :JOB ' :err :e_hope:z ' \\q \\endif' :log :z:s_hope :to_job '\\\\' 

-- :Pass  断言 SQL 语句执行成功
\set Pass '\\if :ACT ' :err :e_pass:z ' \\q \\endif' :do_pass :to_act '\\\\'

-- :Fail  断言 SQL 语句执行失败
\set Fail '\\if :ACT ' :err :e_fail:z ' \\q \\endif' :do_fail :to_act '\\\\'

-- :Rows 记录行数断言
\set Rows '\\if :DID ' :err :e_rows:z' \\q \\endif' :cmd :to_did ' \\set ROW 1 \\set EXPR '

-- :Columns 记录列数断言
\set Columns '\\if :ACT ' :err :e_cols:z' \\q \\endif' :cmd :to_did ' \\set COL 1 \\set EXPR '

-- :Assert 断言表达式
\set Assert '\\if :ACT ' :err :e_assert:z ' \\q \\endif\\\\ assert ' :to_did '\\set ASS 1 \\\\'

-- :Variable 设置变量
\set Variable '\\if :ACT ' :err :e_var:z ' \\q \\endif' :do_var :to_did '\\\\'

-- :Done 结束测试用例
\set Done '\\if :END ' :err :e_done:z ' \\q \\endif \\if :ROW ' :do_row ' \\elif :COL ' :do_col ' \\elif :ASS ' :do_ass ' \\else ' :cmd :exe ' \\endif ' :log :z:s_done :to_end '\\\\'

\o /dev/null

:log 'Import hope.sql\n\n'

\unset do_ass \unset do_row \unset do_col \unset do_fail \unset do_pass 
\unset one \unset row \unset col \unset cnt \unset gxe \unset des \unset exe \unset cmd \unset err \unset log

\unset t1 \unset t0 \unset to_end \unset to_did \unset to_act \unset to_job 
\unset e_done \unset e_rows \unset e_cols \unset e_assert \unset e_fail \unset e_pass \unset e_hope \unset e_include
\unset s_done \unset s_rows \unset s_cols \unset s_assert \unset s_fail \unset s_pass \unset s_hope \unset s_include
\unset u \unset f \unset t \unset y \unset r \unset g \unset b \unset d \unset z
