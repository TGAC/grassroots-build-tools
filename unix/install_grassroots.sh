#!/bin/bash

USER=tyrrells
PCRE2_VER=10.44
HTTPD_VER=2.4.62
APR_VER=1.7.5
APR_UTIL_VER=1.6.3
MONGODB_VER=7.0.14
MONGODB_TOOLS_VER=100.10.0

PCRE2_INSTALL_DIR=/opt/pcre2
APACHE_INSTALL_DIR=/opt/apache
MONGODB_INSTALL_DIR=/opt/mongodb



declare -A grassroots_services
grassroots_services[field-trials]="https://github.com/TGAC/grassroots-service-field-trial.git"
grassroots_services[search]="https://github.com/TGAC/grassroots-service-search.git"
grassroots_services[marti]="https://github.com/TGAC/grassroots-service-marti.git"

grassroots_services[users-groups]="https://github.com/TGAC/grassroots-service-users-groups.git"
grassroots_services[gene-trees]="https://github.com/TGAC/grassroots-service-gene-trees.git"
grassroots_services[parental-genotype]="https://github.com/TGAC/grassroots-parental-genotype-service.git"

grassroots_services[samtools]="https://github.com/TGAC/grassroots-service-samtools.git"
grassroots_services[blast]="https://github.com/TGAC/grassroots-service-blast.git"
grassroots_services[field-pathogenomics]="https://github.com/TGAC/grassroots-service-field-pathogenomics.git"


declare -A grassroots_libs
grassroots_libs[geocoder]="https://github.com/TGAC/grassroots-geocoder.git"
grassroots_libs[frictionless-data]="https://github.com/TGAC/grassroots-frictionless-data.git"


declare -A grassroots_servers
grassroots_servers[httpd-server]="https://github.com/TGAC/grassroots-server-apache-httpd.git"
grassroots_servers[mongodb-jobs-manager]="https://github.com/TGAC/grassroots-jobs-manager-mongodb.git"
grassroots_servers[simple-servers-manager]="https://github.com/TGAC/grassroots-simple-servers-manager.git"
grassroots_servers[brapi-module]="https://github.com/TGAC/grassroots-brapi-module.git"


declare -A grassroots_clients

declare -A grassroots_handlers


#sudo apt install default-jdk libcurl4-openssl-dev gcc wget automake unzip bzip2 flex make git cmake zlib1g-dev g++ libzstd-dev libssl-dev libexpat1-dev

GetAndUnpackArchive() {
	name=$1
	file_url=$2
	suffix=${3:-tar.gz}

	if [ ! -d $name ]; then
		echo "creating $name"

		if [ ! -f $name.$suffix ]; then
			echo "downloading $file_url/$name.$suffix"
			wget $file_url/$name.$suffix

			echo "unpacking $name.$suffix"
			tar zxf $name.$suffix
		fi
	fi
}


GetAllGitRepos() {
	local -n data_ref=$1

	for key in ${!data_ref[@]}
	do
		echo "Calling GetGitRepo 1:${data_ref[${key}]} 2:${key}"
		GetGitRepo ${data_ref[$key]} $key
	done
}


GetGitRepo() {
	git_url=$1
	name=$2

	if [ ! -d $name ]; then
		echo "calling: git clone $git_url $name"
		git clone $git_url $name
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


# Install PCRE2
if [ ! -d "$PCRE2_INSTALL_DIR" ]; then
	GetAndUnpackArchive pcre2-$PCRE2_VER https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER
	cd pcre2-$PCRE2_VER
	./configure --prefix=$PCRE2_INSTALL_DIR
	make

	echo "About to run: SudoEnsureDir $PCRE2_INSTALL_DIR"
	SudoEnsureDir $PCRE2_INSTALL_DIR

	echo "installing pcre2"
	make install
fi


cd ~/Downloads

# Install Apache
if [ ! -d "$APACHE_INSTALL_DIR" ]; then
	GetAndUnpackArchive httpd-$HTTPD_VER https://dlcdn.apache.org/httpd/
	GetAndUnpackArchive apr-$APR_VER https://dlcdn.apache.org/apr/
	GetAndUnpackArchive apr-util-$APR_UTIL_VER https://dlcdn.apache.org/apr/
	tar zxf apr-util-$APR_UTIL_VER.tar.gz
	tar zxf apr-$APR_VER.tar.gz
	tar zxf httpd-$HTTPD_VER.tar.gz
	mv apr-$APR_VER httpd-$HTTPD_VER/srclib/apr
	mv apr-util-$APR_UTIL_VER httpd-$HTTPD_VER/srclib/apr-util
	cd httpd-$HTTPD_VER
	./configure --prefix=$APACHE_INSTALL_DIR --with-included-apr --with-pcre=$PCRE2_INSTALL_DIR/bin/pcre2-config
	make
	SudoEnsureDir $APACHE_INSTALL_DIR
	make install
fi


cd ~/Downloads

# Install MongoDB
if [ ! -d "$MONGODB_INSTALL_DIR" ]; then
	tools_name=mongodb-database-tools-ubuntu2404-x86_64-$MONGODB_TOOLS_VER
	mongo_name=mongodb-linux-x86_64-ubuntu2204-$MONGODB_VER

	GetAndUnpackArchive $mongo_name https://fastdl.mongodb.org/linux tgz
	GetAndUnpackArchive $tools_name https://fastdl.mongodb.org/tools/db tgz

	tar zxf $mongo_name.tgz
	tar zxf $tools_name.tgz

	SudoEnsureDir $MONGODB_INSTALL_DIR
	cp -r $tools_name/* $MONGODB_INSTALL_DIR
	cp -r $mongo_name/* $MONGODB_INSTALL_DIR
	mkdir $MONGODB_INSTALL_DIR/dbs
fi


# Create the Projects directory
EnsureDir ~/Projects
EnsureDir ~/Projects/grassroots

# Install Grassroots
cd ~/Projects/grassroots

GetGitRepo https://github.com/TGAC/grassroots-build-tools.git build-config
GetGitRepo https://github.com/TGAC/grassroots-core.git core
GetGitRepo https://github.com/TGAC/grassroots-lucene.git lucene

EnsureDir ~/Projects/grassroots/services
cd ~/Projects/grassroots/services
GetAllGitRepos grassroots_services

EnsureDir ~/Projects/grassroots/servers
cd ~/Projects/grassroots/servers
GetAllGitRepos grassroots_servers

EnsureDir ~/Projects/grassroots/libs
cd ~/Projects/grassroots/libs
GetAllGitRepos grassroots_libs

EnsureDir ~/Projects/grassroots/clients
cd ~/Projects/grassroots/clients
GetAllGitRepos grassroots_clients

EnsureDir ~/Projects/grassroots/handlers
cd ~/Projects/grassroots/handlers
GetAllGitRepos grassroots_handlers