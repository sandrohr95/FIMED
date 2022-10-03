cd /home/antonio/Anaconda_Projects/Python_Projects/FIMED-Analysis/Gene_Regulation_Networks/
#/home/khaosdev/anaconda3/bin/python --version
#source grnenv/bin/activate
#which python
/home/antonio/Anaconda_Projects/Python_Projects/FIMED-Analysis/Gene_Regulation_Networks/grnenv/bin/python -c "import pre_processing.gene_expression  as ge;
import run_grn_algorithms as run; genEx = ge.GeneExpressions($1, $2, $3);data = genEx.load_gene_expressions();run.run_grn_algorithms(data, $4, $5, $6)"