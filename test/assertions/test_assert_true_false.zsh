test_assert_true_with_1() {
  run assert_true 1
  assert_equal 0 $rc
}

test_assert_true_with_true() {
  run assert_true true
  assert_equal 0 $rc
}

test_assert_true_with_nonempty_string() {
  run assert_true anything
  assert_equal 0 $rc
}

test_assert_true_with_0() {
  run assert_true 0
  assert_equal 1 $rc
}

test_assert_true_with_false() {
  run assert_true false
  assert_equal 1 $rc
}

test_refute_true_with_0() {
  run refute_true 0
  assert_equal 0 $rc
}

test_refute_true_with_false() {
  run refute_true false
  assert_equal 0 $rc
}

test_refute_true_with_1() {
  run refute_true 1
  assert_equal 1 $rc
}

test_refute_true_with_true() {
  run refute_true true
  assert_equal 1 $rc
}

test_refute_true_with_nonempty_string() {
  run refute_true anything
  assert_equal 1 $rc
}

test_assert_false_with_0() {
  run assert_false 0
  assert_equal 0 $rc
}

test_assert_false_with_false() {
  run assert_false false
  assert_equal 0 $rc
}

test_assert_false_with_1() {
  run assert_false 1
  assert_equal 1 $rc
}

test_assert_false_with_true() {
  run assert_false true
  assert_equal 1 $rc
}

test_assert_false_with_nonempty_string() {
  run assert_false anything
  assert_equal 1 $rc
}

test_refute_false_with_1() {
  run refute_false 1
  assert_equal 0 $rc
}

test_refute_false_with_true() {
  run refute_false true
  assert_equal 0 $rc
}

test_refute_false_with_nonempty_string() {
  run refute_false anything
  assert_equal 0 $rc
}

test_refute_false_with_0() {
  run refute_false 0
  assert_equal 1 $rc
}

test_refute_false_with_false() {
  run refute_false false
  assert_equal 1 $rc
}
