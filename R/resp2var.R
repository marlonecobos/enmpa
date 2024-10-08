#' Two-Way interaction response plot
#'
#' @description
#' A view of the species probability into a two-dimensional
#' environmental space.
#'
#' @usage
#' resp2var(model, variable1 , variable2, modelID = NULL, data = NULL, n = 1000,
#'          new_data = NULL, extrapolate = FALSE, add_bar = TRUE,
#'          add_limits = FALSE, color.palette	= NULL, xlab = NULL, ylab = NULL,
#'          ...)
#
#' @param model an object of class `glm` or `enmpa_fitted_models`.
#' @param variable1 (character) name of the variable to be plotted in x axis.
#' @param variable2 (character) name of the variable to be plotted in y axis.
#' @param modelID (character) name of the ModelID if inputed `model` is  in the
#' `enmpa_fitted_models` object.
#' Default = NULL.
#' @param data data.frame or matrix of data to be used in model calibration.
#' Default = NULL.
#' @param n (numeric) an integer guiding the number of breaks. Default = 100
#' @param new_data a `SpatRaster`, data.frame, or  matrix of variables
#' representing the range of variable values in an area of interest.
#' Default = NULL.
#' @param extrapolate (logical) whether to allow extrapolation to study the
#' behavior of the response outside the calibration limits. Ignored if
#' `new_data` is defined. Default = TRUE.
#' @param add_bar (logical) whether to add bar legend. Default = TRUE.
#' @param add_limits (logical) whether to add calibration limits if
#' `extrapolate = TRUE`. Default = FALSE.
#' @param color.palette (function) a color palette function to be used to assign
#' colors in the plot. Default = function(n) rev(hcl.colors(n, "terrain")).
#' @param xlab (character) a label for the x axis. The default, NULL, uses the
#' name defined in `variable1`.
#' @param ylab (character) a label for the y axis. The default, NULL, uses the
#' name defined in `variable2`.
#' @param ... additional arguments passed to
#' \code{\link[graphics]{image}}.
#'
#' @details
#' The function calculates probabilities by focusing on each combination of the
#' two supplied environmental variable while keeping all other variables constant
#' at their mean values.
#'
#'
#' @return
#' A plot with the response interaction of two environmental dimensions for
#' `variable1` and `variable2`, and don't return anything.
#'
#' @export
#' @rdname resp2var
#'
#' @importFrom stats predict coef
#' @importFrom graphics par title axis image layout mtext plot.new plot.window rect
#' @importFrom terra minmax
#' @importFrom grDevices hcl.colors
#'
#' @examples
#' # Load a fitted selected model
#' data(sel_fit, package = "enmpa")
#'
#' # Two-Way interaction response plot in the calibration limits
#'
#' resp2var(sel_fit, variable1 = "bio_1", variable2 = "bio_12", xlab = "BIO-1",
#' ylab = "BIO-12", modelID = "ModelID_7")
#'
#' # Two-Way interaction response plot allowing extrapolation
#' resp2var(sel_fit, variable1 = "bio_1", variable2 = "bio_12", xlab = "BIO-1",
#' ylab = "BIO-12", modelID = "ModelID_7", extrapolate = TRUE)

resp2var <- function(model, variable1 , variable2, modelID = NULL, data = NULL,
                     n = 1000, new_data = NULL, extrapolate = FALSE,
                     add_bar = TRUE, add_limits = FALSE, color.palette	= NULL,
                     xlab = NULL, ylab = NULL, ...) {

  # initial tests
  if (missing(model) | missing(variable1) | missing(variable2)) {
    stop("Argument 'model' or 'variables' must be defined.")
  }

  if (!is.null(new_data)) {
    if (!class(new_data)[1] %in% c("matrix", "data.frame", "SpatRaster")) {
      stop("'new_data' must be of class 'matrix', 'data.frame', 'SpatRaster'")
    }
  }

  if (class(model)[1] == "glm" && is.null(try(model$data)) && is.null(data)) {
    stop(paste("The argument 'data' must be defined in case the model entered",
               "does not explicitly include a data component."))
  }

  if (class(model)[1] == "glm" && !is.null(try(model$data))) {
    data <- model$data
  }

  #  using de 'enmpa fitted object'
  if (class(model)[1] == "enmpa_fitted_models" && !is.null(modelID)) {
    data  <- model$data
    model <-  model$glms_fitted[modelID][[1]]
  } else {
    if (class(model)[1] == "enmpa_fitted_models" && is.null(modelID)) {
      stop(paste("The argument 'modelID' must be defined if you are entering",
                 "an object 'enmpa_fitted_models'."))
    }
  }


  if (is.null(xlab)) xlab <- variable1
  if (is.null(ylab)) ylab <- variable2
  if (is.null(color.palette)) color.palette = function(n) rev(hcl.colors(n, "terrain"))
  # if (is.null(color.palette)) color.palette = function(n) hcl.colors(n)


  variables <- c(variable1, variable2)

  # It gets only the variable names used in the fitted model
  vnames <- colSums(
    sapply(colnames(data), grepl, names(coef(model)[-1]))
  ) > 0

  if (any(!variables %in% names(vnames))) {
    stop("The name of the 'variables' was not defined correctly.")
  }

  # Extract calibration data from the model object
  cal_data <- data[, vnames]

  # Extract the limits of the calibration data
  cal_maxs <-  apply(cal_data, 2, FUN = max)
  cal_mins <-  apply(cal_data, 2, FUN = min)

  # Get the average of all variabless
  means <- apply(cal_data, 2, FUN = mean)


  if (is.null(new_data)) {

    if (extrapolate){

      rr1 <- range(cal_data[, variables[1]]) # range of the calibration data
      rr2 <- range(cal_data[, variables[2]]) # range of the calibration data

      l_limit1 <- rr1[1] - 0.11 * diff(rr1)
      u_limit1 <- rr1[2] + 0.11 * diff(rr1)

      l_limit2 <- rr2[1] - 0.11 * diff(rr2)
      u_limit2 <- rr2[2] + 0.11 * diff(rr2)


      rangev1 <- c(l_limit1, u_limit1)
      rangev2 <- c(l_limit2, u_limit2)

    } else {

      rangev1 <- range(cal_data[, variables[1]])
      rangev2 <- range(cal_data[, variables[2]])
    }

  } else {

    if (class(new_data)[1] == "SpatRaster") {
      rangev1 <- terra::minmax(new_data[[variables[1]]])
      rangev2 <- terra::minmax(new_data[[variables[2]]])

    } else {
      rangev1 <- range(new_data[, variables[1]])
      rangev2 <- range(new_data[, variables[2]])
    }

  }

  newvar <- expand.grid(x = seq(rangev1[1], rangev1[2], length = n),
                        y = seq(rangev2[1], rangev2[2], length = n))


  m <- data.frame(matrix(means, nrow(newvar), length(means), byrow = T))
  colnames(m) <- names(means)

  m[, variables[1]] <- newvar[, 1]
  m[, variables[2]] <- newvar[, 2]

  # Response of the variables
  predicted <- stats::predict(model, m, type = "response")

  # Arguments for filled.contour
  # "x,y" locations of grid lines at which the values in z are measured
  # "z" a numeric matrix containing the values to be plotted
  x = unique(m[, variables[1]])
  y = unique(m[, variables[2]])
  z = matrix(data = predicted, nrow = n, ncol = n)


  # Set colors
  colors <- color.palette(10)

  # Save the original par settings
  original_par <- par(no.readonly = TRUE)

  if (add_bar == FALSE){
    # Plot the main image
    image(x,y,z,
          zlim = c(0,1),
          col = colors,
          xlab = xlab, ylab = ylab, useRaster = F, ...)

    if (extrapolate & add_limits ){

      abline(v = c(cal_mins[variables[1]], cal_maxs[variables[1]]),
             h = c(cal_mins[variables[2]], cal_maxs[variables[2]]),
             lty = 2)
    }
  } else{

    layout(matrix(1:2, ncol = 2), widths = c(4, 1))  # Adjust widths to allocate space for the legend
    par(mar = c(5, 4, 4, 2) + 0.1)  # Set margins for the main plot

    # Plot the main image
    image(x,y,z,
          zlim = c(0,1),
          col = colors,
          xlab = xlab, ylab = ylab, useRaster = T, ...)

    if (extrapolate & add_limits ){

      abline(v = c(cal_mins[variables[1]], cal_maxs[variables[1]]),
             h = c(cal_mins[variables[2]], cal_maxs[variables[2]]),
             lty = 2)
    }

    # Add the color bar legend
    par(mar = c(5, 0, 4, 2) + 0.1)  # Set margins for the legend
    color_levels <- seq(0, 1, length.out = length(colors) + 1)
    legend_y <- seq(min(y), max(y), length.out = length(colors) + 1)

    # Plot the legend
    plot.new()
    plot.window(xlim = c(0, 1), ylim = range(legend_y))

    # Draw rectangles for the legend
    for (i in seq_along(colors)) {
      rect(0.25, legend_y[i], 0.5, legend_y[i + 1], col = colors[i],
           border = "transparent")
    }
    rect(0.25, min(legend_y), 0.5, max(legend_y), col = NA,
         border = "black")

    # Add text labels to the legend
    axis(4, at = legend_y, labels = round(color_levels, 2), las = 1,
         tick = FALSE, pos = 0.5  )
    mtext("Suitability", side = 3, line = 0, cex = 1.2)

    # Restore the original par settings
    par(original_par)
  }


  # filled.contour(x, y, z,
  #                nlevels = 10,
  #                color.palette = color.palette,
  #                key.title = {par(cex.main = 0.9); title(main = NULL)},
  #                xlab = xlab, ylab = ylab,
  # )

  # other alternative
  # image(x,y,z,
  #       zlim = c(0,1),
  #       col = color.palette(10),
  #       xlab = xlab, ylab = ylab, useRaster = T)
  # contour(x,y,z,
  #         levels = seq(0, 1, by = 0.1),
  #         add = TRUE, col = "black")

}
