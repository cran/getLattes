#' @title getOutrasProducoesBibliograficas
#' @description Extract Other Bibliographic Productions from XML file converted to R list.
#' @param curriculo XML exported from Lattes imported to R as list.
#' @return data frame 
#' @details Curriculum without this information will return NULL. 
#' @examples 
#' if(interactive()){
#'  data(xmlsLattes)
#'  # to import from one curriculum 
#'  getOutrasProducoesBibliograficas(xmlsLattes[[2]])
#'
#'  # to import from two or more curricula
#'  lt <- lapply(xmlsLattes, getOutrasProducoesBibliograficas)
#'  head(bind_rows(lt))
#'  }
#' @rdname getOutrasProducoesBibliograficas
#' @export 
getOutrasProducoesBibliograficas <- function(curriculo){

  #print(curriculo$id)

  ll <- curriculo$`PRODUCAO-BIBLIOGRAFICA`
  nm <- names(ll)
  encontro <- FALSE

  if(any( nm %in% 'DEMAIS-TIPOS-DE-PRODUCAO-BIBLIOGRAFICA')){
    ll2 <- ll$`DEMAIS-TIPOS-DE-PRODUCAO-BIBLIOGRAFICA`
    nmll2 <- names(ll2)
    if(any( nmll2 %in% 'OUTRA-PRODUCAO-BIBLIOGRAFICA')){

      tnmll2 <- length(nmll2)
      if(tnmll2 > 0){
        testelista <- list()

        ll3 <- lapply(ll2, function(x){

          if(any( names(x) %in% 'DADOS-BASICOS-DE-OUTRA-PRODUCAO')){


            ll4 <- bind_cols(getCharacter(x$`DADOS-BASICOS-DE-OUTRA-PRODUCAO`) ,

                             if(any(names(x) %in% 'DETALHAMENTO-DE-OUTRA-PRODUCAO')){
                               if(length(x$`DETALHAMENTO-DE-OUTRA-PRODUCAO`) != 0){
                                 getCharacter(x$`DETALHAMENTO-DE-OUTRA-PRODUCAO`)
                               }
                             }
            )

            a <- which(names(x) == "AUTORES" )

            autores <- lapply(a, function(z){ getCharacter(x[[z]])  })

            autores1 <- data.frame(autores = "", autores.citacoes ="", autores.id="")

            for(i in 1:length(autores)){
              if (i == 1){
                autores1$autores <- paste0(autores[[i]]$nome.completo)
                autores1$autores.citacoes<- paste0(autores[[i]]$nome.para.citacao)
                if (any(names(autores[[i]]) %in% "nro.id.cnpq")){
                  if (autores[[i]]$nro.id.cnpq == ""){
                    autores1$autores.id <- paste0("No.id")
                  }else{
                    autores1$autores.id <- paste0(autores[[i]]$nro.id.cnpq)
                  }
                }else{
                  autores1$autores.id <- paste0("No.id")
                }
              }else{
                autores1$autores <- paste0(autores1$autores, ", " , autores[[i]]$nome.completo)
                autores1$autores.citacoes <- paste0(autores1$autores.citacoes, "/ " , autores[[i]]$nome.para.citacao)
                if (any(names(autores[[i]]) %in% "nro.id.cnpq")){
                  if (autores[[i]]$nro.id.cnpq == ""){
                    autores1$autores.id <- paste0(autores1$autores.id, ", " , "No.id")
                  }else{
                    autores1$autores.id <- paste0(autores1$autores.id, ", " , autores[[i]]$nro.id.cnpq)
                  }
                }else{
                  autores1$autores.id <- paste0(autores1$autores.id, ", " , "No.id")
                }
              }
            }

            id1 <-  getCharacter(curriculo$id)
            names(id1) <- "id"
            ll6 <- bind_cols(ll4,autores1,id1)

          }
        })

        if(length(ll3) > 1 || length(ll3)  == 1  ){
          ll3 <- bind_rows(ll3)
        }

      }

      return(ll3)

    }else{
      ll3 <- NULL
      return(ll3)
    } #AQUI
  }else{
    ll3 <- NULL
    return(ll3)
  }


}
