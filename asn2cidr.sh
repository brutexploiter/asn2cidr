#!/bin/bash

# Function to query AS numbers from a file
query_from_file() {
    # Check if the file exists
    if [ -f "$1" ]; then
        # Read the file line by line
        while IFS= read -r AS; do
            # Execute the whois command for each AS number
            whois -h whois.radb.net -- "-i origin $AS" | grep -Eo "([0-9.]+){4}/[0-9]+" | uniq
        done < "$1"
    else
        echo "File '$1' not found."
        exit 1
    fi
}

# Function to handle interruptions
interrupt_handler() {
    echo "Interrupted by user."
    exit 0
}

# Function to display usage
display_usage() {
    echo "Usage: $0 [-l <input_file>] [-i <AS_number>] [-o <output_file>] [-h]"
    echo "Options:"
    echo "  -l <input_file>: Specify a file containing a list of AS numbers."
    echo "  -i <AS_number>: Specify an AS number directly."
    echo "  -o <output_file>: Specify the output file to save the results."
    echo "  -h: Display this help message."
}

# Register interrupt handler
trap interrupt_handler SIGINT

# Default values for flags
INPUT_TYPE=""
OUTPUT_FILE=""

# Parse command-line options
while getopts ":l:i:o:h" opt; do
    case ${opt} in
        l )
            INPUT_TYPE="file"
            INPUT_FILE="$OPTARG"
            ;;
        i )
            INPUT_TYPE="as_numbers"
            AS_NUMBERS+=("$OPTARG")
            ;;
        o )
            OUTPUT_FILE="$OPTARG"
            ;;
        h )
            display_usage
            exit 0
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            exit 1
            ;;
        : )
            echo "Option -$OPTARG requires an argument." 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Validate input type
if [ -z "$INPUT_TYPE" ]; then
    echo "Input source not specified. Use -l for file or -i for AS numbers." 1>&2
    exit 1
fi

# Query AS numbers
if [ "$INPUT_TYPE" == "file" ]; then
    if [ -z "$OUTPUT_FILE" ]; then
        query_from_file "$INPUT_FILE"
    else
        query_from_file "$INPUT_FILE" | tee "$OUTPUT_FILE"
    fi
elif [ "$INPUT_TYPE" == "as_numbers" ]; then
    if [ -z "$OUTPUT_FILE" ]; then
        for AS in "${AS_NUMBERS[@]}"; do
            whois -h whois.radb.net -- "-i origin $AS" | grep -Eo "([0-9.]+){4}/[0-9]+" | uniq
        done
    else
        for AS in "${AS_NUMBERS[@]}"; do
            whois -h whois.radb.net -- "-i origin $AS" | grep -Eo "([0-9.]+){4}/[0-9]+" | uniq
        done | tee "$OUTPUT_FILE"
    fi
fi
