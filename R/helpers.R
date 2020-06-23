
# The Helper Functions Called by the Main Function

#' Helper function to reorder the values in the input flight dataframe.
#'
#'@param df A two-column dataframe - The start and end airports of flights.
#'
#'@return A two-column dataframe
#'
#' @examples
#' \dontrun{
#' arrange_path(sample_trips)
#' }
#'
#' @export

arrange_path <- function(df) {

    for (i in seq_along(1:nrow(df))) {

        if (df[i,1] > df[i,2]) {
            tmp <- df[i,1]
            df[i,1] <- df[i,2]
            df[i,2] <- tmp
        }
    }
    return(df)
}


#' Helper function to calculate the coordinate limits of map border
#'
#' Since the world map is huge, and flights are usually drawn in a relatively\cr
#' small area, the map needs to be cropped based on the coordinates of airports\cr
#' used. This function generates the coordinate limits of the cropped map.
#'
#'@param v A double numeric vector - vector of longtitudes/latitudes.
#'@param type A string - "long" or "lat". It indicates whether longtitudes or latitudes are input.
#'@param padding_ratio A double number - 0 to 1. The padding ratio is defined as\cr
#'padding / (maximum - minimum)
#'
#'@return A two-column dataframe
#'
#' @examples
#' \dontrun{
#' arrange_path(sample_trips)
#' }
#'
#' @export


get_map_border <- function(v,
                           type = c("long", "lat"),
                           padding_ratio = 0.1) {

    padding <- (max(v) - min(v)) * padding_ratio

    extreme <- ifelse(type == "long", 180, 90)

    return(c(max(min(v) - padding, -extreme),
             min(max(v) + padding, extreme)))

}
