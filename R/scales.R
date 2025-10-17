#' ggplot2 scales for jonohey palettes
#'
#' @param palette palette name in jonohey_palettes()
#' @param discrete logical. If TRUE use discrete scale, else continuous
#' @param reverse logical. Reverse palette order
#' @param ... passed to ggplot2 scale constructors
#' @importFrom ggplot2 discrete_scale scale_fill_gradientn scale_color_gradientn
#' @export
scale_fill_jonohey <- function(palette = "autumn", discrete = TRUE, reverse = FALSE, ...) {
  if (discrete) {
    ggplot2::discrete_scale(
      "fill",
      paste0("jonohey_", palette),
      palette = function(n) unname(jonohey_pal(palette, n = n, type = "discrete", reverse = reverse)),
      ...
    )
  } else {
    ggplot2::scale_fill_gradientn(
      colours = unname(jonohey_pal(palette, n = 256, type = "continuous", reverse = reverse)),
      ...
    )
  }
}

#' ggplot2 color scale for jonohey palettes
#'
#' Works exactly like [scale_fill_jonohey()] but applies to `color` aesthetics.
#' @inheritParams scale_fill_jonohey
#' @seealso [ggplot2::scale_color_manual()], [scale_fill_jonohey()], [jonohey_pal()]
#' @importFrom ggplot2 discrete_scale scale_color_gradientn
#' @export
scale_color_jonohey <- function(palette = "autumn", discrete = TRUE, reverse = FALSE, ...) {
  if (discrete) {
    ggplot2::discrete_scale(
      "colour",
      paste0("jonohey_", palette),
      palette = function(n) unname(jonohey_pal(palette, n = n, type = "discrete", reverse = reverse)),
      ...
    )
  } else {
    ggplot2::scale_color_gradientn(
      colours = unname(jonohey_pal(palette, n = 256, type = "continuous", reverse = reverse)),
      ...
    )
  }
}

