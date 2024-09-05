#!/bin/bash

USER=tyrells
PCRE2_VER=10.44

#sudo apt install default-jdk libcurl4-openssl-dev gcc wget automake unzip bzip2 flex make git cmake zlib1g-dev g++ libzstd-dev libssl-dev libexpat1-dev


# Create the Downloads directory
if [ ! -d "Downloads" ]; then
  mkdir Downloads
fi

cd Downloads

echo "PCRE2_VER $PCRE2_VER"

# Install PCRE2
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER/pcre2-$PCRE2_VER.tar.gz
tar zxf pcre2-$PCRE2_VER.tar.gz
cd pcre2-$PCRE2_VER
./configure --prefix=/opt/pcre2
make
sudo mkdir /opt/pcre2
sudo chown $USER /opt/pcre2
make install