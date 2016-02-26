---
title: "README"
output: html_document
---

This repository is for the Coursera "Data Cleaning" course, week 4 project.

The idea is that the data set from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

should be downloaded and unzipped, and the `data_directory` variable in `run_analysis.R` set to wherever that is.

Upon execution of `run_analysis.R`, two files are produced:

`raw_tidy_data.txt` : Which has the training and test data together in it.
`tidy_summary_data.txt` : Which has the mean measurements grouped by subject and activity.

Samples of this output are also part of this repository.

Also in this repository are this `README.md` file, and `CodeBook.md` which shows the code book for the two data (`txt`) files.