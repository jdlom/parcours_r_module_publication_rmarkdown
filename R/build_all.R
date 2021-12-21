# source
source("R/screenshot_share_image.R")

#genere le site distill
rmarkdown::render_site(encoding = 'UTF-8')


#genere le document de reference en pdf
bookdown::render_book(
  input = "book_source",
  output_format = 'pagedown::html_paged',
  output_file = '../_pagedown_index.html'
)
pagedown::chrome_print(
  '_pagedown_index.html',
  output = 'book.pdf',
  extra_args = c("--no-sandbox")
)

#genere le document de reference
bookdown::render_book(input = "book_source", output_dir = "../book")



#genere vignette slides
purrr::map(
  list.files(path = "slides", pattern = ".Rmd"),
  ~ screenshot_share_image(
    fs::path("slides", .x),
    path_image = fs::path("slides",
                          "www",
                          fs::path_ext_set(
                            paste0(fs::path_ext_remove(.x), "-card"),
                            "png"
                          ))
  )
)

#genere les slides
purrr::map(
  list.files(
    path = "slides",
    pattern = ".Rmd",
    full.names = TRUE
  ),
  ~ rmarkdown::render(.x)
)



#bug 
#generer le site distill à la fin ne fonctionne pas
# on copie enfin le book et slide dans le repertoire docs
fs::file_copy("book.pdf", "book/M6_publications_reproductibles_Rmarkdown.pdf")
fs::dir_copy("book", "docs/book")
fs::dir_copy("slides", "docs/slides")



