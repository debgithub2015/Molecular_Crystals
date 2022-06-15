#! /bin/bash
rm -rf out_molecule.dat
for j in *02/;do
echo  $j >> out_molecule.dat
cd $j/
grep -i 'Final energy' *.out | wc -l >> ../out_molecule.dat
cd ../
done
