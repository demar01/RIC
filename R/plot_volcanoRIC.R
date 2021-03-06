#' Plot log2 fold changes against significance (significant hits get highlighted).
#' 
#' \code{plot_volcanoRIC} generates a volcano plot. Different significance levels 
#' get highlighted in different colours.
#'
#' @param tabletoplot Dataframe
#' First element of list output from \code{\link{test_moderateRIC}}
#' @return A scatter plot (generated by \code{\link[ggplot2]{ggplot}}).
#' @examples
#' if(interactive()){
#' test_moderateRIC(aggregatedWCL_batch)[[1]]$diff_hour18_hour4 -> tabletoplotWCL
# 'plot_volcanoRIC(tabletoplotWCL)
#' }
#' @import ggplot2
#' @export
plot_volcanoRIC <- function(tabletoplot) {
  assertthat::assert_that(is.data.frame(tabletoplot))

  if (!(grep("p.adj", colnames(tabletoplot)))) {
    stop(paste0(
      "p.adj \n",
      "is not in ",
      colnames(tabletoplot)
    ),
    call. = FALSE
    )
  }

  if (!(grep("log2FC", colnames(tabletoplot)))) {
    stop(paste0(
      "log2FC \n",
      "is not in ",
      colnames(tabletoplot)
    ),
    call. = FALSE
    )
  }

  volData <- tabletoplot
  volData <- volData[!is.na(volData$p.adj), ]
  col <- ifelse(volData$p.adj <= 0.1, "orange", "gray")
  col[which(volData$p.adj <= 0.05)] <- "firebrick1"
  col[which(volData$p.adj <= 0.01)] <- "firebrick"
  col[which(volData$p.adj <= 0.1 &
    volData$log2FC < 0)] <- "turquoise1"
  col[which(volData$p.adj <= 0.05 &
    volData$log2FC < 0)] <- "turquoise4"
  col[which(volData$p.adj <= 0.01 & volData$log2FC < 0)] <- "blue"
  col[col == "gray"] <- adjustcolor("gray", alpha = 0.2)
  g <- ggplot(volData, aes(log2FC, -log10(p.adj))) +
    geom_point(size = 1, color = col) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black")
    ) +
    xlim(c(-6, 6)) +
    ylim(c(0, 3)) + # limits could be given as arguments
    xlab("log2 fold change") +
    ylab("-log10 p-value")
  # labs(title = paste("Input ", gsub("_mock"," vs Mock",gsub("diff_hour","hpi",s))))
  return(g)
}
