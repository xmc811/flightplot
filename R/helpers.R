
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


get_map_border <- function(v,
                           type = c("long", "lat"),
                           padding_ratio = 0.1) {

    padding <- (max(v) - min(v)) * padding_ratio

    extreme <- ifelse(type == "long", 180, 90)

    return(c(max(min(v) - padding, -extreme),
             min(max(v) + padding, extreme)))

}
