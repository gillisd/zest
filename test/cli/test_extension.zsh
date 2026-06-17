test_multiple_assertion_definition_files_are_sourced() {
  local tree=$(mktemp -d)
  cp -r $__ZEST_ROOT_DIR/src $tree/src
  cp $__ZEST_ROOT_DIR/zest $tree/zest
  cat > $tree/src/zest/assertions/extra.zsh <<'EXTRA'
define_assertion__always_fine() {
  arg x

  assertion_message "expected {x}"
  refutation_message "did not expect {x}"

  check() {
    assert 1
  }
}
EXTRA
  print 'test_ext_inner() { assert_always_fine anything }' > $tree/t.zsh
  run zsh $tree/zest $tree/t.zsh
  zf_rm -rf $tree
  assert_equal 0 $rc
  assert_contains $out "1 passed, 0 failed"
}

test_quit_without_run_restores_shadowed_vars() {
  run zsh -c "typeset -g out=precious; source ${(q)__ZEST_ROOT_DIR}/zest; zest_quit; print -r -- \$out; print -u2 -rn -- CLEAN_STDERR_MARKER"
  assert_equal 0 $rc
  assert_equal precious $out
  assert_equal CLEAN_STDERR_MARKER $err
}
