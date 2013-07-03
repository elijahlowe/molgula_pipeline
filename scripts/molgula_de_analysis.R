transcriptome.data <- read.table("/Users/elijahklowe/Dropbox_work/Dropbox/hyb_recipr.counts", header=FALSE, col.names=c("ocu_id", "ocu_start", "ocu_len", "ocu_f3", "ocu_f4", "ocu_f6", "occu_id", "occu_start", "occu_len", "occu_f3", "occu_f4", "occu_f6"))

library(edgeR)

edger.counts <- transcriptome.data[,c("ocu_f3", "ocu_f4", "ocu_f6", "occu_f3", "occu_f4", "occu_f6")]
edger.data <- DGEList(counts=edger.counts, group=c(1,1,1,2,2,2))

edger.data.norm <- calcNormFactors(edger.data)
edger.data.norm <- estimateCommonDisp(edger.data.norm)
edger.data.norm <- estimateTagwiseDisp(edger.data.norm)
edger.results <- exactTest(edger.data.norm)

topTags(edger.results)


p.vals <- edger.results$table$PValue
fdr.bh <- p.adjust(p.vals, method="BH")

transcriptome.data$p <- p.vals
transcriptome.data$fdr <- fdr.bh

transcriptome.data[transcriptome.data$fdr < 0.01,]

transcriptome.data <- transcriptome.data[order(transcriptome.data$fdr),]

transcriptome.data[1:100,]

write.table(transcriptome.data$id[1:100], file="hyb_top_hits.txt", quote=F, row.names=F, col.names=F)

plot(-log10(edger.results$table[,3])~ edger.results$table[,1])
plot(edger.results$table[,1] ~ edger.results$table[,2])
hist(edger.results$table[,3])
########################

eli.data <- read.table("dmel_all_diff_exp.txt")
eli.data$count <- rowMeans(eli.data[,4:7])
eli.data$diff <- log2(rowMeans(eli.data[,4:5])/rowMeans(eli.data[,6:7]))
hist(eli.data$p)

plot(-log10(eli.data$p)~ eli.data$diff)
plot( eli.data$diff ~ log2(eli.data$count))

###################

likit.data <- read.table("gene_exp.diff", header=T)

plot(-log10(likit.data$p_value[abs(likit.data$log2.fold_change) < 100]) ~ likit.data$log2.fold_change.[abs(likit.data$log2.fold_change) < 100])
plot(likit.data$diff ~ likit.data$)