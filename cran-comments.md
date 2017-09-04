## Test environments
* local Win 7, R 3.3.1
* win-builder (devel)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:


>** running examples for arch 'x64' ... [11s] NOTE  
>Examples with CPU or elapsed time > 10s   
>user system elapsed   
>addFlexTables 16.57 2.71 7.77   

Communication from previous submission:

> Hi, 
> output from running the example on my laptop: 
> system.time({ 
> + library(ReporteRs) 
> + ft_mtcars - vanilla.table(mtcars) 
> + ft_iris - vanilla.table(iris) 
> + FT - list(ft_mtcars = ft_mtcars, ft_iris = ft_iris) 
> + addFlexTables(paste(examplePath(), "templates/templateFT.docx", sep = ""), 
> paste(examplePath(), "results/resultFT.docx", sep = ""), FT) 
> + }) 
> Loading required package: ReporteRsjars  
> user system elapsed  
> 14.39 2.64 9.78  
> 
> and when I was running the check on winbuilder: 
> 
> 
>> Examples with CPU or elapsed time > 10s  
>> user system elapsed  
>> addFlexTables 17.83 2.84 9.12  
> 
> 
> 
> 
> I am not initiating using multiple cores in my code. I am also not aware 
> that package ReportRs which is used in the example would be doing it either. 
> So I do not have any good explanation. 
> 
> t 
> 
> 
> 
> 
> ---------- Původní e-mail ---------- 
> Od: Uwe Ligges <ligges@statistik.tu-dortmund.de> 
> Komu: Tomáš Hovorka <TomasHovorka@seznam.cz>, CRAN-submissions@R-project.org 
> Datum: 29. 8. 2017 14:38:33 
> Předmět: Re: [CRAN-pretest-archived] CRAN submission WordR 0.2.1 
> " 
> 
> On 29.08.2017 11:00, Tomáš Hovorka wrote: 
>> Hi CRAN, 
>> 
>> 
>> 
>> explanations to notes: 
>> 
>> 
>> * checking CRAN incoming feasibility ... NOTE  
>> Maintainer: 'Tomas Hovorka <tomashovorka@seznam.cz>'  
>> 
>> I googled this out, and hopefully it can be ignored.  
>> 
>> The second one:  
>> 
>> ** running examples for arch 'x64' ... [11s] NOTE  
>> Examples with CPU or elapsed time > 10s   
>> user system elapsed   
>> addFlexTables 16.57 2.71 7.77  
>> 
>> The example is pretty basic, and I am not sure how I can simplify it more 
> still presenting the intended use. Majority of the time is file reading and 
> writing, hence I hope this can be accepted as well. 
> 
> 
> Can you explain why user > 2*elapsed? Is this running on more than 2 cores? 
> 
> Best, 
> Uwe Ligges 
> 
> 
> 
> 
>> Thank you 
>> 
>> <br> 
>> 
>> Tomas Hovorka 

##Reverse dependecies check
No reverse dependencies found
