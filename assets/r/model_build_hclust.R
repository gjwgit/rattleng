# Build an Hierarchical cluster.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-05-14 17:06:07 +1000 Graham Williams>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams, Zheyuan Xu

# Cluster using Hierarchical
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/cluster-analysis.html
# https://survivor.togaware.com/datascience/ for further details.

# Reset the random number seed to obtain the same results each
# time. 20241012 gjw RattleV5 did not reset the seed so that we can
# demonstrate that each time we get a different random start and then
# a different model.

# set.seed(<RANDOM_SEED>)

# Load required packages from the local library into the R session.
# The 'reshape' package provides the 'rescaler' function.

library(reshape)
library(amap)

mtype <- "hierarchical_amap"
mdesc <- "Hierarchical Clustering using amap package"

# Set whether the data should be rescaled
rescale <- <CLUSTER_RESCALE>

# Prepare the data for clustering based on the value of rescale.

if (rescale) {
  # Rescale the data.

  tds <- sapply(na.omit(ds[tr, numc]),
                reshape::rescaler,
                "range")
} else {
  # Use the data without rescaling.

  tds <- na.omit(ds[tr, numc])
}

# Convert data to matrix if necessary.

tds <- as.matrix(tds)

# Perform hierarchical clustering using the hcluster function from the amap package.

model_hclust <- hcluster(tds, method=<CLUSTER_DISTANCE>, link=<CLUSTER_LINK>, nbproc=<CLUSTER_PROCESSOR>)
##
## May consider going to agnes() as used in COMP3425
##
## model_hclust <- cluster::agnes(tds, metric="euclidean", method="ward")

# Cut the dendrogram to get the specified number of clusters.

cluster_assignments <- cutree(model_hclust, k = <CLUSTER_NUM>)

# Add the cluster assignments to the data frame (optional).

tds_with_clusters <- data.frame(tds, cluster = cluster_assignments)

# Report on the cluster characteristics.

# Cluster sizes:

cluster_sizes <- table(cluster_assignments)
print("Cluster Sizes:")
print(cluster_sizes)

# Data means:

data_means <- colMeans(tds)
print("Data Means:")
print(data_means)

# Cluster centers:

cluster_centers <- aggregate(tds, by = list(cluster = cluster_assignments), FUN = mean)
print("Cluster Centers:")
print(cluster_centers)

# Within-cluster sum of squares:

withinss <- sapply(split(as.data.frame(tds), cluster_assignments), function(cluster_data) {
  center <- colMeans(cluster_data)
  sum(rowSums((cluster_data - center)^2))
})
print("Within-Cluster Sum of Squares:")
print(withinss)

cat("\n")

# Plot the dendrogram using ggplot2. (gjw 20250514)

svg("<TEMPDIR>/model_cluster_hierarchical.svg", width=12, height=10)
dd <- ggdendro::dendro_data(model_hclust)
id <- ds[tr,identifier] %>% data.frame() %>% '[['(1)
labels <- dd$labels
labels$identifier <- id[match(labels$label, rownames(ds[tr,]))]
ggplot() +
  geom_segment(data = dd$segments,
               aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_text(data = labels,
            aes(x = x, y = y, label = identifier),
            vjust   = -0.2,  # Adjust vertical position
            nudge_y = 0.1, # Nudge labels slightly away from lines
            size    = 4) +    # Adjust text size
  coord_flip() +
  labs(title = "Hierarchical Clustering Dendrogram", y="", x="") +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.margin = margin(10, 50, 10, 10),
        axis.text.x = element_blank(),
        axis.text.y = element_blank() )
dev.off()

# Extract the corresponding cluster assignments.  Hierarchical
# clustering creates a tree-like structure (dendrogram) rather than
# directly assigning observations to clusters.  The cutree function is
# used to cut the dendrogram at a specified number of clusters.

cluster_assignments <- cutree(model_hclust, k=<CLUSTER_NUM>)

pair_file <- "model_cluster_pairs_hierarchical.svg"
