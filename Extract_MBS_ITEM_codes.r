library(tidyverse)
library(openxlsx)

#--Read in txt--
mbscode <- read.table("http://www.mbsonline.gov.au/internet/mbsonline/publishing.nsf/Content/1BC94358D4F276D3CA257CCF0000AA73/$File/MBSONLINE_DESC%2024DEC21.TXT", fill = TRUE) 

#--Fix colnames--
newnames <- c("ITEM", "DESCRIPTION_START", "Description_LATEST",  seq(4,99))

colnames(mbscode) <- newnames

#--Split into two dfs: 1:2 + 3:99 (concatenated)--
mbs1_2 <- mbscode %>% 
  select(1:2)

mbs3_99 <- mbscode %>% 
  select(3:99)

#--Condense 3-99 with paste() in 'apply'--
condense3_99 <- as.data.frame(apply(mbs3_99, 1, paste, collapse=" "))

colnames(condense3_99) <- "Description_LATEST"

MBScode <- mbs1_2 %>% 
  bind_cols(condense3_99)

# Filter to only retain codes
MBScode <- MBScode %>% 
  arrange(ITEM) %>% 
  mutate(c = 1, row = cumsum(c))%>%
  filter(row>164, row<22248) %>% 
  select(-c, -row)

#--Write to xlsx--
write.xlsx(MBScode, "./MBScode.xlsx")

