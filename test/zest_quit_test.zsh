test_zest_quit_removes_params() {
  local -A params
  local params_out_def="$(
    zest_quit
    noglob print "params=(
  [__ZEST]="${(j%:%)${parameters[(I)__ZEST*]}}"
  [__zest]="${(j%:%)${parameters[(I)__zest*]}}"
  [ZEST]="${(j%:%)${parameters[(I)ZEST*]}}"
  [zest]="${(j%:%)${parameters[(I)zest*]}}"
  [assert_]="${(j%:%)${parameters[(I)assert_*]}}"
  )"
  )"
  eval $params_out_def
  for val in ${params}; do
    assert_empty $val
  done
}

test_zest_removes_main_functions() {
  local fnname=$0
  local -A fns
  local val

  local def="$(
    zest_quit
    noglob print "fns=(
  [assert]="$(functions assert || print 1)"
  [run]="$(functions run || print 1)"
  [run_tests]="$(functions run_tests || print 1)"
  )"
  )"
  eval $def
  for val in $fns; do
    assert_equal 1 $val
  done
}

test_zest_quit_removes_generated_assertions_and_helpers() {
  local def="$(
    zest_quit
    print "fns=(
  [assert_equal]="$(functions assert_equal >/dev/null 2>&1 && print 0 || print 1)"
  [refute_match]="$(functions refute_match >/dev/null 2>&1 && print 0 || print 1)"
  [skip]="$(functions skip >/dev/null 2>&1 && print 0 || print 1)"
  [zest_print]="$(functions zest_print >/dev/null 2>&1 && print 0 || print 1)"
  [internal]="$(functions __zest_record_failure >/dev/null 2>&1 && print 0 || print 1)"
  )"
  )"
  local -A fns
  local val
  eval $def
  for val in $fns; do
    assert_equal 1 $val
  done
}
