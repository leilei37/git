#The analyse of diversity of tissue expression
#1.1pca 
data1.gkin <- ibs(data_rna[, autosomal(data_rna)], weight="freq")
summary(data1.gkin[lower.tri(data1.gkin)])
which(data1.gkin==(min(data1.gkin)))
9718/298
which(data1.gkin[,33]==min(data1.gkin))
which(data1.gkin==(max(data1.gkin[lower.tri(data1.gkin)])))
9729/298
which(data1.gkin[,33]==(max(data1.gkin[lower.tri(data1.gkin)])))
hist(as.numeric(data1.gkin[lower.tri(data1.gkin)]))
#make distance matrix by kinship
data1.dist <- as.dist(0.5-data1.gkin)
  #get eigenvalue of each cluster
data1.mds <- cmdscale(data1.dist,k=3,eig =T)
dat_var<-data1.mds$eig
pca_var=dat_var/sum(dat_var)
pca_cvar=cumsum(dat_var)/sum(dat_var)

data1.mds <- cmdscale(data1.dist,k=3)
#kmeans cluster
km  <- kmeans(data1.mds, centers=3, nstart=1000)
cl1 <- names(which(km$cluster==1))#get sample name of each cluster 
cl2 <- names(which(km$cluster==2))
cl3 <- names(which(km$cluster==3))
#save sample name of each cluster 
write.table(cl3,'~/Documents/cl3.txt',row.names = F,col.names = F,quote = F)
#pca plot
#first make a dataframe of the cluster message
pcamak3<-data.frame(matrix(data1.mds,ncol = 3,nrow = 298))
row.names(pcamak3)<-row.names(data1.mds)
for (i in 1:298) {
  pcamak3[which(row.names(pcamak3)==cl1[i]),4]<-'cl1'
  pcamak3[which(row.names(pcamak3)==cl2[i]),4]<-'cl2'
}
#plot (by pc1&pc2 or  pc2&pc3)
png(filename = '~/Downloads/pca.png')
library(ggplot2)
qplot(pcama$X1, pcama$X2, data = pcama, colour = V5,xlab = 'PC1 11.48%',ylab = 'PC2 7.14%')+
  theme(legend.title=element_blank(),legend.key.size = unit(10, "pt"),axis.title.x = element_text(size = 10))
dev.off()
#1.2cluster
#forall
exp4<-exp_ds2
#pick rt,sh,lb and kn
exr<-exp_ds2[,1:298]#exr is a matrix that colnames are sample names and rownames are gene names.
exs<-exp_ds2[,299:596]
exl<-exp_ds2[,597:894]
exk<-exp_ds2[,1193:1490]
#test for cluster,pick 5 genes of each tissues,pick 5 samples of each tissues 
exp42<-exp4[,-which(colSums(is.na(exp4))==24399)]#select all no NA samples
#pick 5 same samples of each tissues 
repeat{
s5<-sample(298,100)
ex4<-cbind(exr[,s5],exs[,s5],exl[,s5],exk[,s5])
if(length(intersect(colnames(exp42),colnames(ex4)))!=400)next else break}

nu1<-sample(nu,100)
ex4<-cbind(exr[,nu1],exs[,nu1],exl[,nu1],exk[,nu1])
which(is.na(ex4[1,]))
#remove genes which no expressed in some samples
#ex43<-exp42[which(rowSums(is.na(exp42))==0),]
ex43<-ex4[which(rowSums(is.na(ex4))==0),]
ex44<-ex43[which(rowSums(ex43==0)==0),] 
ex45<-ex44
s20<-sample(length(ex44[,1]),5000)
ex45<-ex44[s20,]
ex45<-as.matrix(ex45)
samplename<-colnames(ex45)
sn<-data.frame(samplename)
sn[1:298,2]<-'RT'
sn[299:596,2]<-'SH'
sn[597:894,2]<-'LB'
sn[895:1192,2]<-'LT'
sn[1193:1490,2]<-'KN'
sn[1491:1788,2]<-'LD'
sn[1789:2086,2]<-'LN'
st<-sn
write.csv(samplename,'~/Downloads/allsample.csv')
write.csv(samplename,'~/Downloads/1samplegroup100.csv')
#write the 2nd colume by tissues
st<-read.csv('~/Downloads/1samplegroup100.csv')
st<-read.csv('~/Downloads/allsample.csv')
color.map <- function(st) { if (st[,2]=="RT") return('#037ef3')
  if (st[,2]=="SH") return('#f85a40') 
  if (st[,2]=="LB") return('#00c16e')
  if (st[,2]=="LT") return('#7552cc') 
  if (st[,2]=="KN") return('#f48924') 
  if (st[,2]=="LD") return('#ffc845') 
  if (st[,2]=="LN") return('#52565e')
}
cm<-c()#get the color behalf of tissue type
for (i in 1:length(st[,1])) {
  cm[i]<-color.map(st[i,])
}
#plot cluster heatmap
install.packages('gplots')
library(gplots)
png('~/Downloads/allclus.png',width = 400,height =400,units = 'mm',res = 500)
png('~/Downloads/4ti5000genegrob100t3.png',width = 400,height =400,units = 'mm',res = 500)
colorsChoice<- colorRampPalette(c("#eef4f9","#7ca7cd","#4584b6"))  #blue
heatmap.2(ex45,trace = 'none',dendrogram = 'both',cexRow=0.15, 
          cexCol=0.2, 
          scale = 'row',
          col=colorsChoice(5),
          breaks = c(0,0.5,1,1.5,2,2.5),
          ColSideColors = cm
)
dev.off()

dy<-read.csv('~/Downloads/LEI/data/??????.csv')
nr<-unique(as.character(dy[which(dy[,2]=='GRoot'),6]))
ns<-unique(as.character(dy[which(dy[,2]=='GShoot'),6]))
nl<-unique(as.character(dy[which(dy[,2]=='L3Base'),6]))
nk<-unique(as.character(dy[which(dy[,2]=='Kern'),6]))
Reduce(intersect,list(nr,ns,nl,nk))
nu<-c()
for (i in 1:201) {
nu<-append(nu,which(substr(colnames(exr)[1:298],5,length(exr))==Reduce(intersect,list(nr,ns,nl,nk))[i]))
  }
Reduce(intersect,list(nr,ns,nl,nk))
substr(colnames(exr)[1:298],5,length(exr))
