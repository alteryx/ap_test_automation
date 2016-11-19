# This script generates a set of matrixes of random ordinals.  Each column 
# is an integer vector sampled at random from a set of possible values 1:k, 
# where k is the column number.  All sampled values are equiprobable, within 
# a column.  

n <- 10^6
p <- 10^3

rordinal_m <- matrix(data = NA, nrow = n, ncol = p)

for(i in 1:p){
  rordinal_m[, i] <- sample(x = 1:(i + 1), n, replace = TRUE)
}

temp_row_count <- 1000

while(temp_row_count <= n){
  temp_column_count <- 10
  while(temp_column_count <= p){
    temp_file_name <- paste(
      "c:\\temp\\rordinal_reference_datasets\\rordinal_", 
      format(temp_row_count, scientific = FALSE), 
      '_', 
      format(temp_column_count, scientific = FALSE),
      ".txt", 
      sep = ''
    )
    print(temp_file_name)
    flush.console()
    write.table(
      x = rordinal_m[1:temp_row_count, 1:temp_column_count], 
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
