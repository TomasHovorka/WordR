#' Read Word document with R code blocks, evaluate them and writes the result into another Word document.
#'
#' @param docxIn String of length one; path to Word file with R code blocks.
#' @param docxOut String of length one; path for output Word file.
#' @param defaultStyle String of length one or NA; Default style for inserted text
#' @param debug Boolean of length one; If True browser() is called at the beginning of the function
#' @return Path to the rendered Word file if the operation was successfull.
#' @examples
#' \donttest{
#' renderInlineCode(
#'   paste(find.package('WordR'),'examples/templates/template1.docx',sep = '/'),
#'   paste(find.package('WordR'),'examples/results/result1.docx',sep = '/'))
#'   }
renderInlineCode <- function(docxIn, docxOut, defaultStyle = NA, debug = F) {
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
    expressions <- data.frame(ID = sub(rexp, "\\1", expressionsPars), expression2 = sub(rexp, "\\2", expressionsPars), stringsAsFactors = F)
    expressions$expression <- sub("@[{].*[}]$", "\\1", expressions$expression2)
    expressions$style <- sub("(.*)[}]", "\\1", sub("^.*@[{]", "", expressions$expression2))
    expressions$style <- ifelse(expressions$style == expressions$expression2, defaultStyle[1], expressions$style)
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
            style = switch(is.na(expressions$style[i]), NULL, expressions$style[i]))
    }
    
    print(docA, target = docxOut)
    return(docxOut)
}