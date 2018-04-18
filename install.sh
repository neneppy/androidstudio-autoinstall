#!/bin/bash
# Android Studio Auto Installer.
# Copyright (C) 2018 Neneroid. WTFPL License.

# ask sudo password.
read -s -p "PASSWORD: " password
echo "Processing..."

# make tmp directory.
mkdir tmp
cd ./tmp
tmp_dir=`pwd`

# download android-studio binary file from google using wget.
echo "Downloading Android Studio..."
dl_url=`curl -Ss https://developer.android.com/studio/index.html#linux-bundle | grep -G -o -e "https.*linux\.zip" | grep -m 1 -G -e ".*"`
wget $dl_url
zip_url=`echo $dl_url | grep -G -o -e "android-.*zip"`
unzip $zip_url
mv android-studio ~/.android-studio

# add android-studio command.
cd ~/.android-studio/bin
cp studio.sh android-studio
echo "$password" | sudo -S chmod +x android-studio
echo "$password" | sudo -S ln -s ./android-studio /usr/bin/android-studio

# make application launcher icon.
home_dir=`cd ~ && pwd`
{
    echo "[Desktop Entry]"
    echo "Name=Android Studio"
    echo "Exec=android-studio"
    echo "Terminal=false"
    echo "Type=Application"
    echo "Categories=Development;IDE;"
    echo "Icon=$home_dir/.android-studio/bin/studio.png"
} >> ~/.local/share/applications/android-studio.desktop

# if 64bit kernel, install additional packages.
# Ubuntu: sudo apt-get install lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32stdc++6
# Fedora: sudo yum install zlib.i686 ncurses-libs.i686 bzip2-libs.i686
echo "Installing Additional Packages..."
if [ "$(which apt-get)" == "/usr/bin/apt-get" ]; then
    #Ubuntu
    echo "$password" | sudo -S apt-get -y install lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32stdc++6
elif [ "$(which yum)" == "/usr/bin/yum" ]; then
    #Fedora
    echo "$password" | sudo -S yum -y install zlib.i686 ncurses-libs.i686 bzip2-libs.i686
else
    #Others
    echo "Not Supported Platforms..."
fi

# remove temp files.
echo "Removing Temporary Files..."
cd $tmp_dir/../
rm -rf tmp
echo "All done!"
