#! /bin/bash
pwdir='/cluster/projects/nn9650k/SysAdm/analysis_code/bin/pw.x'
dir='/cluster/projects/nn9650k/wake_oslo/debajit_molCrys/X23'
Zval=`echo $1`
echo $Zval
mkdir $dir/test_$Zval
pwd
cd $dir/input_files_2x2x2/
pwd
for i in *.in; do
echo $i
file=`echo $i | cut -d '.' -f1`
echo $file
mkdir $dir/test_$Zval/$file
cp $dir/input_files_2x2x2/$i  $dir/test_$Zval/$file/
cd $dir/test_$Zval/$file/
#sed -i 's/vdw-df/vdw-df2/g' $i
#sed -i 's/vdw-df/sla pw b86r vdW2/g' $i
#sed -i 's/vdw-df/vdw-df-obk8/g' $i
#sed -i 's/vdw-df/vdw-df-cx/g' $i
#sed -i 's/vdw-df/rvv10/g' $i
sed -i 's/vdw-df/vdw-df3-opt1/g' $i
#sed -i 's/vdw-df/vdw-df3-opt2/g' $i
#sed -i 's/vdW-DF/sla pw ob8n vdW1/g' $i
#sed -i 's/vdW-DF/rvv10-scan/g' $i
#sed -i 's/vdW-DF/sla pw b86n vdW2/g' $i
#sed -i 's/pseudo/all_pbe_UPF_v1.5-1/g' $i
#sed -i 's/v1.5/v1.5-6/g' $i
#sed -i 's/v1.5/v1.5-3/g' $i
cat > 'run.sh' << EOF
#!/bin/bash

#SBATCH --job-name=$file
#SBATCH --output="%j.o"
#SBATCH --error="%j.e"
#SBATCH --account=nn9650k
#SBATCH --nodes=4
#SBATCH --time=02:00:00

ulimit -s unlimited

module load QuantumESPRESSO/6.5-intel-2019b 

mpirun $pwdir < $file.in > $file.out

echo "DONE"

EOF
#sbatch run.sh
cd  $dir/input_files_2x2x2
done

cd $dir
