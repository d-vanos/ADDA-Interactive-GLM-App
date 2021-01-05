#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# IDEAS FOR APP 
## allow intercept to vary or not (yes or no)
# Info that says that if you don't allow intercept or slopes to vary, 
# you're just doing a normal regression
# Info with model type (random intercept, slopes, both, normal regression)
# details about the graph (slope, intercept, etc.)
# Random intercepts and if you click on them, it will highlight it
# Make it so that the colours change again

library(tidyverse)
library('lme4')
library('lmerTest')
library(DT)

# Reading in the data
siop <- read_csv("siop.csv")
siop_group <- read_csv("siop_group.csv")

# This merges the data in together (i.e., disaggregate from the group level to the individual level)
siop_merged <- merge(siop, siop_group, by = "grpid")

# Running a random intercept model with random intercepts for group
PA_model <- lmer("jobsat ~ 1 + posaff + (1 | grpid)", data = siop_merged)
summary(PA_model)



# Generated but not used in the graph
model <- lmer("jobsat ~ 1 + posaff + (1 | grpid)", data = siop_merged)
summary <- summary(model)


# Used in the graph
IV <- siop_merged$posaff
DV <- siop_merged$jobsat
group <- as.factor(siop_merged$grpid)
#slope <- summary$coefficients[2]
general_intercept <- summary$coefficients[1]
rand_intercept <- rnorm(50, mean = 0, sd = 0.8094) #unlist(ranef(PA_model))


library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("MLM Simulation"),
    
    # Sidebar with a slider input for number of bins 
    fluidRow(
        column(width = 3, 
               numericInput("n_groups",
                            "Number of groups",
                            min = 1,
                            value = 1),
               sliderInput("slope",
                           "Value of slope:",
                           min = 0,
                           max = 3,
                           value = 1,
                           step = 0.05),
               sliderInput("general_intercept",
                           "Value of the intercept:",
                           min = -10,
                           max = +10,
                           value = 0.05),
               radioButtons(inputId = "intercept_type",
                            label = "Intercept type:",
                            choices = c("Fixed" = "fixed",
                                        "Random" = "random"),
                            inline = TRUE),
               conditionalPanel(
                   condition = "input.intercept_type == 'random'",
                   sliderInput("sd_rand_int",
                               "Variance (in SD) of the random intercepts:",
                               min = 0,
                               max = +3,
                               value = 0.8094,
                               step = 0.01)
               ),
               radioButtons(inputId = "slope_type",
                            label = "Slope type:",
                            choices = c("Fixed" = "fixed",
                                        "Random" = "random"),
                            inline = TRUE),
               conditionalPanel(
                   condition = "input.slope_type == 'random'",
                   sliderInput("sd_rand_slope",
                               "Variance (in SD) of the random slopes:",
                               min = 0,
                               max = +3,
                               value = 0.8094,
                               step = 0.01)
               ),
        ),
        
        column(width = 6, 
               tags$style(HTML("div.MathJax_Display{text-align: center}")),
               htmlOutput("equation"),
               htmlOutput("reactive_equation"),
               #htmlOutput("equation_explanation"),
               plotOutput("mlm_model")),
        column(width = 3,
               #tags$style(HTML("div.MathJax_Display{text-align: left !important;}")),
               HTML("<p><b> Symbols </b>
                    $$y_{ij} = \\text{The job satisfaction score of person } i \\text{ in group } j $$
                    $$\\gamma_{00} = \\text{The general intercept which applies to all individuals}$$
                    $$\\gamma_{10} = \\text{The regression term (slope) which applies to all individuals}$$
                    $$u_{0j} = \\text{Random intercepts - differs for each group} $$
                    $$u_{1j} = \\text{Random slopes - differs for each group} $$
                    $$(predictor)_{ij} = \\text{The positive affect of person } i \\text{ in group } j$$
                    $$\\varepsilon_{ij} = \\text{deviation of actual score of person } i \\text{ in group } j \\text{ from their expected score}$$")),
    ),
    fluidRow(
        column(width = 3, offset = 0.5,
               htmlOutput("notes")
        ),
        column(width = 3, offset = 4.5,
               conditionalPanel(
                   condition = "input.intercept_type == 'random' & input.n_groups > 1",
                   HTML("$$\\text{Random Intercepts} (u_{0j}) $$"),
                   dataTableOutput("table_intercepts")
               )),
        column(width = 3, offset = 4.5,
               conditionalPanel(
                   condition = "input.slope_type == 'random' & input.n_groups > 1",
                   HTML("$$\\text{Random Slopes} (u_{1j}) $$"),
                   dataTableOutput("table_slopes")))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    random_int_dist <- reactive(rnorm(input$n_groups, mean = input$general_intercept, sd = input$sd_rand_int))
    table_intercepts <- reactive(tibble(Group = seq.int(1:input$n_groups),
                                        "Random Intercept" = round(random_int_dist(), digits = 2)))
    random_slope_dist <- reactive(rnorm(input$n_groups, mean = input$slope, sd = input$sd_rand_slope))
    table_slopes <- reactive(tibble(Group = seq.int(1:input$n_groups),
                                    "Random Slope" = round(random_slope_dist(), digits = 2)))
    
    output$equation <- renderUI({
        formula <- '$$y_{ij} = '
        formula1 <- switch(input$intercept_type,
                           fixed = '\\gamma_{00} + ',
                           random = '(\\gamma_{00} + u_{0j}) + ')
        formula2 <- switch(input$slope_type,
                           fixed = '\\gamma_{10} *',
                           random = '(\\gamma_{10} + u_{1j}) *')
        formula3 <- '(predictor)_{ij} + \\varepsilon_{ij} $$'
        withMathJax(
            (paste0(formula, formula1, formula2, formula3))
        )
    })
    
    output$reactive_equation <- renderUI({
        formula1 <- '$$\\text{Job satisfaction}_{ij} = '
        formula2 <- switch(input$intercept_type,
                           fixed = paste0(input$general_intercept, '+'),
                           random = paste0('(',input$general_intercept, '+ u_{0j}) +'))
        formula3 <- switch(input$slope_type,
                           fixed = input$slope,
                           random = paste0('(',input$slope, '+ u_{1j})'))
        formula4 <- '* (\\text{positive affect})_{ij} + \\varepsilon_{ij} $$'
        HTML(
            paste0(
                withMathJax(
                    formula1,
                    formula2,
                    formula3, 
                    formula4)))
    })
    # output$equation_explanation <- renderUI({
    #     gamma <- withMathJax("$$\\gamma_{00}$$")
    #     HTML(
    #         paste0("where;", 
    #                gamma
    #                
    #             ))
    # })
    
    output$notes <- renderUI({
        HTML("Note: You might notice that sometimes the variance of the slopes and intercepts 
             actually appears to decrease on the graph, rather than increase, when you increase the slider
             (or vice versa). This is because the data used to generate the graphs is drawn randomly from a normal distribution. 
             Overall, you should see that as you increase the variance of the intercept and slopes, there 
             is greater difference between each of the intercepts and slopes. This might be more visible if you 
             increase the number of groups.")
    })
    
    
    output$mlm_model <- renderPlot({
        slope <- input$slope 
        general_intercept <- input$general_intercept
        intercept_type <- input$intercept_type
        slope_type <- input$slope_type
        
        rand_intercept <- switch(input$intercept_type,
                                 fixed = 0,
                                 random = random_int_dist())
        
        slope <- switch(input$slope_type,
                        fixed = input$slope,
                        random = random_slope_dist())
        
        n_groups <- 
            if(input$intercept_type == "fixed" & input$slope_type == "fixed") 1 else
                if(input$intercept_type == "fixed" & input$slope_type == "random") input$n_groups else
                    if(input$intercept_type == "random" & input$slope_type == "fixed")input$n_groups else
                        if(input$intercept_type == "random" & input$slope_type == "random")input$n_groups
        
        
        
        # MLM graph
        ggplot(data = siop_merged, mapping = aes(x = IV, y = DV, group = group, colour = as.factor(1:n_groups))) + 
            #geom_point() + 
            geom_abline(slope = slope, intercept = general_intercept + rand_intercept, colour = as.factor(1:n_groups)) +
            xlab("Positive affect") + ylab("Job satisfaction") +
            xlim(-3, +3) + ylim(-8, +11) +
            theme_classic()+ theme(legend.position="none")
        
        
    })
    
    output$table_intercepts <- renderDataTable(
        table_intercepts(), 
        options = list(lengthChange = FALSE,
                       searching = FALSE),
        rownames = FALSE
    )
    output$table_slopes <- renderDataTable(
        table_slopes(), 
        options = list(lengthChange = FALSE,
                       searching = FALSE),
        rownames = FALSE
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
