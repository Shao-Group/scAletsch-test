dir=`pwd`
result=$dir/../results/Mouse-Fibroblast_results
data=$dir/Mouse-Fibroblast
covlist='0 0.5 1 2 5 10 20 30 50 80 100 150'
testlist='2 5 10 30 50 80 100 150 200 300 369'
#testlist='10 50 100 200 300 369'

mkdir -p $data
mkdir -p $dir/figure/Mouse-Fibroblast

#=============================
# collect results
#=============================
# individual-level
# transmeta
if [ "A" == "b" ];then
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
if [ "A" == "b" ];then
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
                        stats=$result/$t/merge_$num/individual.${i}.other.stats
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
