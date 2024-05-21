dir=`pwd`
result=$dir/../results/HEK293T_results
data=$dir/HEK293T
covlist='0 0.5 1 2 5 10 20 30 50 80 100 150'
testlist='2 5 10 20 30 50 80 100 150 192'

mkdir -p $data
mkdir -p $dir/figure/HEK293T

#=============================
# collect results
#=============================
# individual-level
# transmeta
if [ "A" == "B" ];then
	t=transmeta

	mkdir -p $data/$t/individual
	for num in $testlist;
	do
		mat=$data/$t/individual/$num.match
		pre=$data/$t/individual/$num.pre
		
		rm -rf $mat
                rm -rf $pre

		for ((i=1;i<=$num;i++))
		do
			#stats=$result/$t/merge_$num/individual.${i}.stats
			stats=$result/$t/merge_$num/individual.${i}.other.stats
			less $stats | awk '{print $4}' | sed -n '18p' >> $mat
			less $stats | awk '{print $6}' | sed -n '14p' >> $pre
		done

	done
fi

# psiclass
if [ "A" == "B" ];then
        t=psiclass

        mkdir -p $data/$t/individual
        for num in $testlist;
        do
                mat=$data/$t/individual/$num.match
                pre=$data/$t/individual/$num.pre

                rm -rf $mat
                rm -rf $pre

                for ((i=0;i<$num;i++))
                do
			#stats=$result/$t/merge_$num/cov_1/individual.${i}.stats
                        stats=$result/$t/merge_$num/cov_1/individual.${i}.other.stats
                        less $stats | awk '{print $4}' | sed -n '18p' >> $mat
                        less $stats | awk '{print $6}' | sed -n '14p' >> $pre
                done

        done
fi

# aletsch
if [ "A" == "A" ];then
        t=aletsch

        mkdir -p $data/$t/individual
        for num in $testlist;
        do
                mat=$data/$t/individual/$num.match
                pre=$data/$t/individual/$num.pre

                rm -rf $mat
                rm -rf $pre

                for ((i=1;i<=$num;i++))
                do
                        #stats=$result/$t/merge_$num/individual.${i}.stats
                        stats=$result/${t}-link/raw-assemblies/merge_$num/${i}.other.stats
                        less $stats | awk '{print $4}' | sed -n '18p' >> $mat
                        less $stats | awk '{print $6}' | sed -n '14p' >> $pre
                done

        done
fi
