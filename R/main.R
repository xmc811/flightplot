
plot_flights <- function(trips,
                         crop = TRUE,
                         land_color = "#f6e8c3",
                         water_color = "aliceblue",
                         dom_color = "#3288bd",
                         int_color = "#d53e4f",
                         linetype = "solid",
                         times_as_thickness = TRUE
) {

    colnames(trips) <- c("Departure", "Arrival")

    my_airports <- tibble(IATA = unique(c(trips$Departure,
                                          trips$Arrival)))
    my_airports <- inner_join(my_airports,
                              airports,
                              by = "IATA")

    trips %<>%
        arrange_path() %>%
        group_by(Departure, Arrival) %>%
        summarise(n = n()) %>%
        ungroup()

    trips %<>%
        inner_join(airports, by = c("Departure" = "IATA")) %>%
        inner_join(airports, by = c("Arrival" = "IATA")) %>%
        mutate(International = ifelse(Country.x == Country.y, FALSE, TRUE))

    routes <- gcIntermediate(p1 = select(trips, Longtitude.x, Latitude.x),
                             p2 = select(trips, Longtitude.y, Latitude.y),
                             n = 500,
                             breakAtDateLine = TRUE,
                             addStartEnd = TRUE,
                             sp = TRUE)

    routes %<>%
        st_as_sf() %>%
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
        geom_sf(data = st_as_sf(routes),
                mapping = aes(size = n/2, color = factor(int)),
                alpha = 0.5) +
        geom_point(data = my_airports, aes(x = Longtitude, y = Latitude)) +
        geom_text_repel(data = my_airports, aes(x = Longtitude, y = Latitude, label = IATA)) +
        scale_color_manual(values = c(dom_color,
                                      int_color)) +
        scale_size_identity() +
        scale_x_continuous(limits = long_limits,
                           expand = c(0, 0)) +
        scale_y_continuous(limits = lat_limits,
                           expand = c(0, 0)) +
        theme(legend.position = "none")

}
