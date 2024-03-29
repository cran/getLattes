% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getPatentes.R
\name{getPatentes}
\alias{getPatentes}
\title{getPatentes}
\usage{
getPatentes(curriculo)
}
\arguments{
\item{curriculo}{'Lattes' XML imported as `xml2::read_xml()`.}
}
\value{
data frame
}
\description{
Extract Patent data from 'Lattes' XML file.
}
\details{
Curriculum without this information will return NULL.
}
\examples{
if(interactive()) {
 
 # to import from one curriculum 
 # curriculo <- xml2::read_xml('file.xml')
 # getPatentes(curriculo)

 }
}
\seealso{
\code{\link[xml2]{xml_find_all}},\code{\link[xml2]{xml_attr}}
 \code{\link[dplyr]{bind}},\code{\link[dplyr]{distinct}},\code{\link[dplyr]{mutate}}
 \code{\link[janitor]{clean_names}}
}
