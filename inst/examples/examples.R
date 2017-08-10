library(officer)
library(dplyr)

#listing available styles
styles_info(read_docx(paste(find.package("WordR"),'examples/templates/template1.docx',sep = '/'))) %>%
  filter(style_type=="character") %>% select(style_name)

#rendering inline code example
renderInlineCode(
     paste(find.package("WordR"),'examples/templates/template1.docx',sep = '/'),
     paste(find.package("WordR"),'examples/results/result1.docx',sep = '/'),debug=F)

#adding Flex Tables example
library(ReporteRs)
ft_mtcars <- vanilla.table(mtcars)
ft_iris <- vanilla.table(iris)
FT<-list(ft_mtcars=ft_mtcars,ft_iris=ft_iris)
addFlexTables(
 paste(find.package('WordR'),'examples/templates/templateFT.docx',sep = '/'),
 paste(find.package('WordR'),'examples/results/resultFT.docx',sep = '/'),
 FT)
