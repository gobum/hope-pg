--
-- hope.sql - the Postgre test script library
--    Author: Leadzen (李战)
--    Copyright (c) 2000-2023, Gobum Global Development Group
--

\set QUIET 1            \\--关闭元命令的所有回显信息
\set ON_ERROR_STOP 0    \\--需要关闭出错停止
\pset pager 0           \\--需要关闭分页，以防干扰测试报告输出

\set ERROR 0    \\-- 反映 SQL 语句是否执行错误的系统变量，初始值必须设置为 0
\set wrong 0    \\-- 当出现指令使用错误或者无法判断测试结果时设置为 1
\set assert 0   \\-- 断言结果变量
\set variable 0 \\-- 判断 \pset 是否成功

-- 测试报告输出颜色和格式控制
\set z '\033[0m'
\set d '\033[0;30m'
\set b '\033[0;36m'
\set g '\033[0;32m'
\set r '\033[0;31m'
\set y '\033[0;33m'
\set t :g'[✔] '
\set f :r'[✘] '
\set u :y'[?]'
\set n '\n'
\set ln '\\echo '''''

\set s_inc :b '''Include Script File.\n''' :d

-- 字符串常量
\set s_hope '''\nHope: '''
\set s_pass '''Hope to execute SQL passed.\n'''
\set s_fail '''Hope to execute SQL failed.\n'''
\set s_assert '''Check assertion.\n'''
\set s_row 'Hope Row_Count:expr''\n'''
\set s_done :z'''Done.\n\n'''


\set e_Hope       ''':Hope\n'''
\set e_Pass       ''':Pass\n'''
\set e_Fail       ''':Fail\n'''
\set e_Assert     ''':Assert\n'''
\set e_Row_Count  ''':Row_Count\n'''
\set e_Done       ''':Done\n'''

-- 状态变量
-- :ERR     当前测试脚本已出现语法错误，除 :Hope 和 :Done 外，其他指令啥也不做。
-- :JOB     是否处于测试用例中，:Hope -> 1, :Done -> 0
-- :SQL     当前是否有未输出的 SQL 语句，
-- :DID     当前测试用例是否已经封闭
-- :ACT     当前测试用例是否已有部分行动
-- :ROW     当前测试用例用于测试 SQL 的返回记录数
-- :ASS     当前测试用例用于测试断言

\set to_job '\\set ERR 0 \\set JOB 1 \\set SQL 1 \\set DID 0 \\set ACT 0 \\set ROW 0 \\set ASS 0 '
\set to_act '\\set ACT 1 '
\set to_did '\\set DID 1 \\set ACT 1'
\set to_end '\\set ERR 0 \\set JOB 0 \\set SQL 1 \\set DID 1 \\set ACT 1 \\set ROW 0 \\set ASS 0 '
\set to_err '\\set ERR 1 '
:to_end

------------------------------------------------------------------------------------------------
-- 时间计量开关（性能测试）
\set t0 '\\timing 0\\\\ '   \\--关闭计时器
\set t1 '\\timing 1\\\\ '   \\--打开计时器
\set e0 '\\set ECHO none '  \\--关闭 SQL 语句自身输出
\set e1 '\\set ECHO queries '   \\--打开 SQL 语句自身输出


\set say '\\echo -n '
\set err '\\set ERR 1 \\echo -n '

-- :sql  输出将执行的 SQL 到报告
\set sql :say:d ' \\p \\r '
\set cmd '\\if :SQL ' :say:b ' \\p ' :say:z ' \\set SQL 0 \\endif '

\set exe '\\if :ACT \\r \\else ' :t1 :say:d '\\g' :say:z :t0 ' \\endif '
\set gxe :t1 :say:d '\\gset' :say:z :t0
\set do_pass :cmd :exe ' \\if :ERROR ' :say :f:s_pass:z ' \\else ' :say :t:s_pass:z ' \\endif\\\\'
\set do_fail :cmd :exe ' \\if :ERROR ' :say :t:s_fail:z ' \\else ' :say :f:s_fail:z ' \\endif\\\\'
\set as_row :exe ' \\\\select :ROW_COUNT:expr as assert \\gset '
\set do_row '\\if :ERROR ' :say :y:u:s_row:z ' \\else ' :as_row ' \\if :ERROR ' :say :y:u:s_row:z ' \\elif :assert ' :say :g:t:s_row:z ' \\else ' :say :r:f:s_row:z '\\endif \\endif\\\\ '
\set do_ass :cmd :gxe' \\if :ERROR ' :say :y:u:s_assert:z ' \\elif :assert ' :say :g:t:s_assert:z ' \\else ' :say :r:f:s_assert:z ' \\endif\\\\' 

-- :Include 引用其他SQL文件
\set Include :say :s_inc '\\ir '

-- :Hope  开始一个测试用例 E_HOP ? WRONG : E_HOP->0, E_END->1, E_EXE->1, E_ASS->1, E_ROW->1, E_VAR->
\set Hope '\\if :JOB ' :err :y:e_Hope:z :to_err ' \\elif :ERR \\else \\r ' :say :z:s_hope :e0 :to_job ' \\endif\\\\ ' 

-- :Pass  断言 SQL 语句执行成功
\set Pass '\\if :ERR \\elif :ACT' :err :y:e_Pass:z ' \\else ' :do_pass :to_act ' \\endif\\\\'

-- :Fail  断言 SQL 语句执行失败
\set Fail '\\if :ERR \\elif :ACT ' :err :y:e_Fail:z ' \\else ' :do_fail :to_act ' \\endif\\\\'

-- :row_count 记录数断言
\set Row_Count :cmd '\\if :ERR \\elif :DID ' :err :say :y:e_Row_Count:z' \\else ' :to_did ' \\set ROW 1 \\endif \\set expr '

-- :Assert 断言表达式
\set Assert '\\if :ERR \\elif :ACT ' :err :say :y:e_Assert:z ' \\else \\\\assert ' :to_did '\\set ASS 1 \\endif\\\\'

-- :Done 结束测试用例
\set Done '\\if :ERR \\r \\elif :JOB \\if :ROW ' :do_row ' \\elif :ASS ' :do_ass ' \\else ' :cmd :exe ' \\endif ' :say :s_done:d :e1 :to_end ' \\else ' :say :y:e_Done:z ' \\endif\\\\ '

\o /dev/null

:say 'Import hope.sql\n\n':d

:e1