library(RCAS)


queryRegions <- importBed(filePath = "C:/Users/Vidhi Sajnani/Desktop/germany/uni/output/MEC_wt_S3/PureCLIP.crosslink_sites_for_RCAS_human.bed", sampleN = 10000)
gff <- importGtf(filePath = "C:/Users/Vidhi Sajnani/Desktop/germany/uni/output/Homo_sapiens.GRCh38.109.gtf")

overlaps <- as.data.table(queryGff(queryRegions = queryRegions, gffData = gff))

biotype_col <- grep('gene_biotype', colnames(overlaps), value = T)
df <- overlaps[,length(unique(queryIndex)), by = biotype_col]
colnames(df) <- c("feature", "count")
df$percent <- round(df$count / length(queryRegions) * 100, 1)
df <- df[order(count, decreasing = TRUE)]
ggplot2::ggplot(df, aes(x = reorder(feature, -percent), y = percent)) + 
  geom_bar(stat = 'identity', aes(fill = feature)) + 
  geom_label(aes(y = percent + 0.5), label = df$count) + 
  labs(x = 'transcript feature', y = paste0('percent overlap (n = ', length(queryRegions), ')')) + 
  theme_bw(base_size = 14) + 
  theme(axis.text.x = element_text(angle = 90))
txdbFeatures <- getTxdbFeaturesFromGRanges(gff)
summary <- summarizeQueryRegions(queryRegions = queryRegions, 
                                 txdbFeatures = txdbFeatures)

df <- data.frame(summary)
df$percent <- round((df$count / length(queryRegions)), 3) * 100
df$feature <- rownames(df)
ggplot2::ggplot(df, aes(x = reorder(feature, -percent), y = percent)) + 
  geom_bar(stat = 'identity', aes(fill = feature)) + 
  geom_label(aes(y = percent + 3), label = df$count) + 
  labs(x = 'transcript feature', y = paste0('percent overlap (n = ', length(queryRegions), ')')) + 
  theme_bw(base_size = 14) + 
  theme(axis.text.x = element_text(angle = 90))
dt <- getTargetedGenesTable(queryRegions = queryRegions, 
                            txdbFeatures = txdbFeatures)
dt <- dt[order(transcripts, decreasing = TRUE)]

knitr::kable(dt[1:10,])
cvgF <- getFeatureBoundaryCoverage(queryRegions = queryRegions, 
                                   featureCoords = txdbFeatures$transcripts, 
                                   flankSize = 1000, 
                                   boundaryType = 'fiveprime', 
                                   sampleN = 10000)
cvgT <- getFeatureBoundaryCoverage(queryRegions = queryRegions, 
                                   featureCoords = txdbFeatures$transcripts, 
                                   flankSize = 1000, 
                                   boundaryType = 'threeprime', 
                                   sampleN = 10000)

cvgF$boundary <- 'fiveprime'
cvgT$boundary <- 'threeprime'

df <- rbind(cvgF, cvgT)

ggplot2::ggplot(df, aes(x = bases, y = meanCoverage)) + 
  geom_ribbon(fill = 'lightgreen', 
              aes(ymin = meanCoverage - standardError * 1.96, 
                  ymax = meanCoverage + standardError * 1.96)) + 
  geom_line(color = 'black') + 
  facet_grid( ~ boundary) + theme_bw(base_size = 14) 
cvgList <- calculateCoverageProfileList(queryRegions = queryRegions, 
                                        targetRegionsList = txdbFeatures, 
                                        sampleN = 10000)

ggplot2::ggplot(cvgList, aes(x = bins, y = meanCoverage)) + 
  geom_ribbon(fill = 'lightgreen', 
              aes(ymin = meanCoverage - standardError * 1.96, 
                  ymax = meanCoverage + standardError * 1.96)) + 
  geom_line(color = 'black') + theme_bw(base_size = 14) +
  facet_wrap( ~ feature, ncol = 3) 