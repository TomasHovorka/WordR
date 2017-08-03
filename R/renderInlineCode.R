#' Read Word document with R code blocks, evaluate them and writes the result into another Word document.
#'
#' @param docxIn String of length one; path to Word file with R code blocks.
#' @param docxOut String of length one; path for output Word file.
#' @param debug Boolean of length one; If True browser() is called at the beginning of the function
#' @return True if the operation was successfull.
#' @examples
#' \donttest{
#' renderInlineCode(
#'   paste(find.package("WordR"),'inst/templates/template1.docx',sep = '/'),
#'   paste(find.package("WordR"),'inst/results/result1.docx',sep = '/'))
#'   }
renderInlineCode <- function(docxIn, docxOut, debug = F) {
    if (debug) {
        browser()
    }
    doc <- ReporteRs::docx(template = docxIn)

    aaa <- ReporteRs::text_extract(doc)

    aaa2 <- paste(aaa, collapse = "", sep = "")

    starts <- gregexpr("#r[[:digit:]]* ", aaa2, fixed = F)[[1]]
    ends <- gregexpr("r#", aaa2, fixed = T)[[1]]

    expressionsPars <- matrix(c(starts, ends), ncol = 2) %>% apply(1, function(x) {
        if (x[1] >= x[2]) {
            stop("Wrong sequence of inline R code separator (ending found before beginning)!")
        }
        substr(aaa2, 2 + x[1], x[2] - 1)
    })

    rexp <- "^(\\w+)\\s?(.*)$"
    expressions <- data.frame(ID = sub(rexp, "\\1", expressionsPars), expression = sub(rexp, "\\2", expressionsPars), stringsAsFactors = F)
    if (any(duplicated(expressions$ID))) {
        stop(paste("Duplicate inline code IDs:", paste(expressions$ID[duplicated(expressions$ID)], sep = ",", collapse = ",")))
    }

    values <- sapply(expressions$expression, FUN = function(x) {
        eval(parse(text = x))
    })

    docA <- officer::read_docx(docxIn)

    for (i in seq_len(nrow(expressions))) {
        ids <- paste0("#r", expressions$ID[i])
        nfound <- grep(paste0("^", ids, " "), aaa) %>% length
        if (nfound == 0) {
            stop(paste("R Inline code chunk ID:", ids, "not found. Pls reidentificate!(retype the \"#rXXXXX[space]\")"))
        }
        if (nfound > 1) {
            stop(paste("R Inline code chunk ID:", ids, "found in multiple places. Pls check!"))
        }
        docA <- officer::cursor_reach(docA, keyword = ids) %>% officer::body_remove() %>% officer::cursor_backward() %>% officer::slip_in_text(values[i], pos = "before",
            style = "Heading 2 Char")
    }

    print(docA, target = docxOut)
    return(T)
}
