test_that("palette registry lists expected names", {
  nms <- jonohey_palettes()
  expect_type(nms, "character")
  expect_true(all(nzchar(nms)))
  # sanity: some known palettes exist
  expect_true(all(c("autumn", "suit", "bg_col") %in% nms))
})

test_that("all palette hex codes are valid", {
  hex_re <- "^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$"
  for (nm in jonohey_palettes()) {
    pal <- jonohey_pal(nm)
    expect_true(all(grepl(hex_re, pal)), info = paste("invalid hex in", nm))
  }
})
