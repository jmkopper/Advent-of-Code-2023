part1 <- function(input) {
  sum <- 0
  for (row in input) {
    ch <- strsplit(row, split="") |> unlist() |> as.numeric()
    ch <- ch[!is.na(ch)]
    sum <- sum + ch[1]*10 + tail(ch, 1)
  }
  return(sum)
}

fixstr <- function(line) {
  if (line == "") {
    return("")
  }
  
  for (i in 1:nchar(line)) {
    s <- substr(line, 1, i)
    
    if (grepl("one", s, fixed=TRUE)) {
      return(paste(sub("one", "1ne", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("two", s, fixed=TRUE)) {
      return(paste(sub("two", "2wo", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("three", s, fixed=TRUE)) {
      return(paste(sub("three", "3hree", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("four", s, fixed=TRUE)) {
      return(paste(sub("four", "4our", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("five", s, fixed=TRUE)) {
      return(paste(sub("five", "5ive", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("six", s, fixed=TRUE)) {
      return(paste(sub("six", "6ix", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("seven", s, fixed=TRUE)) {
      return(paste(sub("seven", "7even", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("eight", s, fixed=TRUE)) {
      return(paste(sub("eight", "8ight", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    } else if (grepl("nine", s, fixed=TRUE)) {
      return(paste(sub("nine", "9ine", s), substr(line, i+1, nchar(line)), sep="") |> fixstr())
    }
  }
  
  return(line)
}

part2 <- function(input) {
  lapply(input, FUN=fixstr) |> unlist() |> part1()
}


input <- readLines("input.txt")
print(part1(input))
print(part2(input))
