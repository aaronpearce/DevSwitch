#!/bin/sh

# Thanks to Kyle Hickinson (@kylehickinson) for the tip. 
# This is based upon the setup that Brave and Firefox implement to have a local developer setup.

# Sets up local configurations from the tracked .template files

# Checking the `Local` Directory
CONFIG_PATH="DevSwitch/Configuration"
if [ ! -d "$CONFIG_PATH/Local/" ]; then
echo "Creating 'Local' directory"

(cd $CONFIG_PATH && mkdir Local)
fi

# Copying over any necessary files into `Local`
for CONFIG_FILE_NAME in BundleId DevTeam
do
CONFIG_FILE=$CONFIG_FILE_NAME.xcconfig
(cd $CONFIG_PATH \
&& cp -n Local.templates/$CONFIG_FILE Local/$CONFIG_FILE \
)
done
