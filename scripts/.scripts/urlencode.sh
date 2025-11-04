#!/bin/bash

# URL encoding function that properly handles Unicode and special characters
# Based on RFC 3986 standards and current best practices

urlencode() {
    # Check if input is provided
    if [[ -z "$1" ]]; then
        echo "Usage: urlencode <string>" >&2
        return 1
    fi
    
    # Save current locale settings and set to C for byte-level processing
    # This is crucial for proper Unicode handling
    local old_lc_all="${LC_ALL:-}"
    LC_ALL=C
    
    local input="$1"
    local length="${#input}"
    local encoded=""
    
    # Process each character in the input string
    for (( i = 0; i < length; i++ )); do
        local char="${input:$i:1}"
        
        # Characters that don't need encoding (RFC 3986 unreserved characters)
        case "$char" in
            [a-zA-Z0-9.~_-]) 
                encoded+="$char" 
                ;;
            *)
                # Encode all other characters as %XX
                printf -v hex_char '%%%02X' "'$char"
                encoded+="$hex_char"
                ;;
        esac
    done
    
    # Restore original locale
    if [[ -n "$old_lc_all" ]]; then
        LC_ALL="$old_lc_all"
    else
        unset LC_ALL
    fi
    
    # Output the encoded string
    printf '%s' "$encoded"
}

# Example usage and test cases
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Testing URL encoding function..."
    
    # Test cases
    test_cases=(
        "Hello World"
        "test@example.com"
        "user name with spaces"
        "special!@#\$%^&*()characters"
        "unicode: café résumé"
        "path/with/slashes?query=value&another=param"
        "100% guaranteed"
        ""
    )
    
    for test_string in "${test_cases[@]}"; do
        if [[ -n "$test_string" ]]; then
            encoded=$(urlencode "$test_string")
            echo "Original: '$test_string'"
            echo "Encoded:  '$encoded'"
            echo "---"
        else
            echo "Testing empty string..."
            urlencode "$test_string" && echo "Empty string test failed" || echo "Empty string handled correctly"
            echo "---"
        fi
    done
fi
