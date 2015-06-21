###### In order to run the "run_analysis.R", we can store this R file in any arbitrary folder. Run it with RStudio.
###### In the script, the program will automatically do the following things:
- download the dataset into current working directory
- extract the dataset into current working directory
- read the measurements in training and testing datasets and merge them into one dataset
- read the activity list in the training and testing datasets and merge them into one activity list
- convert each number in activity list into a more descriptive string respresenting the corresponding activity
- read the subject list in the training and testing datasets and merge them into one subject list
- merge all subject list, activity list and measurements into 1 dataset
- group all measurements by their corresponding subject and activity
- compute the average of measurement values for each group
- write the resulted tidy dataset into "result.txt"