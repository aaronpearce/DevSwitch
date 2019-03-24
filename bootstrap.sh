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

echo "Choose your developer team that you wish to sign DevSwitch with:"
IFS=$'\n'
developerids=($(security find-identity -v -p codesigning | awk '!/CSSMERR_TP_CERT_REVOKE|Mac/' | awk -F \" '{if ($2) print $2}'))

select opt in "${developerids[@]}" "Quit"
do
    if [[ "$opt" == "Quit" ]]; then 
      echo "Bye!"
      break; 
    fi

    # complain if an invalid option was chosen
    if [[ "$opt" == "" ]]
    then
        echo "'$REPLY' is not a valid option"
        continue
    fi

    # now we can use the selected option
    identifier=`echo $opt | awk -F '[\(\)]' '{print $2}'`
    sed -i '' -e "s:LOCAL_DEVELOPMENT_TEAM = \/:LOCAL_DEVELOPMENT_TEAM = $identifier \/:g" "$CONFIG_PATH/Local/DevTeam.xcconfig"
    echo "You selected '$opt' as your developer team, we've written this to '$CONFIG_PATH/Local/DevTeam.xcconfig'"
    break
done
