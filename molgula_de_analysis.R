hyb.data <- read.table("/mnt/hyb_recipr.counts", header=FALSE, col.names=c("ocu_id", "ocu_start", "ocu_len", "round1.1", "round1.2", "round1.3", "occu_id", "occu_start", "occu_len", "round1.4", "round1.5", "round1.6"))
mol.data <- read.table("/mnt/mol_recipr.counts", header=FALSE, col.names=c("ocu_id", "ocu_start", "ocu_len", "round1.7", "round1.8", "round1.9", "occu_id", "occu_start", "occu_len", "round1.10", "round2.1", "round2.2", "round2.3", "round2.4"))
data<-cbind(mol.data,hyb.data)

source("http://bioconductor.org/biocLite.R")
biocLite("BiocUpgrade")
biocLite("edgeR")
library(edgeR)

#edger.counts1<-mol.data[,c("round1", "round1", "round1", "round1", "round2", "round2", "round2", "round2")]
#edger.counts2<-hyb.data[,c("round1", "round1", "round1","round1", "round1", "round1")]
edger.counts<- data[,c("round1.1", "round1.2", "round1.3","round1.4", "round2.1", "round2.2", "round2.3", "round2.4", "round1.5", "round1.6","round1.7", "round1.8", "round1.9", "round1.10")]
hyb_joined <- cbind(edger.counts$round1.5+edger.counts$round1.8,edger.counts$round1.6+edger.counts$round1.9,edger.counts$round1.7+edger.counts$round1.10)
edger.counts <-cbind(edger.counts,hyb_joined)
Group <- factor(paste(species=c("ocu","ocu","ocu","occ","occ","occ","occ","occ","hyb_ocu","hyb_ocu","hyb_ocu","hyb_occ","hyb_occ","hyb_occ","hyb","hyb","hyb"),stage=c("f3","f4","f6","f3","f3", "f4","f6","f6","f3","f4","f6","f3","f4","f6","f3","f4","f6"),sep="."))
edger.data<-DGEList(counts=edger.counts, group = Group)
rownames(edger.data)<-hyb.data$ocu_id

keep <- rowSums(cpm(edger.data)>1) >=2
edger.data<-edger.data[keep,]

#o <- order(rowSums(edger.data$counts))
#y <- y[o,]
#d <- duplicated(edger.data)


design <- model.matrix(~0+Group)
colnames(design)<-levels(Group)

edger.data <- estimateGLMCommonDisp(edger.data,design)
edger.data <- estimateGLMTagwiseDisp(edger.data,design)
mol.contrasts <- makeContrasts(
  ocuf3vsoccf3 = ocu.f3-occ.f3,
  ocuf4vsoccf4 = ocu.f4-occ.f4,
  ocuf6vsoccf6 = ocu.f6-occ.f6,
  hocuf3vshoccf3 = hyb_ocu.f3-hyb_occ.f3,
  hocuf4vshoccf4 = hyb_ocu.f4-hyb_occ.f4,
  hocuf6vshoccf6 = hyb_ocu.f6-hyb_occ.f6,
  ocuf3vshybf3 = ocu.f3-hyb.f3,
  occf3vshybf3 = occ.f3-hyb.f3,
  ocuf4vshybf4 = ocu.f4-hyb.f4,
  occf4vshybf4 = occ.f4-hyb.f4,
  ocuf6vshybf6 = ocu.f6-hyb.f6,
  occf6vshybf6 = occ.f6-hyb.f6,
  ocuf3vsocuf4 = ocu.f3-ocu.f4,
  occf3vsoccf4 = occ.f3-occ.f4,
  ocuf4vsocuf6 = ocu.f4-ocu.f6,
  occf4vsoccf6 = occ.f4-occ.f6,
  ocuf3vsocuf6 = ocu.f3-ocu.f6,
  occf3vsoccf6 = occ.f3-occ.f6,
  levels=design)
fit <- glmFit(edger.data,design)
lrt <- glmLRT(fit, contrast=mol.contrasts[,"occf3vsoccf4"])
detags<-rownames(topTags(lrt, n=1350)$table)
#plotSmear(lrt, de.tags=detags)
#title("occf3vsoccf4")
for(i in colnames(mol.contrasts)){
  lrt <- glmLRT(fit, contrast=mol.contrasts[,i])
  detags<-rownames(topTags(lrt, n=1350)$table)
  png(paste("/Users/elijahklowe/Dropbox_work/Dropbox/Photos/graphs/",i,"de_graph.png",sep=""))
  plotSmear(lrt, de.tags=detags)
  title(i)
  dev.off()
}