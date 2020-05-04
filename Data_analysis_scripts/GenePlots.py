#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 11 09:48:09 2019
@author: Sandro-Hurtado
"""
from dask.distributed import Client, LocalCluster
from arboreto.algo import grnboost2 , genie3
import networkx as nx
from scipy.spatial.distance import pdist, squareform
import pandas as pd

#include seaborn library for visualization
import seaborn as sns

# Include Plotly library for visualization
import plotly.graph_objs as go
import chart_studio.plotly
import plotly.figure_factory as ff
import plotly
# print(plotly.__version__)
from plotly.offline import plot
chart_studio.tools.set_credentials_file(username='sandrohr', api_key='geLPhCC0443kFfOFbeU5')
from plotly.graph_objs import Figure,Data,Layout,Scatter3d,XAxis,YAxis,ZAxis,Scene,Margin,Annotations,Font,Annotation,Line, Marker

# Include Bokeh library for visualization
from math import pi
from bokeh.io import show
from bokeh.embed import components
from bokeh.models import (
    ColumnDataSource,
    HoverTool,
    LinearColorMapper,
    BasicTicker,
    PrintfTickFormatter,
    ColorBar,
)
from bokeh.plotting import figure,output_file, save
from bokeh.palettes import Viridis256

class GenePlots:
    
    def __init__(self, geneData):
       self.dfz = geneData

    def GeneRegulationNetwork(self, netthreshold, config):

        # Transpose the dataframe to get correct format to create the network
        dfT = self.dfz.transpose()

        # Get all the TF Gene names
        tf_names = list(dfT)

        # Create a Dask Client, just in case we want parellalize the algorithm
        client = Client(processes=False)
        
        # create dataframe network with columns --> TF, target Gene, Importance
        network =  grnboost2(expression_data= dfT, tf_names=tf_names, client_or_address=client)
        print("grnboost2")
        # We put a threshold because we have a lot of conections and we want to obtain a clear graph with the most representatives conected genes
        limit=network.index.size*netthreshold

        G=nx.from_pandas_edgelist(network.head(int(limit)), 'TF', 'target',['importance'], create_using=nx.Graph(directed=False) )

        N=len(list(G.node())) # number of genes nodes
        V=list(G.node())    # list of genes nodes

        Edges= list(G.edges())

        layt = {
            1 : nx.fruchterman_reingold_layout(G, dim=3),
            2 : nx.circular_layout(G, dim=3)
        }.get(config, nx.circular_layout(G, dim=3))

        laytN=list(layt.values())

        Xn=[laytN[k][0] for k in range(N)]# x-coordinates of nodes
        Yn=[laytN[k][1] for k in range(N)]# y-coordinates
        Zn=[laytN[k][2] for k in range(N)]# z-coordinates
        Xe=[]
        Ye=[]
        Ze=[]
        for e in Edges:
            Xe+=[layt[e[0]][0],layt[e[1]][0], None]# x-coordinates of edge ends
            Ye+=[layt[e[0]][1],layt[e[1]][1], None]
            Ze+=[layt[e[0]][2],layt[e[1]][2], None]

        trace1=Scatter3d(x=Xe,
                   y=Ye,
                   z=Ze,
                   mode='lines',
                   line=Line(color='rgb(125,125,125)', width=1),
                   hoverinfo='none'
                   )

        trace2=Scatter3d(x=Xn,
                       y=Yn,
                       z=Zn,
                       mode='markers+text',
                       textposition='top center',
                       name='genes',
                       marker=Marker(symbol='circle',
                                     size=3,
                                     color='#6959CD',
                                     colorscale='Viridis',
                                     line=Line(color='rgb(50,50,50)', width=1)
                                     ),
                       text=V,
                       hoverinfo='text'
                       )

        axis=dict(showbackground=False,
              showline=False,
              zeroline=False,
              showgrid=False,
              showticklabels=False,
              title=''
              )

        fig=Figure(data=Data([trace1, trace2]),
            layout = Layout(
                 title="Gene Regulatory Network",
                 width=1000,
                 height=1000,
                 showlegend=False,
                 scene=Scene(
                 xaxis=XAxis(axis),
                 yaxis=YAxis(axis),
                 zaxis=ZAxis(axis),
                ),
             margin=Margin(
                t=100
            ),
            hovermode='closest',
            annotations=Annotations([
                   Annotation(
                   showarrow=False,
                    text="Khaos Research Group",
                    xref='paper',
                    yref='paper',
                    x=0,
                    y=0.1,
                    xanchor='left',
                    yanchor='bottom',
                    font=Font(
                    size=20
                    )
                    )
                ]),
            ))

        plotly.offline.plot(fig,filename='3DNetworkx_.html', auto_open=False)
        script = plot(fig, output_type='div', include_plotlyjs=False ,show_link=True)
        #print(script)
        return script

    def Heatmap(self):
    
        self.dfz.index.name='Genes'
        self.dfz.columns.name = 'Muestras'
    
        dfej = pd.DataFrame(self.dfz.stack(), columns=['percentage']).reset_index()
    
        genes = list(self.dfz.index)
        muestras = list(self.dfz.columns)
    
        colors = ["#75968f", "#a5bab7", "#c9d9d3", "#e2e2e2", "#dfccce", "#ddb7b1", "#cc7878", "#933b41", "#550b1d"]
    #    colors = ['#084594', '#2171b5', '#4292c6', '#6baed6', '#9ecae1', '#c6dbef', '#deebf7', '#f7fbff']
        #colors = Viridis256
        mapper = LinearColorMapper(palette=colors, low=dfej.percentage.min(), high=dfej.percentage.max())
    
        source = ColumnDataSource(dfej)  #Contiene los datos que le hemos pasado en forma de columnas
    
        TOOLS = "hover,save,pan,box_zoom,reset,wheel_zoom"
    
        p = figure(title="Gene expression Heatmap",
                 x_range=genes, y_range=muestras,
                 x_axis_location="above", plot_width=900, plot_height=400,
                 tools=TOOLS, toolbar_location='below')
    
        p.grid.grid_line_color = None
        p.axis.axis_line_color = None
        p.axis.major_tick_line_color = None
        p.axis.major_label_text_font_size = "7pt"
        p.axis.major_label_standoff = 0
        p.xaxis.major_label_orientation = pi / 3
    
    #    Formamos un rectangulo
        p.rect(x='Genes', y='Muestras', width=1, height=1,
            source=source,
            fill_color={'field':'percentage', 'transform': mapper},
            line_color=None)
    
        color_bar = ColorBar(color_mapper=mapper, major_label_text_font_size="5pt",
                         ticker=BasicTicker(desired_num_ticks=len(colors)),
                         formatter=PrintfTickFormatter(format="%d"),
                         label_standoff=6, border_line_color=None, location=(0, 0))
        p.add_layout(color_bar, 'right')
    
        #rate: porcentaje
        p.select_one(HoverTool).tooltips = [
         ('value', '@percentage'),
         ('Gen','@Genes'),
         ('Sample','@Muestras')
         ]
    
#        show(p)      # show the plot
        #Me devuelve el script que contiene la gráfica y el div asociado
        script, div = components(p)
        print(script,div)
    
        return script,div
    
    def ClusterHeatmap(self):
    
        # Compute the correlation matrix
        genes = list(self.dfz.index)
        # Initialize figure by creating upper dendrogram
        figure = ff.create_dendrogram(self.dfz, orientation='bottom', labels=genes)
    
        for i in range(len(figure['data'])):
            figure['data'][i]['yaxis'] = 'y2'
    
        # Create Side Dendrogram
        dendro_side = ff.create_dendrogram(self.dfz, orientation='right')
        for i in range(len(dendro_side['data'])):
            dendro_side['data'][i]['xaxis'] = 'x2'
    
        # Add Side Dendrogram Data to Figure
        for data in dendro_side['data']:
            figure.add_trace(data)
    
        # Create Heatmap
        dendro_leaves = dendro_side['layout']['yaxis']['ticktext']
        dendro_leaves = list(map(int, dendro_leaves))
        #Distancias por parejas entre observaciones en el espacio n-dimensional.
        data_dist = pdist(self.dfz)
        #Convierte un vector de distancia de forma vectorial en una matriz de distancia de forma cuadrada.
        heat_data = squareform(data_dist)
        heat_data = heat_data[dendro_leaves,:]
        heat_data = heat_data[:,dendro_leaves]
    
        heatmap = [
            go.Heatmap(
                x = dendro_leaves,
                y = dendro_leaves,
                z = heat_data,
                colorscale = 'Blues'
            )
        ]
    
        heatmap[0]['x'] = figure['layout']['xaxis']['tickvals']
        heatmap[0]['y'] = dendro_side['layout']['yaxis']['tickvals']
    
        # Add Heatmap Data to Figure
        for data in heatmap:
            figure.add_trace(data)
    
        # Edit Layout
        figure['layout'].update({'width':800, 'height':800,
                                 'showlegend':False, 'hovermode': 'closest', 
                                 'title': 'Clustering Gene Expression Data'
                                 })
        # Edit xaxis
        figure['layout']['xaxis'].update({'domain': [.15, 1],
                                          'mirror': False,
                                          'showgrid': False,
                                          'showline': False,
                                          'zeroline': False,
                                          'ticks':""})
        # Edit xaxis2
        figure['layout'].update({'xaxis2': {'domain': [0, .15],
                                           'mirror': False,
                                           'showgrid': False,
                                           'showline': False,
                                           'zeroline': False,
                                           'showticklabels': False,
                                           'ticks':""}})
    
        # Edit yaxis
        figure['layout']['yaxis'].update({'domain': [0, .85],
                                          'mirror': False,
                                          'showgrid': False,
                                          'showline': False,
                                          'zeroline': False,
                                          'showticklabels': False,
                                          'ticks': ""})
        # Edit yaxis2
        figure['layout'].update({'yaxis2':{'domain':[.825, .975],
                                           'mirror': False,
                                           'showgrid': False,
                                           'showline': False,
                                           'zeroline': False,
                                           'showticklabels': False,
                                           'ticks':""}})
    
        # Plot!
        plotly.offline.plot(figure,filename='ClusterMap.html', auto_open=False)
#        plot(figure, output_type='div', include_plotlyjs=False, show_link=True)
        script = plot(figure, output_type='div', include_plotlyjs=False ,show_link=True)
        print(script)
    
        return script

    
    
    def sns_clusterMap(self):
        self.dfz.index.name='Genes'
        self.dfz.columns.name = 'Muestras'
        sns.set(color_codes=True)
        sns.clustermap(self.dfz)
    
    
