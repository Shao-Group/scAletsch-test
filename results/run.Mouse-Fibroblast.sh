#!/bin/bash
dir=`pwd`
data=$dir/../data/Mouse-Fibroblast/zUMIs_output/demultiplexed
index=$dir/Mouse-Fibroblast_index
#index=/datadisk1/qqz5133/single-cell/sc3/result/mouse_data
ref=$dir/../data/mouse/Mus_musculus.GRCm39.109.gtf
#ref=/datadisk1/qqz5133/single-cell/sc3/ref/mouse/Mus_musculus.GRCm39.104.gtf
scallop2=$dir/../programs/scallop2
stringtie2=$dir/../programs/stringtie
linkmerge=$dir/../programs/linkmerge
transmeta=$dir/../programs/TransMeta/TransMeta
psiclass=$dir/../programs/psiclass/psiclass
gffcompare=$dir/../programs/gffcompare
gtfcuff=$dir/../programs/gtfcuff
result=$dir/Mouse-Fibroblast_results

covlist='0 0.5 1 2 5 10 20 30 50 80 100 150'
testlist='2 5 10 30 50 80 100 150 200 300 369'
#testlist='10 50 100 200 300 369'
#testlist='369'

# step 0: check to-be-used tools
if [ "A" == "b" ];then
	echo "================================================================="
	echo "Check if to-be-used tools are properly linked..."
	echo "================================================================="
	if [ -e $scallop2 ];then
		echo -e "Tool Scallop2 found successfully!"
	else
		echo -e "Tool Scallop2 not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
		echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
    		exit 1
	fi

	if [ -e $stringtie2 ];then
                echo -e "Tool StringTie2 found successfully!"
        else
                echo -e "Tool StringTie2 not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

        if [ -e $linkmerge ];then
                echo -e "Tool Linkmerge found successfully!"
        else
                echo -e "Tool Linkmerge not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

	if [ -e $transmeta ];then
                echo -e "Tool TransMeta found successfully!"
        else
                echo -e "Tool TransMeta not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

	if [ -e $psiclass ];then
                echo -e "Tool PsiCLASS found successfully!"
        else
                echo -e "Tool PsiCLASS not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

	if [ -e $gffcompare ];then
                echo -e "Tool gffcompare found successfully!"
        else
                echo -e "Tool gffcompare not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

	if [ -e $gtfcuff ];then
                echo -e "Tool gtfcuff found successfully!"
        else
                echo -e "Tool gtfcuff not found in directory 'programs'.\nPlease follow the instructions in 'Step 1: Download and Link Tools' to properly download and link all necessary tools to the directory 'programs'."
                echo -e "\nNote: Tools are not downloaded automatically. Users need to download and/or compile all required tools, and then link them to 'programs' directory before running experiments.\n"
                exit 1
        fi

	echo -e "All To-be-used tools found successfully!"

fi


#============================================
# create index for cells
#=============================================
if [ "A" == "B" ];then
        mkdir -p $index
        cd $index

        i=1
        for k in `ls $data/*.demx.bam`
        do
                if [ "$i" -lt "500"  ]; then
                        ln -sf $data/$k .
                        echo "cell #$i: $k" >> index.list
                        mv $k $i.bam
                        let i++
                fi
        done
fi


#============================================
# assembly and evaluate
#============================================
# TransMeta
if [ "A" == "B" ];then
        echo "Running Transmeta..."
	
	cur=$result/transmeta
        mkdir -p $cur
	cd $cur

	# generate job list
	joblist=$cur/jobs.list
	rm -rf $joblist

	for num in $testlist;
	do
		list=$cur/$num.list
		rm -rf $list

		for ((i=1;i<=$num; i++))
        	do
                	echo "$index/$i.bam" >> $list
        	done

		mkdir -p $cur/merge_$num

		script=$cur/$num.sh
		rm -rf $script
		#echo "$transmeta -B $list -s unstranded -o $cur/merge_$num > $cur/merge_$num/merge_$num.log" > $script
		#echo "cp $cur/merge_$num/TransMeta.gtf $cur/merge_$num/TransMeta-2.gtf" >> $script
		#for cov in $covlist;
		#do
			#echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov.stats $cur/merge_$num/TransMeta-$cov.gtf" >> $script
			#echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/TransMeta-$cov.gtf > $cur/merge_$num/TransMeta-$cov-otherchrm.gtf" >> $script
                        #echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov-otherchrm.stats $cur/merge_$num/TransMeta-$cov-otherchrm.gtf" >> $script
		#done

		# gffcompare individual-level
                for ((j=1;j<=$num; j++))
                do
                        echo "$gffcompare -r $ref -o $cur/merge_$num/individual.${j}.stats $cur/merge_$num/TransMeta.bam$j.gtf" >> $script
                        echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/TransMeta.bam$j.gtf > $cur/merge_$num/TransMeta.bam$j.otherchrm.gtf" >> $script
                        echo "$gffcompare -r $ref -o $cur/merge_$num/individual.${j}.other.stats $cur/merge_$num/TransMeta.bam$j.otherchrm.gtf" >> $script
                done

		chmod +x $script
		echo $script >> $joblist
	done

	cat $joblist | xargs -L 1 -I CMD -P 12 bash -c CMD 1> /dev/null 2> /dev/null

	echo "Finish Transmeta."
fi

# PsiCLASS
if [ "A" == "B" ];then
        echo "Running PsiCLASS..."

        cur=$result/psiclass
        mkdir -p $cur
        cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                list=$cur/$num.list
                rm -rf $list

                for ((i=1;i<=$num; i++))
                do
                        echo "$index/$i.bam" >> $list
                done

                mkdir -p $cur/merge_$num

                script=$cur/$num.sh
		rm -rf $script
		#for cov in $covlist;
		#do
			#mkdir -p $cur/merge_${num}/cov_$cov
                	#echo "$psiclass --lb $list -o $cur/merge_$num/cov_$cov/ --vd $cov -p 10 > $cur/merge_$num/cov_$cov/merge_${num}_$cov.log" >> $script
                        #echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov.stats $cur/merge_$num/cov_$cov/psiclass_vote.gtf" >> $script
                	#echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/cov_$cov/psiclass_vote.gtf > $cur/merge_$num/cov_$cov/psiclass_vote-otherchrm.gtf" >> $script
                        #echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov-otherchrm.stats $cur/merge_$num/cov_$cov/psiclass_vote-otherchrm.gtf" >> $script
		#done

		# gffcompare individual-level
                for ((j=0;j<$num; j++))
                do
                        echo "$gffcompare -r $ref -o $cur/merge_$num/cov_1/individual.${j}.stats $cur/merge_$num/cov_1/psiclass_sample_$j.gtf" >> $script
                        echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/cov_1/psiclass_sample_$j.gtf > $cur/merge_$num/cov_1/psiclass_sample_$j.otherchrm.gtf" >> $script
                        echo "$gffcompare -r $ref -o $cur/merge_$num/individual.${j}.other.stats $cur/merge_$num/cov_1/psiclass_sample_$j.otherchrm.gtf" >> $script
                done

                chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 12 bash -c CMD 1> /dev/null 2> /dev/null

        echo "Finish PsiCLASS."
fi

# scallop2 - linkmerge
# step 1: run scallop2 to generate full and non-full transcripts
if [ "A" == "B" ];then
        echo "generating Scallop2's assemblies..."

        sgtf=$result/sc2-link/raw-assemblies
        mkdir -p $sgtf
        cd $sgtf

        joblist=$sgtf/jobs.list
        rm -rf $joblist
        for((i=1;i<=369;i++));
        do
                script=$sgtf/$i.sh
		rm -rf $script
                echo "$scallop2 -i $index/$i.bam -o $sgtf/$i.star.scallop2.gtf -f $sgtf/nf.$i.star.scallop2.gtf > $sgtf/$i.star.scallop2.log" > $script
                echo "$gffcompare -r $ref -o $i.f $sgtf/$i.star.scallop2.gtf" >> $script
		echo "$gffcompare -r $ref -o $i.nf $sgtf/nf.$i.star.scallop2.gtf" >> $script
		templist=$sgtf/$i.list
                echo "$sgtf/$i.star.scallop2.gtf" > $templist
                echo "$sgtf/nf.$i.star.scallop2.gtf" >> $templist
                echo "$linkmerge union $templist $sgtf/$i.star.scallop2.fnf.gtf" >> $script
		echo "$gffcompare -r $ref -o $i.fnf $sgtf/$i.star.scallop2.fnf.gtf" >> $script

                chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 20 bash -c CMD 1> /dev/null 2> /dev/null

fi

if [ "A" == "b" ];then
        echo "Running Scallop2 - Link..."

        sgtf=$result/sc2-link/raw-assemblies
        cur=$result/sc2-link
        cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                list=$cur/$num.list
                rm -rf $list

                for ((i=1;i<=$num; i++))
                do
                        echo "$sgtf/$i.star.scallop2.fnf.gtf" >> $list
                done

                mkdir -p $cur/merge_$num

                script=$cur/$num.sh
                rm -rf $script
                echo "$linkmerge link-merge $list $cur/merge_$num/linkmerge_$num > $cur/merge_$num/merge_$num.log" > $script
                echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}.stats $cur/merge_$num/linkmerge_$num.gtf" >> $script
                #echo "$gtfcuff roc $cur/merge_$num/merge_${num}.linkmerge_$num.gtf.tmap 114718 cov > $cur/merge_$num/linkmerge_$num.roc.txt" >> $script

                chmod +x $script
                echo $script >> $joblist
        done

	cat $joblist | xargs -L 1 -I CMD -P 12 bash -c CMD 1> /dev/null 2> /dev/null
fi

# stringtie-merge system
# step 1: run stringtie2
if [ "A" == "B" ];then
        echo "generating stringtie2's assemblies..."

        sgtf=$result/st2-merge/raw-assemblies
        mkdir -p $sgtf
        cd $sgtf

        joblist=$sgtf/jobs.list
        rm -rf $joblist
        for((i=1;i<=369;i++));
        do
                script=$sgtf/$i.sh
                echo "$stringtie2 $index/$i.bam -o $sgtf/$i.stringtie2.gtf > $sgtf/$i.stringtie2.log" > $script
                chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 30 bash -c CMD 1> /dev/null 2> /dev/null
fi

# step 2: st-merge assemblies
if [ "A" == "B" ];then
        echo "Running Stringtie2 - merge system..."

        sgtf=$result/st2-merge/raw-assemblies
        cur=$result/st2-merge
        cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                list=$cur/$num.list
                rm -rf $list

                for ((i=1;i<=$num; i++))
                do
                        echo "$sgtf/$i.stringtie2.gtf" >> $list
                done

                mkdir -p $cur/merge_$num

                script=$cur/$num.sh
                rm -rf $script
                
		for cov in $covlist;
                do
                        mkdir -p $cur/merge_${num}/cov_$cov
                        #echo "$stringtie2 --merge $list -o $cur/merge_$num/cov_$cov/st2merge.gtf -c $cov > $cur/merge_$num/cov_$cov/merge_${num}_$cov.log" >> $script
                        #echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov.stats $cur/merge_$num/cov_$cov/st2merge.gtf" >> $script
                	echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/cov_$cov/st2merge.gtf > $cur/merge_$num/cov_$cov/st2merge-otherchrm.gtf" >> $script
                        echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}_$cov-otherchrm.stats $cur/merge_$num/cov_$cov/st2merge-otherchrm.gtf" >> $script
		done
                
		chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 12 bash -c CMD 1> /dev/null 2> /dev/null

        echo "Finish StringTie2 - merge system."
fi

# run additional experiments to use sc2+st2's assemblies for linkmerge
# merge st2 and sc2
if [ "A" == "b" ];then
        echo "merging st2 and sc2's assemblies, intra-cell..."

        sc2gtf=$result/sc2-link/raw-assemblies
        st2gtf=$result/st2-merge/raw-assemblies

        sgtf=$result/sc2st2-link/raw-assemblies
        mkdir -p $sgtf
        cd $sgtf

        joblist=$sgtf/jobs.list
        rm -rf $joblist
        for((i=1;i<=369;i++));
        do
                script=$sgtf/$i.sh
                templist=$sgtf/$i.list
                echo "$sc2gtf/$i.star.scallop2.fnf.gtf" > $templist
                echo "$st2gtf/$i.stringtie2.gtf" >> $templist
                echo "$linkmerge union $templist $sgtf/$i.gtf" > $script

                chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 20 bash -c CMD 1> /dev/null 2> /dev/null

fi

# step 2: post linkmerge assemblies
if [ "A" == "B" ];then
        echo "Running Scallop2 - Link..."

        sgtf=$result/sc2st2-link/raw-assemblies
        cur=$result/sc2st2psi-link
        mkdir -p $cur
	cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                list=$cur/$num.list
                rm -rf $list

                for ((i=1;i<=$num; i++))
                do
                        echo "$sgtf/$i.gtf" >> $list
			echo "$result/psiclass/merge_$num/cov_1/psiclass_sample_$((i-1)).gtf" >> $list
                done

                mkdir -p $cur/merge_$num

                script=$cur/$num.sh
                rm -rf $script
                echo "$linkmerge link-merge $list $cur/merge_$num/linkmerge_$num > $cur/merge_$num/merge_$num.log" > $script
                echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}.stats $cur/merge_$num/linkmerge_$num.gtf" >> $script

                chmod +x $script
                echo $script >> $joblist
        done

        cat $joblist | xargs -L 1 -I CMD -P 10 bash -c CMD 1> /dev/null 2> /dev/null

        echo "Finish Scallop2 + StringTie2 - Link."
fi

# Aletsch as input for linkmerge
if [ "A" == "B" ];then
        echo "Running altesch - Link..."

        sgtf=$result/aletsch-link/raw-assemblies
        cur=$result/aletsch-link
        mkdir -p $cur
        cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                list=$cur/$num.list
                rm -rf $list

                for ((i=1;i<=$num; i++))
                do
                        echo "$sgtf/merge_$num/$i.gtf" >> $list
                done

                mkdir -p $cur/merge_$num

                script=$cur/$num.sh
                rm -rf $script
                echo "$linkmerge link-merge $list $cur/merge_$num/linkmerge_$num > $cur/merge_$num/merge_$num.log" > $script
                #echo "$gffcompare -r $ref -o $cur/merge_$num/merge_${num}.stats $cur/merge_$num/linkmerge_$num.gtf" >> $script
                #echo "$gtfcuff roc $cur/merge_$num/merge_${num}.linkmerge_$num.gtf.tmap 225036 cov > $cur/merge_$num/linkmerge_$num.roc.txt" >> $script


                # gffcompare individual-level
                #for ((j=1;j<=$num; j++))
		#do
                        #echo "$gffcompare -r $ref -o $cur/merge_$num/linkmerge_${num}_sgtf/individual.${j}.stats $cur/merge_$num/linkmerge_${num}_sgtf/$j.gtf" >> $script
                        #echo "$gtfcuff roc $cur/merge_$num/linkmerge_${num}_sgtf/individual.${j}.$j.gtf.tmap 120480 cov > $cur/merge_$num/linkmerge_${num}_sgtf/individual.${j}.roc.txt" >> $script
                #done

                chmod +x $script
                echo $script >> $joblist

        done

	cat $joblist | xargs -L 1 -I CMD -P 10 bash -c CMD 1> /dev/null 2> /dev/null

        echo "Finish Aletsch - Link."
fi

# copy aletsch-link results
if [ "A" == "b" ];then
        cur=$result/aletsch-link

        rm -r $result/cp/aletsch-link
        mkdir -p $result/cp/aletsch-link

        for num in $testlist;
        do
                # from gtf -> tlist, chrm and tid
                mkdir -p $result/cp/aletsch-link/merge_$num

                #awk '{print $2, $3, $5}' $cur/merge_$num/merge_$num.linkmerge_$num.gtf.tmap > $result/cp/aletsch-link/merge_$num/merge_$num.linkmerge_$num.gtf.tmap
                cp $cur/merge_$num/*.csv $result/cp/aletsch-link/merge_$num

                for ((j=1;j<=$num;j++))
                do
                        awk '{print $1, $12}' $cur/merge_$num/linkmerge_${num}_sgtf/$j.gtf > $result/cp/aletsch-link/merge_$num/$j.tlist
                        sed -i 's/[";]//g' $result/cp/aletsch-link/merge_$num/$j.tlist
                        awk '{print $2, $3, $5}' $cur/merge_$num/linkmerge_${num}_sgtf/individual.$j.$j.gtf.tmap > $result/cp/aletsch-link/merge_$num/$j.tmap

                done
        done
fi

# copy Aletsch results
if [ "A" == "B" ];then
        cur=$result/aletsch-link/raw-assemblies
        mkdir -p $result/cp/aletsch

        for num in $testlist;
        do
                # from gtf -> tlist, chrm and tid
                mkdir -p $result/cp/aletsch/merge_$num

                for ((j=1;j<=$num; j++));
                do
                        awk '{print $1, $12}' $cur/merge_$num/$j.gtf > $result/cp/aletsch/merge_$num/$j.tlist
                        sed -i 's/[";]//g' $result/cp/aletsch/merge_$num/$j.tlist

                        $gffcompare -r $ref -o $cur/merge_$num/$j $cur/merge_$num/$j.gtf
                        awk '{print $2, $3, $5}' $cur/merge_$num/$j.$j.gtf.tmap > $result/cp/aletsch/merge_$num/$j.tmap
                done
        done
fi

if [ "A" == "A" ];then
        cur=$result/aletsch-link/raw-assemblies
        scriptDir=$cur/scripts

        mkdir -p $result/cp/aletsch
        mkdir -p $scriptDir
        cd $cur

        # generate job list
        joblist=$cur/jobs.list
        rm -rf $joblist

        for num in $testlist;
        do
                # gffcompare individual-level
                for ((j=1;j<=$num; j++))
                do
                        script=$scriptDir/$num.$j.sh
                        echo "awk '\$1 !~ /^(1|2|3|4|5|6|7|8|9)$/' $cur/merge_$num/$j.gtf > $cur/merge_$num/$j.otherchrm.gtf" >> $script
                        echo "$gffcompare -r $ref -o $cur/merge_$num/${j}.other.stats $cur/merge_$num/$j.otherchrm.gtf" >> $script
                        chmod +x $script
                        echo $script >> $joblist
                done
        done

        cat $joblist | xargs -L 1 -I CMD -P 40 bash -c CMD 1> /dev/null 2> /dev/null

        echo "Finish Alestch."
fi
