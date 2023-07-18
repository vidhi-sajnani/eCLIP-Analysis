library(clusterProfiler)
library(goseq)
library(org.Hs.eg.db)
library(org.Mm.eg.db)
library(AnnotationDbi)
library(enrichplot)
library(ggridges)
library(pathview)
library(ggplot2)
set.seed(2022)

#Select up regulated gene
peaks <- data.table::fread("C:/Users/Vidhi Sajnani/Desktop/annotated/annotated3.bed")
up_genes <- unique(peaks$V5)
#make the over representation test
GO_res <- enrichGO(gene = up_genes,
                   OrgDb = "org.Mm.eg.db",
                   keyType = "ENSEMBL",
                   ont = "BP")
as.data.frame(GO_res)
# plot the results
fit1 <- plot(barplot(GO_res,showCategory = 30,font.size = 7,title = "Significantly up-regulated genes"))
fit1

# # same process for the downregulated genes
# down_genes <- rownames(res_control_vs_D3_shrunk[res_control_vs_D3_shrunk$log2FoldChange<0,])
# 
# GO_res_d <- enrichGO(gene = down_genes,
#                      OrgDb = "org.Hs.eg.db",
#                      keyType = "ENSEMBL",
#                      ont = "BP")
# as.data.frame(GO_res_d)
# fit2 <- plot(barplot(GO_res_d,showCategory = 30,font.size = 7,title = "Significantly down-regulated genes in control vs Day5"))
# fit2

# make a dot plot
dot_go <- dotplot(GO_res,showCategory=20,title="Up-regulated GO-enrichment for control vs Day5",font.size=7)

tiff("Plots/GO_bar_Day5_vs_control_up.tiff",width = 35,height = 21,units = 'cm',res = 300)
plot(fit1)
plot(dot_go)
dev.off()
#GSEA

