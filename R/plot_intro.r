#' Plot introduction
#'
#' Plot basic information (from \link{introduce}) for input data.
#' @param data input data
#' @param title plot title
#' @param ggtheme complete ggplot2 themes. The default is \link{theme_gray}.
#' @param theme_config a list of configurations to be passed to \link{theme}.
#' @return invisibly return the ggplot object
#' @keywords plot_intro
#' @import ggplot2
#' @importFrom stats reorder
#' @importFrom scales comma percent
#' @export
#' @seealso \link{introduce}
#' @examples
#' plot_intro(airquality)
#' plot_intro(iris)

plot_intro <- function(data, title = NULL, ggtheme = theme_gray(), theme_config = list()) {
	## Declare variable first to pass R CMD check
	id <- dimension <- variable <- value <- NULL
	## Get intro data
	intro <- introduce(data)
	memory_usage <- intro[["memory_usage"]]
	class(memory_usage) <- "object_size"
	memory_usage_string <- format(memory_usage, unit = "auto")
	intro2 <- data.table(
		"id" = seq.int(5L),
		"dimension" = c(rep("column", 3L), "row", "observation"),
		"variable" = c("Discrete Columns", "Continuous Columns", "All Missing Columns", "Complete Rows", "Missing Observations"),
		"value" = c(
			intro[["discrete_columns"]] / intro[["columns"]],
			intro[["continuous_columns"]] / intro[["columns"]],
			intro[["all_missing_columns"]] / intro[["columns"]],
			intro[["complete_rows"]] / intro[["rows"]],
			intro[["total_missing_values"]] / intro[["total_observations"]]
		)
	)
	## Create ggplot object
	output <- ggplot(intro2, aes(x = reorder(variable, -id), y = value, fill = dimension)) +
		geom_bar(stat = "identity") +
		geom_text(aes(label = percent(value))) +
		scale_y_continuous(labels = percent) +
		scale_fill_discrete("Dimension") +
		coord_flip() +
		labs(x = "Metrics", y = "Value")
	## Plot object
	class(output) <- c("single", class(output))
	plotDataExplorer(
		plot_obj = output,
		title = ifelse(is.null(title), paste("Memory Usage:", memory_usage_string), title),
		ggtheme = ggtheme,
		theme_config = theme_config
	)
}
