#' Jonohey card theme (rounded panel and optional rounded plot background)
#'
#' Draws a rounded, card-like panel using \pkg{elementalist}. Border is rendered
#' with clipping disabled so stroke width looks even at large radii.
#'
#' Internally adds `coord_cartesian(clip = "off")`. If you later add a different
#' coordinate system like `coord_fixed()` or `coord_polar()`, that replaces it.
#'
#' @param radius_panel Corner radius in points for the panel
#' @param panel_fill Fill color for the panel (defaults to package bg)
#' @param panel_border_colour Panel border color
#' @param panel_border_linewidth Panel border linewidth
#' @param base_size Base font size
#' @param base_family Base font family
#' @param round_plot Logical. Round the outer plot background card
#' @param radius_plot Corner radius in points for the plot background
#' @param plot_bg_fill Fill color for the plot background. Use NA for transparent
#' @param plot_border_colour Plot background border color
#' @param plot_border_linewidth Plot background border linewidth
#'
#' @return A plain list of ggplot components to add with `+`
#' @importFrom grid unit
#' @export
theme_card <- function(
  radius_panel = 30,
  panel_fill = NULL,
  panel_border_colour = "gray20",
  panel_border_linewidth = 0.5,
  base_size = 12,
  base_family = "Fuzzy Bubbles",
  round_plot = FALSE,
  radius_plot = 30,
  plot_bg_fill = NULL,
  plot_border_colour = NA,
  plot_border_linewidth = 0
) {
  bg <- unname(jonohey_pal("bg_col"))[1]
  if (is.null(panel_fill)) {
    panel_fill <- bg
  }
  if (is.null(plot_bg_fill)) {
    plot_bg_fill <- bg
  }

  plot_bg <- if (round_plot) {
    elementalist::element_rect_round(
      fill = plot_bg_fill,
      colour = plot_border_colour,
      linewidth = plot_border_linewidth,
      radius = grid::unit(radius_plot, "pt")
    )
  } else {
    ggplot2::element_rect(
      fill = plot_bg_fill,
      colour = plot_border_colour,
      linewidth = plot_border_linewidth
    )
  }

  list(
    ggplot2::theme_minimal(base_size = base_size, base_family = base_family),
    ggplot2::theme(
      plot.background = plot_bg,
      panel.background = elementalist::element_rect_round(
        fill = panel_fill,
        colour = ggplot2::alpha("black", 0),
        radius = grid::unit(radius_panel, "pt")
      ),
      panel.border = elementalist::element_rect_round(
        fill = ggplot2::alpha("black", 0),
        colour = panel_border_colour,
        linewidth = panel_border_linewidth,
        radius = grid::unit(radius_panel, "pt")
      ),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.ticks.length = grid::unit(0, "pt"),
      plot.margin = grid::unit(c(12, 12, 12, 12), "pt"),
      panel.spacing = grid::unit(8, "pt")
    ),
    ggplot2::coord_cartesian(clip = "off")
  )
}


#' Jonohey axes-wiggle theme
#'
#' Only the axes wiggle (cartoony vibe) using elementalist. Geoms remain straight.
#' No grid, no ticks. Rounded panel optional (same args as round theme).
#'
#' @param base_size base font size
#' @param base_family base font family
#' @param amount wiggle intensity (approx. pixels)
#' @param wiggle_n number of control points for the wiggle
#' @param linewidth linewidth to be passed to axes
#' @param line_color color to be passed to axes
#' @param ... passed to ggplot2 theme constructors
#' @seealso [elementalist::element_line_wiggle()]
#' @export
theme_axes_wiggle <- function(
  base_size = 12,
  base_family = "Fuzzy Bubbles",
  amount = 3,
  wiggle_n = 100,
  linewidth = 1,
  line_color = "gray20",
  ...
) {
  has_elem <- requireNamespace("elementalist", quietly = TRUE)
  bg <- unname(jonohey_pal("bg_col"))[1]
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = bg, colour = NA),
      panel.background = ggplot2::element_rect(fill = bg, colour = NA),
      panel.border = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.ticks.length = grid::unit(0, "pt"),
      # turn on axis lines and wiggle them; keep panel border (rounded) if you like both
      axis.line = elementalist::element_line_wiggle(
        amount = amount,
        n = wiggle_n,
        lineend = "round",
        linewidth = linewidth,
        colour = line_color
      ),
      # breathing room
      plot.margin = grid::unit(c(10, 10, 10, 10), "pt"),
      panel.spacing = grid::unit(8, "pt"),
      ...
    )
}


#' Prefer ragg in the IDE plot pane or fall back to a ragg PNG device
#'
#' - In RStudio/Posit: switches the plot pane backend to ragg and closes the
#'   current pane device so the next plot uses ragg immediately.
#' - Elsewhere: sets the default graphics device to ragg::agg_png for this session.
#'
#' @export
jonohey_use_ragg <- function() {
  is_rstudio <- identical(Sys.getenv("RSTUDIO"), "1") ||
    identical(Sys.getenv("RSTUDIO_SESSION_PORT"), "")
  if (is_rstudio) {
    # Use the IDE's ragg backend for the plot pane
    options(RStudioGD.backend = "ragg")

    # If the current device is the IDE pane, close it so the next plot uses ragg
    cur <- grDevices::dev.cur()
    if (identical(names(cur), "RStudioGD")) {
      grDevices::dev.off()
    }
    cli::cli_alert_success(
      "RStudio plot pane backend set to {.code ragg}. Next plot will use ragg."
    )
    invisible(TRUE)
  } else {
    # Not RStudio: use a ragg PNG device as the default
    old <- getOption("device")
    options(jonohey.original_device = old)
    options(device = function(...) ragg::agg_png(...))

    cli::cli_alert_success(
      "Default graphics device set to {.code ragg::agg_png} for this session."
    )
    cli::cli_alert_info(
      "Plots will open as PNG devices. Use {.code ggsave(..., device = ragg::agg_png)} for files."
    )
    invisible(TRUE)
  }
}

#' Save a PNG with ragg and transparent device bg
#' @param filename output filename
#' @param plot ggplot object to export with transparent bg
#' @param ... passed to ggplot2::ggsave()
#' @export
jonohey_save_png <- function(filename, plot, ...) {
  ggplot2::ggsave(
    filename,
    plot,
    device = ragg::agg_png,
    bg = "transparent",
    ...
  )
}
