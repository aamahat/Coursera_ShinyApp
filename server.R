library(ggplot2)

income_data <- read.csv('salary.csv', stringsAsFactors = FALSE, na.strings = "")
names(income_data) <- c("Name", "Position", "Department", "Income")
income_data <- income_data[!is.na(income_data$Department),]

shinyServer(
  function(input, output) {
    output$tab_output <- renderDataTable({
      dataset <- subset(income_data, Department == input$Department)
      agg_data <- aggregate(as.numeric(substr(Income,2,nchar(Income))) ~ Position, dataset, FUN=mean)
      names(agg_data) <- c("Position", "Average Income")
      final_output <- agg_data[order(agg_data$"Average Income", decreasing = TRUE),]
      final_output
    }, options = list(orderClasses = TRUE)
    )

    output$plot_output <- renderPlot({
      agg_data <- aggregate(as.numeric(substr(income_data$Income,2,nchar(income_data$Income))), list(income_data$Department), FUN=mean)    
      names(agg_data) <- c("Dept", "AvgInc")
      top5_dept <- agg_data[order(agg_data$AvgInc, decreasing = TRUE),]
      top5_dept <- head(top5_dept, 5)
      top5_dept$Dept <- factor(top5_dept$Dept, levels = top5_dept$Dept[order(top5_dept$AvgInc, decreasing = TRUE)])
      ggplot(top5_dept, aes(x = Dept, y = AvgInc)) + 
        geom_point(size=4, group = 1) + geom_line(size=1.25, group = 1, color = "red") + 
        theme(plot.background=element_rect(fill="yellow"), axis.text.x = element_text(angle = 90, hjust = 1)) + 
        labs(x = "Department", y = "Average Income", title = "Top 5 highly paid Departments")
      
    }
    )
  }
)
