#Data Source: https://data.cityofchicago.org/api/views/xzkq-xp2w/rows.csv?accessType=DOWNLOAD

fileurl <- "https://data.cityofchicago.org/api/views/xzkq-xp2w/rows.csv"
if(!file.exists('salary.csv')){
  download.file(fileurl, destfile="./salary.csv")
}

income_data <- read.csv('salary.csv', stringsAsFactors = FALSE, na.strings = "")
names(income_data) <- c("Name", "Position", "Department", "Income")
income_data <- income_data[!is.na(income_data$Department),]
income_data <- income_data[order(income_data$Department),]
dept <- unique(income_data$Department)

shinyUI(pageWithSidebar(
  titlePanel('Highly paid Departments & Positions in the City of Chicago'),
  sidebarPanel(
    selectInput('Department','Choose Department', choices=dept),
    br(),
    br(),
    h4('Top 5 highly paid Departments'),
    plotOutput("plot_output")
  ),
  mainPanel(
    h3('Highly paid Positions for the selected Department', style="color:brown"),
    dataTableOutput("tab_output")
  )
))

