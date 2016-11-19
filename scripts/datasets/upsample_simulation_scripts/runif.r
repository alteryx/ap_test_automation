# This script generates a set of matrixes of random reals on the unit interval.

n <- 10^6
p <- 10^3

runif_m <- matrix(data = runif(n = n * p, min = 0.0, max = 1.0), nrow = n, ncol = p)

temp_row_count <- 1000

while(temp_row_count <= n){
  temp_column_count <- 10
  while(temp_column_count <= p){
    temp_file_name <- paste(
      "c:\\temp\\runif_reference_datasets\\runif_", 
      format(temp_row_count, scientific = FALSE), 
      '_', 
      format(temp_column_count, scientific = FALSE),
      ".txt", 
      sep = ''
    )
    print(temp_file_name)
    flush.console()
    write.table(
      x = runif_m[1:temp_row_count, 1:temp_column_count], 
      file = temp_file_name,
      append = FALSE,
      quote = FALSE,
      sep = ' ',
      eol = "\n", 
      na = "NA", 
      dec = ".", 
      row.names = FALSE,
      col.names = FALSE, 
      qmethod = "double",
      fileEncoding = ""
    )
    temp_column_count <- temp_column_count * 10
  }
  temp_row_count <- temp_row_count * 10
}
