import os
import re


root_dir = './'  


lines_without_datatype = []


def check_datatypes(file_path):
    """
    Check the data types of variables in a file.

    Args:
        file_path (str): The path to the file.

    Returns:
        None
    """
    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line_number, line in enumerate(lines, start=1):
            
            if re.search(r"(\bvar\s+\w+\s*:=)|(\bvar\s+\w+\s*=)", line):
                lines_without_datatype.append((file_path, line_number, line.strip()))


def main():
    """
    Main function to check data types in files.

    This function walks through the directory specified by `root_dir` and checks the data types of files with the '.gd' extension.
    It calls the `check_datatypes` function for each file found.

    If any lines in the files are found without a data type, it prints the file path, line number, and the line itself.

    If there are any variables without a data type, it raises an exception with the count of such variables.

    Returns:
        None
    """
    for subdir, dirs, files in os.walk(root_dir):
        for filename in files:
            if filename.endswith('.gd'):
                file_path = os.path.join(subdir, filename)
                check_datatypes(file_path)

    
    count_without_datatype = len(lines_without_datatype)
    for file_path, line_number, line in lines_without_datatype:
        print(f"Data typ is missing in {file_path} on line {line_number}: {line}")

    if count_without_datatype > 0:
        raise Exception("Anzahl der Variablen ohne Datentyp: " + str(count_without_datatype))

if __name__ == "__main__":
    main()
