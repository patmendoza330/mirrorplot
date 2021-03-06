# This R file will store code that creates a 'mirrorplot' that is often 
# used in RNA-seq analysis
library(ggplot2)
library(ggrepel)

# BEGIN Enter your variables here
sample.type1 <- c("Root", "Stem", "Leaf") # types of samples for RNA-seq
sample.values1 <- c(500, -300, 200, -50, 200, -30) 
regulation.type1 <- c("Upregulated", "Downregulated")
bar.fill1 <- c("white", "black") # upregulated genes will have a white bar
# downregulated genes will generally appear black
# END Enter your variables here
label.text.color1 <- rev(bar.fill1)
y.lab <- "Number of Genes" # the label for the y axis
maxnum <- max(sample.values1) 

# block of code to create a path and filename for your impage output
filename <- "mirrorplot.png" # your local image created
wd <- getwd()
filename1 <- paste0(wd, '/' , filename)

dat1 <- data.frame(sample.type=rep(sample.type1, each = 2), 
                  # we want all categories listed twice (up/down)
                  regulation.type = regulation.type1,
                  # regulation types will be repeated for all samples
                  y = sample.values1, 
                  # enter the samples
                  bar.fill = bar.fill1, 
                  label.text.color = label.text.color1, 
                  stringsAsFactors = FALSE)
dat1$regulation.type <- factor(dat1$regulation.type, levels = regulation.type1)
dat1$sample.type <- factor(dat1$sample.type, levels = sample.type1)
# this ensures that the order of the regulation types and sample types 
# appears as we have entered them into the dataframe. ggplot will order them 
# alphabetically, unless we specify otherwise

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
p
dev.off()