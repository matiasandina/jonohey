# scripts/setup_fuzzy_bubbles.R  (run from pkg root)

# 1) ensure folders
dir.create("inst/fonts/FuzzyBubbles", recursive = TRUE, showWarnings = FALSE)

# 2) download TTFs + license from Google Fonts repo
base <- "https://github.com/google/fonts/raw/main/ofl/fuzzybubbles"
files <- c(
  "FuzzyBubbles-Regular.ttf",
  "FuzzyBubbles-Bold.ttf",
  "OFL.txt"
)
urls <- file.path(base, files)
dest <- file.path("inst/fonts/FuzzyBubbles", files)

for (i in seq_along(files)) {
  utils::download.file(
    urls[i],
    dest[i],
    mode = "wb",
    quiet = TRUE,
    overwrite = TRUE
  )
}

# 3) add dependency
usethis::use_package("systemfonts", type = "Imports")

# 4) write .onLoad registrar
zzz <- '
.onLoad <- function(libname, pkgname) {
  reg <- function(path) system.file(path, package = pkgname, mustWork = TRUE)
  systemfonts::register_font(
    name  = "Fuzzy Bubbles",
    plain = reg("fonts/FuzzyBubbles/FuzzyBubbles-Regular.ttf"),
    bold  = reg("fonts/FuzzyBubbles/FuzzyBubbles-Bold.ttf")
  )
}
'
writeLines(zzz, "R/zzz.R")

# 5) add a NOTICE about embedded font
notice <- '
This package vendors the Fuzzy Bubbles typeface (SIL Open Font License).
Files: inst/fonts/FuzzyBubbles/*.ttf with OFL.txt included.
Source: https://fonts.google.com/specimen/Fuzzy+Bubbles
'
dir.create("inst", showWarnings = FALSE)
writeLines(notice, "inst/COPYRIGHTS")

# 6) document and reinstall
devtools::document()
devtools::install()
