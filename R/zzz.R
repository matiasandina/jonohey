.onLoad <- function(libname, pkgname) {
  safe_reg <- function() {
    reg <- system.file(
      "fonts/FuzzyBubbles/FuzzyBubbles-Regular.ttf",
      package = pkgname
    )
    bold <- system.file(
      "fonts/FuzzyBubbles/FuzzyBubbles-Bold.ttf",
      package = pkgname
    )
    if (!nzchar(reg) || !nzchar(bold)) {
      return(invisible())
    }

    # quick header sanity
    hdr_ok <- function(p) {
      h <- try(readBin(p, "raw", n = 4), silent = TRUE)
      isTRUE(
        length(h) == 4 &&
          (identical(h[1:4], as.raw(c(0x00, 0x01, 0x00, 0x00))) ||
            rawToChar(h) == "OTTO")
      )
    }
    if (!hdr_ok(reg) || !hdr_ok(bold)) {
      return(invisible())
    }

    # register, swallow low-level parsing warnings
    suppressWarnings(
      try(
        systemfonts::register_font(
          name = "Fuzzy Bubbles",
          plain = reg,
          bold = bold
        ),
        silent = TRUE
      )
    )
  }
  safe_reg()
}


.onAttach <- function(libname, pkgname) {
  # remember original device once
  if (is.null(getOption("jonohey.original_device", NULL))) {
    options(jonohey.original_device = getOption("device"))
  }

  if (!interactive() || isTRUE(getOption("jonohey.suppress_startup", FALSE))) {
    return(invisible())
  }

  if (requireNamespace("cli", quietly = TRUE)) {
    cli::cli_inform(c(
      "i" = "Exact typography in saved figures works via {.pkg systemfonts} + {.pkg ragg}.",
      ">" = "For interactive plots, run {.code jonohey::jonohey_use_ragg()}",
      " " = "Silence this tip with {.code options(jonohey.suppress_startup = TRUE)}."
    ))
  } else {
    packageStartupMessage(
      "Tip: for exact typography in interactive plots, call jonohey::jonohey_use_ragg(). ",
      "To silence: options(jonohey.suppress_startup = TRUE)"
    )
  }
}
