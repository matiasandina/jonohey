test_that("jonohey_pal() returns full discrete palette by default", {
  pal <- jonohey_pal("autumn")
  expect_type(pal, "character")
  expect_equal(length(pal), 4L)
})

test_that("jonohey_pal() respects n for discrete and errors if n too large", {
  expect_equal(length(jonohey_pal("suit", n = 2)), 2L)
  expect_error(jonohey_pal("suit", n = 99), "has only")
})

test_that("jonohey_pal() reverse works", {
  pal <- jonohey_pal("autumn")
  pal_rev <- jonohey_pal("autumn", reverse = TRUE)
  expect_identical(rev(pal), pal_rev)
})

test_that("jonohey_pal() errors on unknown palette", {
  expect_error(jonohey_pal("nope"), "Unknown palette")
})

test_that("continuous path returns function when n is NULL and vector when n given", {
  ramp <- jonohey_pal("autumn", type = "continuous")
  expect_type(ramp, "closure")
  v <- jonohey_pal("autumn", type = "continuous", n = 7)
  expect_type(v, "character")
  expect_equal(length(v), 7L)
})
