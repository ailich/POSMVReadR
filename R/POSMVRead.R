#' Extract information from binary Applanix POSMV files and write to plain text
#'
#' Extract information from binary Applanix POSMV files and write to plain text. Note this function requires python 3 to be installed on your computer.
#' @param input Character vector of file names or a directory containing applanix binary files
#' @param output Output file name
#' @param append Logical indicating whether the output should be appended to an existing output
#' @param tmpdir character vector giving the directory name for temporary files to be stored
#' @details
#' This R function uses system calls to a python script written by Paul Kennedy (https://github.com/pktrigg/posmv)
#' @export

POSMVRead<- function(input, output, append=FALSE, tmpdir= tempdir()){
  if(dir.exists(input)){
    input<- list.files(input, full.names = TRUE)
  }

  n_files<- length(input)

  if(n_files > 1 | append){
    tmp_name<- tempfile(tmpdir = tmpdir, fileext = ".csv")
  }

  if(n_files==1 & !append){
    system2("python",
            args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  input,  "-position"),
            stdout = output)
  }

  if(n_files > 1 & !append){
    for (i in seq_along(input)) {
      if(i==1){
        system2("python",
              args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  input[i],  "-position"),
              stdout = output)
        } else{
          system2("python",
                  args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  input[i],  "-position"),
                  stdout = tmp_name)
          file.append(output, tmp_name)
          file.remove(tmp_name)
        }}}

  if(n_files==1 & append){
    system2("python",
            args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  input,  "-position"),
            stdout = tmp_name)
    file.append(output, tmp_name)
    file.remove(tmp_name)
  }

  if(n_files > 1 & append){
    for (i in seq_along(input)) {
      system2("python",
              args= c(system.file("python/POSMVRead.py", package = "POSMVReadR"), "-i",  input[i],  "-position"),
              stdout = tmp_name)
        file.append(output, tmp_name)
        file.remove(tmp_name)
    }}
  invisible(NULL)
}
