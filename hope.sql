-- \set QUIET on
\set ON_ERROR_STOP off

\set opening 0
\set waiting 0
\set pending 0
\set judging 0
\set has_sql 1

\set z '\033[0m'
\set b '\033[0;36m' 
\set g '\033[0;32m'
\set r '\033[0;31m'
\set y '\033[0;33m'
\set s_pass '[✔] '
\set s_fail '[✘] '

\set s_success_pass :g:s_pass'Hope execute SQL command success.':z
\set s_success_fail :r:s_fail'Hope execute SQL command success.':z
\set s_failure_pass :g:s_pass'Hope execute SQL command failure.':z
\set s_failure_fail :r:s_fail'Hope execute SQL command failure.':z

\set s_row_count 'Hope row_count'
\set s_assert 'Check assertion.'

\set e_done :y'The previous SQL test case has not been completed. Use ":done" first. ':z
\set e_hope :y'No SQL test case has been defined. Please use ":hope" first.':z
\set e_sql  :r'Error executing SQL.':z
\set e_run  :y'SQL is already executed, can not be executed again.':z

\set to_closed  '\\set opening 0 \\set waiting 0 \\set pending 0 \\set judging 0 \\set has_sql 1'
\set to_waiting '\\set opening 1 \\set waiting 1 \\set pending 0 \\set judging 0 \\set not_run 1'
\set to_pending '\\set opening 1 \\set waiting 0 \\set pending 1 \\set judging 0'
\set to_judging '\\set opening 1 \\set waiting 0 \\set pending 0 \\set judging 1'

\set hope '\\if :opening \\echo :e_done \\q \\endif \\; :to_waiting \\r'

\set success ':say \\if :waiting \\; :execute \\; :do_success \\else \\echo :e_hope \\q \\endif'
\set failure ':say \\if :waiting \\; :execute \\; :do_failure \\else \\echo :e_hope \\q \\endif'

\set row_count ':say \\if :waiting \\; :to_pending \\else \\echo :e_hope \\q \\endif \\; \\set expr '

\set assert 'assert_ :to_judging'

\set done ':say \\if :waiting \\; :do_run \\elif :pending \\; :do_rows \\elif :judging \\; :do_judge \\else echo :e_hope \\q \\endif \\; :to_closed \r'

\set do_success '\\if :ERROR \\echo :s_success_fail \\else \\echo :s_success_pass \\endif'
\set do_failure '\\if :ERROR \\echo :s_failure_pass \\else \\echo :s_failure_fail \\endif'

\set do_run '\\if :not_run \\g \\if :ERROR \\echo :e_sql \\q \\endif \\set not_run 0 \\endif'

\set do_rows ':do_run \\; select :ROW_COUNT :expr assert_ \\gset \\if :ERROR \\echo :e_sql \\q \\endif \\set text :s_row_count :expr \\; :do_assert'

\set do_judge '\\gset \\if :ERROR \\echo :e_sql \\q \\endif \\set text :s_assert \\; :do_assert'

\set do_assert '\\if :assert_ \\echo :g:s_pass:text:z \\else \\echo :r:s_fail:text:z \\endif'

\set say '\\if :has_sql \\echo :b\\p\\echo :z \\set has_sql 0 \\endif'

\set execute '\\if :not_run \\g \\set not_run 0 \\else \\echo :e_run \\q \\endif'
