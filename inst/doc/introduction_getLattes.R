## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=F-------------------------------------------------------------------
#  
#  # install and load devtools from CRAN
#  # install.packages("devtools")
#  library(devtools)
#  
#  # install and load getLattes
#  devtools::install_github("roneyfraga/getLattes")

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
library(getLattes)

# support packages
library(xml2)
library(dplyr)
library(tibble)
library(purrr)

## ----eval = F, echo = F, include=F--------------------------------------------
#  # esse executo para testar meu código
#  # o próximo chunk é só para aparecer o código no html
#  curriculo <- xml2::read_xml('inst/extdata/4984859173592703.zip')

## ----eval=T, include=T--------------------------------------------------------
curriculo <- xml2::read_xml('../inst/extdata/4984859173592703.zip')

## ----eval=F-------------------------------------------------------------------
#  getDadosGerais(curriculo)
#  getArtigosPublicados(curriculo)
#  getAreasAtuacao(curriculo)
#  getArtigosPublicados(curriculo)
#  getAtuacoesProfissionais(curriculo)
#  getBancasDoutorado(curriculo)
#  getBancasGraduacao(curriculo)
#  getBancasMestrado(curriculo)
#  getCapitulosLivros(curriculo)
#  getDadosGerais(curriculo)
#  getEnderecoProfissional(curriculo)
#  getEventosCongressos(curriculo)
#  getFormacaoDoutorado(curriculo)
#  getFormacaoMestrado(curriculo)
#  getFormacaoGraduacao(curriculo)
#  getIdiomas(curriculo)
#  getLinhaPesquisa(curriculo)
#  getLivrosPublicados(curriculo)
#  getOrganizacaoEventos(curriculo)
#  getOrientacoesDoutorado(curriculo)
#  getOrientacoesMestrado(curriculo)
#  getOrientacoesPosDoutorado(curriculo)
#  getOutrasProducoesTecnicas(curriculo)
#  getParticipacaoProjeto(curriculo)
#  getProducaoTecnica(curriculo)
#  getId(curriculo)

## ----eval = F, echo = F, include=F--------------------------------------------
#  # esse executo para testar meu código
#  # o próximo chunk é só para aparecer o código no html
#  files <- list.files(path = 'inst/extdata/', pattern = '*.xml|*.zip', full.names = T)
#  system.file("extdata", "4984859173592703.zip", package = "getLattes")

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
files <- list.files(path = '../inst/extdata/', pattern = '*.xml|*.zip', full.names = T)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
curriculos <- lapply(files, read_xml)

## ----eval=T, warning=FALSE, message=FALSE-------------------------------------
curriculos <- 
    purrr::map(files, safely(read_xml)) |> 
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

