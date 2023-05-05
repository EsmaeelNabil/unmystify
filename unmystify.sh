#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
default_output_suffix="_cracked.txt"

# Function to print script help
print_help() {
    echo -e "${YELLOW}Usage:${NC} $0 [-m mapping-file] -s stack-trace-file [-o output-file]"
    echo -e "${YELLOW}Options:${NC}"
    echo -e "  ${YELLOW}-m, --mapping-file${NC}  Specify the mapping file (default: choose from existing files)"
    echo -e "  ${YELLOW}-s, --stack-trace${NC}   Specify the stack trace file (mandatory)"
    echo -e "  ${YELLOW}-o, --output-file${NC}   Specify the output file (optional)"
    echo -e "  ${YELLOW}-h, --help${NC}          Print this help message"
    exit 1
}

# Function to select a file from "mapping*.txt" files with pop-up formatting
select_mapping_file() {
  # Find all "mapping*.txt" files recursively
  map_files=($(find . -type f -name "mapping*.txt"))

  # Check if any files were found
  if [ ${#map_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}No 'mapping*.txt' files found in the current directory.${NC}"
    return 1
  fi

  # Display the files with creation dates
  echo -e "${CYAN}${BOLD}Found the following 'mapping*.txt' files:${NC}"
  for ((i=0; i<${#map_files[@]}; i++)); do
    creation_date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "${map_files[$i]}")
    echo -e "${GREEN}${BOLD}$((i+1)). ${map_files[$i]}${NC} ${YELLOW}(Created on: $creation_date)${NC}"
  done

  # Ask the user to choose a file only if files were found
  if [ ${#map_files[@]} -gt 0 ]; then
    # Validate the user's choice
    read -p "$(echo -e ${YELLOW}${BOLD}Choose a file by entering the corresponding number:${NC}) " choice

    if [[ ! $choice =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#map_files[@]} )); then
      echo -e "${RED}${BOLD}Invalid choice. Exiting.${NC}"
      return 1
    fi

    # Set the selected file to the existing 'mapping' variable
    mapping=${map_files[$((choice-1))]}
  fi
}



# Parsing command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -m|--mapping-file)
            mapping="$2"
            shift # past argument
            shift # past value
            ;;
        -s|--stack-trace)
            stack_trace="$2"
            shift # past argument
            shift # past value
            ;;
        -o|--output-file)
            output="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            print_help
            ;;
        *) # unknown option
            echo -e "${RED}Error:${NC} Unknown option '$key'"
            print_help
            ;;
    esac
done

# Check if the mandatory stack trace file is provided
if [[ -z $stack_trace ]]; then
    echo -e "${RED}Error:${NC} Stack trace file is mandatory"
    print_help
fi

# Get the absolute path of the script's parent directory
ROOT="$(cd "$(dirname "$0")" && pwd)"

# If mapping file is not provided, prompt the user to choose one
if [[ -z $mapping ]]; then
    select_mapping_file
fi

# If output file is not provided, generate the default name
if [[ -z $output ]]; then
output="${stack_trace%.*}$default_output_suffix"
fi

# Execute the retrace.jar with the provided arguments
/Users/$USER/Library/Android/sdk/tools/proguard/bin/retrace.sh -verbose "$mapping" "$stack_trace" > "$output"

echo -e "${GREEN}Output saved to:${NC} $output"
echo -e "========================================"

read -rp "Do you want to display the content of the generated file? (y/N) " display_content
if [[ $display_content =~ ^[Yy]$ ]]; then
    cat "$output"
fi