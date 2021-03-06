% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getOutrasProducoesBibliograficas.R
\name{getOutrasProducoesBibliograficas}
\alias{getOutrasProducoesBibliograficas}
\title{getOutrasProducoesBibliograficas}
\usage{
getOutrasProducoesBibliograficas(curriculo)
}
\arguments{
\item{curriculo}{XML exported from Lattes imported to R as list.}
}
\value{
data frame
}
\description{
Extract Other Bibliographic Productions from XML file converted to R list.
}
\details{
Curriculum without this information will return NULL.
}
\examples{
if(interactive()){
 data(xmlsLattes)
 # to import from one curriculum 
 getOutrasProducoesBibliograficas(xmlsLattes[[2]])

 # to import from two or more curricula
 lt <- lapply(xmlsLattes, getOutrasProducoesBibliograficas)
 head(bind_rows(lt))
 }
}
