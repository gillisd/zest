define_assertion__defined() {
  arg parameter

  assertion_message "expected {parameter} to be defined but was not"
  refutation_message "expected {parameter} to be undefined but was not"

  check() {
    assert $+parameters[$parameter]
  }
}

define_assertion__greater_than() {
  arg lhs integer
  arg rhs integer

  assertion_message "expected {lhs} to be greater than {rhs} but was not"
  refutation_message "expected {lhs} to not be greater than {rhs} but was"

  check() {
    assert $(( lhs > rhs ))
  }
}

define_assertion__less_than() {
  arg lhs integer
  arg rhs integer

  assertion_message "expected {lhs} to be less than {rhs} but was not"
  refutation_message "expected {lhs} to not be less than {rhs} but was"

  check() {
    assert $(( lhs < rhs ))
  }
}

define_assertion__true() {
  arg subject

  assertion_message "expected {subject} to be %Btruthy%b but was not"
  refutation_message "expected {subject} to not be %Btruthy%b but was"

  check() {
    assert $subject
  }
}

define_assertion__false() {
  arg subject

  assertion_message "expected {subject} to be %Bfalsey%b but was not"
  refutation_message "expected {subject} to not be %Bfalsey%b but was"

  check() {
    refute $subject
  }
}

define_assertion__equal() {
  arg expected
  arg actual

  assertion_message "{expected} != {actual}"
  refutation_message "{expected} == {actual}"

  check() {
    if [[ $actual = $expected ]]; then
      return 0
    else
      return 1
    fi
  }
}

define_assertion__match() {
  arg expected
  arg pattern

  assertion_message "expected {expected} to match {pattern} but did not"
  refutation_message "expected {expected} to not match {pattern} but did"

  check() {
    [[ $expected =~ $pattern ]]
  }
}

define_assertion__contains() {
  arg container
  arg item

  assertion_message "expected {container} to contain {item} but did not"
  refutation_message "expected {container} to not contain {item} but did"

  check() {
    if __zest_is_array $container; then
      integer filtered_length=${#${${(P)container}:#$item}}
      integer container_length=${#${(P)container}}
      (( filtered_length < container_length ))
    else
      [[ $container = *${item}* ]]
    fi
  }
}

define_assertion__file_exists() {
  arg file

  assertion_message "expected file {file} to exist but did not"
  refutation_message "expected file {file} to not exist but did"

  check() {
    [[ -e $file ]]
  }
}

define_assertion__empty() {
  arg container

  assertion_message "expected {container} to be empty but was not"
  refutation_message "expected {container} to not be empty but was"

  check() {
    if [[ -n $container ]] && __zest_is_array $container; then
      (( ${#${(P)${container}}} == 0 ))
    else
      [[ -z $container ]]
    fi
  }
}
