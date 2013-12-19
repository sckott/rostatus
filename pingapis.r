library(taxize)
library(plyr)
library(treebase)
library(rgauges)
library(rebird)
library(rsnps)
library(rgbif)

timeit <- function(x){
  tm <- system.time(out <- tryCatch(x,  error = function(e) "http_error" ))[["elapsed"]]
  list(time = tm, out = out)
}
foo <- function(pkg, endpoint, exp, expectation){
  dt <- strsplit(as.character(Sys.time()), "\\s")[[1]]
  date <- dt[[1]]
  time <- dt[[2]]
  tt <- timeit(exp)
  status <- ifelse(tt$out == expectation, 1, 0)
  list(pkg=pkg, endpoint=endpoint, date=date, time=time, speed=tt$time, status=status)
}
eol <- foo(pkg="taxize", endpoint="eol", exp=eol_ping(), expectation="Success")
coflife <- foo(pkg="taxize", endpoint="coflife", exp=names(col_search(name="Apis")), expectation="Apis")
tropicos <- foo(pkg="taxize", endpoint="tropicos", exp=tp_search(name = 'Poa annua annua')[1,1], expectation=25517736)
gnr <- foo(pkg="taxize", endpoint="gnr", exp=as.character(gnr_resolve("Helianthus annuus")[1,1]), expectation="Helianthus annuus")
itis <- foo(pkg="taxize", endpoint="itis", exp=as.character(getparenttsnfromtsn(tsn = 202385)[1,1]), expectation='180543')
taxa <- c("Collomia grandiflora", "Lilium lankongense", "Helianthus annuus")
phylomatic <- foo(pkg="taxize", endpoint="phylomatic", exp=class(phylomatic_tree(taxa=taxa, get = 'POST', informat='newick',method = "phylomatic", storedtree = "smith2011",outformat = "newick", clean = "true")), expectation="phylo")
iucn <- foo(pkg="taxize", endpoint="iucn", exp=iucn_summary("Panthera uncia")$`Panthera uncia`$trend, expectation="Decreasing")
plantminer <- foo(pkg="taxize", endpoint="plantminer", exp=as.character(plantminer(c("Myrcia lingua", "Myrcia bella"))[1,1]), expectation="Myrtaceae")

ubio <- foo(pkg="taxize", endpoint="ubio", exp=as.character(ubio_classification(hierarchiesID = 2483153)$data[1,1]), expectation="84")
taxosaurus <- foo(pkg="taxize", endpoint="taxosaurus", exp=tnrs(c("Panthera tigris", "Neotamias minimus", "Magnifera indica"), source="NCBI")[1,1], expectation="Panthera tigris")

ebird <- foo(pkg="rebird", endpoint="ebird", exp=as.character(ebirdloc('L99381')[1,1]), expectation="Canada Goose")

gauges <- foo(pkg="rgauges", endpoint="gauges", exp=gs_me()$user$name, expectation="Scott Chamberlain")

rsnps <- foo(pkg="rsnps", endpoint="rsnps", exp=phenotypes(userid=1)[[1]]$name, expectation="Bastian Greshake")

treebase <- foo(pkg="treebase", endpoint="treebase", exp=class(search_treebase("2377", by="id.study")[[1]]), expectation="phylo")

rgbif <- foo(pkg="rgbif", endpoint="rgbif", exp=as.character(occ_get(key=773433533, return='data')[1,1]), expectation="Helianthus annuus L.")

out <- compact(list(eol, coflife, tropicos, gnr, itis, phylomatic, iucn, plantminer, ubio, taxosaurus, ebird, gauges, rsnps, treebase, rgbif))
df <- do.call(rbind, lapply(out, function(x) data.frame(x, stringsAsFactors=FALSE)))

require(DBI)
require(RMySQL)
drv <- dbDriver("MySQL")
con <- dbConnect(drv, username = "root", dbname = "rodb", host = "localhost")
query <- paste("INSERT INTO speedtable (pkg, endpoint, date, time, speed, status) VALUES", paste(apply(df, 1, function(x) paste("('", x[1], "','", x[2],  "','", x[3],  "','", x[4],  "','", x[5], "','", x[6], "')", sep="")), collapse=","))
dbGetQuery(con, query)
dbDisconnect(con)