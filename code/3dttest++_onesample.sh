#!/bin/bash
: 'one sample ttest using AFNI 3dttest++'

# configure directories
top=`pwd`
data_dir=<path/to/dir>                              #infiles
out_dir=<path/to/dir> ; mkdir -p $out_dir		    #outfiles
script_dir=$out_dir/scripts; mkdir -p $script_dir   #ttest file

# define group or condition
tag=test

# enter data dir
cd $data_dir

# define list of subjects
SUB=( <sub01> <sub02> <sub03> )
#SUB=`cat id_subj`

# create tcsh script to run ttest
cmd_file=$script_dir/cmd_tt++.onesamp_${tag}

# define result file naming
result_file=$out_dir/tt++.onesamp_${tag}.nii.gz

# create cmd file
touch $cmd_file

echo "#!/bin/tcsh" > $cmd_file
echo "3dttest++ \\" >> $cmd_file
echo "-prefix '$result_file' \\" >> $cmd_file
echo "-Clustsim \\" >> $cmd_file
echo "-mask '<mask file>' \\" >> $cmd_file
#echo "-covariates '<covariates file>' \\">>$cmd_file           #uncomment if using covariates
echo "-setA $tag \\" >> $cmd_file

for sub in ${SUB[@]}
do
    #define infile
    infile=<infile>

    # define volume or sub-brick identifier
    sb=<sub-brick e.g. PearCorr#0>

    if [ ! -f $infile ]; then
        echo "++ no input file for $sub"
        echo "terminating script"
        exit 1
    else
        echo "$sub '$infile[$sb]' \\" >> $cmd_file
    fi 

done

#run cmd file
tcsh -xef $cmd_file