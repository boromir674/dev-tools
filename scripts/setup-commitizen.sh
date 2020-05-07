#!/usr/bin/env bash

set -e


repository_dir=$1

# Argument checks

if [[ $# -eq 0 ]]; then
    echo "Please indicate the project dir for the 'commitizen' runtime to target."
    echo "Script $0 requires a repository's root dir path as a positional argument."
    echo "Example usage: $0 ~/path_to_repo_dir"
    exit 3
fi

if [ ! -d "$repository_dir" ]; then
    echo "Path '$repository_dir' is not a directory"
    exit 4
fi


# helper functions

check_installed () {
	program=$1
	which $program
	if [[ $? -ne 0 ]]; then
     	echo "Failed to find $program executable. Please, either install or add it to PATH."
    	exit 2
	fi
}

success_message () {
  echo "Installed the cz-conventional-changelog adapter npm module and registered it in package.json's dependencies or devDependencies"
  echo "Added the config.commitizen key to the root of your package.json"

  echo "Now you should be able to use 'git cz' in place of 'git commit'"

  echo "Success :)"
}


###### BEGIN

echo "This script assumes that Node.js and npm are both installed and available on PATH."

node_bin="node";
npm_bin="npm";

check_installed $node_bin
check_installed $npm_bin


$node_bin -v
$npm_bin -v


#### Installation

# update npm
$npm_bin install npm@latest -g

$npm_bin install -g commitizen


#### Script


package_json_content="{
	\"name\": \"my_package_name\",
	\"version\": \"v1.3.4_example_version\"
}"

if [ ! -f "$repository_dir/package.json" ]; then
  echo "A package.json file is required by node modules to run, but did not find one in $repository_dir"
  echo "Creating one with the default toy values for fields 'name' and 'version'"
  echo $package_json_content > $repository_dir/package.json
fi

pushd $repository_dir

# install the cz-conventional-changelog adapter from npm
commitizen init cz-conventional-changelog --save-dev --save-exact --force

if [ $? -ne 0 ]; then
  popd
  echo "There was an error while initializing the 'commitizen' runtime."
  echo "Exiting .."
  exit 1
fi

popd

success_message

