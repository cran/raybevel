#' Plot Offset Polygons
#'
#' Plot the offset polygons generated by the `generate_offset_polygon` function.
#'
#' @param offset_polygons Default `NULL`. A `rayskeleton_polygon` or `rayskeleton_polygon_list` object, generated from
#' `generate_offset_polygon()`.
#' @param color Default `grDevices::heat.colors`.  A color or palette function to generate the color palette for the offset polygons' borders.
#' @param xlim Default `NULL`. The x-axis limits as a vector of two values (min, max). If `NULL`, it calculates the limits from the data.
#' @param ylim Default `NULL`. The y-axis limits as a vector of two values (min, max). If `NULL`, it calculates the limits from the data.
#' @param fill Default `NULL`. A color or palette function to generate the fill palette for the polygons' interiors.
#' @param linewidth Default `1`. The linewidth of the polygon.
#' @param background Default `"white"`. Background color.
#' @param plot_original_polygon Default `TRUE`. Whether to plot the original polygon.
#' @param plot_skeleton Default `FALSE`. Whether to plot the straight skeleton.
#' @param return_layers Default `FALSE`, plots the figure. If `TRUE`, this will instead
#' return a list of the ggplot layers.
#' @param ... Additional arguments to pass to `plot_skeleton()` if `plot_skeleton = TRUE`
#'
#'
#' @return A plot showing the offset polygons.
#' @export
#' @examples
#' # Outer polygon
#' vertices = matrix(c(0,0, 7,0, 7,7, 0,7, 0,0), ncol = 2, byrow = TRUE)
#' # Holes inside the polygon
#' hole_1 = matrix(c(1,1, 2,1, 2,2, 1,2, 1,1), ncol = 2, byrow = TRUE)[5:1,]
#' hole_2 = matrix(c(5,5, 6,5, 6,6, 5,6, 5,5), ncol = 2, byrow = TRUE)[5:1,]
#' skeleton = skeletonize(vertices, holes = list(hole_1, hole_2))
#' plot_skeleton(skeleton)
#'
#' #Generate three offsets with the skeleton
#' plot_offset_polygon(generate_offset_polygon(skeleton, c(0.25,0.75,1.5,2)), plot_skeleton = TRUE)
#'
#' #Generate many offsets
#' plot_offset_polygon(generate_offset_polygon(skeleton, seq(0.05,2.55,by=0.1)))
#'
#' #Pass a palette
#' plot_offset_polygon(generate_offset_polygon(skeleton, seq(0.05,2.55,by=0.1)),
#'                     color = heat.colors)
#'
#' #Pass colors manually (colors in excess of the number of offsets are ignored)
#' plot_offset_polygon(generate_offset_polygon(skeleton, seq(0.05,2.55,by=0.1)),
#'                     color = rep(c("red","red","blue","blue"),100))
#'
#' # Skeletonize and plot an {sf} object
#' if(length(find.package("spData",quiet = TRUE)) > 0) {
#'   us_states = spData::us_states
#'   texas = us_states[us_states$NAME == "Texas",]
#'   texas_skeleton = skeletonize(texas)
#'   plot_offset_polygon(generate_offset_polygon(texas_skeleton, seq(0, 2.5, by = 0.1)),
#'                       color = heat.colors,
#'                       linewidth = 1)
#' }
plot_offset_polygon = function(offset_polygons,
                               plot_original_polygon = TRUE,
                               fill = NA, color= "dodgerblue", xlim=NULL, ylim=NULL,
                               linewidth = 1, background = "white",
                               plot_skeleton = FALSE, return_layers = FALSE, ...) {
  # Check if ggplot2 package is installed
  if(!(length(find.package("ggplot2", quiet = TRUE)) > 0)) {
    stop("{ggplot2} package required for plot_offset_polygon_ggplot()")
  }

  # Import ggplot2 functions
  ggplot = ggplot2::ggplot
  aes = ggplot2::aes
  geom_polygon = ggplot2::geom_polygon
  theme_void = ggplot2::theme_void
  coord_fixed = ggplot2::coord_fixed
  theme = ggplot2::theme
  element_rect = ggplot2::element_rect

  x = y = NULL
  # Create an empty ggplot object

  p = list()
  if (inherits(offset_polygons, "rayskeleton_polygons")) {
    if(all(is.na(offset_polygons))) {
      stop("No non-NA offset polygons passed.")
    }
    max_offsets = max(unlist(lapply(offset_polygons[!is.na(offset_polygons)], length)))

    # Set color palettes if provided
    n_polygons = max_offsets
    if(is.function(color)) {
      color = color(n_polygons)
    } else if (is.character(color)) {
      if(length(color) == 1) {
        color = rep(color[1], n_polygons)
      }
    } else {
      color = rep(color[1], n_polygons)
    }

    if(is.function(fill)) {
      fill = fill(n_polygons)
    } else if (is.character(fill)) {
      if(length(fill) == 1) {
        fill = rep(fill[1], n_polygons)
      }
    } else {
      fill = rep(fill[1], n_polygons)
    }
    ray_environment$final_polygon = FALSE
    on.exit({ray_environment$final_polygon = TRUE},
            add = TRUE)
    for(ii in seq_len(length(offset_polygons))) {
      single_skeleton = offset_polygons[[ii]]
      number_offsets = attr(single_skeleton, "number_offsets")
      for(j in seq_len(number_offsets)) {
        single_offset = single_skeleton[[j]]
        n_polygons = attr(single_offset, "number_polygons")
        for(i in seq_len(n_polygons)) {
          if(nrow(single_offset[[i]]) > 0) {
            poly = single_offset[[i]]
            colnames(poly) = c("x","y")
            p[[length(p) + 1]] = geom_polygon(data = data.frame(poly), aes(x = x, y = y),
                                              fill = fill[j], color = color[j], linewidth = linewidth)
          }
        }
      }
    }
    ray_environment$final_polygon = TRUE
  } else if(!inherits(offset_polygons, "rayskeleton_offset_polygons_collection")) {
    stop(sprintf("`offset_polygons`` must be of class `rayskeleton_polygon` or `rayskeleton_offset_polygons_collection` (object is class `%s`)",
                 class(offset_polygons)))
  }

  for(i in seq_len(length(offset_polygons))) {
    original_vertices = attr(offset_polygons[[i]], "original_vertices")
    colnames(original_vertices) = c("x","y")
    # If skeleton is provided and plot_original_polygon is TRUE, add original polygon and holes to the plot
    if (plot_original_polygon) {
      p[[length(p) + 1]] = geom_polygon(data = data.frame(original_vertices),
                           aes(x = x, y = y), fill = NA, color = "black", linewidth = linewidth)

      # Plot holes, if they exist
      original_holes = attr(offset_polygons[[i]], "original_holes")
      if (!is.null(original_holes)) {
        for (hole in original_holes) {
          colnames(hole) = c("x","y")
          p[[length(p) + 1]] = geom_polygon(data = data.frame(hole),
                               aes(x = x, y = y), fill = NA, color = "black", linewidth = linewidth)
        }
      }
    }
  }
  if(plot_skeleton) {
    for(i in seq_len(length(offset_polygons))) {
      p[[length(p) + 1]] = plot_skeleton(attr(offset_polygons[[i]], "skeleton"),
                                         return_layers = TRUE,
                                         ... )
    }
  }

  # Set x and y limits if provided
  if(ray_environment$final_polygon && !return_layers) {
    p[[length(p) + 1]] = coord_fixed()
    p[[length(p) + 1]] = theme_void()
    p[[length(p) + 1]] = theme(legend.position = "none")
    if(!is.na(background)) {
      p[[length(p) + 1]] = theme(plot.background = element_rect(fill = background,
                                                                color = NA))
    }
    return(ggplot() + p)
  } else {
    return(p)
  }
}
