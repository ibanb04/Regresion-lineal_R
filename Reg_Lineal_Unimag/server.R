library(shiny)
library(ggplot2)
library(xtable)
library(plotly)
library(MASS)
library(Hmisc)


shinyServer(function(input, output) {
  
  Dataset <- reactive({
    if (is.null(input$file)) {
     
      # si el usuario no ha subido el archivo
      return(NULL)
    }
    #captura la tabla de datos
    Dataset <-as.data.frame(read.csv(input$file$datapath))
    return(Dataset)
  })
  
  varnames<-reactive({names(Dataset())})
  #retorna el modelo lineal
  linearmodel<-reactive({
    x<-input$X
    y<-input$Y
    datos<-Dataset()
    tx<-sprintf("mod<-lm(data=datos,%s~%s)",y,x,x)
    eval(parse(text=tx))
    return(mod)
  })
  #modelo cuadratics
  quadmodel<-reactive({
    x<-input$X
    y<-input$Y
    datos<-Dataset()
   
    tx<-sprintf("mod<-lm(data=datos,%s~%s+I(%s^2))",y,x,x)
    eval(parse(text=tx))
    return(mod)
  })
  
 
  #funcion reactiva
  ggstart<-reactive({
    x<-input$X
    y<-input$Y
    datos<-Dataset()
    tx<-sprintf("g0<-ggplot(data=datos,aes(x=%s,y=%s))",x,y)
    eval(parse(text=tx))
    return(g0)
  })
  #muestra la tabla de datos
  output$table <- renderDataTable(Dataset())
  #grafica de la linea recta
  output$lplot <- renderPlotly({
    g0<-ggstart()
    g1<-g0+geom_point() + geom_smooth(method=lm)+theme_bw()
    ggplotly(g1)
  })
  
  #grafica de la linea recta para funcion Quadratics
  output$qplot <- renderPlotly({
    g0<-ggstart()
    g1<-g0+geom_point() + geom_smooth(method="lm",formula=y~x+I(x^2), se=TRUE) +theme_bw()
    ggplotly(g1)
  })
  #grafico de los diagnosticos y los supuestos
  output$dplot <- renderPlot({
    mod<-linearmodel()
    par(mfcol=c(2,2))
    plot(mod)
  })
  #summary de la regresion
  output$sumtable <- renderText({
    mod<-linearmodel()
    a<-summary(mod)
    output$sum<-renderPrint(a)
    print(xtable(a),type="html")
    
  } )
  #para pintar la anova
  output$anova<-renderPrint(anova(linearmodel()))
  #hace quadratic summary
  output$quadsum<-renderPrint(
    {
      mod<-quadmodel()
      summary(mod)
    })
  #mostrar quadratic anova
  output$quadanova<-renderPrint(
    {
      mod<-quadmodel()
      anova(mod)
    })
  
  #hace la tabla anova  
  output$antable <- renderText({
    mod<-linearmodel()
    a<-anova(mod)
    print(xtable(a),type="html")
    
  } )
  
  #hace el modelo lineal
  output$sumtext <- renderText({
    x<-input$X
    y<-input$Y
    mod<-linearmodel()
    a<-summary(mod)
    int<-round(coef(mod)[1],4)
    slope<-round(coef(mod)[2],4)
    rsq<-round(a$r.squared,3)
    sprintf("La linea de regresion es: %s = %s + %s %s -con un valor r cuadrado de %s",y,int,slope,x,rsq)
    
  } )
  
  output$X <- renderUI({ 
    selectInput("X", "Seleccione la variable independiente", varnames())
  })
  output$Y <- renderUI({ 
    selectInput("Y", "Seleccione la variable dependiente", varnames(),selected=varnames()[2])
  })
  
  
})