test_that("scale_fill_jonohey discrete does not error and maps levels", {
  skip_if_not_installed("ggplot2")
  library(ggplot2)
  
  df <- data.frame(x = factor(c("a","b","c")), y = 1:3)
  p <- ggplot(df, aes(x, y, fill = x)) +
    geom_col() +
    scale_fill_jonohey("suit")  # 3 colors available
  
  expect_silent(ggplot_build(p))
  gb <- ggplot_build(p)
  # Extract mapped fill values from first layer
  fills <- unique(gb$data[[1]]$fill)
  expect_equal(length(fills), 3L)
  # all are hex colors
  expect_true(all(grepl("^#", fills)))
})

test_that("scale_fill_jonohey continuous builds", {
  skip_if_not_installed("ggplot2")
  library(ggplot2)
  p <- ggplot(faithfuld, aes(eruptions, waiting, fill = density)) +
    geom_raster() +
    scale_fill_jonohey("surfing", discrete = FALSE)
  expect_silent(ggplot_build(p))
})

test_that("scale_color_jonohey discrete builds", {
  skip_if_not_installed("ggplot2")
  library(ggplot2)
  df <- data.frame(x = 1:3, y = 1:3, g = factor(c("a","b","c")))
  p <- ggplot(df, aes(x, y, colour = g)) +
    geom_point(size = 2) +
    scale_color_jonohey("color_wheel")
  expect_silent(ggplot_build(p))
})
