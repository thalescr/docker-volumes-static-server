#!/bin/bash

set -e

# Check if user is root
if (($EUID != 0)); then
    echo "Please run this script as root."
    exit
fi

# Get current dir
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Docker_run command
docker_run="docker run -d -p 80:8080 --name static-server"

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

        # Append "-v" parameter to the docker run command
        docker_run="${docker_run} -v $volume:/vol/$location"
        echo "Configured to serve volume $volume in URL /$location"
    fi
done

# Finally build the docker image and run it
docker build --tag static-server .
echo $docker_run
$docker_run static-server

echo "Successfully started container static-server"