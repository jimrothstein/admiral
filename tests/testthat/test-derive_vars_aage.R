# derive_vars_aage ----
## Test 1: duration and unit variable are added ----
test_that("derive_vars_aage Test 1: duration and unit variable are added", {
  input <- tibble::tribble(
    ~BRTHDT, ~RANDDT,
    ymd("1999-09-09"), ymd("2020-02-20")
  )
  expected_output <- mutate(input, AAGE = 20, AAGEU = "YEARS")

  expect_dfs_equal(derive_vars_aage(input), expected_output, keys = c("BRTHDT", "RANDDT"))
})

## Test 2: Error is thrown when age_unit is not proper unit ----
test_that("derive_vars_aage Test 2: Error is thrown when age_unit is not proper unit", {
  input <- tibble::tribble(
    ~BRTHDT, ~RANDDT,
    ymd("1999-09-09"), ymd("2020-02-20")
  )
  expect_error(
    derive_vars_aage(input, age_unit = "centuries"),
    class = "assert_character_scalar"
  )
})


# derive_var_age_years ----
## Test 3: derive_var_age_years works as expected when AGEU exists ----
test_that("derive_var_age_years Test 3: derive_var_age_years works as expected when AGEU exists", {
  input <- tibble::tibble(
    AGE = c(12, 24, 36, 48, 60),
    AGEU = c("months", "months", "months", "months", "months")
  )

  expected_output <- mutate(
    input,
    AAGE = c(1, 2, 3, 4, 5)
  )

  expect_dfs_equal(derive_var_age_years(input, AGE, new_var = AAGE), expected_output, keys = "AGE")
})

## Test 4: AGEU doesn't exist and `age_unit` is used ----
test_that("derive_var_age_years Test 4: AGEU doesn't exist and `age_unit` is used", {
  input <- tibble::tibble(AGE = c(12, 24, 36, 48, 60))

  expected_output <- mutate(
    input,
    AAGE = c(1, 2, 3, 4, 5)
  )

  expect_dfs_equal(derive_var_age_years(input, AGE, new_var = AAGE, age_unit = "months"),
    expected_output,
    keys = "AGE"
  )
})

## Test 5: Error is thrown when age_unit is not proper unit ----
test_that("derive_var_age_years Test 5: Error is thrown when age_unit is not proper unit", {
  input <- data.frame(AGE = c(12, 24, 36, 48))
  expect_error(
    derive_var_age_years(input, AGE, age_unit = "month", new_var = AAGE),
    class = "assert_character_scalar"
  )
})

## Test 6: Error is issued if age_unit is missing ----
test_that("derive_var_age_years Test 6: Error is issued if age_unit is missing", {
  input <- data.frame(AGE = c(12, 24, 36, 48))
  expect_snapshot(
    derive_var_age_years(input, AGE, new_var = AAGE),
    error = TRUE
  )
})

## Test 7: warn if `age_unit` doesn't match units in data ----
test_that("derive_var_age_years Test 7: warn if `age_unit` doesn't match units in data", {
  input <- tibble::tribble(
    ~AGE,   ~AGEU,
    25,     "years",
    312,    "months",
    51,     "years",
    402,    "months",
    432,    "months"
  )

  expect_snapshot(
    derive_var_age_years(input, AGE, age_unit = "months", new_var = AAGE)
  )
})


## Test 8: error if age_unit has more than one value. ----
test_that("derive_var_age_years Test 8: error if age_unit has more than one value.", {
  input <- tibble::tribble(
    ~AGE,   ~AGEU,
    459,    "months",
    312,    "months",
    510,    "months",
    402,    "months",
    432,    "months"
  )

  expect_error(
    derive_var_age_years(input, AGE, age_unit = c("months", "years"), new_var = AAGE),
    class = "assert_character_scalar"
  )
})

## Test 9: 'unit' variable is handled case insensitive ----
test_that("derive_var_age_years Test 9: 'unit' variable is handled case insensitive", {
  # The tibbles "input" and "input2" differ only in the third row: "Months"
  # versus "months".

  input <- tibble::tribble(
    ~AGE,   ~AGEU,
    459,    "months",
    312,    "months",
    510,    "Months",
    402,    "months",
    432,    "months"
  )

  input2 <- tibble::tribble(
    ~AGE,   ~AGEU,
    459,    "months",
    312,    "months",
    510,    "months",
    402,    "months",
    432,    "months"
  )

  expect_equal(
    derive_var_age_years(input, AGE, age_unit = "months", new_var = AAGE)$AAGE,
    derive_var_age_years(input2, AGE, age_unit = "months", new_var = AAGE)$AAGE
  )
})

## Test 10: warn if unit in data differs from `age_unit` ----
test_that("derive_var_age_years Test 10: warn if unit in data differs from `age_unit`", {
  input <- tibble::tribble(
    ~AGE,   ~AGEU,
    459,    "months",
    312,    "months",
    510,    "months",
    402,    "months",
    432,    "months"
  )

  expect_snapshot(
    derive_var_age_years(input, AGE, age_unit = "years", new_var = AAGE)
  )
})
