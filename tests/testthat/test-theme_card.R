test_that("theme_card returns a list of ggplot additions", {
  th <- theme_card(radius_panel = 20)
  expect_type(th, "list")
  expect_true(any(vapply(th, inherits, logical(1), what = "theme")))
  expect_true(any(vapply(th, inherits, logical(1), what = "CoordCartesian")))
})

test_that("theme_card can be added to a plot without error", {
  skip_if_not_installed("ggplot2")
  library(ggplot2)
  p <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
    geom_boxplot(width = 0.7) +
    scale_fill_jonohey("suit") +
    theme_card(radius_panel = 40)
  expect_silent(ggplot_build(p))
})
