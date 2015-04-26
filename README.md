Assuming the Samsung data is downloaded and unzipped and the working directory set to UCI HAR Dataset
the code, loads subject ids,activity codes for which measurements were taken, and  
the measurements - 561 time and frequency domain vector data set
Also gets feature names from features.txt and activity names by code from activity_label.txt

The train and test data from different files are merged separately :(row combined)

measurements data - x_train.txt to x_test.txt
subject - subject_test.txt and subject_train.txt
activity - y_train.txt and y_test.txt

These three datasets are combined into one single dataset (tidyset - column combined)
This dataset will give measurements for each subject by the subject's activity

The variable names extracted from features are replaced with more descriptive names
cleaning out the characters from the oiginal names.
From all of the measurements only mean and standard deviation variables are selected
for the final dataset based on finding the words "mean" and "std". (tidysetf)

Then this data set is grouped by subject and activity to calculate averages of all means and 
standard deviations.

The final summarized data set (summ_grp) is written to "Tidyset.txt" 

The resulting data is tidy data set :
1.All features get their own column
2.Narrow dataset - Subjects measurements for each activity are presented 
3.Measurements are for one kind of observation (i.e Subject)
4.No extra data to split into multiple tables

