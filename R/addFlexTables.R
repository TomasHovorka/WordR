#' Read Word document with R code blocks, evaluate them and writes the result into another Word document.
#'
#' @param docxIn String of length one; path to Word file with bookmarks.
#' @param docxOut String of length one; path for output Word file.
#' @param FlexTables Named list of FlexTables; Tables to be inserted into the Word file
#' @param debug Boolean of length one; If True browser() is called at the beginning of the function
#' @param ... Parameters to be sent to other methods (mainly ReporteRs::addFlexTable)
#' @return  Path to the rendered Word file if the operation was successfull.
#' @examples
#' \donttest{
#' ft_mtcars <- vanilla.table(mtcars)
#' ft_iris <- vanilla.table(iris)
#' FT <- list(ft_mtcars=ft_mtcars,ft_iris=ft_iris)
#' addFlexTables(
#'   paste(find.package('WordR'),'examples/templates/templateFT.docx',sep = '/'),
#'   paste(find.package('WordR'),'examples/results/resultFT.docx',sep = '/'),
#'   FT)
#'   }
addFlexTables <- function(docxIn, docxOut, FlexTables = list(), debug = F, ...) {
    if (debug) {
        browser()
    }

    doc <- ReporteRs::docx(template = docxIn)

    bks <- list_bookmarks(doc) %>% grep("^t_", ., value = T) %>% gsub("^t_", "", .)
    for (bk in bks) {
        # bk<-bks[1]
        if (!bk %in% names(FlexTables)) {
            stop(paste("Table rendering: Table", bk, "not in the FlexTables list"))
        }
        doc <- ReporteRs::addFlexTable(doc, FlexTables[[bk]], bookmark = gsub("FT$", "", paste0("t_", bk)), par.properties = parProperties(text.align = "center"),
            ...)
    }


    writeDoc(doc, docxOut)
    return(docxOut)
}
