
#' The Information of All Aiports
#'
#' A dataframe with basic information of airports all over the world
#'
#' @source <https://github.com/jpatokal/openflights/blob/master/data/airports.dat>
#'
#' @format Dataframe
#' \describe{
#' \item{ID}{Unique OpenFlights identifier for this airport.}
#' \item{Name}{Name of airport. May or may not contain the City name.}
#' \item{City}{Main city served by airport. May be spelled differently from Name.}
#' \item{Country}{Country or territory where airport is located. See Countries to cross-reference to ISO 3166-1 codes.}
#' \item{IATA}{3-letter IATA code. Null if not assigned/unknown.}
#' \item{ICAO}{4-letter ICAO code. Null if not assigned.}
#' \item{Latitude}{Decimal degrees, usually to six significant digits. Negative is South, positive is North.}
#' \item{Longtitude}{Decimal degrees, usually to six significant digits. Negative is West, positive is East.}
#' \item{Altitude}{In feet.}
#' \item{Timezone}{Hours offset from UTC. Fractional hours are expressed as decimals, eg. India is 5.5.}
#' \item{DST}{Daylight savings time. One of E (Europe), A (US/Canada), S (South America), O (Australia), Z (New Zealand), N (None) or U (Unknown). }
#' \item{TZName}{Timezone in \href{http://en.wikipedia.org/wiki/Tz_database}{"tz" (Olson) format}, eg. "America/Los_Angeles".}
#' \item{Type}{Type of the airport. Value "airport" for air terminals, "station" for train stations, "port" for ferry terminals and "unknown" if not known. In airports.csv, only type=airport is included.}
#' \item{Source}{Source of this data. "OurAirports" for data sourced from \href{http://ourairports.com/data/}{OurAirports}, "Legacy" for old data not matched to OurAirports (mostly DAFIF), "User" for unverified user contributions. }
#' }
#' @examples
#'   airports
"airports"

#' Sample Trip Dataset
#'
#' A two-column dataframe with start and end airports of flights. The dataframe can be readily used as input for the main plot function.
#'
#' @format Dataframe
#' \describe{
#' \item{Departure}{IATA code for departure airports}
#' \item{Arrival}{IATA code for arrival airports.}
#' }
#' @examples
#'   sample_trips

"sample_trips"

#' World Map Vector Data
#'
#' A simple feature dataframe generated from world land and earth shapefile.
#'
#' @source <https://www.naturalearthdata.com/downloads/50m-physical-vectors/50m-land/>
#' @format A simple feature dataframe.
#' @examples
#'   world

"world"
