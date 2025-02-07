# packages ---------------------------------------------------------------------
library(purrr)
library(dplyr)
library(here)
library(readr)
library(scoringutils)
library(rmarkdown)
library(data.table)
library(covidHubUtils)
library(lubridate)

options(knitr.duplicate.label = "allow")

report_date <- lubridate::floor_date(lubridate::today(), 'week', week_start = 1)

locations <- hub_locations_ecdc

dir.create(here::here("html"))

for (i in 1:nrow(hub_locations_ecdc)) {
  country_code <- hub_locations_ecdc$location[i]
  country <- hub_locations_ecdc$location_name[i]

  rmarkdown::render(here::here("reports", "evaluation", "evaluation-by-country.Rmd"),
                    output_format = "html_document",
                    params = list(location_code = country_code,
                                  location_name = country,
                                  report_date = report_date),
                    output_file =
                      here::here("html", paste0("evaluation-report-", report_date,
                                                "-", country, ".html")),
                    envir = new.env())
}

rmarkdown::render(here::here("reports", "evaluation", "evaluation-report.Rmd"),
                  params = list(report_date = report_date),
                  output_format = "html_document",
                  output_file =
                    here::here("html", paste0("evaluation-report-", report_date, "-Overall.html")),
                  envir = new.env())

## to make this generalisable
# allow bits to be turned off and on
# somehow pass down the filtering
