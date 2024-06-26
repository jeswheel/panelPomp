args <- commandArgs(trailingOnly = TRUE)

# Function to replace cross-references and labels according to the specified patterns
replace_crossrefs <- function(file_name) {
  text <- readLines(paste0(file_name, '.Rmd'))

  # Remove Header that causes problems
  start_header <- 1
  end_header <- which(grepl('---', text))[2]
  header <- text[start_header:end_header]
  new_header <- c(
    header[1],
    header[grepl('title: ', header)],
    header[grepl('subtitle: ', header)],
    header[length(header)]
  )

  text <- text[(end_header+1):length(text)]
  text <- c(new_header, text)

  # Replace equation references
  text <- gsub("Eqs?\\. \\\\@ref\\(eq:([[:alnum:]_-]+)\\)", "@eq-\\1", text)



  # Replace equation references (In case doesn't have leading word "Eq")
  text <- gsub("\\\\@ref\\(eq:([[:alnum:]_-]+)\\)", "@eq-\\1", text)

  # Replace table references
  text <- gsub("Tables? \\\\@ref\\(tab:([[:alnum:]_-]+)\\)", "@tbl-\\1", text)

  # Replace table references (In case doesn't have leading word "Table")
  text <- gsub("\\\\@ref\\(tab:([[:alnum:]_-]+)\\)", "@tbl-\\1", text)

  # Replace figure references
  text <- gsub("\\\\@ref\\(fig:([[:alnum:]_-]+)\\)", "@fig-\\1", text)

  # Replace equation labels
  text <- gsub("\\(\\\\#eq:([[:alnum:]_-]+)\\)", "{#eq-\\1}", text)

  caption_pattern <- "Table: \\(\\\\#tab:([^)]+)\\) (.+) ([^\n]+)"
  table_captions <- gsub(caption_pattern, ": \\2 {#tbl-\\1}\n", text[grepl(caption_pattern, text)])

  # Remove original captions.
  text <- text[!grepl(caption_pattern, text)]
  start_bars <- which(grepl("^\\|", text))
  start_tbls <- c(start_bars[1], start_bars[c(FALSE, diff(start_bars) > 1)])
  end_tbls <- c(start_bars[c(diff(start_bars) > 1, FALSE)], start_bars[length(start_bars)])

  if (length(start_tbls) == length(end_tbls)) {
    for (i in 1:length(start_tbls)) {
      text <- c(
        text[1:(end_tbls[i] + i - 1)],
        table_captions[i],
        text[(end_tbls[i] + i):length(text)]
      )
    }
  }

  eq_blk_start <- which(grepl('\\\\begin\\{align\\}', text))
  eq_blk_end <- which(grepl('\\\\end\\{align\\}', text))

  for (i in 1:length(eq_blk_start)) {
    eq_lines <- text[eq_blk_start[i]:eq_blk_end[i]]

    eq_lines <- paste0(eq_lines, collapse = '')
    eq_lines <- strsplit(eq_lines, '\\\\\\\\') |> unlist()
    eq_lines <- gsub('\\\\begin\\{align\\}', '', eq_lines)
    eq_lines <- gsub('\\\\end\\{align\\}', '', eq_lines)
    eq_lines <- gsub('\\&=', '=', eq_lines)
    eq_lines <- paste0("$$\n", eq_lines)
    eq_lines <- gsub("\\s\\{#eq-([[:alnum:]_-]+)\\}$", "\n$$ \\{#eq-\\1\\}\n", eq_lines)

    text <- c(
      text[1:(eq_blk_start[i] - 1)],
      eq_lines,
      text[(eq_blk_end[i] + 1):length(text)]
    )
  }

  writeLines(text, paste0(file_name, '.qmd'))
}

replace_crossrefs(args[1])
