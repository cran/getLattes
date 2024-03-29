% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getEventosCongressos.R
\name{getEventosCongressos}
\alias{getEventosCongressos}
\title{getEventosCongressos}
\usage{
getEventosCongressos(curriculo)
}
\arguments{
\item{curriculo}{'Lattes' XML imported as `xml2::read_xml()`.}
}
\value{
data frame
}
\description{
Extract Events and Congresses from 'Lattes' XML file.
}
\details{
Curriculum without this information will return NULL.
}
\examples{
if(interactive()) {
 
 # to import from one curriculum 
 # curriculo <- xml2::read_xml('file.xml')
 # getEventosCongressos(curriculo)
 
 }
}
\seealso{
\code{\link[xml2]{xml_find_all}},\code{\link[xml2]{xml_attr}},\code{\link[xml2]{xml_children}}
 \code{\link[purrr]{map}},\code{\link[purrr]{map2}}
 \code{\link[dplyr]{bind}},\code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
 \code{\link[janitor]{clean_names}}
 \code{\link[tibble]{tibble}}
}
