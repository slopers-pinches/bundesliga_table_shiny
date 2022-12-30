# Load libraries
library(shiny)
library(httr)
library(reactable)
library(htmltools)
library(readr)
library(shinycssloaders)
library(dplyr)


## Load functions, variables, credentials --------------------------------------
source("_config.R", local = TRUE)
source("_ui.R", local = TRUE)
source("_server.R", local = TRUE)


## Prepare everything, run shiny -----------------------------------------------

# Parameters
api_url <- "https://api.football-data.org/v4/competitions/BL1/"
n_match_days <- 34

# Get current season and its match day 
standings_api <- GET(paste0(api_url, "standings?season=2022"),
                     add_headers("X-Auth-Token" = auth_token)
)
cur_match_day <- content(standings_api)$season$currentMatchday

# Run shiny app
ui <- fluidPage(
    id = 'test',
    tags$head(tags$title("Bundesliga Standings")),
    tags$style(HTML(build_css(n_match_days, cur_match_day))),
    
    titlePanel(h1("Bundesliga Standings", align = "center",
                  style = paste0("color:", red))),
    
    h4("Season 2022/23", align = "center"),
    h5(paste0("Current match day: ", cur_match_day), align = "center"),
    
    fluidRow(
        column(10, offset = 1, style='padding-top:20px;',
               matchday_slider("matchday", "Select match day:",
                               min = 1, max = n_match_days,
                               value = cur_match_day, step = 1, 
                               from_min = 1, from_max = cur_match_day
               ),
               reactableOutput("table") %>%
                   withSpinner(color=spinner_color),
               br(),
               div("LEGEND:"),
               strong("POS"), "current position & previous position
                   indicator ", br(),
               strong("PL"), "number of matches played", br(),
               strong("+/-"), "goal difference", br(),
               strong("W"), "number of wins", br(),
               strong("D"), "number of draws", br(),
               strong("L"), "number of losses", br(),
               strong("PTS"), "number of points",
               hr(),
               div("Football data provided by the ",
                   a("Football-Data.org API",
                     href="https://www.football-data.org/"),".",
                   style = "font-size:11px;")
        )
    )
)
server <- function(input, output) {
    
    teams_matches <- get_teams_matches(api_url)
    all_standings <- get_all_standings_tables(teams_matches, cur_match_day)
    
    observeEvent(input$matchday, {
        BL_table_df <- all_standings[[input$matchday]]
        
        prev <- BL_table_df$prev
        BL_table_df$prev <- NULL
        
        BL_table_df$goals_scored <- NULL
        
        output$table <- renderReactable({
            reactable(BL_table_df,
                      defaultColDef =
                          colDef(vAlign = "center",
                                 style = list(fontWeight = "bold",
                                              color = red),
                                 headerStyle = list(fontWeight = "normal",
                                                    fontSize=12)
                          ),
                      columns = list(
                          position =
                              colDef(name = "POS", maxWidth = 50,
                                     align = "center",
                                     style = list(fontWeight = "normal",
                                                  fontSize = 12),
                                     cell = function(value, index) {
                                         badge <- pos_indicator(prev[index])
                                         tagList(value, badge)
                                     },
                                     header = function(value, name) {
                                         div(value, title="Current position")
                                     }),
                          team = 
                              colDef(name = "TEAM", minWidth = 140,
                                     cell = function (value) {
                                         get_team_img(value)
                                     },
                                     header = function(value, name) {
                                         div(value, title="Team name")
                                     }),
                          played = 
                              colDef(name = "PL",
                                     maxWidth = 50,
                                     class = "border-right",
                                     align = "center",
                                     header = function(value, name) {
                                         div(value,
                                             title="Number of matches played")
                                     }),
                          goal_diff =
                              colDef(name = "+/-",
                                     maxWidth = 50,
                                     class="border-right",
                                     align = "center",
                                     style = function (value) {
                                         color <- goal_diff_color(value)
                                         list(color = color,
                                              fontWeight = "bold")
                                     },
                                     header = function(value, name) {
                                         div(value, title="Goal difference")
                                     }),
                          won =
                              stats_col(min(BL_table_df$won),
                                        max(BL_table_df$won),
                                        cell_class = "spi-rating rating-win",
                                        name = "W",
                                        header = function(value, name) {
                                            div(value, title="Number of wins")
                                        }),
                          draw =
                              stats_col(min(BL_table_df$draw),
                                        max(BL_table_df$draw),
                                        cell_class = "spi-rating rating-draw",
                                        name = "D",
                                        header = function(value, name) {
                                            div(value, title="Number of draws")
                                        }),
                          lost =
                              stats_col(min(BL_table_df$lost),
                                        max(BL_table_df$lost),
                                        cell_class = "spi-rating rating-lose",
                                        name = "L", class = "border-right",
                                        header = function(value, name) {
                                            div(value, title="Number of losses")
                                        }),
                          points =
                              colDef(maxWidth = 50, align = "center",
                                     name = "PTS",
                                     header = function(value, name) {
                                         div(value, title="Number of points")
                                     })
                      ),
                      pagination = FALSE,
                      highlight = TRUE,
                      sortable = FALSE,
                      details = function (index) {
                          sub_table(index, input$matchday, teams_matches,
                                    BL_table_df)
                      }
            )
        })
    })
    
}
shinyApp(ui, server)