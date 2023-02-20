#!/bin/bash

: 'AFNI 3dROIstats fcn to display statistics over masked regions
see https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dROIstats.html'

# configure directories
top=`pwd`
data_dir=<path/to/dir>                              #infiles
mask_dir=<path/to/dir>                              #mask files or ROIs
out_dir=<path/to/dir> ; mkdir -p $out_dir		    #outfile

# define mask files
#mask=( roi01 roi02 roi03)
ROI=`cat $mask_dir/roi_list`

# define infile name
infile=<infile name>

# define volume or sub-brick identifier
vol=<sub-brick e.g. PearCorr#0>

# define subject list
#SUB=( sub01 sub02 sub03 )
SUB=`cat $data_dir/id_subj`

# compute ROIstats for each subject and each roi mask
for sub in ${SUB[@]}
do
    echo "++ computing ROI stats for subj: $sub"
    cd $data_dir/$sub
    
    for roi in ${ROI[@]}
    do
        3dROIstats -mask_f2short -nzvoxels -nzmean -nzsigma -mask $roi ${infile}[${vol}] >> $out_dir/roistats_${roi}.xls
    done
done