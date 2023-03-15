#!/usr/bin/bash

set -e

# Search for the IP address and store it in a variable
ip_address=$(grep -r "PUBLISH_URL" /etc/sysconfig/httpd | awk -F '"' '{print $2}' | cut -d: -f2)

# Check if the IP address was found
if [ -z "$ip_address" ]; then
    echo "Error: could not find IP address"
    exit 1
fi

# Print the IP address
echo  $ip_address

# Check if the file has already been updated with the current IP address
if grep -q "PUBLISHER_IP=\"$ip_address\"" /etc/httpd/conf.d/apolloredirectmap; then
    echo "File already contains the current IP address"
    exit 0
fi

if ! sed -i "5s/.*/PUBLISHER_IP=\"$ip_address\"/" /etc/httpd/conf.d/apolloredirectmap; then
    echo "Error: could not update file"
    exit 1
fi
echo "Successfully updated file"
