#!/bin/bash -e

PROGRAM="bin/rating_prediction"
DATA_DIR=data/ml-100k

echo "MyMediaLite load/save test script"
echo "This will take about 2 minutes ..."

echo
echo "rating predictors"
echo "-----------------"

for method in SlopeOne BipolarSlopeOne MatrixFactorization BiasedMatrixFactorization UserItemBaseline GlobalAverage UserAverage
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time\s*\S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time\s*\S+//g" > output2.txt
	diff --ignore-space-change output1.txt output2.txt
	rm tmp.model*
done

for method in ItemAverage FactorWiseMatrixFactorization
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt | perl -pe "s/\w+_time\s*\S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt | perl -pe "s/\w+_time\s*\S+//g" > output2.txt
	diff --ignore-space-change output1.txt output2.txt
	rm tmp.model* um.txt im.txt
done


for method in CoClustering SVDPlusPlus SigmoidSVDPlusPlus SigmoidUserAsymmetricFactorModel SigmoidItemAsymmetricFactorModel SigmoidCombinedAsymmetricFactorModel
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time\s*\S+//g" | perl -ne '$ln = $_; while (/(\d+\.\d+)/g) { $f = sprintf "%.4", $1; $ln =~ s/$1/$f/; } print $ln' > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time\s*\S+//g" | perl -ne '$ln = $_; while (/(\d+\.\d+)/g) { $f = sprintf "%.4", $1; $ln =~ s/$1/$f/; } print $ln' > output2.txt
	diff --ignore-space-change output1.txt output2.txt
	rm tmp.model* um.txt im.txt
done

for method in UserKNNCosine ItemKNNCosine
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-space-change output1.txt output2.txt
	rm tmp.model*
done

for method in UserKNNPearson ItemKNNPearson
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5 shrinkage=10" --save-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5 shrinkage=10" --save-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5 shrinkage=10" --load-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5 shrinkage=10" --load-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-space-change output1.txt output2.txt
	rm tmp.model*
done

#rm output1.txt output2.txt

echo
echo "item recommenders"
echo "-----------------"

PROGRAM="bin/item_recommendation"

for method in MostPopular
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-all-space output1.txt output2.txt
	rm tmp.model*
done

for method in WRMF BPRMF
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --save-user-mapping=um.txt --save-item-mapping=im.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --load-user-mapping=um.txt --load-item-mapping=im.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-all-space output1.txt output2.txt
	rm tmp.model*
	rm um.txt im.txt
done

for method in UserKNN ItemKNN WeightedUserKNN WeightedItemKNN
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-all-space output1.txt output2.txt
	rm tmp.model*
done

for method in BPRLinear
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --save-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt --recommender-options=\"num_iter=1\"
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --load-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt --recommender-options="num_iter=1" | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-all-space output1.txt output2.txt
	rm tmp.model*
done

for method in ItemAttributeKNN
do
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --save-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt | perl -pe "s/\w+_time \S+//g" > output1.txt
	echo $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt
	     $PROGRAM --training-file=u1.base --test-file=u1.test --recommender=$method --recommender-options="k=5" --load-model=tmp.model --data-dir=$DATA_DIR --item-attributes=item-attributes-genres.txt | perl -pe "s/\w+_time \S+//g" > output2.txt
	diff --ignore-all-space output1.txt output2.txt
	rm tmp.model*
done

rm output1.txt output2.txt
