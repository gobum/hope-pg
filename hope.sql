/*
 * hope.sql - the Postgre test script library
 *
 * Copyright (c) 2000-2023, Gobum Global Development Group
 *
 */

\set QUIET on
\set ON_ERROR_STOP off    \\--需要关闭出错停止
\pset pager off           \\--需要关闭分页，以防干扰测试报告输出

-- 引用其他SQL文件
\set include '\\ir '

-- :hope  开始一个测试用例
\set hope ':Say :n \\if :as_case\\\\ :Say:e_done \\q \\endif\\\\ :to_case '
/* 若已经是 as_case 状态，则提示先用 :done 结束 */

-- :success  断言 SQL 语句执行成功
\set success ':sql \\if :as_case \\\\ :run :do_success \\else\\\\ :Say :e_hope \\q \\endif\\\\'

-- :success  断言 SQL 语句执行失败
\set failure ':sql \\if :as_case \\\\ :run :do_failure \\else\\\\ :Say :e_hope \\q \\endif\\\\'

-- :assert 断言表达式
\set assert '\\if :as_case \\\\ assert_ \\set as_ass 1 \\set as_exe 0 \\set text :s_assert \\else\\\\ :Say :e_hope \\q \\endif\\\\'

-- :row_count 记录数断言
\set row_count ':sql \\if :as_case \\\\ :to_row \\else\\\\ :Say :e_hope \\q \\endif \\\\ \\set expr '

-- :done
\set done ':sql :run :to_done :Say done.:n'

-- :Say  输出字符串
\set Say '\\echo -n '

-- :sql  输出 SQL 到报告
\set sql '\\if :as_sql\\\\ :Say :b \\p\\\\ :Say :z \\set as_sql 0 \\endif\\\\'

-- :run  执行 SQL 语句
\set run '\\if :as_exe \\g \\set as_exe 0 \\endif \\if :as_ass \\gset \\\\ :do_assert \\set as_ass 0 \\endif  \\if :as_row \\\\ :do_row \\set as_row 0 \\endif\\\\'

\set do_success '\\if :ERROR\\\\ :Say :s_success_fail \\else\\\\ :Say :s_success_pass \\endif\\\\'
\set do_failure '\\if :ERROR\\\\ :Say :s_failure_pass \\else\\\\ :Say :s_failure_fail \\endif\\\\'
\set do_assert '\\if :ERROR\\\\ :Say :y:s_none:text:z \\elif :assert_\\\\ :Say :g:s_pass:text:z \\else\\\\ :Say :r:s_fail:text:z \\endif\\\\'
\set do_row '\\set text :s_row_count:expr:n \\if :ERROR\\\\ :Say :y:s_none:text:z \\else \\\\ :do_row_assert \\endif\\\\'
\set do_row_assert ':Say :s_getrow\\\\ select :ROW_COUNT :expr as assert_ \\gset\\\\ :do_assert'

-- 状态变量
\set as_case 0      \\-- 是否开始测试用例 :hope -> 1，:done -> 0
\set as_sql 0       \\-- 作为 SQL 语句，:hope -> 1，:sql -> 0
\set as_exe 0       \\-- 用于执行判断，:hope -> 1，:assert -> 0
\set as_ass 0       \\-- 用于断言判断， :assert -> 1
\set as_row 0       \\-- 用于行数判断， :row_count -> 1

-- :to_case  转换到测试用例初始状态
\set to_done '\\set as_case 0 \\set as_sql 0 \\set as_exe 0 \\\\'
\set to_case '\\set as_case 1 \\set as_sql 1 \\set as_exe 1 \\\\'
\set to_row '\\set as_row 1\\\\'



-- 测试报告输出颜色和格式控制
\set z '\033[0m'
\set b '\033[0;36m'
\set g '\033[0;32m'
\set r '\033[0;31m'
\set y '\033[0;33m'
\set s_pass '[✔] '
\set s_fail '[✘] '
\set s_none '[?]'
\set n '\n'

-- 字符串常量
\set s_success_pass :g:s_pass'Hope to execute SQL command successful.\n':z
\set s_success_fail :r:s_fail'Hope to execute SQL command successful.\n':z
\set s_failure_pass :g:s_pass'Hope to execute SQL command failed.\n':z
\set s_failure_fail :r:s_fail'Hope to execute SQL command failed.\n':z

\set s_row_count 'Hope row_count'
\set s_getrow :b'Read row count.\n':z
\set s_assert 'Check assertion.\n'

\set e_done :y'The SQL test case is not complete. Use ":done" to end it.\n':z
\set e_hope :y'No SQL test case has been defined. Please use ":hope" first.\n':z
\set e_sql  :r'Error executing SQL.\n':z

------------------------------------------------------------------------------------------------
-- 时间计量开关（性能测试）
\set timing_on '\\timing on\\\\'      \\--打开计时器
\set timing_off '\\timing off\\\\'    \\--关闭计时器

-- 查询结果开关
\set reply_on '\\o\\\\'
\set reply_off '\\o /dev/null\\\\'

:timing_on  --默认打开计时器
:reply_off  --默认关闭查询回应

:Say :b'Import hope.sql\n':z