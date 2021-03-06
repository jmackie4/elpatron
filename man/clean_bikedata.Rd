% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cleaning.R
\name{clean_bikedata}
\alias{clean_bikedata}
\title{Clean raw cycling device data.}
\usage{
clean_bikedata(data, ...)
}
\arguments{
\item{data}{ride data (from \code{\link{import_ride}}) to be "cleaned".}

\item{...}{arguments to be passed to \code{\link[dplyr]{select}}.}
}
\value{
a \code{\link[dplyr]{tbl_df}} with the column structure as described
  above, with a \code{"start_time"} attribute appended where available.
}
\description{
These functions implement a consistent and predictable column
  structure for incoming cycling device data. This should permit, where
  necessary, batch operations on various different file formats. See below
  for details of this structure.
}
\details{
Note that these functions do not retain any of the original data
  columns. If extra columns want to be retained, extra arguments can be
  passed down to \code{\link[dplyr]{select}} via \code{...}

  If any required columns are missing in the original \code{data}, those
  columns of the specification (below) that depend on them will still be
  returned, but filled with \code{NA}s.

  When imported with \code{\link{import_ride}}, the returned data is given a
  file extension attribute. This attribute is the basis for method dispatch
  here.
}
\section{Clean structure}{
 In general, fields should be named as
  \code{"field.units"}, where the field is generally written in full. Time
  derivatives should be adjacent to their "parent" (e.g. distance, speed;
  work, power). If data for any of these columns are missing the column
  should be included, but filled with \code{NA}s. The SI unit system should
  be adhered to.

\describe{

  \item{time.s}{
  Elapsed time \emph{since} the start of recording, in seconds. Should not
  start at 0.
  }

  \item{lon, lat}{
  Positional coordinates in degrees. Keeping these fields in lon,lat order is
  in keeping with the x,y convention.
  }

  \item{distance.km, speed.kmh}{
  Self-explanatory: cumulative distance covered (kilometres) and speed
  (kilometres per hour).
  }

  \item{elevation.m, VAM}{
  Metres above sea level and "vertical ascent metres per second".
  }

  \item{work.kJ, power.W}{
  Self-explanatory: cumulative work done (kilojoules) and power output (Watts).
  }

  \item{cadence.rpm}{
  Pedal (angular) velocity in revolutions per minute.
  }

  \item{hr.bpm}{
  Heart rate in beats per minute.
  }

  \item{temp.C}{
  Ambient temperature in degrees Celsius.
  }

  \item{lap}{
  A lap counter, starting from 1.

  }

}
}
\examples{
ride_file <- system.file("extdata/lufbra.fit", package = "elpatron")

parsed_ride <- import_ride(ride_file, make_laps = TRUE)

## Simple cleaning:
clean_bikedata(parsed_ride)

## We can also make use of dplyr's select_helpers
## (see ?dplyr::select_helpers)

library(dplyr, warn.conflicts = FALSE)
clean_bikedata(parsed_ride, contains("torque"))

## Trying to hold on to non-existent fields won't throw errors.
clean_bikedata(parsed_ride, contains("epo_concentration"))
}

