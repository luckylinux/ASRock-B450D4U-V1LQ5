#!/bin/bash

# One Liner (but only works for VarStoreId = 0x5000 - AmdSetup)
# grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' ./*.txt | sed -E "s|.*VarStoreId: 0x([0-9a-fA-F]+), VarOffset: 0x([0-9a-fA-F]+),.*|setup_var.efi AmdSetup(0x\1):0x\2 >> current.txt|g" | sort | uniq

get_varstore_name() {
    # Input Argument
    local lvarstoreid=$1

    # Declare Local Variable
    local lresult

    # Get Name
    # lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*, Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")
    # lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*, Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # Fix for PCI_COMMON: an "Attributes" might exist between VarStoreId and Size
    # lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # Try VarStore First
    lresult=$(grep --color -hr -e 'VarStore Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")

    # If nothing Found, use VarStoreEfi
    if [[ -z "${lresult}" ]]
    then
        lresult=$(grep --color -hr -e 'VarStoreEfi Guid: .*, VarStoreId: .*,.*Size: 0x.*, Name: .*' ./*.txt | uniq | grep "VarStoreId: ${lvarstoreid}" | head -n1 | sed -E "s|.*, Name: \"([0-9a-zA-Z\_-]+)\"|\1|g")
    fi

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

# Total Number of Matches
NUM_MATCHES=$(grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' ./*.txt | wc -l)

# Initialize Variable
match_counter=1

# Process ALL Files
grep --color -hr -e 'VarStoreId.*VarOffset' -e 'VarOffset.*VarStoreId' ./*.txt | while IFS= read -r value;
do
    # Debug
    # echo "${value}"

    # Get VarStoreId and VarOffset
    varstoreid=$(echo "${value}" | sed -E "s|.*VarStoreId: 0x([0-9a-fA-F]+), .*|0x\1|g")
    varoffset=$(echo "${value}" | sed -E "s|.*VarOffset: 0x([0-9a-fA-F]+), .*|0x\1|g")

    # Get ALL VarStore ID

    # Get VarStore Name Corresponding to VarStoreId
    varstorename=$(get_varstore_name "${varstoreid}")

    # Get Name corresponding to VarStoreId
    # grep --color -hr -e 'VarStore Guid: [0-9A-F\-]+, VarStoreId: 0x[0-9]+, Size:0x[0-9]+, Name: \"([0-9A-Za-z]+)\"' ./*.txt | sed -E "s|VarStore Guid: 3A997502-647A-4C82-998E-52EF9486A247, VarStoreId: 0x5000, Size: 0x611, Name: "AmdSetup"

    # Define Line
    cmdline="setup_var.efi ${varstorename}(${varstoreid}):${varoffset}"

    # Echo
    echo "[${match_counter}/${NUM_MATCHES}] Processing Match with Command Line: ${cmdline}"

    # Check that Line has NOT already been processed
    status=$(grep -ri "${cmdline}" "${SCRIPT_FILENAME}" | wc -l)

    if [ $status -eq 0 ]
    then
        # Create Line for Script
        echo "setup_var.efi ${varstorename}(${varstoreid}):${varoffset} >> current.txt" | tee -a "${SCRIPT_FILENAME}"
    fi

    # Increase Counter
    match_counter=$((match_counter+1))
done

# Sort File and create Copy
cat "${SCRIPT_FILENAME}" | sort | tee "${SCRIPT_FILENAME}.sorted"
