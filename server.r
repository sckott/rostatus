require(shiny)
require(rCharts)
require(ggplot2)
require(scales)
require(DBI)
require(RMySQL)
require(lubridate)
require(reshape2)

# Set custon theme
theme_none <- function(){
  list(
    theme_bw(base_size=18),
       theme(panel.border = element_blank(),
             axis.line = element_line(colour="grey"),
             panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             axis.ticks = element_blank(),
             axis.text = element_text(colour="grey")))
}

shinyServer(function(input, output, session) {
  drv <- dbDriver("MySQL")
  con <- dbConnect(drv, username = "root", dbname = "rodb", host = "localhost")
  
  readTimestamp <- function(){
    dbGetQuery(con, 'select max(time) from speedtable')[[1]]
  }
  
  readValues <- function(){
    tmp <- dbGetQuery(con, "select * from speedtable order by time desc limit 500")
    transform(tmp, datetime = paste(date, time, sep=" "))
  }
  
  data <- reactivePoll(60000, session, readTimestamp, readValues)
  
  # function to create chart for the UI
  doo_speed <- function(label){
    renderChart({
      df <- data()
      label2 <- strsplit(label, "_")[[1]][[1]]
      df <- df[df$endpoint == label2, c('datetime','speed')]
      m2 <- mPlot(x = "datetime", y = "speed", type = "Line", data = df)
      m2$set(pointSize = 3, lineWidth = 1, hideHover = 'auto')
      m2$addParams(dom = label)
      return(m2)
    })
  }
  doo_status <- function(label){
    renderChart({
      df <- data()
      label2 <- strsplit(label, "_")[[1]][[1]]
      df <- df[df$endpoint == label2, c('datetime','status')]
      m2 <- mPlot(x = "datetime", y = "status", type = "Line", data = df)
      m2$set(pointSize = 3, lineWidth = 1, hideHover = 'auto', ymin=0, ymax=1)
      m2$addParams(dom = label)
      return( m2 )
    })
  }

  get_speed_data <- function(label){
    df <- data()
    label2 <- strsplit(label, "_")[[1]][[1]]
    df <- df[df$endpoint == label2, c('datetime','speed')]
    df$datetime <- ymd_hms(as.character(df$datetime))
    df$speed <- as.numeric(df$speed)
    return( df )
  }

  doo_speed_gg <- function(label){
    renderPlot({
      df <- get_speed_data(label)
      m2 <- ggplot(df, aes(datetime, speed)) +
        theme_none() +
        # geom_point() +
        geom_line(size=1.5) +
        expand_limits(y=0) +
        scale_x_datetime(breaks = date_breaks(width="10 min"),
                         labels = date_format("%H:%M")) +
        labs(x="", y="")
      print( m2 )
    }, width = 400, height = 200)
  }
  
  doo_status_gg <- function(label){
    renderPlot({
      df <- data()
      label2 <- strsplit(label, "_")[[1]][[1]]
      df <- df[df$endpoint == label2, c('datetime','status')]
      df$datetime <- ymd_hms(as.character(df$datetime))
      m2 <- ggplot(df, aes(datetime, status)) +
        theme_none() +
        # geom_point() +
        geom_line(size=1.5) +
        scale_y_continuous(limits=c(0,1), breaks=c(0,1)) +
        scale_x_datetime(breaks = date_breaks(width="10 min"),
                         labels = date_format("%H:%M")) +
        labs(x="", y="")
      print( m2 )
    }, width = 400, height = 200)
  }
  
  
  output$eol_speed <- doo_speed_gg("eol_speed")
  output$eol_status <- doo_status_gg("eol_status")
  output$coflife_speed <- doo_speed_gg("coflife_speed")
  output$coflife_status <- doo_status_gg("coflife_status")
  output$tropicos_speed <- doo_speed_gg("tropicos_speed")
  output$tropicos_status <- doo_status_gg("tropicos_status")
  output$gnr_speed <- doo_speed_gg("gnr_speed")
  output$gnr_status <- doo_status_gg("gnr_status")
  output$itis_speed <- doo_speed_gg("itis_speed")
  output$itis_status <- doo_status_gg("itis_status")
  output$phylomatic_speed <- doo_speed_gg("phylomatic_speed")
  output$phylomatic_status <- doo_status_gg("phylomatic_status")
  output$iucn_speed <- doo_speed_gg("iucn_speed")
  output$iucn_status <- doo_status_gg("iucn_status")
  output$plantminer_speed <- doo_speed_gg("plantminer_speed")
  output$plantminer_status <- doo_status_gg("plantminer_status")
  
  output$ubio_speed <- doo_speed_gg("ubio_speed")
  output$ubio_status <- doo_status_gg("ubio_status")
  output$taxosaurus_speed <- doo_speed_gg("taxosaurus_speed")
  output$taxosaurus_status <- doo_status_gg("taxosaurus_status")
  output$ebird_speed <- doo_speed_gg("ebird_speed")
  output$ebird_status <- doo_status_gg("ebird_status")
  output$gauges_speed <- doo_speed_gg("gauges_speed")
  output$gauges_status <- doo_status_gg("gauges_status")
  output$rsnps_speed <- doo_speed_gg("rsnps_speed")
  output$rsnps_status <- doo_status_gg("rsnps_status")
  output$treebase_speed <- doo_speed_gg("treebase_speed")
  output$treebase_status <- doo_status_gg("treebase_status")
  output$rgbif_speed <- doo_speed_gg("rgbif_speed")
  output$rgbif_status <- doo_status_gg("rgbif_status")

  makelabel <- function(x, y){
    paste(sprintf('<a href="%s" target="_blank" class="label label-info">', y), x, "</a>", sep="")
  }  
  
  output$eoltitle <- renderText({makelabel("EOL", "http://eol.org/api")})
  output$coflifetitle <- renderText({makelabel("COL", "http://www.catalogueoflife.org/colwebsite/content/web-services")})
  output$tropicostitle <- renderText({makelabel("Tropicos", "http://services.tropicos.org/help")})
  output$gnrtitle <- renderText({makelabel("GNR", "http://resolver.globalnames.org/api")})
  output$itistitle <- renderText({makelabel("ITIS", "http://www.itis.gov/ws_description.html")})
  output$phylomatictitle <- renderText({makelabel("Phylomatic", "http://phylodiversity.net/phylomatic/")})
  output$iucntitle <- renderText({makelabel("IUCN", "https://www.assembla.com/spaces/sis/wiki/Red_List_API?version=3")})
  output$plantminertitle <- renderText({makelabel("Plantminer", "http://www.plantminer.com/help")})
  output$ubiotitle <- renderText({makelabel("uBio", "http://www.ubio.org/index.php?pagename=xml_services")})
  output$taxosaurustitle <- renderText({makelabel("Taxosaurus", "http://taxosaurus.org/")})
  output$ebirdtitle <- renderText({makelabel("eBird", "https://confluence.cornell.edu/display/CLOISAPI/eBird+API+1.1")})
  output$gaugestitle <- renderText({makelabel("Gaug.es", "http://get.gaug.es/documentation/")})
  output$rsnspstitle <- renderText({makelabel("openSNP", "http://opensnp.org/faq#api")})
  output$treebasetitle <- renderText({makelabel("Treebase", "https://www.nescent.org/wg/evoinfo/index.php?title=PhyloWS")})
  output$rgbiftitle <- renderText({makelabel("GBIF", "http://www.gbif.org/developer/summary")})
  output$blank <- renderText({""})
})