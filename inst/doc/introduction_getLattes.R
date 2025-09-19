## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=F-------------------------------------------------------------------
# # install and load devtools from CRAN
# # install.packages("devtools")
# library(devtools)
# 
# # install and load getLattes
# devtools::install_github("roneyfraga/getLattes")

## ----eval=F, include=T--------------------------------------------------------
# install.packages('getLattes')

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
library(getLattes)

# support packages
library(xml2)
library(dplyr)
library(tibble)
library(purrr)

## ----eval=T, include=T--------------------------------------------------------
# find the file in system
zip_xml <- system.file('extdata/4984859173592703.zip', package = 'getLattes')

curriculo <- xml2::read_xml(zip_xml)

## ----eval=F-------------------------------------------------------------------
# getDadosGerais(curriculo)
# getAreasAtuacao(curriculo)
# getArtigosPublicados(curriculo)
# getAtuacoesProfissionais(curriculo)
# getBancasDoutorado(curriculo)
# getBancasGraduacao(curriculo)
# getBancasMestrado(curriculo)
# getCapitulosLivros(curriculo)
# getDadosGerais(curriculo)
# getEnderecoProfissional(curriculo)
# getEventosCongressos(curriculo)
# getFormacaoDoutorado(curriculo)
# getFormacaoGraduacao(curriculo)
# getFormacaoMestrado(curriculo)
# getIdiomas(curriculo)
# getLinhaPesquisa(curriculo)
# getLivrosPublicados(curriculo)
# getOrganizacaoEventos(curriculo)
# getOrientacoesDoutorado(curriculo)
# getOrientacoesMestrado(curriculo)
# getOrientacoesPosDoutorado(curriculo)
# getOutrasProducoesTecnicas(curriculo)
# getParticipacaoProjeto(curriculo)
# getPatentes()
# getProducaoTecnica(curriculo)
# getTrabalhosEmEventos()
# getId(curriculo)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
# find the files in system
zips_xmls <- c(system.file('extdata/4984859173592703.zip', package = 'getLattes'),
               system.file('extdata/3051627641386529.zip', package = 'getLattes'))

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
curriculos <- lapply(zips_xmls, read_xml)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
curriculos <- 
    purrr::map(zips_xmls, safely(read_xml)) |> 
    purrr::map(pluck, 'result') 

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
dados_gerais <- 
    purrr::map(curriculos, safely(getDadosGerais)) |>
    purrr::map(pluck, 'result') 

dados_gerais

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------

dados_gerais <- 
    purrr::map(curriculos, safely(getDadosGerais)) |>
    purrr::map(pluck, 'result') |>
    dplyr::bind_rows() 

glimpse(dados_gerais)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
artigos_publicados <- 
    purrr::map(curriculos, safely(getArtigosPublicados)) |>
    purrr::map(pluck, 'result') |>
    dplyr::bind_rows() 

artigos_publicados |>
    dplyr::arrange(desc(ano_do_artigo)) |>
    dplyr::select(titulo_do_artigo, ano_do_artigo, titulo_do_periodico_ou_revista) 

livros_publicados <- 
    purrr::map(curriculos, safely(getLivrosPublicados)) |>
    purrr::map(pluck, 'result') |>
    dplyr::bind_rows() 

capitulos_livros <- 
    purrr::map(curriculos, safely(getCapitulosLivros)) |>
    purrr::map(pluck, 'result') |>
    dplyr::bind_rows() 

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------

artigos_publicados2 <- 
    dplyr::group_by(artigos_publicados, id) |>
    dplyr::tally(name = 'artigos') 

artigos_publicados2

livros_publicados2 <- 
    dplyr::group_by(livros_publicados, id) |>
    dplyr::tally(name = 'livros') 

livros_publicados2

capitulos_livros2 <- 
    dplyr::group_by(capitulos_livros, id) |>
    dplyr::tally(name = 'capitulos') 

capitulos_livros2

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------

artigos_publicados2 |>
    dplyr::left_join(livros_publicados2) |>
    dplyr::left_join(capitulos_livros2)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------

artigos_publicados2 |>
    dplyr::left_join(livros_publicados2) |>
    dplyr::left_join(capitulos_livros2) |>
    dplyr::left_join(dados_gerais |> dplyr::select(id, nome_completo)) |>
    dplyr::select(nome_completo, artigos, livros, capitulos) 

## ----eval=F, echo=T, warning=FALSE, message=FALSE-----------------------------
# 
# writePublicationsRis(artigos_publicados,
#                      filename = '~/Desktop/artigos_nome_citacao.ris',
#                      citationName = T,
#                      append = F,
#                      tableLattes = 'ArtigosPublicados')
# 
# # full author name, ex: Antonio Marcio Buainain
# writePublicationsRis(artigos_publicados,
#                      filename = '~/Desktop/artigos_nome_completo.ris',
#                      citationName = F,
#                      append = F,
#                      tableLattes = 'ArtigosPublicados')
# 
# writePublicationsRis(livros_publicados,
#                filename = '~/Desktop/livros.ris',
#                append = F,
#                citationName = T,
#                tableLattes = 'Livros')
# 
# writePublicationsRis(capitulos_livros,
#                      filename = '~/Desktop/capitulos_livros.ris',
#                      append = T,
#                      citationName = F,
#                      tableLattes = 'CapitulosLivros')
# 

