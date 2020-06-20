# Tidyverse collects various R packages and used to clean, process, model and visualize data
library(tidyverse)

# The readxl package makes it easy to get data out of Excel into R
library(readxl)

# Dplyr allows the working with local data frames and remote database tables. The package is designed to abstract over how the data is stored
library(dplyr)

# Tidyr allows the tidying of data
library(tidyr)

# Set path to the folder that contains all the files named path_to_folders
path_to_folders <- paste0("data_files")

# Make a list containing the names of files in the named directory: folders_to_read
folders_to_read <- list.files(path_to_folders)

# Create an empty data frame named full_data_contents to store the whole data  
full_data_contents <- data.frame()

# Loop to automatically read all the folders within each country folders
for(i in 1:length(folders_to_read)){
  this_folder <- folders_to_read[i] 
  folder_path <- paste(path_to_folders, this_folder, sep= '/')
  files_to_read <- list.files(folder_path, pattern = ".xlsx")
  
  # Read the files within each folders of every country
  for(j in 1:length(files_to_read)){
    this_file <- files_to_read[j]
    file_path <- paste(folder_path, this_file, sep = '/')
    if (file_path == paste0("data_files/Albania/~$Albania.xlsm")){
      next
    }
    
    # Allocate the content of the excel files to the data frame
    raw_data <- read_excel(file_path, skip = 1)
    country_name <- raw_data[3,3]
    flow <- raw_data[1,3]
    final_data <- read_excel(file_path, skip = 5)
    final_data$Country <- c(country_name)
    final_data$Year <- final_data$Product
    final_data$Flow <- c(flow)
    final_data <-final_data[c(2:(nrow(final_data)-3)),c(68:70,1,3:67)]
    final_data <- gather(final_data,"Product","Value",5:69)
    # Combine full_data_contents and final_data data frame using rbind function
    full_data_contents <- rbind(full_data_contents,final_data)
  }
}

# Changing the list to character vectors
full_data_contents$Country <- as.character(full_data_contents$Country)
full_data_contents$Flow <- as.character(full_data_contents$Flow)
full_data_contents$Product <- as.character(full_data_contents$Product)

# Encode/convert the vectors on full_data_contents data frame as factors (Country, Year, Flow, Product column) and as numeric (Value column)
full_data_contents$Country <- as.factor(full_data_contents$Country)
full_data_contents$Year <- as.factor(full_data_contents$Year)
full_data_contents$Flow <- as.factor(full_data_contents$Flow)
full_data_contents$Product <- as.factor(full_data_contents$Product)
full_data_contents$Value <- as.numeric(full_data_contents$Value)

# Export data frame to csv format 
write.csv(full_data_contents,file="structured_data.csv",row.names=F,col.names=T)