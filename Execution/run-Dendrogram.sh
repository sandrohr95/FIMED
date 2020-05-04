cd /home/dani/Khaos_Project/FIMED/Data_analysis_scripts
#/home/khaosdev/anaconda3/bin/python --version
/home/dani/anaconda3/envs/env/bin/python -c "import GeneExpressions as ge;import GenePlots as gp;genEx = ge.GeneExpressions($1, $2, $3);data = genEx.load_gexpressions();grnPlots = gp.GenePlots(data);grnPlots.ClusterHeatmap()"