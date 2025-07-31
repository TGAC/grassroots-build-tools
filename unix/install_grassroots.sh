#!/bin/bash

# edit this to where you want the tools installed to 
INSTALL_DIR=/home/billy/temp/dest

# This is where all of the Grassroots git repos will get checked out to
SRC_DIR="$( cd "$(dirname "$0")" ; pwd -P )"


# array declarations are declare -A for bash and typeset -A for zsh
ARRAY_DECL="declare -A"
#ARRAY_DECL="typeset -A" 

# for Bash set this to -n, for zsh, leave blank
LOCAL_VAR_ARG=-n

# so for linux, dylib for mac
LIB_SUFFIX=so

# If you need sudo rights to install grassroots
# then set
# 
# SUDO=sudo
#
SUDO=


# The root path that grassroots will be installed to
GRASSROOTS_INSTALL_DIR=$INSTALL_DIR/grassroots


# If you are needing to use sudo to install
# then this will set the owner
USER=billy


#######################################
## The versions of the various tools ##
#######################################


APR_VER=1.7.6
APR_UTIL_VER=1.6.3
HTTPD_VER=2.4.65
MONGODB_TOOLS_VER=100.12.2
MONGODB_VER=8.0.12
PCRE2_VER=10.45


HCXSELECT_VER=1.1
HTMLCXX_VER=0.86
HTSLIB_VER=1.21
JANSSON_VER=2.14
LIBEXIF_VER=0.6.24
LIBUUID_VER=1.0.3
LUCENE_VER=9.12.2
MONGO_C_VER=2.0.2
PCRE_VER=8.45
PCRE2_VER=10.44
SOLR_VER=9.9.0
SQLITE_VER=3500400
SQLITE_YEAR=2025



#####################################
#####################################
#####################################
#### DO NOT EDIT BELOW THIS LINE ####
#####################################
#####################################
#####################################


eval "$ARRAY_DECL" grassroots_services=(
	[field-trials]="https://github.com/TGAC/grassroots-service-field-trial.git"
	[search]="https://github.com/TGAC/grassroots-service-search.git"
	[marti]="https://github.com/TGAC/grassroots-service-marti.git"
	[users-groups]="https://github.com/TGAC/grassroots-service-users-groups.git"
	[gene-trees]="https://github.com/TGAC/grassroots-service-gene-trees.git"
	[parental-genotype]="https://github.com/TGAC/grassroots-parental-genotype-service.git"
	[samtools]="https://github.com/TGAC/grassroots-service-samtools.git"
	[blast]="https://github.com/TGAC/grassroots-service-blast.git"
	[field-pathogenomics]="https://github.com/TGAC/grassroots-service-field-pathogenomics.git"
)

eval "$ARRAY_DECL" grassroots_libs=(
	[geocoder]="https://github.com/TGAC/grassroots-geocoder.git" 
	[frictionless-data]="https://github.com/TGAC/grassroots-frictionless-data.git"
)

eval "$ARRAY_DECL" grassroots_servers
grassroots_servers["httpd-server"]="https://github.com/TGAC/grassroots-server-apache-httpd.git"
grassroots_servers["mongodb-jobs-manager"]="https://github.com/TGAC/grassroots-jobs-manager-mongodb.git"
grassroots_servers["simple-servers-manager"]="https://github.com/TGAC/grassroots-simple-servers-manager.git"
grassroots_servers["brapi-module"]="https://github.com/TGAC/grassroots-brapi-module.git"


eval "$ARRAY_DECL" grassroots_clients

eval "$ARRAY_DECL" grassroots_handlers


GRASSROOTS_EXTRAS_INSTALL_PATH=$GRASSROOTS_INSTALL_DIR/extras

APACHE_INSTALL_DIR=$INSTALL_DIR/apache
MONGODB_INSTALL_DIR=$INSTALL_DIR/mongodb
PCRE2_INSTALL_DIR=$INSTALL_DIR/pcre2


HCXSELECT_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/hcxselect
HTMLCXX_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/htmlcxx
HTSLIB_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/htslib
JANSSON_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/jansson
LIBEXIF_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/libexif
LIBUUID_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/libuuid
LUCENE_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/lucene
MONGOC_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/mongoc
PCRE_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/pcre
SOLR_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/solr
SQLITE_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/sqlite


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

			if [ $suffix = "zip" ]; then
				unzip $name.$suffix
			else
				tar zxf $name.$suffix				
			fi
			
		fi
	fi
}


GetAllGitRepos() {
	local $LOCAL_VAR_ARG data_ref=$1

	echo ">>> length ${#data_ref[@]}"

	for key in ${!data_ref[@]}
	do
		echo "Calling GetGitRepo 1:${data_ref[${key}]} 2:${key}"
		GetGitRepo ${data_ref[$key]} $key
	done
}


GetGitRepo() {
	git_url=$1
	name=$2

	echo ">>>> GetGitRepo $git_url $name"

	if [ ! -d $name ]; then
		echo "calling: git clone $git_url $name"
		git clone $git_url $name
	fi
}

EnsureDir() {
	if [ ! -d $1 ]; then
		echo "About to run: mkdir -p $1"
	  mkdir -p $1
	fi
}


SudoEnsureDir() {
	if [ ! -d $1 ]; then
		echo "About to run: sudo mkdir -p $1"
		$SUDO mkdir -p $1

		if [ ! -z "$SUDO" ]; then
			echo "About to run: sudo chown $USER $1"
			$SUDO chown $USER $1
		fi
	fi
}


DoesFileExist() {
	local res = 0;
	if [ -e $1]; then
		res = 1
	fi
	
	echo res
}

echo ">>> ROOT: $SRC_DIR" 

EnsureDir $SRC_DIR/temp
cd $SRC_DIR/temp



# Install PCRE2
if [ ! -e "$PCRE2_INSTALL_DIR/bin/pcre2-config" ]; then
	echo "$PCRE2_INSTALL_DIR/bin/pcre2-config doesn't exist"
	GetAndUnpackArchive pcre2-$PCRE2_VER https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER
	cd pcre2-$PCRE2_VER
	./configure --prefix=$PCRE2_INSTALL_DIR
	make

	echo "About to run: SudoEnsureDir $PCRE2_INSTALL_DIR"
	SudoEnsureDir $PCRE2_INSTALL_DIR

	echo "installing pcre2"
	make install
fi


cd $SRC_DIR/temp

# Install Apache
if [ ! -e "$APACHE_INSTALL_DIR/bin/apxs" ]; then
	echo "$APACHE_INSTALL_DIR/bin/apxs doesn't exist"
	echo ">>>> START INSTALLAING APACHE"
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
	echo ">>>> END INSTALLAING APACHE"
fi


cd $SRC_DIR/temp

# Install MongoDB
if [ ! -e "$MONGODB_INSTALL_DIR/bin/mongod" ]; then
	echo "$MONGODB_INSTALL_DIR/bin/mongod doesn't exist"
	echo ">>>> START INSTALLAING MONGO"
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
	echo ">>>> END INSTALLAING MONGO"
fi


# Install the dependencies

# Install Jansson 
if [ ! -e "$JANSSON_INSTALL_DIR/lib/libjansson.$LIB_SUFFIX" ]; then
	echo "$JANSSON_INSTALL_DIR/lib/libjansson.$LIB_SUFFIX doesn't exist"
	echo ">>>> START INSTALLAING JANSSON"
	
	cd $SRC_DIR/temp
	
	GetAndUnpackArchive jansson-$JANSSON_VER https://github.com/akheron/jansson/releases/download/v$JANSSON_VER/
	cd jansson-$JANSSON_VER
	./configure --prefix=$JANSSON_INSTALL_DIR
	
	make
	
	echo "About to run: SudoEnsureDir $JANSSON_INSTALL_DIR"
	SudoEnsureDir $JANSSON_INSTALL_DIR

	echo "installing jansson"
	make install

	echo ">>>> END INSTALLAING JANSSON"
fi


# LIBUUID
if [ ! -e "$LIBUUID_INSTALL_DIR/lib/libuuid.$LIB_SUFFIX" ]; then
	echo "$LIBUUID_INSTALL_DIR/lib/libuuid.$LIB_SUFFIX doesn't exist"
	echo ">>>> START INSTALLING UUID"

	cd $SRC_DIR/temp

	wget -O libuuid-$LIBUUID_VER.tar.gz "https://downloads.sourceforge.net/project/libuuid/libuuid-$LIBUUID_VER.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibuuid%2Ffiles%2Flibuuid-$LIBUUID_VER.tar.gz%2Fdownload&ts=1532275139"  
	tar xzf libuuid-$LIBUUID_VER.tar.gz 
	cd libuuid-$LIBUUID_VER  
	./configure --prefix=$LIBUUID_INSTALL_DIR

	make
	
	echo "About to run: SudoEnsureDir $LIBUUID_INSTALL_DIR"
	SudoEnsureDir $LIBUUID_INSTALL_DIR

	echo "installing jansson"
	make install

	echo ">>>> END INSTALLING UUID"
fi



# MONGO DB C
if [ ! -e "$MONGOC_INSTALL_DIR/lib/libmongoc2.$LIB_SUFFIX" ]; then
	echo "$MONGOC_INSTALL_DIR/lib/libmongoc2.$LIB_SUFFIX doesn't exist"
	echo ">>>> START INSTALLING MONGOC"

	cd $SRC_DIR/temp

	GetAndUnpackArchive mongo-c-driver-$MONGO_C_VER https://github.com/mongodb/mongo-c-driver/releases/download/$MONGO_C_VER
	cd mongo-c-driver-$MONGO_C_VER

	EnsureDir _build 

	cmake -S . -B _build -D CMAKE_BUILD_TYPE=RelWithDebInfo -D BUILD_VERSION="$MONGO_C_VER" -D ENABLE_MONGOC=ON -D ENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF
	cmake --build _build --config RelWithDebInfo --parallel

	echo "About to run: SudoEnsureDir $MONGOC_INSTALL_DIR"
	SudoEnsureDir $MONGOC_INSTALL_DIR

	cmake --install _build --config RelWithDebInfo --prefix=$MONGOC_INSTALL_DIR


	echo ">>>> END INSTALLING MONGOC"
fi



# LIBEXIF
if [ ! -e "$LIBEXIF_INSTALL_DIR/lib/libexif.$LIB_SUFFIX" ]; then
	echo "$LIBEXIF_INSTALL_DIR/lib/libexif.$LIB_SUFFIX doesn't exist"
	echo ">>>> START INSTALLING EXIF"

	cd ~/Downloads

	GetAndUnpackArchive libexif-$LIBEXIF_VER https://github.com/libexif/libexif/releases/tag/v$LIBEXIF_VER zip
	cd libexif-$LIBEXIF_VER 

	./configure --prefix=$LIBEXIF_INSTALL_DIR 
	make 


	echo "About to run: SudoEnsureDir LIBEXIF_INSTALL_DIR "
	SudoEnsureDir $LIBEXIF_INSTALL_DIR 
	
	make install 

	echo ">>>> END INSTALLING EXIF"
fi




# SQLITE
if [ ! -e "$SQLITE_INSTALL_DIR/lib/libsqlite3.$LIB_SUFFIX" ]
then
	echo "$SQLITE_INSTALL_DIR/lib/libsqlite3.$LIB_SUFFIX doesn't exist"

	echo ">>>> START INSTALLING SQLITE"

	cd $SRC_DIR/temp
	wget https://www.sqlite.org/$SQLITE_YEAR/sqlite-amalgamation-$SQLITE_VER.zip 
	unzip sqlite-amalgamation-$SQLITE_VER.zip 
	cd sqlite-amalgamation-$SQLITE_VER 
	gcc sqlite3.c -o libsqlite3.$LIB_SUFFIX -shared -fPIC 
	SudoEnsureDir $SQLITE_INSTALL_DIR/include 
	mkdir -p $SQLITE_INSTALL_DIR/lib 
	cp libsqlite3.$LIB_SUFFIX $SQLITE_INSTALL_DIR/lib/ 
	cp *.h $SQLITE_INSTALL_DIR/include 

	echo ">>>> END INSTALLING SQLITE"
fi



# HTMLCXX
if [ ! -e "$HTMLCXX_INSTALL_DIR/lib/libhtmlcxx.$LIB_SUFFIX" ]
then

	echo "$HTMLCXX_INSTALL_DIR/lib/libhtmlcxx.$LIB_SUFFIX doesn't exist"
	echo ">>>> START INSTALLING HTMLCXX"

	cd $SRC_DIR/temp
	wget -O htmlcxx-$HTMLCXX_VER.tar.gz "https://downloads.sourceforge.net/project/htmlcxx/htmlcxx/$HTMLCXX_VER/htmlcxx-0.86.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fhtmlcxx%2Ffiles%2Flatest%2Fdownload%3Fsource%3Dtyp_redirect&ts=1532444157" 
	tar xzf htmlcxx-$HTMLCXX_VER.tar.gz 
	cd htmlcxx-$HTMLCXX_VER 
	./configure --prefix=$HTMLCXX_INSTALL_DIR
	make install 

	echo ">>>> END INSTALLING HTMLCXX"

fi


# HCX SELECT
if [ ! -e "$HCXSELECT_INSTALL_DIR/lib/libhcxselect.$LIB_SUFFIX" ]
then

	echo "$HCXSELECT_INSTALL_DIR/lib/libhcxselect.$LIB_SUFFIX"
	echo ">>>> START INSTALLING HCX SELECT"

	cd $SRC_DIR/temp
	wget https://github.com/jgehring/hcxselect/archive/$HCXSELECT_VER.tar.gz  
	tar xzf $HCXSELECT_VER.tar.gz 
	cd hcxselect-$HCXSELECT_VER/src 
	patch < $SRC_DIR/hcxselect.patch 
	make shared DIR_HTMLCXX=$HCXSELECT_INSTALL_DIR
	mkdir -p $HCXSELECT_INSTALL_DIR/include 
	mkdir -p $HCXSELECT_INSTALL_DIR/lib 
	cp libhcxselect.so $HCXSELECT_INSTALL_DIR/lib/ 
	cp *.h $HCXSELECT_INSTALL_DIR/include	 

	echo ">>>> END INSTALLING HCX SELECT"

fi

# HTSLIB
if [ ! -e "$HTSLIB_INSTALL_DIR/lib/libhts.$LIB_SUFFIX" ]
then
	echo "$HTSLIB_INSTALL_DIR/lib/libhts.$LIB_SUFFIX doesn't exist"

	echo ">>>> START INSTALLING HTSLIB"

	cd $SRC_DIR/temp
	wget https://github.com/samtools/htslib/releases/download/$HTSLIB_VER/htslib-$HTSLIB_VER.tar.bz2 
	tar xjf htslib-$HTSLIB_VER.tar.bz2 
	cd htslib-$HTSLIB_VER 
	./configure --prefix=$HTSLIB_INSTALL_DIR --disable-bz2 --disable-lzma 
	make install 

	echo ">>>> END INSTALLING HTSLIB"

fi

# PCRE
if [ ! -e "$PCRE_INSTALL_DIR/lib/libpcre.$LIB_SUFFIX" ]
then
	echo "$PCRE_INSTALL_DIR/lib/libpcre.$LIB_SUFFIX doesn't exist"

	echo ">>>> START INSTALLING PCRE"

	cd $SRC_DIR/temp
	wget https://altushost-swe.dl.sourceforge.net/project/pcre/pcre/$PCRE_VER/pcre-$PCRE_VER.tar.bz2 
	tar xjf pcre-$PCRE_VER.tar.bz2 
	cd pcre-$PCRE_VER 
	./configure --prefix=$PCRE_INSTALL_DIR
	make install 

	echo ">>>> EWND INSTALLING PCRE"

fi


# LUCENE
if [ ! -e "$LUCENE_INSTALL_DIR/modules/lucene-core-$LUCENE_VER.jar" ]
then

	echo "$LUCENE_INSTALL_DIR/modules/lucene-core-$LUCENE_VER.jar doesn't exist"
	echo ">>>> START INSTALLING LUCENE"

	cd $SRC_DIR/temp
	wget https://dlcdn.apache.org/lucene/java/$LUCENE_VER/lucene-$LUCENE_VER.tgz 
	tar xzf lucene-$LUCENE_VER.tgz --directory $GRASSROOTS_EXTRAS_INSTALL_PATH
	
	if [ -d $LUCENE_INSTALL_DIR ]; then
		rm -fr $LUCENE_INSTALL_DIR
	fi
	
	mv $GRASSROOTS_EXTRAS_INSTALL_PATH/lucene-$LUCENE_VER $LUCENE_INSTALL_DIR

	echo ">>>> END INSTALLING LUCENE"

fi


# SOLR
if [ ! -e "$SOLR_INSTALL_DIR/bin/solr" ]
then

	echo "$SOLR_INSTALL_DIR/bin/solr doesn't exist"
	echo ">>>> START INSTALLING SOLR"

	cd $SRC_DIR/temp
	wget --max-redirect 20 "https://www.apache.org/dyn/closer.lua/solr/solr/$SOLR_VER/solr-$SOLR_VER.tgz?action=download" -O solr-$SOLR_VER.tgz
	tar xzf solr-$SOLR_VER.tgz --directory $GRASSROOTS_EXTRAS_INSTALL_PATH

	if [ -d $SOLR_INSTALL_DIR ]; then
		rm -fr $SOLR_INSTALL_DIR
	fi
	

	mv $GRASSROOTS_EXTRAS_INSTALL_PATH/solr-$SOLR_VER $SOLR_INSTALL_DIR


	echo ">>>> END INSTALLING SOLR"
fi


# Create the Projects directory
EnsureDir $SRC_DIR/Projects
EnsureDir $SRC_DIR/Projects/grassroots

# Install Grassroots
cd $SRC_DIR/Projects/grassroots

GetGitRepo https://github.com/TGAC/grassroots-build-tools.git build-config
GetGitRepo https://github.com/TGAC/grassroots-core.git core
GetGitRepo https://github.com/TGAC/grassroots-lucene.git lucene

EnsureDir $SRC_DIR/Projects/grassroots/services
cd $SRC_DIR/Projects/grassroots/services

echo "services: ${grassroots_services[@]}"
GetAllGitRepos grassroots_services

EnsureDir $SRC_DIR/Projects/grassroots/servers
cd $SRC_DIR/Projects/grassroots/servers
GetAllGitRepos grassroots_servers

EnsureDir $SRC_DIR/Projects/grassroots/libs
cd $SRC_DIR/Projects/grassroots/libs
GetAllGitRepos grassroots_libs

EnsureDir $SRC_DIR/Projects/grassroots/clients
cd $SRC_DIR/Projects/grassroots/clients
GetAllGitRepos grassroots_clients

EnsureDir $SRC_DIR/Projects/grassroots/handlers
cd $SRC_DIR/Projects/grassroots/handlers
GetAllGitRepos grassroots_handlers
