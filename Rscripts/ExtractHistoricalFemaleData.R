# An official factsheet by IOC
female_pdf <- "data/Women-in-the-Olympic-Movement.pdf"
# automatically detect tables
female_tbls <- extract_tables(female_pdf, pages = 6)

# the first table is the Summer Olympics
# clean it a bit
female_dat <- female_tbls[[1]][-1, ]
female_dat <- separate(female_dat, col = 1, into = c("Year", "Sports"), sep = " ")

colnames(female_dat)[3:9] <- c(
  "Women_events",
  "Mixed_events",
  "Total_events",
  "Prcnt_women_events",
  "Prcnt_womenandmixed_events",
  "Women_participants",
  "Prcnt_women_participants"
  )

# define numerical columns
female_dat[, 2:9] <- lapply(female_dat[, 2:9], as.numeric)