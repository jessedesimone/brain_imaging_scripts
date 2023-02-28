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


# another option
# configure directories
top=`pwd`
data_dir=$top/data
mask_dir=$top/output/output_230222
out_dir=$top/stats/roistats ; mkdir -p $out_dir

# define mask files
ROI=`cat $mask_dir/roi_list`

# define subject list
SUB=`cat $data_dir/id_subj`

# compute ROIstats for each subject and each roi mask
for roi in ${ROI[@]}
do
    echo "++ computing roistats for ROI $roi"
    mask=$mask_dir/$roi/grp_wb_z_${roi}_fwer_mask.nii.gz

    for sub in ${SUB[@]}
    do
        echo "++ computing roistats for SUBJ $sub"
        infile=$data_dir/$sub/NETCORR_000_INDIV/WB_Z_ROI_${roi}.nii.gz[PearCorr#0]
        3dROIstats -mask_f2short -nzvoxels -nzmean -mask $mask $infile >> $out_dir/roistats_${roi}.txt

    done
done