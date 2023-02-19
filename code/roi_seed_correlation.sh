#!/bin/bash
: '
A bash script to compute voxel-wise correlation maps (pearson and z-score) for a list of ROIs (seed regions)
User must first create binary mask files for each seed region then add to seed_list.txt
Module resamples seed location to resolution of input file (typically the error time series file generated from fmri preprocessing)
Module computes the average time series for voxels that comprise the seed region
Module calculates pearson correlation coefficient between average seed time series and all other voxels within masked region
Module performs fisher r-to-z transformation on pearson correlation coefficients

Input files:
- Error time series (errts) output file from afni_proc.py preprocessing (or a similar preproc pipeline)
- Text file with list of ROIs as binary mask files

Output files:
- Pearson correlation coefficient map
- Fisher r-to-z transformed pearson correlation coefficient map
'

#configuration
data_dir=<path/to/dir>				#location of errts files
roi_dir=<path/to/dir>				#location of roi masks and seed_list.txt
out_dir=<path/to/dir>				#location of output files

# define infiles
infile=<path/to/infile>				#error time series file (errts)
mask=<path/to/brain/mask>			#restrict correlation map to masked region

# define roi seed list
ROI=`cat $roi_dir/seed_list.txt`

if [ ! -f $infile ]; then
	echo "input file does not exist"
	exit 1
else
	for roi in ${ROI[@]}
	do
		# resample to infile resolution
		if [ ! -f ${roi_dir}/${seed}_r.nii ]; then
			3dresample -master $infile -rmode NN -prefix ${roi_dir}/${seed}_r.nii -inset ${roi_dir}/${roi}.nii
  		fi

		# create 1D file of average ROI time-series
		if [ ! -f ${roi_dir}/${roi}.1D ]; then
			3dROIstats -quiet -mask_f2short -mask ${roi_dir}/${seed}_r.nii $infile > ${roi_dir}/${roi}.1D
		fi

		# create pearson correlation map
		if [ ! -f ${out_dir}/${roi}_pmap.nii ]; then
			3dTcorr1D -pearson -mask $mask -prefix ${out_dir}/${roi}_pmap.nii $infile ${roi_dir}/${roi}.1D
		fi

		# create fisher r-to-z transformed correlation map
		if [ ! -f ${out_dir}/${roi}_zmap.nii ]; then
			3dcalc -a ${out_dir}/${roi}_pmap.nii -expr 'atanh(a)' -prefix ${out_dir}/${roi}_zmap.nii
		fi

	done

fi