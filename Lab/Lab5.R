library(tidyverse)
# The data for this lab are in the file MLLT3_small.vcf. These are data on genomic variants in a gene called
#MLLT3. The file includes many meta-data lines that start with ##, and then a header for the data columns
#that starts with #. The separator for the data columns is the tab character.

#1. Use the appropriate read_* function to read these data into R, skipping the meta-data lines.
a <- read_tsv("D:/Simon Fraser University/2020 fall/STAT 261/lab5/MLLT3_small.vcf",comment="##")

#2. Use the spec() function to print a list of the column specifications. Copy this and make changes so
#that the REF and ALT variables are read in as factors.
spec(a)
b <- read_tsv("D:/Simon Fraser University/2020 fall/STAT 261/lab5/MLLT3_small.vcf",comment="##",
              col_types=cols(
                `#CHROM` = col_double(),
                POS = col_double(),
                ID = col_character(),
                REF = col_factor(),
                ALT = col_factor(),
                QUAL = col_double(),
                FILTER = col_character(),
                INFO = col_character(),
                FORMAT = col_character(),
                HG00096 = col_character(),
                HG00097 = col_character(),
                HG00099 = col_character(),
                HG00100 = col_character(),
                HG00101 = col_character(),
                HG00102 = col_character(),
                HG00103 = col_character(),
                HG00105 = col_character(),
                HG00106 = col_character(),
                HG00107 = col_character(),
                HG00108 = col_character(),
                HG00109 = col_character(),
                HG00110 = col_character()
              ))
str(b)

#3. Rename the first column CHROM. Hint: Beware the #-sign in the column name. This is what the text
#calls a ¡°non-syntactic¡± name. How do you refer to such a name?

