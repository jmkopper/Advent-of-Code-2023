library("stringr")

roundOk <- function(round_str) {
  round_str <- substr(round_str, 2, nchar(round_str))
  pulls <- str_split(round_str, "; ") |> unlist()
  for (pull in pulls) {
    colors <- str_split(pull, ", ") |> unlist()
    counts <- list(red=0, green=0, blue=0)
    for (color in colors) {
      color_counts <- str_split(color, " ") |> unlist()
      counts[[color_counts[2]]] = as.integer(color_counts[1])
    }
    if (counts$blue > 14 || counts$green > 13 || counts$red > 12) {
      return(FALSE)
    }
  }
  return(TRUE)
}

fewestInRound <- function(round_str) {
  round_str <- substr(round_str, 2, nchar(round_str))
  pulls <- str_split(round_str, "; ") |> unlist()
  counts <- list(red=0, green=0, blue=0)
  for (pull in pulls) {
    colors <- str_split(pull, ", ") |> unlist()
    for (color in colors) {
      color_counts <- str_split(color, " ") |> unlist()
      cname <- color_counts[2]
      ccount <- as.integer(color_counts[1])
      counts[[cname]] <- max(counts[[cname]], ccount)
    }
  }
  return(counts)
}

runGames <- function(input) {
  scores <- c(0, 0)
  for (row in input) {
    split_by_colon <- strsplit(row, ":") |> unlist()
    
    # Part 1
    game_id <-substr(split_by_colon[1], 6, nchar(split_by_colon[1])) |> as.integer()
    if (roundOk(split_by_colon[2])) {
      scores[1] <- scores[1] + game_id
    }
    
    # Part 2
    counts <- fewestInRound(split_by_colon[2])
    scores[2] <- scores[2] + (counts$red * counts$blue * counts$green)
  }
  return(scores)
}

input <- readLines("input.txt")
s <- runGames(input)
print(paste("Part 1: ", s[1]))
print(paste("Part 2: ", s[2]))
