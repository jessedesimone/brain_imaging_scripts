#!/bin/bash
: 'two sample ttest using AFNI 3dttest++ fcn'

# configure directories
top=`pwd`
data_dir=<path/to/dir>                              #infiles
out_dir=<path/to/dir> ; mkdir -p $out_dir		    #outfiles
script_dir=$out_dir/scripts; mkdir -p $script_dir   #ttest file

# define group or condition
tag=<tag>

# define groups
GRP=( <group1> <group2> )

# enter data dir
cd $data_dir

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
#echo "-paired \\" >> $cmd_file                                 #uncomment if paired t-test
#echo "-covariates '<covariates file>' \\">>$cmd_file           #uncomment if using covariates

ia=A
for grp in ${GRP[@]}
do
    echo "-set${ia} $grp \\" >> $cmd_file
    
    # define subject list
	#SUB=( <sub01> <sub02> <sub03> )
    SUB=`cat <path/to/grp/list>`
    for sub in ${SUB[@]}
	do
        # define infile
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
    ia=B
done

#run cmd file
tcsh -xef $cmd_file