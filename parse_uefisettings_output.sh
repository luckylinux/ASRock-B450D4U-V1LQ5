#!/bin/bash

# Load Configuration
source "config.sh"

# Get Number of Elements to Process
NUM_ELEMENTS=$(cat "${UEFISETTINGS_BASE_PATH}/${UEFISETTINGS_LIST_QUESTIONS_FILENAME}" | jq -r ". | length")

# Loop over all Questions
for index_question in $(seq 0 1 $((NUM_ELEMENTS - 1)))
do
    # Get Name of Setting
    name=$(cat "${UEFISETTINGS_BASE_PATH}/${UEFISETTINGS_LIST_QUESTIONS_FILENAME}" | jq -r ".[${index_question}].name")

    # Get Value of Setting
    object=$("${UEFISETTINGS_EXECUTABLE}" hii get --json "${name}" | jq -r)

    # Debug
    # echo $object
    # echo ${object} | jq -r '.responses | length'

    # Get Number of Results
    num_results=$(echo ${object} | jq -r '.responses | length')

    # Debug
    # echo "Found ${num_results} for ${name}"

    for index_result in $(seq 0 1 $((num_results - 1)))
    do
        # Get Selector of Setting
        result_selector=$(echo "${object}" | jq -r ".responses[${index_result}].selector")

        # Get Backend of Setting
        result_backend=$(echo "${object}" | jq -r ".responses[${index_result}].backend")

        # Get Value of Setting
        result_value=$(echo "${object}" | jq -r ".responses[${index_result}].question.answer")

        # Get Name of Setting
        result_name=$(echo "${object}" | jq -r ".responses[${index_result}].question.name")

        # Get Help of Setting
        result_help=$(echo "${object}" | jq -r ".responses[${index_result}].question.help")

        # Get Options of Setting
        result_options_obj=$(echo "${object}" | jq -r ".responses[${index_result}].question.options")

        # Contactenate Options with Separator
        result_options_str=""
        num_options=$(echo ${result_options_obj} | jq -r ". | length")
        for index_option in $(seq 0 1 $((num_options - 1)))
        do
             current_option=$(echo ${result_options_obj} | jq -r ".[${index_option}]")
             result_options_str="${result_options_str}||||||${current_option}"
        done

        if [[ -n "${result_name}" ]]
        then
            # Echo (one-Liner)
            # echo -e "[${index}/${NUM_ELEMENTS}] ${result_selector}: ${result_name} = ${result_value} (Options: ${result_options_str})"

            # Echo (multi-Line & Tab)
            # echo -e "[${index}/${NUM_ELEMENTS}] ${result_name}"
            echo -e "${result_name}"
            echo -e "\tSelector: ${result_selector}"
            echo -e "\tValue: ${result_value}"

            # One-Liner Options
            # echo -e "\tOptions: ${result_options_str}"

            # Multi-Line & Tab Options
            echo -e "\tOptions:"
            for index_option in $(seq 0 1 $((num_options - 1)))
            do
                current_option=$(echo ${result_options_obj} | jq -r ".[${index_option}]")
                echo -e "\t\t- ${current_option}"
            done

            echo -e "\tBackend: ${result_backend}"
        fi
    done
done
