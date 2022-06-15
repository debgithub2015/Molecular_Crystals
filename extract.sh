#!/bin/bash

dir=/cluster/projects/nn9650k/wake_oslo/debajit_molCrys/X23

arccos ()
{
    scale=3
    if (( $(echo "$1 == 0" | bc -l) )); then
        echo "a(1)*2" | bc -l
    elif (( $(echo "(-1 <= $1) && ($1 < 0)" | bc -l) )); then
        echo "scale=${scale}; a(1)*4 - a(sqrt((1/($1^2))-1))" | bc -l
    elif (( $(echo "(0 < $1) && ($1 <= 1)" | bc -l) )); then
        echo "scale=${scale}; a(sqrt((1/($1^2))-1))" | bc -l
    else
        echo "input out of range"
        return 1
    fi
}

for folder in $dir/test_*/;do
echo $folder
Zval=`echo "${folder##*/}"| cut -d '_' -f3`
echo $Zval
rm -rf $folder/*.txt
cd $folder/
echo 'system' $Zval > $folder/results_energy_crystal.txt
echo 'system' $Zval > $folder/results_energy_molecule.txt
for i in *;do
if [[ -d  "$i" ]]; then
cd $i/
converge=`cat *01.out | grep -i 'END of BFGS' | tail -1 | awk '{print }'`
echo $i
final_enthalpy=`cat *01.out|grep -i 'Final enthalpy' |tail -1| awk '{printf "%4.10f", $4*13.605698065894}'`
#final_energy=`cat *.out|grep -i '!' |tail -1| awk '{printf "%4.10f", $5*13.605698065894}'`
volume=`cat *01.out| grep -i 'new unit-cell volume' |tail -1| awk '{printf "%4.10f",  $8}'`
#lat_old=`cat *.out | grep -i 'CELL_PARAMETERS' | tail -1 | awk '{print $3}'` 
#len=${#lat_old}; 
#lat=`echo ${lat_old:0:len-1}`
#echo $lat >> $folder/results_energy.txt
a_11=`cat *01.out | grep -A1 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $1}'` 
a_12=`cat *01.out | grep -A1 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $2}'` 
a_13=`cat *01.out | grep -A1 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $3}'`
a_cell_param=`echo $a_11 $a_12 $a_13 | awk '{print sqrt($1*$1+$2*$2+$3*$3)}'`  
#echo $a_cell_param >> $folder/results_energy.txt
b_11=`cat *01.out | grep -A2 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $1}'` 
b_12=`cat *01.out | grep -A2 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $2}'` 
b_13=`cat *01.out | grep -A2 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $3}'`
b_cell_param=`echo $b_11 $b_12 $b_13 | awk '{print sqrt($1*$1+$2*$2+$3*$3)}'`  
c_11=`cat *01.out | grep -A3 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $1}'` 
c_12=`cat *01.out | grep -A3 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $2}'` 
c_13=`cat *01.out | grep -A3 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $3}'` 
c_cell_param=`echo $c_11 $c_12 $c_13 | awk '{print sqrt($1*$1+$2*$2+$3*$3)}'` 
alpha_1=`echo $b_11 $b_12 $b_13 $c_11 $c_12 $c_13 | awk '{print ($1*$4+$2*$5+$3*$6)}'`
angle_alpha=`echo ${alpha_1#-} $b_cell_param $c_cell_param | awk '{print $1/($2*$3)}'` 
beta_1=`echo $a_11 $a_12 $a_13 $c_11 $c_12 $c_13 | awk '{print ($1*$4+$2*$5+$3*$6)}'`
angle_beta=`echo ${beta_1#-} $a_cell_param $c_cell_param | awk '{print $1/($2*$3)}'` 
gamma_1=`echo $a_11 $a_12 $a_13 $b_11 $b_12 $b_13 | awk '{print ($1*$4+$2*$5+$3*$6)}'`
angle_gamma=`echo ${gamma_1#-} $a_cell_param $b_cell_param | awk '{print $1/($2*$3)}'` 
#echo $c_cell_param >> $folder/results_energy.txt
#a_lat=`echo $lat $a_cell_param | awk '{printf "%4.10f",$1*$2*0.52917721}'` 
#c_lat=`echo $lat $c_cell_param | awk '{printf "%4.10f",$1*$2*0.52917721}'` 
#a_lat=`cat *.out | grep -A1 'CELL_PARAMETERS' | tail -1 | awk '{printf "%4.10f", $1}'` 
#echo $i $converge >>  $folder/results_energy.txt
#echo $final_enthalpy ${a_lat#-} ${c_lat#-} $volume >> $folder/results_energy.txt
echo $i $final_enthalpy ${a_cell_param#-} ${b_cell_param#-} ${c_cell_param#-} $angle_alpha $angle_beta $angle_gamma $volume >> $folder/results_energy_crystal.txt
#echo $final_energy >> $folder/results_energy.txt
final_energy=`cat *02.out|grep -i '!' |tail -1| awk '{printf "%4.10f", $5*13.605698065894}'`
echo $i $final_energy >> $folder/results_energy_molecule.txt
cd ../
fi
done
cd ../../
done
