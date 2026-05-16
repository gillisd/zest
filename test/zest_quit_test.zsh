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
