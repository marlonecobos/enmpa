% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enmpa.R
\docType{package}
\name{enmpa}
\alias{enmpa-package}
\alias{enmpa}
\title{enmpa: Ecological Niche Modeling using Presence-Absence Data}
\description{
\code{enmpa} contains a set of tools to perform detailed Ecological Niche Modeling
using presence-absence data.
}
\details{
It includes algorithms for data partitioning, model fitting, calibration,
evaluation, selection, and prediction. Other functions help to explore model
features as such variable response curves and variable importance.
}
\section{Main functions in \code{enmpa}}{

\code{\link{calibration_glm}}, \code{\link{evaluation_stats}},
\code{\link{fit_glms}}, \code{\link{fit_selected}},
\code{\link{get_formulas}}, \code{\link{independent_eval1}},
\code{\link{kfold_partition}}, \code{\link{model_selection}}
\code{\link{model_validation}}, \code{\link{niche_signal}},
\code{\link{optimize_metrics}}, \code{\link{predict_glm}},
\code{\link{predict_selected}}, \code{\link{response_curve}},
\code{\link{resp2var}}, \code{\link{var_importance}},
\code{\link{jackknife}}, \code{\link{plot_jk}}
}

\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/Luisagi/enmpa}
  \item Report bugs at \url{https://github.com/Luisagi/enmpa/issues}
}

}
\author{
\strong{Maintainer}: Luis F. Arias-Giraldo \email{lfarias.giraldo@gmail.com} (\href{https://orcid.org/0000-0003-4861-8064}{ORCID})

Authors:
\itemize{
  \item Marlon E. Cobos \email{manubio13@gmail.com} (\href{https://orcid.org/0000-0002-2611-1767}{ORCID})
}

Other contributors:
\itemize{
  \item A. Townsend Peterson \email{town@ku.edu} (\href{https://orcid.org/0000-0003-0243-2379}{ORCID}) [contributor]
}

}
