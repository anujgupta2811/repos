## How the Script Works

* Function merge_data takes the directory as argument which has the Samsung Dataset.
* Library function loads the required package for the script.
* A vector is created having values 'test' and 'train' which determines whether it is a test or train dataset
* An empty dataframe is created which will hold the Merge dataset of train and test.
* features.txt file is read and stored in a dataframe.
* activity_labels.txt is read and stored in a dataframe.
* Using the For Loop, test and train data is read from file based on the value of vector. 
* Inside the For loop, only Mean and Standard Deviation variables are extracted and descriptive names are assigned to each variable column and activities data.
* Finally the data is appended to empty dataframe created above, hence merging test and train data
* After the for loop, descriptive names are assigned to columns having Activities Label and Subject Id
* New Dataframe is created from the Merged dataset having Activities Label, Subject Id and variables having 3-axial direction features.
* Another Datframe is created from the Merged dataset having Activities Label, Subject Id and variables having Magintude features
* From the dataframe with variables having 3-axial direction features, average is calculated for each variable for each subject and activities. Data is cleansed and stored in a dataframe having two new columns Variables and Axis from existing variables. Column Variable contains the value Mean and Standard Deviation while Axis contain the direction - X, Y and Z
* The dataframe created in above step is written to a file named Tidy_Data_Signals.txt
* Similarly from the dataframe with variables having Magintude features, average is calculated for each variable for each subject and activities. Data is cleansed and stored in a dataframe having one new columns Variables from existing variables. Column Variable contains the value Mean and Standard Deviation. No axis column is created for Magintude features
* The dataframe created in above step is written to a file named Tidy_Data_Magnitude.txt
