#' Draw a Rectangle
#'
#' @param sketch A p5 sketch.
#' @param x The x coordinate for the
#' @param y The y coordinate for the
#' @param w The width of the rectangle.
#' @param h The height of the rectangle.
#' @export
#' @family Shape 2D Primitives
#' @examples
#' \dontrun{
#'
#' p5() %>%
#'   rect(10, 10, 30, 40)
#'
#' library(dplyr)
#'
#' data_frame(x = c(10, 30, 10, 30),
#'            y = c(10, 10, 30, 30),
#'            w = rep(10, 4),
#'            h = rep(10, 4)) %>%
#'   p5() %>%
#'   rect()
#'
#' data_frame(A = c(10, 40),
#'            B = c(10, 10),
#'            Width = c(20, 10),
#'            Height = c(30, 40)) %>%
#'   p5() %>%
#'   rect(~A, ~B, ~Width, ~Height)
#'
#' }
rect <- function(sketch, x = NULL, y = NULL, w = NULL, h = NULL){
  base_prototype(sketch, "rect", shape_factory, x = x, y = y, w = w, h = h)
}

#' Draw a Line
#'
#' @param sketch A p5 sketch.
#' @param x1 The x coordinate for the first point.
#' @param y1 The y coordinate for the first point.
#' @param x2 The x coordinate for the second point.
#' @param y2 The y coordinate for the second point.
#' @export
#' @family Shape 2D Primitives
#' @export
#' @examples
#' \dontrun{
#'
#' p5() %>%
#'   line(30, 20, 85, 75)
#'
#' }
line <- function(sketch, x1 = NULL, y1 = NULL, x2 = NULL, y2 = NULL){
  base_prototype(sketch, "line", shape_factory, x1 = x1, y1 = y1, x2 = x2, y2 = y2)
}

#' Draw an Arc
#'
#' @param sketch A p5 sketch.
#' @param a The x coordinate of the arc's ellipse.
#' @param b The y coordinate of the arc's ellipse.
#' @param c The width of the arc's ellipse.
#' @param d The height of the arc's ellipse.
#' @param start The angle to start the arc in radians.
#' @param stop The angle to stop the arc in radians.
#' @param mode Determines the style by which the arc is drawn.
#' @export
#' @family Shape 2D Primitives
#' @export
#' @examples
#' \dontrun{
#'
#' p5() %>%
#'   createCanvas(100, 100) %>%
#'   background("#DCDCDC") %>%
#'   arc(50, 55, 50, 50, 0, ~HALF_PI) %>%
#'   noFill() %>%
#'   arc(50, 55, 60, 60, ~HALF_PI, ~PI) %>%
#'   arc(50, 55, 70, 70, ~PI, ~PI+QUARTER_PI) %>%
#'   arc(50, 55, 80, 80, ~PI+QUARTER_PI, ~TWO_PI)
#'
#' p5() %>%
#'   background("#DCDCDC") %>%
#'   arc(50, 50, 80, 80, 0, ~PI+QUARTER_PI, ~OPEN)
#'
#' p5() %>%
#'   background("#DCDCDC") %>%
#'   arc(50, 50, 80, 80, 0, ~PI+QUARTER_PI, ~CHORD)
#'
#' p5() %>%
#'   background("#DCDCDC") %>%
#'   arc(50, 50, 80, 80, 0, ~PI+QUARTER_PI, ~PIE)
#'
#' }
arc <- function(sketch, a = NULL, b = NULL, c = NULL, d = NULL, start = NULL, stop = NULL, mode = NULL){
  base_prototype(sketch, "arc", shape_factory,
                 a = a, b = b, c = c, d = d, start = start, stop = stop, mode = mode)
}

#' Draw an Ellipse
#'
#' @param sketch A p5 sketch.
#' @param x The x coordinate of the ellipse.
#' @param y The y coordinate of the ellipse.
#' @param w The width of the ellipse.
#' @param h The height of the ellipse.
#' @export
#' @family Shape 2D Primitives
#' @export
#' @examples
#' \dontrun{
#'
#' p5() %>%
#'   background("#DCDCDC") %>%
#'   ellipse(56, 46, 55, 55)
#'
#' }
ellipse <- function(sketch, x = NULL, y = NULL, w = NULL, h = NULL){
  base_prototype(sketch, "ellipse", shape_factory, x = x, y = y, w = w, h = h)
}

# Utilities

shape_factory <- function(func, ...){
  args_ <- list(...)
  x <- function(...){
    sprintf(paste0("p.", func, "(",
                   paste(rep("%s", length(args_)), collapse = ","),
                   ");"), ...)
  }
  function(l){
    do.call(x, l)
  }
}

# @param sketch A p5 object.
# @param func A string of a function name.
# @param factory A function which returns a function that creates the p5 string.
# @param ... Named arguments for the function.
#' @importFrom purrr reduce
base_prototype <- function(sketch, func, factory, ...){
  section <- get_section(sketch, func)

  args_ <- prepare_args(sketch, ...) %>%
    map(factory(func, ...)) %>%
    reduce(JS_)

  sketch$x[[section]] <- sketch$x[[section]] %>%
    js_append(args_)
  sketch
}
