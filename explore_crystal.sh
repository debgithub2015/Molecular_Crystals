#! /bin/bash
rm -rf out_crystal.dat
for j in *01/;do
echo  $j >> out_crystal.dat
cd $j/
grep -i 'Final enthalpy' *.out | wc -l >> ../out_crystal.dat
cd ../
done
