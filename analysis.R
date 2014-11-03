#load packages
library(data.table)
library(reshape2)

#read in Data
odds = fread('C:/Users/hgerard/Downloads/cut_data.csv',header=FALSE)
setnames(odds,c("team","score","odds","spread","date","id","home"))

##a few transformations

#convert odds to decimal format (as opposed to American format when collected)
odds[,odds:=as.double(odds)]
odds[,odds:=ifelse(odds<0,100/abs(odds)+1,abs(odds)/100+1)]

#covert spread and score to float and int. 
odds[,spread:=as.double(spread)]
odds[,score:=as.integer(score)]

#reshape so each row is now a game with 'home' and 'away' teams as separate fields. 
home = odds[home=='home']
away = odds[home=='away']
all = merge(home,away,by=c("id","date"),suffixes=c(".h",".a"))

#create spread result variable (did a team 'cover the spread')
all[,cover:=ifelse(score.h+spread.h > score.a,'home','away')]

#betting markets take a commission. Give back this take that implied probabilites sum to 1. 
all[,take:=1/odds.h+1/odds.a]
all[,odds.h:=odds.h*take]
all[,odds.a:=odds.a*take]

##cumulative and net return calculations

#construct return to $1 bet on each team in each game
all[,ret.h:=ifelse(cover==home.h,odds.h-1,-1)]
all[,ret.a:=ifelse(cover==home.a,odds.a-1,-1)]

#tally up cumulative return to always investing $1 on the same team over the season
final = rbind(all[,list(team=team.h,ret=ret.h)],all[,list(team=team.a,ret=ret.a)])
returns = final[,list(N=sum(!is.na(ret)),cumulative_ret=sum(ret,na.rm=TRUE)),by="team"]

#calculate net return
returns[,pct_ret:=cumulative_ret*100/N]

#take top and bottom 10 for graph 
top = returns[N>10][order(-pct_ret)][1:10]
bottom = returns[N>10][order(pct_ret)][1:10]

#plot with ggplot
top[,type:='top 10']
bottom[,type:="bottom 10"]
data = rbind(top,bottom)
data[team=="william &amp; mary",team:='william & mary']
g = ggplot(data=data,aes(x=reorder(team,pct_ret),y=pct_ret,fill=type,alpha=0.7,label=team))+
  geom_bar(stat="identity",position="dodge")+
  coord_flip()+
  geom_text(size=6,fontface="bold",alpha=1)+
  theme_bw()+
  xlab("")+
  ylab("Net Return (%)")+
  theme(legend.position="none",axis.text.y=element_blank(),axis.ticks.y=element_blank(),axis.text.x=element_text(size=15),axis.title.x=element_text(size=20),plot.title=element_text(size=24))+
  ylim(-100,100)+
  ggtitle("Top Over- and Under-Performing Teams \n Relative to Market Expectations 2013/14 NCAA Season")
#print(g)
ggsave('C:/Users/hgerard/Downloads/final_figure.pdf')
ggsave('C:/Users/hgerard/Downloads/final_figure.png')