#' Extract information from binary Applanix POSMV files and write to plain text
#'
#' Extract information from binary Applanix POSMV files and write to plain text. Note this function requires python 3 to be installed on your computer.
#' @param input Character vector of file names or a directory containing Applanix POSMV binary files
#' @param output Output file name for resultant csv file.
#' @param recursive logical (default is TRUE). Should the listing recurse into directories?
#' @param append Logical indicating whether the output should be appended to an existing output
#' @param pattern Pattern of file names to search for in directory. Default is to is a file extension of just numbers (e.g. '.000').
#' @param verbose logical indicating whether to print progress to display (deafult is FALSE)
#' @param tmpdir character vector giving the directory name for temporary files to be stored
#' @importFrom tidyr separate
#' @importFrom lubridate ymd_hms
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#' @importFrom tibble tibble
#' @details
#' This R function uses system calls to a python script written by Paul Kennedy (https://github.com/pktrigg/posmv). Data is then read into R to do some tidying so it can be exported as a clean csv.
#' @export

POSMVRead<- function(input, output, recursive=TRUE, append=FALSE, pattern = "\\.\\d+$", verbose=FALSE, tmpdir= tempdir()){
  if(length(input)==1){
    if(dir.exists(input)){
    input<- list.files(input, pattern = pattern, recursive = recursive, full.names = TRUE)
    input<- input[!dir.exists(input)] #Don't include directories in file list
    }
  } #Read files in directory

  n_files<- length(input)

  if(n_files > 1 | append){
    tmp_name<- tempfile(tmpdir = tmpdir, fileext = ".csv")
  } #Create name for temporary file

  if(n_files==1 & !append){
    if(verbose){
      print("1 of 1")
      print(basename(input))
      }
    system2("python",
            args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  shQuote(input),  "-position"),
            stdout = output)
    df<- suppressWarnings(suppressMessages(read_csv(output))) #Read data into R to fix formatting
    if(nrow(df)==0){
      df<- tibble(Time=ymd_hms(),
                  Latitude = numeric(),
                  Longitude = numeric(),
                  Altitude = numeric(),
                  Pitch = numeric(),
                  Roll = numeric(),
                  Heading = numeric(),
                  Speed = numeric())
      write_csv(df, file = output, append = FALSE) #re-export
    } else{
      df[,3:8]<- df[,2:7]
      df<- separate(df, Date, into = c("Date", "Time", "Latitude"), sep = " ")
      df$Time<- ymd_hms(paste(df$Date, df$Time))
      df$Latitude<- as.numeric(df$Latitude)
      df<- df[,names(df)!="Date"]
      write_csv(df, file = output, append = FALSE) #re-export
  }}

  if(n_files > 1 & !append){
    for (i in seq_along(input)) {
      if(verbose){
        print(paste(i, "of", n_files))
        print(basename(input[i]))
      }
      if(i==1){
        system2("python",
              args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  shQuote(input[i]),  "-position"),
              stdout = output)
        df<- suppressWarnings(suppressMessages(read_csv(output))) #Read data into R to fix formatting
        if(nrow(df)==0){
          df<- tibble(Time=ymd_hms(),
                      Latitude = numeric(),
                      Longitude = numeric(),
                      Altitude = numeric(),
                      Pitch = numeric(),
                      Roll = numeric(),
                      Heading = numeric(),
                      Speed = numeric())
          write_csv(df, file = output, append = FALSE) #re-export
        } else{
          df[,3:8]<- df[,2:7]
          df<- separate(df, Date, into = c("Date", "Time", "Latitude"), sep = " ")
          df$Time<- ymd_hms(paste(df$Date, df$Time))
          df$Latitude<- as.numeric(df$Latitude)
          df<- df[,names(df)!="Date"]
          write_csv(df, file = output, append = FALSE) #re-export
        }} else{
          system2("python",
                  args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  shQuote(input[i]),  "-position"),
                  stdout = tmp_name)
          df<- suppressWarnings(suppressMessages(read_csv(tmp_name))) #Read data into R to fix formatting
          if(nrow(df)==0){
            file.remove(tmp_name)
          } else{
            df[,3:8]<- df[,2:7]
            df<- separate(df, Date, into = c("Date", "Time", "Latitude"), sep = " ")
            df$Time<- ymd_hms(paste(df$Date, df$Time))
            df$Latitude<- as.numeric(df$Latitude)
            df<- df[,names(df)!="Date"]
            write_csv(df, file= output, append = TRUE) #re-export
            file.remove(tmp_name)
        }}}}

  if(n_files==1 & append){
    if(verbose){
      print("1 of 1")
      print(basename(input))
    }
    system2("python",
            args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  shQuote(input),  "-position"),
            stdout = tmp_name)
    df<- suppressWarnings(suppressMessages(read_csv(tmp_name))) #Read data into R to fix formatting
    if(nrow(df)==0){
      file.remove(tmp_name)
    } else{
      df[,3:8]<- df[,2:7]
      df<- separate(df, Date, into = c("Date", "Time", "Latitude"), sep = " ")
      df$Time<- ymd_hms(paste(df$Date, df$Time))
      df$Latitude<- as.numeric(df$Latitude)
      df<- df[,names(df)!="Date"]
      write_csv(df, file = output, append = TRUE) #re-export
      file.remove(tmp_name)
      }}

  if(n_files > 1 & append){
    for (i in seq_along(input)) {
      if(verbose){
        print(paste(i, "of", n_files))
        print(basename(input[i]))
      }
      system2("python",
              args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  shQuote(input[i]),  "-position"),
              stdout = tmp_name)
      df<- suppressWarnings(suppressMessages(read_csv(tmp_name))) #Read data into R to fix formatting
      if(nrow(df)==0){
        file.remove(tmp_name)
      } else{
        df[,3:8]<- df[,2:7]
        df<- separate(df, Date, into = c("Date", "Time", "Latitude"), sep = " ")
        df$Time<- ymd_hms(paste(df$Date, df$Time))
        df$Latitude<- as.numeric(df$Latitude)
        df<- df[,names(df)!="Date"]
        write_csv(df, file = output, append = TRUE) #re-export
        file.remove(tmp_name)}}}
  invisible(NULL) #Don't return anything
}
