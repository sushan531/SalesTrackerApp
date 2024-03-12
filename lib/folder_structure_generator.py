import os

# Specify the folder name you want to create
folder_name = input("Enter the folder name: ")

# Get the current working directory
current_directory = os.getcwd()

# Join the current directory with the folder name to create the full path
new_folder_path = os.path.join(current_directory, folder_name)

# Check if the folder already exists before creating it
if not os.path.exists(new_folder_path):
    # Create the folder
    os.mkdir(new_folder_path)
    print(f"Folder '{folder_name}' created successfully in the current path.")
    os.chdir(new_folder_path)
    file_name = "index.dart"
    with open(file_name, 'w') as file:
      print(f"File '{file_name}' has been created in the '{new_folder_path}' directory.")
      subfolder_names = ["blocs","models","repository","services","utils", "screens","widgets"]
      for folder_name in subfolder_names:
        subfolder_path = os.path.join(new_folder_path, folder_name)
        if not os.path.exists(subfolder_path):
           os.makedirs(subfolder_path)
           print(f"Created subfolder: {subfolder_path}")
           os.chdir(subfolder_path)
           with open(file_name, 'w') as file:
            print(f"File '{file_name}' has been created in the '{subfolder_path}' directory.") 
else:
    print(f"Folder '{folder_name}' already exists in the current path.")


   
     