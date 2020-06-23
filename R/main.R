
# The Main Plotting Function

#' The main function to plot flight paths
#'
#' The \code{plot_flights} function use 'ggplot2' to plot flight paths on a world map. The flight path follow the great circle of the Earth, which is computed by 'geosphere'. The function also provides extended functionalities including coloring and cropping. \cr
#' Since 'ggplot2' is used, additional plotting parameters can be easily added to the result.
#'
#' @param trips A two-column dataframe - The start and end airports of flights. The first column should be the start airports, and the second column the end airports. The airport value should be IATA airport code. The column names can be any valid names.
#' @param crop A logical value or a string - Whether the map should be cropped or not and by which preset the map is cropped. If \code{FALSE}, the whole world map is plotted; if \code{TRUE}, the map will be cropped based on the airport coordinates. It also accepts certain strings as presets: \cr
#' \code{"NA"}: North America. \cr
#' \code{"48States"}: The contiguous United States. \cr
#' The default value is \code{TRUE}.
#' @param land_color A string - the color used for land. Default value is \code{"#f6e8c3"}.
#' @param water_color A string - the color used for earth. Default value is \code{"aliceblue"}.
#' @param dom_color A string - the color used for domestic flights. Default value is \code{"#3288bd"}.
#' @param int_color A string - the color used for international flights. Default value is \code{"#d53e4f"}.
#' @param linetype A string - the linetype used for flight paths. Default value is \code{"solid"}.
#' @param times_as_thickness A logical value - whether the times of flights are used as aestheic mappings for the thickness of flight paths. Default value is \code{TRUE}.
#'
#' @return A plot
#'
#' @importFrom magrittr %<>%
#' @importFrom dplyr group_by summarise n ungroup inner_join mutate %>% select
#' @importFrom ggplot2 ggplot geom_sf theme geom_point scale_color_manual scale_size_identity scale_x_continuous scale_y_continuous element_rect aes
#' @importFrom ggrepel geom_text_repel
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' plot_flights(sample_trips)
#' }
#'
#' @export

plot_flights <- function(trips,
                         crop = TRUE,
                         land_color = "#f6e8c3",
                         water_color = "aliceblue",
                         dom_color = "#3288bd",
                         int_color = "#d53e4f",
                         linetype = "solid",
                         times_as_thickness = TRUE) {

    colnames(trips) <- c("Departure", "Arrival")

    my_airports <- tibble::tibble(IATA = unique(c(trips$Departure,
                                                  trips$Arrival)))
    my_airports <- inner_join(my_airports,
                              airports,
                              by = "IATA")

    trips %<>%
        arrange_path() %>%
        group_by(.data$Departure, .data$Arrival) %>%
        summarise(n = n()) %>%
        ungroup()

    trips %<>%
        inner_join(airports, by = c("Departure" = "IATA")) %>%
        inner_join(airports, by = c("Arrival" = "IATA")) %>%
        mutate(International = ifelse(.data$Country.x == .data$Country.y, FALSE, TRUE))

    routes <- geosphere::gcIntermediate(p1 = select(trips,
                                                    .data$Longtitude.x,
                                                    .data$Latitude.x),
                                        p2 = select(trips,
                                                    .data$Longtitude.y,
                                                    .data$Latitude.y),
                                        n = 500,
                                        breakAtDateLine = TRUE,
                                        addStartEnd = TRUE,
                                        sp = TRUE)

    routes %<>%
        sf::st_as_sf() %>%
        mutate(n = trips$n,
               int = trips$International)

    if(!times_as_thickness) {
        routes$n <- 1
    }

    if(crop == TRUE) {

        long_limits <- get_map_border(my_airports$Longtitude,
                                      type = "long")
        lat_limits <- get_map_border(my_airports$Latitude,
                                     type = "lat")
    } else if (crop == "NA") {
        long_limits <- c(-180, -40)
        lat_limits <- c(0, 90)
    } else if (crop == "48States") {
        long_limits <- c(-131, -61)
        lat_limits <- c(23, 51)
    } else {
        long_limits <- c(-180, 180)
        lat_limits <- c(-90, 90)
    }

    ggplot() +
        geom_sf(data = world, fill = land_color, size = 0) +
        theme(panel.background = element_rect(fill = water_color)) +
        geom_sf(data = sf::st_as_sf(routes),
                mapping = aes(size = n/2,
                              color = factor(.data$int)),
                alpha = 0.5) +
        geom_point(data = my_airports,
                   aes(x = .data$Longtitude,
                       y = .data$Latitude)) +
        geom_text_repel(data = my_airports,
                        aes(x = .data$Longtitude,
                            y = .data$Latitude,
                            label = .data$IATA)) +
        scale_color_manual(values = c(dom_color,
                                      int_color)) +
        scale_size_identity() +
        scale_x_continuous(limits = long_limits,
                           expand = c(0, 0)) +
        scale_y_continuous(limits = lat_limits,
                           expand = c(0, 0)) +
        theme(legend.position = "none")

}

