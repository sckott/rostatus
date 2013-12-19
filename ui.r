require(shiny)
require(rCharts)

width <- "400px"
height <- "120px"
classleft <- 'span5'
classright <- 'span5 offset1'

shinyUI(
  bootstrapPage(
    HTML('<style type="text/css">
          .hero-unit{
            padding: 10px;
            float: none;
            margin: auto;
          }

          .row-fluid .span5{height: 130px;}
          .row-fluid:after{height: 30px;}

          .span8 {
            width: 770px;
            float: none;
            margin: 0 auto;
          }
          </style>
    '),
    HTML('<div class="container">
            <header class="span10 hero-unit" align="center" height="100">
              <h1>rOpenSci <font color="green">Status</font></h1>
            </header>
        <body>
    '),
    
    mainPanel(
      HTML('<br>
            <div class="span8">
            <font color="grey"><p>This site monitors the status of all the web APIs we work with. The left-hand graphs show 
            speed of the API call, and the right-hand graphs show whether (1) or not (0) the result
            of the call matches what is expected</p></font>
            </div>'),
      
      HTML('
        <br>
        <div class="alert alert-success">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            Made with Shiny, from RStudio.
        </div>
      '),
      
      HTML('
        <div class="subnav">
        <ul class="nav nav-pills">
          <li><a href="#eol">EOL</a></li>
          <li><a href="#col">CofLife</a></li>
          <li><a href="#tropicos">Tropicos</a></li>
          <li><a href="#gnr">GNR</a></li>
          <li><a href="#itis">ITIS</a></li>
          <li><a href="#phylomatic">Phylomatic</a></li>
          <li><a href="#iucn">IUCN</a></li>
          <li><a href="#plantminer">Plantminer</a></li>
          <li><a href="#ubio">uBio</a></li>
          <li><a href="#taxosaurus">Taxosaurus</a></li>
          <li><a href="#ebird">eBird</a></li>
          <li><a href="#gagues">Gaug.es</a></li>
          <li><a href="#rsnps">openSNP</a></li>
          <li><a href="#treebase">Treebase</a></li>
          <li><a href="#gbif">GBIF</a></li>
        </ul>
        </div>
      '),
      
      div(class='row-fluid',
          div(textOutput('blank')),
          div(class='span3 offset2', HTML("<h2>Speed</h2>")),
          div(class='span3 offset3', HTML("<h2>Status</h2>"))),
      
      div(class='row-fluid', id="eol",
          div(htmlOutput('eoltitle')),
          div(class=classleft, plotOutput('eol_speed')),
          div(class=classright, plotOutput('eol_status'))),
      div(class='row-fluid', id="col",
          div(htmlOutput('coflifetitle')),
          div(class=classleft, plotOutput('coflife_speed')),
          div(class=classright, plotOutput('coflife_status'))),
      div(class='row-fluid',id="tropicos",
          div(htmlOutput('tropicostitle')),
          div(class=classleft, plotOutput('tropicos_speed')),
          div(class=classright, plotOutput('tropicos_status'))),
      div(class='row-fluid',id="gnr",
          div(htmlOutput('gnrtitle')),
          div(class=classleft, plotOutput('gnr_speed')),
          div(class=classright, plotOutput('gnr_status'))),
      div(class='row-fluid',id="itis",
          div(htmlOutput('itistitle')),
          div(class=classleft, plotOutput('itis_speed')),
          div(class=classright, plotOutput('itis_status'))),
      div(class='row-fluid',id="phylomatic",
          div(htmlOutput('phylomatictitle')),
          div(class=classleft, plotOutput('phylomatic_speed')),
          div(class=classright, plotOutput('phylomatic_status'))),
      div(class='row-fluid',id="iucn",
          div(htmlOutput('iucntitle')),
          div(class=classleft, plotOutput('iucn_speed')),
          div(class=classright, plotOutput('iucn_status'))),
      div(class='row-fluid',id="plantminer",
          div(htmlOutput('plantminertitle')),
          div(class=classleft, plotOutput('plantminer_speed')),
          div(class=classright, plotOutput('plantminer_status'))),
      
      div(class='row-fluid',id="ubio",
          div(htmlOutput('ubiotitle')),
          div(class=classleft, plotOutput('ubio_speed')),
          div(class=classright, plotOutput('ubio_status'))),
      div(class='row-fluid',id="taxosaurus",
          div(htmlOutput('taxosaurustitle')),
          div(class=classleft, plotOutput('taxosaurus_speed')),
          div(class=classright, plotOutput('taxosaurus_status'))),
      div(class='row-fluid',id="ebird",
          div(htmlOutput('ebirdtitle')),
          div(class=classleft, plotOutput('ebird_speed')),
          div(class=classright, plotOutput('ebird_status'))),
      div(class='row-fluid',id="gauges",
          div(htmlOutput('gaugestitle')),
          div(class=classleft, plotOutput('gauges_speed')),
          div(class=classright, plotOutput('gauges_status'))),
      div(class='row-fluid',id="rsnps",
          div(htmlOutput('rsnspstitle')),
          div(class=classleft, plotOutput('rsnps_speed')),
          div(class=classright, plotOutput('rsnps_status'))),
      div(class='row-fluid',id="treebase",
          div(htmlOutput('treebasetitle')),
          div(class=classleft, plotOutput('treebase_speed')),
          div(class=classright, plotOutput('treebase_status'))),
      div(class='row-fluid',id="gbif",
          div(htmlOutput('rgbiftitle')),
          div(class=classleft, plotOutput('rgbif_speed')),
          div(class=classright, plotOutput('rgbif_status')))
    ),
    
    HTML('</body> </div>')
))