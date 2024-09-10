#!/bin/bash

USER=tyrrells
PCRE2_VER=10.44
HTTPD_VER=2.4.62
APR_VER=1.7.5
APR_UTIL_VER=1.6.3
MONGODB_VER=7.0.14
MONGODB_TOOLS_VER=100.10.0


#sudo apt install default-jdk libcurl4-openssl-dev gcc wget automake unzip bzip2 flex make git cmake zlib1g-dev g++ libzstd-dev libssl-dev libexpat1-dev

GetAndUnpackArchive() {
	name=$1
	file_url=$2

	if [ ! -d $name ]; then
		echo "creating $name"

		if [ ! -f $name.tar.gz ]; then
			echo "downloading $file_url/$name.tar.gz"
			wget $file_url/$name.tar.gz

			echo "unpacking $name.tar.gz"
			tar zxf $name.tar.gz		
		fi
	fi
}


GetGitRepo() {
	name=$1
	git_url=$2

	if [ ! -d $name ]; then
		echo "cloning $name"
		git clone $git_repo $name	
	fi
}


EnsureDir() {
	if [ ! -d $1 ]; then
	  mkdir -p $1
	fi
}


SudoEnsureDir() {
	if [ ! -d $1 ]; then
		echo "About to run: sudo mkdir -p $1"
	  sudo mkdir -p $1

		echo "About to run: sudo chown $USER $1"
		sudo chown $USER $1
	fi
}

# Create the Downloads directory
EnsureDir ~/Downloads

cd ~/Downloads

echo "PCRE2_VER $PCRE2_VER"

# Install PCRE2
if [ ! -d "/opt/pcre2" ]; then
	GetAndUnpackArchive pcre2-$PCRE2_VER https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER
	cd pcre2-$PCRE2_VER
	./configure --prefix=/opt/pcre2
	make
	
	echo "About to run: sudo EnsureDir /opt/pcre2"
	SudoEnsureDir /opt/pcre2
	
	echo "installing pcre2"
	make install
fi


cd ~/Downloads

# Install Apache
if [ ! -d "/opt/apache" ]; then
	GetAndUnpackArchive httpd-$HTTPD_VER https://dlcdn.apache.org/httpd/
	GetAndUnpackArchive apr-$APR_VER https://dlcdn.apache.org/apr/
	GetAndUnpackArchive apr-util-$APR_UTIL_VER https://dlcdn.apache.org/apr/
	tar zxf apr-util-$APR_UTIL_VER.tar.gz
	tar zxf apr-$APR_VER.tar.gz
	tar zxf httpd-$HTTPD_VER.tar.gz
	mv apr-$APR_VER httpd-$HTTPD_VER/srclib/apr
	mv apr-util-$APR_UTIL_VER httpd-$HTTPD_VER/srclib/apr-util
	cd httpd-$HTTPD_VER
	./configure --prefix=/opt/apache --with-included-apr --with-pcre=/opt/pcre2/bin/pcre2-config
	make
	sudo EnsureDir /opt/apache
	make install
fi


cd ~/Downloads

# Install MongoDB
if [ ! -d "/opt/mongodb" ]; then
	GetAndUnpackArchive mongodb-linux-x86_64-ubuntu2204-$MONGODB_VER https://fastdl.mongodb.org/linux/
	GetAndUnpackArchive mongodb-database-tools-ubuntu2204-x86_64-$MONGODB_TOOLS_VER https://fastdl.mongodb.org/tools/db/

	tar zxf mongodb-linux-x86_64-ubuntu2204-$MONGODB_VER.tgz 
	tar zxf mongodb-database-tools-ubuntu2204-x86_64-$MONGODB_TOOLS_VER.tgz 

	sudo EnsureDir /opt/mongodb
	cp -r mongodb-database-tools-ubuntu2204-x86_64-$MONGODB_TOOLS_VER/* /opt/mongodb/
	cp -r mongodb-linux-x86_64-ubuntu2204-$MONGODB_VER/* /opt/mongodb/
	mkdir /opt/mongodb/dbs
fi


# Create the Projects directory
EnsureDir ~/Projects
EnsureDir ~/Projects/grassroots

cd ~/Projects/grassroots

# Install Grassroots


GetGitRepo https://github.com/TGAC/grassroots-build-tools.git build-config
GetGitRepo https://github.com/TGAC/grassroots-core.git core
GetGitRepo https://github.com/TGAC/grassroots-lucene.git lucene

EnsureDir clients

EnsureDir handlers

EnsureDir libs
GetGitRepo https://github.com/TGAC/grassroots-geocoder.git geocoder
GetGitRepo https://github.com/TGAC/grassroots-frictionless-data.git frictionless-data

EnsureDir services
git clone https://github.com/TGAC/grassroots-service-field-trial.git field-trials

EnsureDir servers
cd servers
GetGitRepo https://github.com/TGAC/grassroots-server-apache-httpd.git httpd-server
GetGitRepo https://github.com/TGAC/grassroots-jobs-manager-mongodb.git mongodb-jobs-manager
GetGitRepo https://github.com/TGAC/grassroots-simple-servers-manager.git simple-servers-manager





