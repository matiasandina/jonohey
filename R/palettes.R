#' jonohey palettes
#' @keywords internal
#' @noRd
.jonohey_palettes <- list(
  bg_col = c(background = "#fbf6d6"),
  jonored = c(jonored = "#c83639"),
  autumn = c(chloro="#27af27", xantho="#f0e57c", caro="#f26d08", antho="#bf2b2b"),
  color_wheel = c(green="#24c22dff", blue="#1f55b5ff", purple="#d63affff",
                  red="#f02e13ff", orange="#feb93aff", yellow="#fff73aff"),
  flying_fabric = c(parachute="#f75e45ff", paraglider="#1f55b5ff", hangglider="#ef9a27ff",
                    kitesurf="#ffac8fff", kite="#6dbb4bff", wingsuit="#303030ff"),
  landlocked = c(access="#b0e8a1ff", landlocked="#feaa3aff", doublelocked="#cd4d4dff"),
  suit = c(jacket="#7b7c6eff", shirt="#6e88a0ff", accent="#af676aff"),
  surfing = c(wave="#b8d3e0ff", sand="#f0d299ff", rock="#bdb4a3ff", accent="#fd6041ff")
)

#' List available palettes
#' @export
jonohey_palettes <- function() names(.jonohey_palettes)

#' Access a jonohey palette
#'
#' @param palette palette name
#' @param n number of colors. If NULL, returns full palette
#' @param type "discrete" or "continuous"
#' @param reverse reverse order
#' @return character vector of hex colors, or a function for continuous scales when used by ggplot
#' @export
jonohey_pal <- function(palette, n = NULL, type = c("discrete","continuous"), reverse = FALSE) {
  type <- match.arg(type)
  pal <- .jonohey_palettes[[palette]]
  if (is.null(pal)) stop("Unknown palette: ", palette, call. = FALSE)
  
  # validate hex
  ok <- grepl("^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$", pal)
  if (!all(ok)) stop("Palette ", palette, " contains invalid hex codes.", call. = FALSE)
  
  if (reverse) pal <- rev(pal)
  
  if (type == "discrete") {
    if (is.null(n)) return(pal)
    if (n > length(pal)) stop("Palette ", palette, " has only ", length(pal), " colors.", call. = FALSE)
    return(pal[seq_len(n)])
  } else {
    # continuous ramp
    ramp <- grDevices::colorRampPalette(pal)
    if (is.null(n)) return(ramp)
    return(ramp(n))
  }
}
