# flightplot
R Package to Plot the Paths of Flights on the World Map

[![Build Status](https://travis-ci.org/xmc811/flightplot.svg?branch=master)](https://travis-ci.com/xmc811/flightplot)
[![Build status](https://ci.appveyor.com/api/projects/status/qvp3kbwjkjd3clr2/branch/master?svg=true)](https://ci.appveyor.com/project/xmc811/flightplot/branch/master)


### Installation

Please use the following code to install and load the package:

```R
if (!require("devtools")) {
  install.packages("devtools")
}

install_github("xmc811/flightplot", ref = "development")
library(flightplot)
```


### Examples

The main plot function `plot_flights` accepts a two-column dataframe as input, with one column as departure airports and the other as arrival. The values of airports should be IATA 3-letter codes. `sample_trips` is an example dataframe that can be readily used for plotting. The columns names can be any valid names.

```R
sample_trips
```

| Departure | Arrival |
|-----|-----|
| LAX | IAH |
| IAH | LAX |
| SFO | IAH |
| IAH | ORL |
| ORL | IAH |
| IAH | DEN |
| DEN | IAH |
| ... | ... |


To call the main plot function:

```R
plot_flights(sample_trips)
```
<p align="center">
<img src=https://github.com/xmc811/flightplot/blob/master/images/plot_1.png/>
</p>

The map can be set to be cropped to presets:

```R
plot_flights(sample_trips, crop = "48States")
```
<p align="center">
<img src=https://github.com/xmc811/flightplot/blob/master/images/plot_2.png/>
</p>

Some additional parameters can be adjusted:

```R
plot_flights(sample_trips,
             crop = "48States", 
             land_color = "#fdae6b", 
             water_color = "#9ecae1", 
             dom_color = "white", 
             int_color = "black", 
             times_as_thickness = FALSE))
```
<p align="center">
<img src=https://github.com/xmc811/flightplot/blob/master/images/plot_3.png/>
</p>

