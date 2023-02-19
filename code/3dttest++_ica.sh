#!/bin/bash
: 'two sample ttest using AFNI 3dttest++ on independent fmri components
will create and run ttest file for each independent component'

# configure directories
top=`pwd`
data_dir=<path/to/dir>                              #infiles
out_dir=<path/to/dir>; mkdir -p $out_dir		    #outfiles
script_dir=$out_dir/scripts; mkdir -p $script_dir   #ttest file

# define groups
GRP=( <group1> <group2> )

# enter data dir
cd $data_dir

#for ((i=0;i<1;i++))		#uncomment for t-test of first component
for ((i=1;i<20;i++))		#uncomment for t-test of all other components; set to max (e.g., set to 30 if 30 components)
do

    # define component
    : 'in AFNI, the first component is labelled as sub-brick 0'
	comp=`expr $i + 1`

    # create tcsh script to run ttest
	cmd_file=$script_dir/cmd_tt++.twosamp_${comp}

    # define result file naming
	result_file=$out_dir/tt++.twosamp_${comp}.nii.gz

    # create cmd file
    touch $cmd_file

    echo "#!/bin/tcsh" > $cmd_file
	echo "3dttest++ \\" >> $cmd_file
    echo "-prefix $result_file \\" >> $cmd_file
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
            if [ ! -f $infile ]; then
                echo "++ no input file for $sub"
                exit 1
            else
                echo "$sub '$data_dir/$infile[$i]' \\" >> $cmd_file
            fi
		done
		ia=B
	done

    #run cmd file
    tcsh -xef $cmd_file
done