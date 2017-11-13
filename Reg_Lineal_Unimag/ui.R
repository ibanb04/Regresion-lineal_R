library(shiny)
library(ggplot2)
library(xtable)
library(plotly)

shinyUI(pageWithSidebar(
  
  # Header:
  headerPanel("Regresion Lineal Simple-Unimag"),
  
  # Input del sidepanel:
  sidebarPanel(
    
    # Cargar archivos:
    fileInput("file", "Subir el archivo .CSV :"),
    htmlOutput("X"),
    htmlOutput("Y"),
    h3("Delopeved by:"),
    h4(" * Ricardo Pelaez."),
    h4(" * Ivan Bettin."),
    h4(" * Dairo Cantillo."),
    h4(" * David Vargas."),
   
    tags$img(src='EscudoUnimag.png',heigth=100,width=100)
  ),
  
  # funcion principal(Main):
  mainPanel(
    navbarPage("",
               tabPanel("Tabla de datos", dataTableOutput("table")),
               navbarMenu("Regresion",
                          tabPanel("Grafica de la recta", p(),plotlyOutput("lplot")), 
                          tabPanel("Modelo lineal",htmlOutput("sumtable"),htmlOutput("sumtext"),verbatimTextOutput("sum")), 
                          tabPanel("ANOVA", htmlOutput("antable"),verbatimTextOutput("anova")),
                          tabPanel("Diagnostics (Supuestos)", plotOutput("dplot"))),
              # navbarMenu("Non parametric",
               #           tabPanel("Spline plot", plotlyOutput("splot")),           
                #          tabPanel("Non parametric (rank) plot", plotlyOutput("rplot")),
                 #         tabPanel("Spearman's rank correlation",verbatimTextOutput("cor"))),
              navbarMenu("Quadratics",
                          tabPanel("Quadratic plot", plotlyOutput("qplot")),
                          tabPanel("Quadratic summary", verbatimTextOutput("quadsum")),
                          tabPanel("Quadratic anova",verbatimTextOutput("quadanova")))
              # navbarMenu("GLM",
                          #tabPanel("Poisson plot for counts", plotlyOutput("poisplot")), 
                          #tabPanel("Negbin plot for counts", plotlyOutput("nbplot")),
                          #tabPanel("Poisson summary", verbatimTextOutput("poissum")),
                          #tabPanel("Negbin summary", verbatimTextOutput("nbsum")),
                          #tabPanel("Poisson anova",verbatimTextOutput("poisanova")),
                          #tabPanel("Negbin anova",verbatimTextOutput("nbanova")))
    )
  )
))