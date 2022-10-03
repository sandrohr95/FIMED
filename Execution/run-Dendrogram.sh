cd /home/antonio/Anaconda_Projects/Python_Projects/FIMED-Analysis/Gene_Regulation_Networks/
#/home/khaosdev/anaconda3/bin/python --version
#source grnenv/bin/activate
#which python
/home/antonio/Anaconda_Projects/Python_Projects/FIMED-Analysis/Gene_Regulation_Networks/grnenv/bin/python -c  "import pre_processing.gene_expression as ge;
import data_visualization.gene_plot as plots;
genEx = ge.GeneExpressions($1, $2, $3);
data = genEx.load_gene_expressions();
plot = plots.GenePlots(data);
plot.cluster_heat_map()"