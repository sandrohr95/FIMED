cd /home/antonio/Anaconda_Projects/Python_Projects/generegulatorynetworks/
#/home/khaosdev/anaconda3/bin/python --version
/home/antonio/anaconda3/bin/python -c "import GeneExpressions as ge;import GenePlots as gp;genEx = ge.GeneExpressions($1, $2, $3);data = genEx.load_gexpressions();grnPlots = gp.GenePlots(data);grnPlots.ClusterHeatmap()"