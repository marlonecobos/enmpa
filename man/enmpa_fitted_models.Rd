% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Classes.R
\name{enmpa_fitted_models}
\alias{enmpa_fitted_models}
\alias{new_enmpa_fitted_models}
\title{Constructor of S3 objects of class enmpa_fitted_models}
\usage{
new_enmpa_fitted_models(glms_fitted, selected, data, weights = NULL)
}
\arguments{
\item{glms_fitted}{a list of fitted GLMs.}

\item{selected}{date.frame with information about selected models.}

\item{data}{data.frame or matrix with the input data used for calibration.}

\item{weights}{(numeric) a vector with the weights for observations.
Default = NULL.}
}
\value{
An S3 object of class \code{enmpa_fitted_models}.
}
\description{
Constructor of S3 objects of class enmpa_fitted_models
}
