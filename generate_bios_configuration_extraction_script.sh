#!/bin/bash

# One Liner (but only works for VarStoreId = 0x5000 - AmdSetup)
# grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' ./*.txt | sed -E "s|.*VarStoreId: 0x([0-9a-fA-F]+), VarOffset: 0x([0-9a-fA-F]+),.*|setup_var.efi AmdSetup(0x\1):0x\2 >> current.txt|g" | sort | uniq

get_varstore_name() {
    # Input Argument
    local lfilename=$1
    local lvarstoreid=$2

    # Declare Local Variable
    local lresult

    # Get Name
    #### lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*, Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")
    #### lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*, Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # Fix for PCI_COMMON: an "Attributes" might exist between VarStoreId and Size
    #### lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # Try VarStore First
    # lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # Only process the current File
    # Try VarStore First
    lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' "${lfilename}" | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # If nothing Found, use VarStoreEfi
    if [[ -z "${lresult}" ]]
    then
        # lresult=$(grep --color -hr -e 'VarStoreEfi Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

        # Only process the current File
        lresult=$(grep --color -hr -e 'VarStoreEfi Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' "${lfilename}" | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")
    fi

    # Return Result
    echo "${lresult}"
}

get_varstore_guid() {
    # Input Argument
    local lfilename=$1
    local lvarstoreid=$2

    # Declare Local Variable
    local lresult

    # Try to parse File
    lresult=$(cat $lfilename | grep "VarStoreId: ${lvarstoreid}," | sed -E "s|VarStore Guid: ([0-9A-Za-z_-]+), VarStoreId: 0x([0-9]+), Size: 0x([0-9]+), Name: \"([0-9a-zA-Z_-]+)\"|\1|g")

    # Return Result
    echo "${lresult}"
}

# Define Parameters
SCRIPT_FILENAME="script.nsh"

# Move File if it exists already
if [[ -f "${SCRIPT_FILENAME}" ]]
then
    mkdir -p backup/
    TIMESTAMP=$(date +"%Y%m%d_%Hh%Mm%Ss")
    mv "${SCRIPT_FILENAME}" "backup/${SCRIPT_FILENAME}.backup.${TIMESTAMP}"
fi

# Create File if not exist
if [[ ! -f "${SCRIPT_FILENAME}" ]]
then
    touch "${SCRIPT_FILENAME}"
fi

# Total Number of Files
NUM_FILES=$(find . -iwholename "*.txt" | wc -l)

# Total Number of Matches
NUM_MATCHES=$(grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' ./*.txt | wc -l)

# Initialize Variables
file_counter=1
match_counter=1

# Process ALL Files
for file in ./*.txt
do
    # Echo
    echo "[${file_counter}/${NUM_FILES}] Processing File ${file}"

    # Get File Number of Matches
    file_matches=$(grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' "${file}" | wc -l)

    # Reset Counters
    total_match_counter=1
    file_match_counter=1

    # Look for VarOffset Values in current File
    grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' "${file}" | while IFS= read -r value;
    do
        # Debug
        # echo "${value}"

        # Get VarStoreId and VarOffset
        varstoreid=$(echo "${value}" | sed -E "s|.*VarStoreId: 0x([0-9a-fA-F]+), .*|0x\1|g")
        varoffset=$(echo "${value}" | sed -E "s|.*VarOffset: 0x([0-9a-fA-F]+), .*|0x\1|g")

        # Get ALL VarStore ID

        # Get Varstore GUID corresponding to VarStoreId and Filename
        varstoreguid=$(get_varstore_guid "${file}" "${varstoreid}")

        # Get VarStore Name corresponding to VarStoreId
        varstorename=$(get_varstore_name "${file}" "${varstoreid}")

        # Get Name corresponding to VarStoreId
        # grep --color -hr -e 'VarStore Guid: [0-9A-F\-]+, VarStoreId: 0x[0-9]+, Size:0x[0-9]+, Name: \"([0-9A-Za-z]+)\"' ./*.txt | sed -E "s|VarStore Guid: 3A997502-647A-4C82-998E-52EF9486A247, VarStoreId: 0x5000, Size: 0x611, Name: "AmdSetup"

        # Define Line
        cmdline="setup_var.efi ${varstorename}(${varstoreid}):${varoffset} >> current.txt"

        # Echo
        echo -e "\t[${file_match_counter}/${file_matches}] Processing Match with Command Line: ${cmdline}"

        # Check that Line has NOT already been processed
        status=$(grep -ri "${cmdline}" "${SCRIPT_FILENAME}" | wc -l)

        if [ $status -eq 0 ]
        then
            # Debug
            echo -e "\t\t Adding Line to Script: ${cmdline}"

            # Create Line for Script
            echo "${cmdline}" >> ${SCRIPT_FILENAME}
        fi

        # Increase Counter
        total_match_counter=$((total_match_counter+1))
        file_match_counter=$((file_match_counter+1))
    done

    # Increase file_counter
    file_counter=$((file_counter+1))
done

# Sort File and create Copy
cat "${SCRIPT_FILENAME}" | sort | tee "${SCRIPT_FILENAME}.sorted"
