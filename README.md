# Bundesliga Standings 2022/23

## Description

Personally, I love sports and play around with data. I decided to present the data from the current season of the [Bundesliga](https://www.bundesliga.com/en/bundesliga). I created an interactive Shiny app, which displays the current standings table and allows the user to check each team's previous matches, as well as check the standings in the previous match days of the season. The app is deployed on shinyapps.io and can be accessed [here](https://slopers-pinches.shinyapps.io/Bundesliga-Table-Standing/).

![](images/BL%20Screenshot.png){width="1500"}

### **About the Bundesliga**

If you are not a football/soccer fan, the concepts could be confusing, but let me briefly explain it! The Bundesliga was founded in 1963 and each year consists of 18 top football teams in England. Seasons run from August to May and consist of 34 match days as each team is playing 34 matches in order to play other 17 teams both home and away. During the season the teams are collecting points. A win gets them 3 points, a draw is worth 1 point and a loss means 0 points. The goals scored and goals conceded also matter. According to the Bundesliga's rules, the final standings table is sorted by number of points received, goal difference and number of goals scored.

### Functionalities

When generated the table shows standings of the current match day. For each team you can see:

-   position, together with an indicator telling us whether the team's current position is better, equal, or worse than the previous one
-   logo and team name
-   number of matches played
-   goal difference (goals scored subtracted by goals received), where a positive number is green, zero is grey and negative is red
-   number of wins, draws, losses, where the background color is selected based on all values in the column and allows us to quickly see if a team is standing out in any way
-   number of points

All rows are expandable. By clicking on the little arrow at the beginning of each row we open a new table that displays all the previous matches of the chosen team. You can see their opponent, whether they played home or away, the final score and the date of the match. At the beginning of each row, there's a little colored circle, which allows you to see whether the team won, lost or drew based on the color (green, red, grey, respectively).

![Expandable Table](images/BL%20Expandable%20Rows.gif){width="1500"}

The table also allows you to "travel in time" by using the slider above. The slider allows you to pick any of the previous match days and see the league standings back then.

![Matchday Slider](images/BL%20Matchday%20Slider.gif){width="1500"}

## Data

In order to get the latest data, I use [Football-Data.org API](https://www.football-data.org/). You need to create an account to get the API token which is free. When running the app, the scripts except a `_config.R` file to get the API token. In the file, my API token is stored as a variable called `auth_token`. I did not include this file in the repository.

#### Requirements

-   R version 4.0.4
-   [shiny](https://cran.r-project.org/web/packages/shiny/index.html)
-   [reactable](https://cran.r-project.org/web/packages/reactable/index.html)
-   [httr](https://cran.r-project.org/web/packages/httr/index.html)
-   [htmltools](https://cran.r-project.org/web/packages/htmltools/index.html)
-   [readr](https://cran.r-project.org/web/packages/readr/index.html)
-   [shinycssloaders](https://cran.r-project.org/web/packages/shinycssloaders/index.html)
-   [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)

#### Basic Folder structure

    .
    ├── www                 # Folder with Bundesliga teams logos                    
    ├── .gitignore                  
    ├── README.md                       
    ├── _server.R           # Script with functions for the server side of the app
    ├── _ui.R               # Script with functions for the UI and style of the app
    └── app.R               # Shiny app file
