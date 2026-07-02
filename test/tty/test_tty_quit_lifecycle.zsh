test_interactive_quit_and_reinitialize_is_clean() {
  local custom=$(mktemp)
  cat > $custom <<'CF'
define_assertion__executable() {
  arg file
  assertion_message 'expected {file} to be executable'
  refutation_message 'expected {file} to not be executable'
  check() { [[ -x $file ]] }
}
__zest_build_assertions

test_inner_lifecycle_marker() { assert_executable /bin/ls }
CF

  tty_start
  tty_run "source ${__ZEST_ROOT_DIR}/zest"
  tty_run "source ${custom}"
  tty_run 'run_tests'
  tty_run 'zest_quit'
  tty_run "source ${__ZEST_ROOT_DIR}/zest"

  zf_rm -f $custom

  assert_tty_screen 'inner lifecycle marker'
  assert_tty_screen 'now initialized'
  refute_tty_screen 'command not found'
}
