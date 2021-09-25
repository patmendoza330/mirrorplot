# This R file will store code that creates a 'mirrorplot' that is often used in RNA-seq analysis
library(ggplot2)
library(ggrepel)
library("rstudioapi")
wd <- rstudioapi::getSourceEditorContext()$path
wd1 <- strsplit(wd, "/")
wd1 <- paste0(wd1[[1]][1:lengths(wd1)-1], collapse = "/")

filename1 <- paste0(wd1, '/mirrorplot.png')
dat <- data.frame(group=c(), x=c(), z=c())
jackrabbit <- list()
jackrabbit[["Cat1"]] <- c(500,-300)
jackrabbit[["Cat2"]] <- c(200, -50)
for(i in 1:length(jackrabbit)){
  intdf <- data.frame(group=c("upregulated", "downregulated"), x=rep(names(jackrabbit)[i], 2), z=jackrabbit[[i]], color1=c("black", "white"), fill1 = c("#FFFFFF", "#000000"))
  dat <- rbind(dat, intdf)
}
dat$color1 <- as.character(dat$color1)
dat$fill1 <- as.character(dat$fill1)
maxnum <- 0
for (i in 1:length(jackrabbit)){
  maxnum <- max(maxnum, jackrabbit[[i]])
  #minnum <- min(minnum, jackrabbit[[i]])
}

png(filename1, height = 1200, width = 1200)
p <- ggplot(dat, aes(x=x, y=z, fill=group, label=abs(z))) + 
  geom_bar(stat="identity", position="identity", color = "black", width=.6) + 
  scale_fill_manual(values = c("black","white")) + 
  theme(axis.title.x=element_blank(),axis.text.y=element_blank(), axis.title.y = element_text(size=50, face="bold"), axis.text=element_text(size=50, face="bold"))+
  ylab('Number of Genes') +
  scale_colour_manual(values=c('white','black'))+
  geom_label_repel(direction = "y", mapping = aes(hjust=.5, 
                                                  vjust = rep(c(1,0), length(jackrabbit))),
                   color = dat$color1,
                   fill=dat$fill1, size=15, label.padding = unit(.5, "lines"))+
  theme(legend.position = "none")+  
  geom_hline(yintercept=0, color="black", size=2)+
  annotate(geom="text", x=.45, y=.02*maxnum, label="Upregulated",
           color="black", angle=90, fontface="italic", size=12, hjust=0) +
  annotate(geom="text", x=.45, y=-.02*maxnum, label="Downregulated",
           color="black", angle=90, fontface="italic", size=12, hjust =1) + 
  scale_y_continuous(expand=expansion(mult=c(.10,.10)))
print(p)
dev.off()