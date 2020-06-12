## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=F-------------------------------------------------------------------
#  # install and load devtools from CRAN
#  install.packages("devtools")
#  library(devtools)
#  
#  # install and load getLattes
#  devtools::install_github("roneyfraga/getLattes")

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
library(getLattes)

# support packages
library(dplyr)
library(tibble)
library(pipeR)

## ----eval=F, echo=F-----------------------------------------------------------
#  # delete '*.xml$' in datatet
#  # setwd('~/OneDrive/Rworkspace/getLattes/datatest')
#  # file.remove(list.files(pattern='*.xml$'))
#  # setwd('~/OneDrive/Rworkspace/getLattes')

## ----eval=F, warning=FALSE, message=FALSE-------------------------------------
#  
#  # the zip file(s) (is)are stored in datatest/
#  # unzipLattes(filezip='2854855744345507.zip', path='datatest/')
#  # unzipLattes(filezip='*.zip', path='datatest/')
#  
#  # the zip files are stored in the working directory
#  unzipLattes(filezip='*.zip')

## ----eval=F, include=T--------------------------------------------------------
#  
#  # the file 4984859173592703.xml
#  # cl <- readLattes(filexml='4984859173592703.xml', path='datatest/')
#  
#  # import several files
#  # cls <- readLattes(filexml='*.xml$', path='datatest/')
#  
#  # import xml files from working directory
#  cls <- readLattes(filexml='*.xml$')

## ----eval=T-------------------------------------------------------------------
data(xmlsLattes)
length(xmlsLattes)
names(xmlsLattes[[1]])

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
# to import from one curriculum 
getDadosGerais(xmlsLattes[[1]])

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lt <- lapply(xmlsLattes, getDadosGerais) 
lt <- bind_rows(lt)
glimpse(lt)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getDadosGerais) %>>% 
    bind_rows %>>% 
    glimpse

## ----eval=T-------------------------------------------------------------------
lapply(xmlsLattes, getDadosGerais) %>>% 
    bind_rows %>>% 
    (. -> res)

glimpse(res)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getOrientacoesDoutorado) %>>% 
    bind_rows %>>% 
    glimpse()

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getOrientacoesMestrado) %>>% 
    bind_rows %>>% 
    glimpse()

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getOrientacoesPosDoutorado) %>>% 
    bind_rows %>>% 
    glimpse()

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getOrientacoesOutras) %>>% 
    bind_rows %>>% 
    glimpse()

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getArtigosPublicados) %>>% 
    bind_rows %>>% 
    as_tibble %>>% 
    (. -> pub)

glimpse(pub)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
# use explict arguments
normalizeByDoi( pub, doi='doi', year='ano.do.artigo', issn='issn', paperTitle='titulo.do.artigo', journalName='titulo.do.periodico.ou.revista')

# use de defult data frame from getArtigosPublicados
normalizeByDoi(pub)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
# use explict arguments
nj <- normalizeJournals(pub, issn='issn', journalName='titulo.do.periodico.ou.revista')

# use de defult data frame from getArtigosPublicados
nj <- normalizeJournals(pub)

nj %>>% 
    select(issn_old, issn, titulo.do.periodico.ou.revista_old, titulo.do.periodico.ou.revista) %>>% 
    tail

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------

# use explict arguments
ny <- normalizeYears(pub, year2normalize='ano.do.artigo',issn='issn',journalName='titulo.do.periodico.ou.revista',paperTitle='titulo.do.artigo')

# use de defult variables names from getArtigosPublicados
ny <- normalizeYears(pub)

ny %>>% 
    select(ano_old, ano, issn, titulo.do.periodico.ou.revista, titulo.do.artigo) %>>% 
    head

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getArtigosPublicados) %>>% 
    bind_rows %>>% 
    as_tibble %>>% 
    normalizeByDoi %>>% 
    normalizeJournals %>>% 
    normalizeYears %>>% 
    select(titulo.do.artigo,ano.do.artigo,issn,titulo.do.periodico.ou.revista,id) %>>% 
    slice(1:10)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
lapply(xmlsLattes, getArtigosPublicados) %>>% 
    bind_rows %>>% 
    as_tibble %>>% 
    normalizeByDoi %>>% 
    normalizeJournals %>>% 
    normalizeYears %>>% 
    select(titulo.do.artigo,ano.do.artigo,issn,titulo.do.periodico.ou.revista,id) %>>% 
    left_join( lapply(xmlsLattes, getDadosGerais) %>>% bind_rows %>>% select(id,nome.completo,pais.de.nascimento)) %>>%   
    slice(1:10)

