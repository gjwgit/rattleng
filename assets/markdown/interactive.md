# Interactive Data Exploration

The interactive data exploration functionality is not yet
available. However, I am experimenting with including the
[explore](https://github.com/rolkra/explore) package. You can also
experiment with the package. After loading a dataset into Rattle, go
to the CONSOLE tab and entry the following commands:

```r
install.packages('explore')
library(explore)
explore(ds)
```

Rattle V5 and earlier utilised [GGobi](http://ggobi.org/) for
interactive graphic data visualisations. GGobi was written in C and
supported specialist tools including tours, scatterplots, barcharts
and parallel coordinates plots. GGobi has not seen any activity since
about 2010 and is not currently included in this version of Rattle.

You can try installing GGobi following the instructions from the
[Download GGobi](http://ggobi.org/downloads/index.html) site. The
older [rggobi](https://cran.r-project.org/package=rggobi) package for
R was archived in 2020.

The Debian/Ubuntu version is still available and can be installed as:

```bash
sudo apt install ggobi
```

>
