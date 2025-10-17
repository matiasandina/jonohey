#' Preview a palette
#' @param palette Name of palette to show. Available names can be found using [jonohey_palettes()]
#' @export
jonohey_show <- function(palette) {
  pal <- jonohey_pal(palette)
  scales::show_col(pal)
}

