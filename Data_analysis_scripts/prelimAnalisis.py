import os
path='/home/antonio/Anaconda_Projects/Python_Projects/generegulatorynetworks'
os.chdir(path)
import parse2 as pr
import numpy as np
import normalize2 as nor
import MongoDBConect as mongo


def run_norm_mongodb(id_list):
    datalist=[]
    flags=[]  
    genes=[]
    
    mongodb = mongo.MongoConecction()
    for id in id_list:
        dt = mongodb.read_from_mongo(id)
        dt=pr.parse(dt)
        if (len(genes)>0):
            if (np.all(np.array(dt[0])==np.array(genes))!=True):
                print('Gene lists do not match')        
                exit()
        genes=dt[0]             # Gene name
        datalist.append(dt[2])  # Gene values
        flags.append(dt[3])
        

    return nor.process(genes, dt[1], id_list, datalist, flags)










