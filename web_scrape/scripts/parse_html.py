from BeautifulSoup import BeautifulSoup
import os,pdb

#where the html files are stored
folder = "~/76ers/web_scrape/data/html/" #include trainling slash!
fnames = os.listdir(os.path.expanduser(folder))
fnames.sort() #chronological order given the date format. 

#loop through the files (days) and create a csv file. 
#each row is a team that played for that day. 

for dt in fnames: 
    #with open(os.path.expanduser(folder) + dt,'r') as f:
    with open(os.path.expanduser(folder)+'20131108.html') as f: #to test a single file.
        table = BeautifulSoup(f.read())
        id = 0 #uniqe game id I am constructing
        #pdb.set_trace()
        #loop through the matches (divs)
        for row in table.findAll('div',{'class': 'event-holder holder-complete'}):
        #for row in table.find('div',{'class': 'eventLines'}):
            id+=1
            d = {}
            counter = 0
            #loop through the teams
            for team in row.find('div',{'class': "el-div eventLine-team"}).findAll('span',{'class': 'team-name'}):
                d[counter]=team.string.lower().strip().replace('.','')
                counter+=1

            #loop through the different odds and build csv    
            for odds in row.findAll('div',{'class': "el-div eventLine-book"}):
                counter=0
                for odd in odds.findAll('div'):
                    if odd.b.string:
                        temp = odd.b.string.encode('utf-8').split('\xc2\xa0') #strange html character need to split on to separate spread from odds
                        odds = temp[-1]
                        spread = re.sub('\\xc2\\xbd','.5',temp[0]) #replace 1/2 with .5
                        
                        #odd.b.string.encode('utf-8').split('xc2\xa0')
                        #note half symbol used in utf-8 is: '\xc2\xbd'
                        d[counter]+=","+odds+","+spread
                    else:
                        d[counter]+=",\N,\N"
                    counter+=1
            counter=0        

            time = row.find('div',{'class': "el-div eventLine-time"}).div.string
            d[0]+=","+time+","+dt.strip('.html')+","+str(id)+","+"away" 
            d[1]+=","+time+","+dt.strip('.html')+","+str(id)+","+"home"
            print d[0]#.encode('utf-8')
            print d[1]#.encode('utf-8')

