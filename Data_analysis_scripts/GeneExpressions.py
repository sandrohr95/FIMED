#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 11 10:17:56 2019

@author: Sandro-Hurtado
"""
import os
from sklearn.preprocessing import MinMaxScaler
from scipy import stats as sst
import pandas as pd
import findStable as fs
import prelimAnalisis as pa
import subprocess 
import MongoDBConect as mongo

path='/home/antonio/Anaconda_Projects/Python_Projects/generegulatorynetworks'
os.chdir(path) 

"""
This class preprocess the data and create a geneExpression dataframe in a proper form to work with 
"""


class GeneExpressions:
    
    def __init__(self, idList, labelList, percentage):
        self.idList = idList
        self.labelList = labelList
        self.percentage = percentage
        self.dfz = pd.DataFrame()
       
    def load_gexpressions(self):
        os.getcwd()
        res=pa.run_norm_mongodb(self.idList)
        cont=0
        df=pd.DataFrame(index=res[cont].tolist())
    
        # If no option label is selected the name of the sample will be displayed
        if len(self.labelList) <2:
            self.labelList = []
            for id_sample in self.idList:
                mongodb = mongo.MongoConecction()
                label = mongodb.get_sample_name(id_sample)
                self.labelList.append(label)
        
        for i in self.labelList:
            cont += 1
            df[i]=res[cont].tolist()  
            
#        print(df)
        # obtain unstable genes 
        ngenes=int(df.index.size*self.percentage)
        
        unstable_genes=fs.findUnstable(df.values,ngenes)

        # select unstable genes from dataframe to plot
        M=pd.DataFrame()
        for g in unstable_genes:
            M=pd.concat([M,df.iloc[[g]]])
        # transform to zscope in axis 1 (rows)
        dfzs1=sst.zscore(M.values, axis=1, ddof=1)
#        print(dfzs1)
        self.dfz= pd.DataFrame(index=M.index,data=dfzs1,columns=self.labelList)
        
        return self.dfz    
    
   
    # Save dataframe in HDFS for workflow process
    def save_dataframe_HDFS(self,name_csv):
        self.dfz.to_csv(name_csv)
        # create path HDFS --> hdfs dfs -mkdir /HDFS
        rutaOrigen='/home/khaosdev/AnacondaProjects/MongoPGenes/generegulatorynetworks/dataset1.csv'
        rutaDestino='/home/khaosdev/AnacondaProjects/MongoPGenes/generegulatorynetworks/HDFS'
        subprocess.call(['hdfs', 'dfs', '-mv', rutaOrigen,rutaDestino])
        
     
    
    # Normalized dataframe (range 0-1) for JMetal algorithms
    def normalized_DF(self):
        df_invert = self.dfz.transpose()
        columns = list(df_invert.columns)    
        scaler = MinMaxScaler()
        scaled_df = scaler.fit_transform(df_invert)
        scaled_df = pd.DataFrame(scaled_df, index= self.labelList, columns=columns)
        scaled_df.to_csv("Normalized_DF.csv", sep='\t')    
    

