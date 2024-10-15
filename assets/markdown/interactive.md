# Interactive Data Exploration

Rattle V5 and earlier have utilised [GGobi](http://ggobi.org/) as an
independent application which provides highly dynamic and interactive
graphic data visualisations for exploratory data analysis. GGobi is
written in C.  Specialist tools include tours, scatterplots, barcharts
and parallel coordinates plots. Points can be identified and linked
with brushing across multiple plots.

GGobi is a stable product and development of it has not seen any
activity since about 2010. Nonetheless, it remains a great tool to
interactively visualise your data.

This interactive feature will simply pass the current dataset on to
GGobi for you to separately explore your data.

In the meantime you can install GGobi following the instructions from
the [Download GGobi](http://ggobi.org/downloads/index.html) site. The
older [rggobi](https://cran.r-project.org/package=rggobi) package for
R was archived in 2020.

The Debian/Ubuntu version is still available and can be installed as:

```
sudo apt install ggobi
```

>
