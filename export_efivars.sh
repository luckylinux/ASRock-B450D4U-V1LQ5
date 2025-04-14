#!/bin/bash

# Create Folder for decoded efivars
mkdir -p efivars-decoded/

# Create Folder for dmpstore efivars
mkdir -p efivars-dmpstore/

# List all files in /sys/firmware/efi/efivars/
for file in /sys/firmware/efi/efivars/*
do
    # Get just the Basename
    name=$(basename "${file}")

    # Debug
    echo "Processing File ${name} (${file})"

    # Get Number of Characters
    numchars=${#name}

    # GUID Length
    guid_length=36

    # Assume 36 Characters for the GUID
    end_index=${numchars}
    start_index=$((end_index-${guid_length}))

    # Get GUID
    guid=${name:${start_index}:${guid_length}}

    # Get Name Only since we need to swap GUID and Name for efivar to accept it
    category=${name:0:$((start_index-1))}

    # Debug
    echo "Running: efivar --name=${guid}-${category} --print > efivars-decoded/${name}.decoded.txt"

    # Decode & Save in Readable Format
    efivar --name="${guid}-${category}" --print > "efivars-decoded/${name}.decoded.txt"

    # Save in dmpstore Format
    efivar --name="${guid}-${category}" --dmpstore --export="efivars-dmpstore/${name}.dmpstore"
done

# Remove any possible MokListRT since we don't want SecureBoot Configuration to be saved
rm -f efivars-*/MokListRT*

# Remove any possible MokListTrustedRT since we don't want SecureBoot Configuration to be saved
rm -f efivars-*/MokListTrustedRT*

# Remove any possible MokListXRT since we don't want SecureBoot Configuration to be saved
rm -f efivars-*/MokListXRT*
