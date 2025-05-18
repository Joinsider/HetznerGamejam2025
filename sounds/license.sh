#!/bin/bash

# Define the license text
LICENSE_TEXT='
SPDX-FileCopyrightText: Copyright information recorded in version control history

SPDX-License-Identifier: AGPL-3.0-or-later
'

# Loop through all files in the current directory
for file in *; do
    # Skip if it's a directory or already a license file
    if [[ -f "$file" && ! "$file" == *".license" ]]; then
        # Create the license file for this file
        echo "$LICENSE_TEXT" > "${file}.license"
        echo "Created license file for: ${file}"
    fi
done

echo "License files creation completed."

