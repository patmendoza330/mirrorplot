# This R file will store code that creates a 'mirrorplot' that is often 
# used in RNA-seq analysis
library(ggplot2)
library(ggrepel)
library("rstudioapi")
wd <- rstudioapi::getSourceEditorContext()$path
wd1 <- strsplit(wd, "/")
wd1 <- paste0(wd1[[1]][1:lengths(wd1)-1], collapse = "/")

filename1 <- paste0(wd1, '/mirrorplot.png')

# Lets put together the table that will be used as the basis for our chart

sample.type1 <- c("Root", "Stem", "Leaf")
regulation.type1 <- c("Upregulated", "Downregulated")
sample.values1 <- c(500, -300, 200, -50, 200, -30) # These correspond with 
# the values that will be included for each of your 
# samples. You will have one positive and one negative number for each. 
# In this case, since we have two categories, there will be four numbers
# included.
bar.fill1 <- c("white", "black")
# because the labels will be the opposite of the fill colors we only need
# to reverse the order fo the fill
label.text.color1 <- rev(bar.fill)

dat1 <- data.frame(sample.type=rep(sample.type1, each = 2), 
                  # we want all categories listed twice (up/down)
                  regulation.type = regulation.type1,
                  # regulation types will be repeated for all samples
                  y = sample.values, 
                  # enter the samples
                  bar.fill = bar.fill1, 
                  label.text.color = label.text.color1, 
                  stringsAsFactors = FALSE)
dat1$regulation.type <- factor(dat1$regulation.type, levels = regulation.type)
dat1$sample.type <- factor(dat1$sample.type, levels = sample.type1)
# this ensures that the order of the regulation types appears as we have 
# entered it into the dataframe in the ggplot
y.lab <- "Number of Genes"
maxnum <- max(sample.values)
# grab the maximum number of the sample values for use later

png(filename1, height = 1200, width = 1200)
p <- ggplot(dat1, aes(x=sample.type, y=y, fill=regulation.type, label=abs(y))) + 
  # setting the color and width of the borders around our bar charts
  geom_bar(stat="identity", position="identity", color = "black", width=.6) + 
  scale_fill_manual(values = dat1$bar.fill) + 
  # remove the x axis title and increase the font size of the y axis and
  # the individual items on the x axis
  theme(axis.title.x=element_blank(),axis.text.y=element_blank(), 
        axis.title.y = element_text(size=50, face="bold"), 
        axis.text=element_text(size=50, face="bold")) +
  # relabel the y axis
  ylab(y.lab) +
  # add in the labels for the values
  geom_label_repel(direction = "y", mapping = aes(hjust=.5, 
                                                  vjust = rep(c(1,0), length(sample.type1))), 
                   color = dat1$label.text.color, 
                   fill= dat1$bar.fill, size=15, 
                   label.padding = unit(.5, "lines")) +
  # remove the legend
  theme(legend.position = "none")+  
  # adding a horizontal line at the zero axis
  geom_hline(yintercept=0, color="black", size=2)+
  # placing the labels for the 
  annotate(geom="text", x=.45, y=.02*maxnum, label=regulation.type1[1],
           color="black", angle=90, fontface="italic", size=12, hjust=0) +
  annotate(geom="text", x=.45, y=-.02*maxnum, label=regulation.type1[2],
           color="black", angle=90, fontface="italic", size=12, hjust =1) + 
  # Increase the size of the plot so that it can encompass the labels that
  # were added
  scale_y_continuous(expand=expansion(mult=c(.10,.10)))
print(p)
dev.off()