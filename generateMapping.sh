#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

display_help() {
    echo -e "${CYAN}-----------------------------------${NC}"
    echo -e "${YELLOW}Usage: $0 -p /path/to/android/studio/project${NC}"
    echo -e "${CYAN}-----------------------------------${NC}"
    echo
    echo -e "   -p, --project      Path to Android Studio project root directory"
    exit 1
}

check_mapping_file() {
    if [ -f "${mapping_file}" ]; then
        return 0
    else
        return 1
    fi
}

copy_mapping_file() {
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    mkdir -p "${SCRIPT_DIR}/bin"
    cp "${mapping_file}" "${SCRIPT_DIR}/bin/mapping_${timestamp}.txt"
    echo -e "${GREEN}Copied mapping.txt file to ${SCRIPT_DIR}/bin/mapping_${timestamp}.txt${NC}"
}

generate_mapping_file() {
    cd "${project_path}"
    echo -e "${CYAN}-----------------------------------${NC}"
    echo -e "${YELLOW}Cleaning project...${NC}"
    ./gradlew clean
    echo -e "${CYAN}-----------------------------------${NC}"
    echo -e "${YELLOW}Generating new mapping.txt file...${NC}"
    ./gradlew :app:minifyReleaseWithR8
    echo -e "${CYAN}-----------------------------------${NC}"
}

if [ $# -eq 0 ]; then
    display_help
    exit 1
fi

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -p|--project)
        project_path="$2"
        shift
        shift
        ;;
        *)
        display_help
        exit 1
        ;;
    esac
done

if [ ! -f "${project_path}/app/build.gradle" ] && [ ! -f "${project_path}/app/build.gradle.kts" ]; then
    echo -e "${RED}The provided path is not a valid Android Studio project. Please provide the path to the root of an Android Studio project.${NC}"
    exit 1
fi

mapping_file="${project_path}/app/build/outputs/mapping/release/mapping.txt"

if check_mapping_file; then
    echo -e "${CYAN}-----------------------------------${NC}"
    echo -e "${GREEN}Found existing mapping.txt file: ${mapping_file}${NC}"
    creation_date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "${mapping_file}")
    echo -e "Creation date: ${creation_date}"
    echo -e "${CYAN}-----------------------------------${NC}"
    echo "Choose an option:"
    echo "1. Use existing mapping.txt file"
    echo "2. Generate a new mapping.txt file"
    read -p "Enter the number of your choice (1 or 2): " choice

    case $choice in
        1)
        copy_mapping_file
        ;;
        2)
        generate_mapping_file
        if check_mapping_file; then
            copy_mapping_file
        else
            echo -e "${RED}Failed to generate mapping.txt file.${NC}"
        fi
        ;;
        *)
        echo -e "${RED}Invalid choice. Exiting...${NC}"
        exit 1
        ;;
    esac
else
    echo -e "${CYAN}-----------------------------------${NC}"
    echo -e "${RED}The mapping.txt file does not exist. Generating a new mapping.txt file...${NC}"
    generate_mapping_file
    if check_mapping_file; then
        copy_mapping_file
    else
        echo -e "${RED}Failed to generate mapping.txt file.${NC}"
    fi
    echo -e "${CYAN}-----------------------------------${NC}"
fi
