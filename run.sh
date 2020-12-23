#!/bin/bash

set -e

# Check if user is root
if (($EUID != 0)); then
    echo "Please run this script as root."
    exit
fi

# Check positional parameters
if (($# != 1)); then
  echo "Usage: ./run.sh [SITE_NAME]"
  exit
fi

site_name=$1

# Get current dir
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Docker_run command
docker_run=""

# Declare generate location file function
function generate_location_file () {
cat > $current_dir/locations/$1 <<EOF
location /$1 {
    alias /vol/$1;
}
EOF
}

# Get all docker volumes
volumes=$(docker volume list -q)

# Iterate all docker volumes
for volume in $volumes; do
    if [[ "$volume" == *_static ]]; then
        # Get its location name and generate the file
        location=${volume%"_static"}
        generate_location_file $location

        echo "Configured to serve volume $volume in URL $site_name/$location"
    fi
done

# Finally download the docker image and run it
docker run -d --name static-server -e VIRTUAL_HOST=$site_name -e LETSENCRYPT_HOST=$site_name -v $current_dir/locations:/static flashspys/nginx-static

echo "Successfully started container static-server"