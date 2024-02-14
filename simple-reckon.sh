#!/bin/bash

# Function to run subfinder
run_subfinder() {
    mkdir ./$domain/subfinder
    echo "running subfinder with all sources..."
    subfinder -all -silent -d "$1" -o ./$domain/subfinder/subdomains-$domain.txt
 }

# Function to run httpx
run_httpx() {
    mkdir ./$domain/httpx
    echo "running httpx with cool options..."
    httpx -title -tech-detect -silent -fc 403 -retries 1 -sc -probe -follow-redirects -cl -o ./$domain/httpx/$domain-httpx.txt -list ./$domain/subfinder/subdomains-$domain.txt && cat ./$domain/httpx/$domain-httpx.txt | grep -v "FAILED" > ./$domain/httpx/$domain-httpx-clean.txt
}

# Function to run dirseach
run_dirsearch(){
mkdir ./$domain/dirsearch
cat ./$domain/httpx/$domain-httpx-clean.txt | cut -d " " -f 1 > ./$domain/dirsearch/urls-to-dirsearch
echo "Starting dirsearch..."

dirsearch.py -l $(pwd)/$domain/dirsearch/urls-to-dirsearch -x 404,403 -o $(pwd)/$domain/dirsearch/dirsearch-results.txt
}

# Main function
main() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <domain>"
        exit 1
    fi

    domain="$1"
    run_subfinder "$domain"
    run_httpx "$domain"
    run_dirsearch "$domain"
    
   
}

# Execute main function with command-line arguments
main "$@"
