#!/bin/bash

# Define directories
INPUT_VOLUME="$(pwd)/slurm-tarballs"
OUTPUT_VOLUME="$(pwd)/output"
RPMMACROS_VOLUME="$(pwd)/my-custom-rpmmacros"

# Ensure required directories exist
if [ ! -d "$INPUT_VOLUME" ]; then
    echo "Error: Input directory '$INPUT_VOLUME' does not exist."
    exit 1
fi

# Check if TARBALL is already set; if not, prompt the user to select a tarball
if [ -z "$TARBALL" ]; then
    echo "Available tarballs in $INPUT_VOLUME:"
    tarballs=("$INPUT_VOLUME"/*.tar.*) # Array of tarballs

    if [ "${#tarballs[@]}" -eq 0 ]; then
        echo "Error: No tarballs found in $INPUT_VOLUME."
        exit 1
    fi

    # Display tarball options
    select tarball in "${tarballs[@]}"; do
        if [ -n "$tarball" ]; then
            TARBALL=$(basename "$tarball") # Extract the filename
            echo "You selected: $TARBALL"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
else
    echo "Using pre-set TARBALL: $TARBALL"
fi

# Check if BUILDARGS is already set; if not, prompt the user
if [ -z "$BUILDARGS" ]; then
    read -p "Enter build arguments (default: '--with lua --with numa'): " user_buildargs
    BUILDARGS=${user_buildargs:-"--with lua --with numa"} # Use default if empty
else
    echo "Using pre-set BUILDARGS: $BUILDARGS"
fi

# Print the chosen values
echo "Using TARBALL: $TARBALL"
echo "Using BUILDARGS: $BUILDARGS"

docker run --rm \
    -e TARBALL="${TARBALL}" \
    -e BUILDARGS="${BUILDARGS}" \
    -v "${INPUT_VOLUME}:/home/builder/input" \
    -v "${OUTPUT_VOLUME}:/home/builder/rpmbuild/RPMS" \
    -v "${RPMMACROS_VOLUME}:/home/builder/.rpmmacros" \
    slurm-rpm-builder:almalinux9
