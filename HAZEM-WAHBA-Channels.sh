#!/bin/sh
##
channel=HAZEM-WAHBA
version=motor

echo "> Downloading "$channel" "$version" Channels List Please Wait ......"
sleep 3s

# Download with progress display
wget -O /var/volatile/tmp/$channel-$version.tar.gz "https://raw.githubusercontent.com/Ham-ahmed/2802/refs/heads/main/channels_backup_OpenBlackhole_20260227_HAZEMWAHBA.tar.gz" 2>&1 | \
sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading... \2\/s, \3 remaining/'

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "> Download completed successfully!"
else
    echo "> Download failed! Please check your internet connection."
    exit 1
fi

echo ""
echo "> Removing old channel lists..."
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml

cd /tmp
set -e

echo "> Installing "$channel" "$version" Channels List Please Wait ......"
sleep 3s
echo

# Extract with progress
tar -xvf $channel-$version.tar.gz -C / | while read file; do
    echo "> Extracting: $file"
done

set +e

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "> Installation completed successfully!"
else
    echo "> Installation failed!"
    exit 1
fi

# Clean up temporary file
rm -f $channel-$version.tar.gz

echo ""
echo "> Reloading Services - Please Wait..."
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 2

echo ""
echo "> Restarting Enigma2 GUI..."
echo "> Please wait for the interface to restart..."
sleep 3

# Restart Enigma2 GUI
init 4
sleep 2
init 3

echo ""
echo "> Channel list installation completed successfully!"
echo "> Enigma2 has been restarted"
echo "> Enjoy your $channel $version channels!"

exit 0