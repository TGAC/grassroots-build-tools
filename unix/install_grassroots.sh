#!/bin/bash

# Edit this to where you want Grassroots installed to 
INSTALL_DIR=/home/billy/temp/dest

# This gets the current directory
SRC_DIR="$( cd "$(dirname "$0")" ; pwd -P )"


# array declarations are declare -A for bash and typeset -A for zsh
ARRAY_DECL="declare -A"
#ARRAY_DECL="typeset -A" 

# For Bash set this to -n, for zsh, leave blank
LOCAL_VAR_ARG=-n

# This is the library extension for this platform e.g. so for linux, dylib for mac
LIB_SUFFIX=so

# If you need sudo rights to install grassroots
# then set
# 
# SUDO=sudo
#
SUDO=

# Set this to either linux or mac depending upon your OS
PLATFORM=linux

# The path where you want the Grassroots source code to be checked out to
GRASSROOTS_PROJECT_DIR=$SRC_DIR/Projects/grassroots


# The root path that grassroots will be installed to
GRASSROOTS_INSTALL_DIR=$INSTALL_DIR/grassroots


# If you are needing to use sudo to install
# then this will set the owner
USER=billy


# The port to run apache on
APACHE_PORT=2000

# This is the web path that Grassroots backend server will be working on
APACHE_GRASSROOTS_LOCATION=grassroots/public_backend

# This is the name of the Grassroots config that we will generate
GRASSROOTS_SERVER_CONFIG=public

# This is the name that this Grassroots Server will use
PROVIDER_NAME=localhost

# This is the description that this Grassroots Server will use
PROVIDER_DESCRIPTION="Grassroots running on localhost"

# This is the logo that this Grassroots Server will use
PROVIDER_LOGO="grassroots/logo.png"

# Set this to the path of the mongorestore tool
MONGORESTORE=mongorestore

# The name to give to the field trials database
FIELD_TRIALS_DB=field_trials


# This is the web address that the Django server will be running on
DJANGO_URL="http://localhost:8000"


# The path to pdflatex used to generate the Study handbooks
PDFLATEX="/opt/texlive/bin/x86_64-linux/pdflatex"


# your geoify api key, see https://www.geoapify.com/ for details
GEOIFY_API_KEY=""


# Set this to http or https depending upon if your server is
# set up for secure traffic or not
HTTP="http"

DJANGO_DIR="django-server"

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
grassroots_servers[${DJANGO_DIR}]="https://github.com/TGAC/grassroots_services_django_web.git"


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


BUILD_CONFIG_DIR_NAME=build-config


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

#	echo ">>> length ${#data_ref[@]}"

	for key in ${!data_ref[@]}
	do
#		echo "Calling GetGitRepo 1:${data_ref[${key}]} 2:${key}"
		GetGitRepo ${data_ref[$key]} $key
	done
}


GetGitRepo() {
	git_url=$1
	name=$2

#	echo ">>>> GetGitRepo $git_url $name"

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
	if [ -e $1 ]; then
		res = 1
	fi
	
	echo res
}


WriteDependencies() {
	cd $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM

	# if there's an existing file, back it up
	if [ -e $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM/dependencies.properties ]; then
		
		if [ -e $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM/dependencies.properties~ ]; then
			rm $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM/dependencies.properties~
		fi

		mv $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM/dependencies.properties $GRASSROOTS_PROJECT_DIR/$BUILD_CONFIG_DIR_NAME/unix/$PLATFORM/dependencies.properties~

	fi



	echo -e "export DIR_GRASSROOTS_INSTALL := $GRASSROOTS_INSTALL_DIR" > dependencies.properties
	echo -e "export DIR_GRASSROOTS_EXTRAS := $GRASSROOTS_EXTRAS_INSTALL_PATH\n" >> dependencies.properties

	echo -e "export HCXSELECT_HOME := $HCXSELECT_INSTALL_DIR" >> dependencies.properties
	echo -e "export HTMLCXX_HOME := $HTMLCXX_INSTALL_DIR" >> dependencies.properties
	echo -e "export HTSLIB_HOME := $HTSLIB_INSTALL_DIR" >> dependencies.properties
	echo -e "export JANSSON_HOME := $JANSSON_INSTALL_DIR" >> dependencies.properties
	echo -e "export LIBEXIF_HOME := $LIBEXIF_INSTALL_DIR" >> dependencies.properties
	echo -e "export JANSSON_HOME := $JANSSON_INSTALL_DIR" >> dependencies.properties
	echo -e "export MONGODB_HOME := $MONGOC_INSTALL_DIR" >> dependencies.properties
	echo -e "export BSON_HOME := $MONGOC_INSTALL_DIR" >> dependencies.properties
	echo -e "export PCRE_HOME := $PCRE_INSTALL_DIR" >> dependencies.properties
	echo -e "export PCRE2_HOME := $PCRE2_INSTALL_DIR" >> dependencies.properties
	echo -e "export SQLITE_HOME := $SQLITE_INSTALL_DIR\n" >> dependencies.properties


	echo -e "export DIR_APACHE := $APACHE_INSTALL_DIR" >> dependencies.properties
	echo -e "export APXS := \$(DIR_APACHE)/bin/apxs" >> dependencies.properties
	echo -e "export SUDO := $SUDO" >> dependencies.properties

	echo -e "export IRODS_ENABLED := 0" >> dependencies.properties


	if [[ MONGO_C_VER == 1.* ]]; then
		BSON_LIB_NAME="bson-1.0"
		MONGO_LIB_NAME="mongoc-1.0"
		BSON_INC_NAME="lib$BSON_LIB_NAME"
		MONGO_INC_NAME="lib$MONGO_LIB_NAME"
	else 
		local c=${MONGO_C_VER:0:1}
		BSON_LIB_NAME="bson$c"	
		MONGO_LIB_NAME="mongoc$c"	
		BSON_INC_NAME="bson-$MONGO_C_VER"
		MONGO_INC_NAME="mongoc-$MONGO_C_VER"
	fi

	echo -e "export BSON_LIB_NAME := $BSON_LIB_NAME" >> dependencies.properties
	echo -e "export BSON_INC_NAME := $BSON_INC_NAME" >> dependencies.properties
	echo -e "export MONGO_LIB_NAME := $MONGO_LIB_NAME" >> dependencies.properties
	echo -e "export MONGO_INC_NAME := $MONGO_INC_NAME" >> dependencies.properties


#LUCENE_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/lucene
#SOLR_INSTALL_DIR=$GRASSROOTS_EXTRAS_INSTALL_PATH/solr
}


# lucene/grassroots-lucene.properties
WriteLuceneProperties() {

	cd $GRASSROOTS_PROJECT_DIR/lucene/

	# if there's an existing file, back it up
	if [ -e $GRASSROOTS_PROJECT_DIR/$lucene/grassroots-lucene.properties ]; then
		
		if [ -e $GRASSROOTS_PROJECT_DIR/$lucene/grassroots-lucene.properties~ ]; then
			rm $GRASSROOTS_PROJECT_DIR/$lucene/grassroots-lucene.properties~
		fi

		mv $GRASSROOTS_PROJECT_DIR/$lucene/grassroots-lucene.properties $GRASSROOTS_PROJECT_DIR/$lucene/grassroots-lucene.properties~

	fi


	echo -e "install.dir = $GRASSROOTS_INSTALL_DIR/lucene\n" > grassroots-lucene.properties

	echo -e "index.dir=\${install.dir}/index" >> grassroots-lucene.properties
	echo -e "tax.dir=\${install.dir}/tax\n" >> grassroots-lucene.properties

	echo -e "lucene.dir=$LUCENE_INSTALL_DIR" >> grassroots-lucene.properties
	echo -e "lucene.version=$LUCENE_VER\n" >> grassroots-lucene.properties

	echo -e "solr.dir=$SOLR_INSTALL_DIR" >> grassroots-lucene.properties
	echo -e "solr.version=$SOLR_VER\n" >> grassroots-lucene.properties
}



WriteGrassrootsServerConfig() {

	local global_config_filename="$GRASSROOTS_INSTALL_DIR/config/${GRASSROOTS_SERVER_CONFIG}_config"
	cd $GRASSROOTS_INSTALL_DIR


	echo "global_config_filename: $global_config_filename"

	# create the config folder
	mkdir -p config


	echo -e "{" > $global_config_filename

	# The Grassroots backend url
	echo -e "\t\"so:url\": \"${HTTP}://localhost:${APACHE_PORT}/${APACHE_GRASSROOTS_LOCATION}\"," >> $global_config_filename


	echo -e "\t\"jobs_manager\": \"mongodb_jobs_manager\"," >> $global_config_filename
	echo -e "\t\"servers_manager\": \"simple_external_servers_manager\"," >> $global_config_filename

	echo -e "\t\"mongodb_jobs_manager\": {" >> $global_config_filename
	echo -e "\t\t\"database\": \"grassroots\"," >> $global_config_filename
	echo -e "\t\t\"collection\": \"jobs\"" >> $global_config_filename
	echo -e "\t}," >> $global_config_filename

	echo -e "\t\"users\": {" >> $global_config_filename
	echo -e "\t\t\"database\": \"users_and_groups\"," >> $global_config_filename
	echo -e "\t\t\"users_collection\": \"users\"," >> $global_config_filename
	echo -e "\t\t\"groups_collection\": \"groups\"" >> $global_config_filename
	echo -e "\t}," >> $global_config_filename

	# provider
	echo -e "\t\"provider\": {" >> $global_config_filename
	echo -e "\t\t\"@type\": \"so:Organization\"," >> $global_config_filename
	echo -e "\t\t\"so:name\": \"${PROVIDER_NAME}\"," >> $global_config_filename
	echo -e "\t\t\"so:description\": \"${PROVIDER_DESCRIPTION}\"," >> $global_config_filename
	echo -e "\t\t\"so:url\": \"${HTTP}://localhost:${APACHE_PORT}/${APACHE_GRASSROOTS_LOCATION}\"," >> $global_config_filename
	echo -e "\t\t\"so:logo\": \"${HTTP}://localhost:${APACHE_PORT}/${PROVIDER_LOGO}\"" >> $global_config_filename
	echo -e "\t}," >> $global_config_filename


	# geocoder
	echo -e "\t\"geocoder\": {" >> $global_config_filename
	echo -e "\t\t\"default_geocoder\": \"nominatim\"," >> $global_config_filename
	echo -e "\t\t\"geocoders\": [{" >> $global_config_filename
	
	echo -e "\t\t\t\"name\": \"nominatim\"," >> $global_config_filename
	echo -e "\t\t\t\"reverse_geocode_url\": \"https://nominatim.openstreetmap.org/reverse\"," >> $global_config_filename
	echo -e "\t\t\t\"geocode_url\": \"https://nominatim.openstreetmap.org/search?format=json\"" >> $global_config_filename
	
	echo -e "\t\t}]" >> $global_config_filename
	echo -e "\t}," >> $global_config_filename


	# write the mongo config
	echo -e "\t\"mongodb\": {" >> $global_config_filename
	echo -e "\t\t\"uri\": \"mongodb://localhost:27017\"" >> $global_config_filename
	echo -e "\t}," >> $global_config_filename
	
	
	# lucene
	echo -e "\t\"lucene\": {" >> $global_config_filename






	# classpath
	local lucene_mods_dir=${LUCENE_INSTALL_DIR}/modules

	echo -e -n "\t\t\"classpath\": \"${lucene_mods_dir}/lucene-analysis-common-${LUCENE_VER}.jar" >> $global_config_filename

	echo -e -n ":${lucene_mods_dir}/lucene-core-${LUCENE_VER}.jar" >> $global_config_filename

	echo -e -n ":${lucene_mods_dir}/lucene-facet-${LUCENE_VER}.jar" >> $global_config_filename
	echo -e -n ":${lucene_mods_dir}/lucene-queryparser-${LUCENE_VER}.jar" >> $global_config_filename
	echo -e -n ":${lucene_mods_dir}/lucene-backward-codecs-${LUCENE_VER}.jar" >> $global_config_filename
	echo -e -n ":${lucene_mods_dir}/lucene-highlighter-${LUCENE_VER}.jar" >> $global_config_filename

	echo -e -n ":${lucene_mods_dir}/lucene-memory-${LUCENE_VER}.jar" >> $global_config_filename
	echo -e -n ":${lucene_mods_dir}/lucene-queries-${LUCENE_VER}.jar" >> $global_config_filename
	echo -e -n ":${GRASSROOTS_INSTALL_DIR}/lucene/lib/json-simple-1.1.1.jar" >> $global_config_filename
	echo -e -n ":${GRASSROOTS_INSTALL_DIR}/lucene/lib/grassroots-search-core-0.1.jar" >> $global_config_filename

	echo -e ":${GRASSROOTS_INSTALL_DIR}/lucene/lib/grassroots-search-lucene-app-0.1.jar\"," >> $global_config_filename
	




	echo -e "\t\t\"index\": \"$GRASSROOTS_INSTALL_DIR/lucene/index\"," >> $global_config_filename
	echo -e "\t\t\"taxonomy\": \"$GRASSROOTS_INSTALL_DIR/lucene/tax\"," >> $global_config_filename

	echo -e "\t\t\"search_class\": \"uk.ac.earlham.grassroots.app.lucene.Searcher\"," >> $global_config_filename
	echo -e "\t\t\"delete_class\": \"uk.ac.earlham.grassroots.app.lucene.Deleter\"," >> $global_config_filename
	echo -e "\t\t\"index_class\": \"uk.ac.earlham.grassroots.app.lucene.Indexer\"," >> $global_config_filename

	echo -e "\t\t\"working_directory\": \"$GRASSROOTS_INSTALL_DIR/working_directory/lucene\"," >> $global_config_filename
	echo -e "\t\t\"facet_key\": \"facet_type\"" >> $global_config_filename

	echo -e "\t}" >> $global_config_filename
	
	


	echo -e "\n}" >> $global_config_filename

}



# Install PCRE2
InstallPCRE2() {

	if [ ! -e "$PCRE2_INSTALL_DIR/bin/pcre2-config" ]; then

		cd $SRC_DIR/temp

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
}


# Install Apache
InstallApache() {
	if [ ! -e "$APACHE_INSTALL_DIR/bin/apxs" ]; then

		cd $SRC_DIR/temp

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
}


# Install MongoDB
InstallMongoDB() {
	if [ ! -e "$MONGODB_INSTALL_DIR/bin/mongod" ]; then

		cd $SRC_DIR/temp

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
}

# Install the dependencies

# Install Jansson 
InstallJansson() {
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
}

# LIBUUID
InstallLibUUID() {
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
}


# MONGO DB C
InstallMongoC() {
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
}


# LIBEXIF
InstallLibExif() {
	if [ ! -e "$LIBEXIF_INSTALL_DIR/lib/libexif.$LIB_SUFFIX" ]; then
		echo "$LIBEXIF_INSTALL_DIR/lib/libexif.$LIB_SUFFIX doesn't exist"
		echo ">>>> START INSTALLING EXIF"

		cd $SRC_DIR/temp

		GetAndUnpackArchive libexif-$LIBEXIF_VER https://github.com/libexif/libexif/releases/tag/v$LIBEXIF_VER zip
		cd libexif-$LIBEXIF_VER 

		./configure --prefix=$LIBEXIF_INSTALL_DIR 
		make 


		echo "About to run: SudoEnsureDir LIBEXIF_INSTALL_DIR "
		SudoEnsureDir $LIBEXIF_INSTALL_DIR 
		
		make install 

		echo ">>>> END INSTALLING EXIF"
	fi
}



# SQLITE
InstallSQLite() {
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
}


# HTMLCXX
InstallHTMLCXX() {
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
}

# HCX SELECT
InstallHCXSelect () {
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
}

# HTSLIB
InstallHTSLib () {
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
}

# PCRE
InstallPCRE() {
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

		echo ">>>> END INSTALLING PCRE"

	fi
}


# LUCENE
InstallLucene() {
	if [ ! -e "$LUCENE_INSTALL_DIR/modules/lucene-core-${LUCENE_VER}.jar" ]
	then

		echo "$LUCENE_INSTALL_DIR/modules/lucene-core-${LUCENE_VER}.jar doesn't exist"
		echo ">>>> START INSTALLING LUCENE"

		cd $SRC_DIR/temp
		wget https://dlcdn.apache.org/lucene/java/$LUCENE_VER/lucene-${LUCENE_VER}.tgz 
		tar xzf lucene-${LUCENE_VER}.tgz --directory $GRASSROOTS_EXTRAS_INSTALL_PATH
		
		if [ -d $LUCENE_INSTALL_DIR ]; then
			rm -fr $LUCENE_INSTALL_DIR
		fi
		
		mv $GRASSROOTS_EXTRAS_INSTALL_PATH/lucene-${LUCENE_VER} $LUCENE_INSTALL_DIR

		echo ">>>> END INSTALLING LUCENE"

	fi
}


# SOLR
InstallSolr() {
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
}


GetGrassrootsRepos() {
	# Create the Projects directory
	EnsureDir $GRASSROOTS_PROJECT_DIR

	# Install Grassroots
	cd $GRASSROOTS_PROJECT_DIR

	GetGitRepo https://github.com/TGAC/grassroots-build-tools.git $BUILD_CONFIG_DIR_NAME
	GetGitRepo https://github.com/TGAC/grassroots-core.git core
	GetGitRepo https://github.com/TGAC/grassroots-lucene.git lucene

	EnsureDir $GRASSROOTS_PROJECT_DIR/services
	cd $GRASSROOTS_PROJECT_DIR/services

#	echo "services: ${grassroots_services[@]}"
	GetAllGitRepos grassroots_services

	EnsureDir $GRASSROOTS_PROJECT_DIR/servers
	cd $GRASSROOTS_PROJECT_DIR/servers
	GetAllGitRepos grassroots_servers

	EnsureDir $GRASSROOTS_PROJECT_DIR/libs
	cd $GRASSROOTS_PROJECT_DIR/libs
	GetAllGitRepos grassroots_libs

	EnsureDir $GRASSROOTS_PROJECT_DIR/clients
	cd $GRASSROOTS_PROJECT_DIR/clients
	GetAllGitRepos grassroots_clients

	EnsureDir $GRASSROOTS_PROJECT_DIR/handlers
	cd $GRASSROOTS_PROJECT_DIR/handlers
	GetAllGitRepos grassroots_handlers
}


# Write the Grassroots Apache config and 
# add the include statement for it, if not 
# already there, to the main httpd.conf file
WriteApacheGrassrootsConfig() {
	local gr_conf=conf/extra/grassroots.conf
	cd ${APACHE_INSTALL_DIR}

	# if there's an existing file, back it up
	if [ -e ${gr_conf} ]; then
		
		if [ -e ${gr_conf}~ ]; then
			rm ${gr_conf}~
		fi

		mv ${gr_conf} ${gr_conf}~
	fi


	echo -e "#" > ${gr_conf}
	echo -e "# Load the Grassroots module and the caching modules required" >> ${gr_conf}
	echo -e "# for storing persistent data when the server is running" >> ${gr_conf}
	echo -e "#\n" >> ${gr_conf}

	echo -e "LoadModule grassroots_module modules/mod_grassroots.so" >> ${gr_conf}
	echo -e "LoadModule cache_module modules/mod_cache.so" >> ${gr_conf}
	echo -e "LoadModule cache_socache_module modules/mod_cache_socache.so" >> ${gr_conf}
	echo -e "LoadModule socache_shmcb_module modules/mod_socache_shmcb.so\n" >> ${gr_conf}

	echo -e "# Set the caching preferences for storing the persistent data" >> ${gr_conf}
	echo -e "CacheSocache shmcb" >> ${gr_conf}
	echo -e "CacheSocacheMaxSize 102400\n\n" >> ${gr_conf}


	echo -e "# Let Grassroots handle these requests" >> ${gr_conf}
	echo -e "<LocationMatch \"${APACHE_GRASSROOTS_LOCATION}\">\n" >> ${gr_conf}

	echo -e "\t# Set the uri for the Grassroots infrastructure requests" >> ${gr_conf}
	echo -e "\tSetHandler grassroots-handler\n" >> ${gr_conf}

	echo -e "\t# The path to the Grassroots root directory" >> ${gr_conf}
	echo -e "\tGrassrootsRoot ${GRASSROOTS_INSTALL_DIR}\n" >> ${gr_conf}

	echo -e "\t# The global configuration file to use" >> ${gr_conf}
	echo -e "\tGrassrootsConfig ${GRASSROOTS_SERVER_CONFIG}_config\n" >> ${gr_conf}

	echo -e "\t# The path to the service configuration files" >> ${gr_conf}
	echo -e "\tGrassrootsServicesConfigPath ${GRASSROOTS_SERVER_CONFIG}\n" >> ${gr_conf}


	echo -e "</LocationMatch>" >> ${gr_conf}

	# Add the config file to the main apache config 
	# if it's not already there
	local line="Include ${gr_conf}"
	local httpd_conf=${APACHE_INSTALL_DIR}/conf/httpd.conf
	grep -qF -- "${line}" "${httpd_conf}" || echo -e "# Add Grassroots\n${line}\n" >> "${httpd_conf}"
} 



InstallDemoDatabases() {
	read -p "Would you like to install the demo field trial data? [y/N] " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		# Get the demo mongodb and lucene databases
		echo "Install the dbs"
		local server="https://grassroots.tools/demo/downloads/"
		local lucene_db="demo_lucene_db.zip"
		local field_trials_db="demo_field_trials"

		cd $SRC_DIR/temp
		wget ${server}/${field_trials_db}.zip
		unzip ${field_trials_db}.zip
		${MONGORESTORE} -d ${FIELD_TRIALS_DB} ${field_trials_db}/${field_trials_db}


		
	else
		echo "Skipping the dummy field trial install"
	fi
}



WriteFieldTrialsServiceConfigs(){

	echo ">>>>>>> ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}"

	mkdir -p ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}
	cd ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}

	local cfg_file="Browse Programme Revisions"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_programme_url\": \"${DJANGO_URL}/fieldtrial/programme/\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Browse Study Revisions"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_study_url\": \"${DJANGO_URL}/fieldtrial/study/\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Browse Field Trial Revisions"	
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_trial_url\": \"${DJANGO_URL}/fieldtrial/trial/\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Manage Field Trial data"	
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_study_url\": \"${DJANGO_URL}/fieldtrial/study/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"">> "${cfg_file}"
  echo -e "\t\"wastebasket_path\": \"${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials/backups\",">> "${cfg_file}"
  echo -e "\t\"pdflatex_path\": \"${PDFLATEX}\",">> "${cfg_file}"
  echo -e "\t\"geoapify_api_key\": \"${GEOIFY_API_KEY}\",">> "${cfg_file}"
  echo -e "\t\"handbook_phenotype_images\": \"${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials/backup\"">> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Manage Study"	
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_study_url\": \"${DJANGO_URL}/fieldtrial/study/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
  echo -e "\t\"wastebasket_path\": \"${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials/backups\"," >> "${cfg_file}"
  echo -e "\t\"pdflatex_path\": \"${PDFLATEX}\"," >> "${cfg_file}"
  echo -e "\t\"geoapify_api_key\": \"${GEOIFY_API_KEY}\"," >> "${cfg_file}"
  echo -e "\t\"handbook_phenotype_images\": \"${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials/backup\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Search Field Trials"	
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_study_url\": \"${DJANGO_URL}/fieldtrial/study/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
  echo -e "\t\"use_mv_cache\": false," >> "${cfg_file}"
  echo -e "\t\"images\": {," >> "${cfg_file}"

  echo -e "\t\t\"Grassroots:Location\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/map\"," >> "${cfg_file}"
  echo -e "\t\t\"Grassroots:Study\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/polygonchange\"," >> "${cfg_file}"
  echo -e "\t\t\"Grassroots:FieldTrial\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/polygonchange\"," >> "${cfg_file}"
  echo -e "\t\t\"Grassroots:Phenotype\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/distance\"" >> "${cfg_file}"

  echo -e "\t}," >> "${cfg_file}"
  echo -e "\t\"geoapify_api_key\": \"${GEOIFY_API_KEY}\"," >> "${cfg_file}"
  echo -e "\t\"handbook_phenotype_images\": \"${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials/backup\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Edit Field Trial Rack"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_plots_url\": \"${DJANGO_URL}/fieldtrial/plots/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Any Field Trial data"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"default_crop\": \"wheat\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Crop"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Gene Banks"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Location"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_location_url\": \"${DJANGO_URL}/fieldtrial/location/\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Materials"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Measured Variables"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"
	

	cfg_file="Submit Field Trial Phenoytypes"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "Submit Field Trial Phenoytypes" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Plots"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_plots_url\": \"${DJANGO_URL}/fieldtrial/plots/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Programme"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_programme_url\": \"${DJANGO_URL}/fieldtrial/programme/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trials"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_trial_url\": \"${DJANGO_URL}/fieldtrial/trial/\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Study"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e ",\n\t\"view_study_url\": \"${DJANGO_URL}/fieldtrial/study/\"," >> "${cfg_file}"
  echo -e "\t\"fd_path\": \"${APACHE_INSTALL_DIR}/grassroots/frictionless\"," >> "${cfg_file}"
  echo -e "\t\"fd_url\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/frictionless\"" >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Treatment Factor"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"


	cfg_file="Submit Field Trial Treatments"
	BaseWriteFieldTrialsServiceConfig "${cfg_file}" "grassroots/images/polygonchange"
	echo -e "}" >> "${cfg_file}"

}



# $1 is config filename
# $2 is the icon
BaseWriteFieldTrialsServiceConfig() {


	cd ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}

	local working_directory=${GRASSROOTS_INSTALL_DIR}/working_directory/field_trials
	echo -e "{" > "$1"
	echo -e "\t\"so:image\": \"${HTTP}://localhost:${APACHE_PORT}/$2\"," >> "$1"
	echo -e "\t\"cache_path\": \"${working_directory}\"," >> "$1"
	echo -e "\t\"database\": \"${FIELD_TRIALS_DB}\"," >> "$1"
	echo -e -n "\t\"database_type\": \"mongodb\"" >> "$1"

}


WriteSearchGrassrootsConfig() {
	cd ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}
	local cfg_file="Search Grassroots"


	echo -e "{" > "${cfg_file}"
	echo -e "\t\"so:image\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/search\"," >> "${cfg_file}"

	echo -e "\t\"facets\": [{," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Dataset\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Dataset\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Service\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Service\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Field Trial\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Field Trial\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Study\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Study\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Location\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Location\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Measured Variable\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Measured Variable\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Programme\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Programme\"" >> "${cfg_file}"
	echo -e "\t}, {," >> "${cfg_file}"

	echo -e "\t\t\"so:name\": \"Publication\"," >> "${cfg_file}"
	echo -e "\t\t\"so:description\": \"Publication\"" >> "${cfg_file}"
	echo -e "\t}]" >> "${cfg_file}"

	echo -e "}" >> "${cfg_file}"
}



WriteUsersSubmissionConfig() {
	cd ${GRASSROOTS_INSTALL_DIR}/config/${GRASSROOTS_SERVER_CONFIG}
	local cfg_file="Users submission service"

	echo -e "{" > "${cfg_file}"
	echo -e "\t\"so:image\": \"${HTTP}://localhost:${APACHE_PORT}/grassroots/images/useradd\"," >> "${cfg_file}"
	echo -e "\t\"database\": \"users_and_groups\"," >> "${cfg_file}"
	echo -e "\t\"users_collection\": \"users\"," >> "${cfg_file}"
	echo -e "\t\"groups_collection\": \"groups\"," >> "${cfg_file}"
	echo -e "}" >> "${cfg_file}"
}




ConfigureDjango() {
	local django="grassroots_services_django_web/custom_settings.py"
	cd $GRASSROOTS_PROJECT_DIR/servers/${DJANGO_DIR}/

	# if there's an existing file, back it up
	if [ -e ${django} ]; then
		
		if [ -e ${django}~ ]; then
			rm ${django}~
		fi

		mv ${django} ${django}~
	fi
	

	echo -e "# The filesystem path to where the static files" >> "${django}"
	echo -e "# that Django uses will be installed" >> "${django}"
	echo -e "STATIC_ROOT = ${APACHE_INSTALL_DIR}/htdocs/static\n" >> "${django}"

	echo -e "# The web address to access the static files" >> "${django}"
	echo -e "STATIC_URL = '/static/'\n" >> "${django}"

	echo -e "# The web address for the grassroots server to connect to" >> "${django}"
	echo -e "SERVER_URL = \"${HTTP}://localhost:${APACHE_PORT}/${APACHE_GRASSROOTS_LOCATION}\"\n" >> "${django}"
	
	local security_key=`LC_ALL=C tr -dc '[:graph:]' < /dev/urandom | head -c 32; echo`
	
	echo -e "# SECURITY WARNING: keep the secret key used in production secret!" >> "${django}"
	echo -e "SECRET_KEY = \"${security_key}\"\n" >> "${django}"
	
	echo -e "# The Base URL used to generate the links from the single study page to the plots, etc." >> "${django}"
	echo -e "BASE_URL = "${HTTP}://localhost:${APACHE_PORT}"\n" >> "${django}"

	echo -e "# The path for the uploaded photos" >> "${django}"
	echo -e "MEDIA_ROOT = \"${APACHE_INSTALL_DIR}/htdocs/media\"\n" >> "${django}"

	echo -e "# The url for the uploaded photos" >> "${django}"
	echo -e "MEDIA_URL = \"media\"\n" >> "${django}"

	echo -e "# The url for the photo server." >> "${django}"
	echo -e "PHOTO_URL_SERVER = "${HTTP}://localhost:${APACHE_PORT}"\n" >> "${django}"


	echo -e "# Set this to True to enable debugging output" >> "${django}"
	echo -e "DEBUG = False\n" >> "${django}"

}


#######################
### START OF SCRIPT ###
#######################


echo ">>> ROOT: $SRC_DIR" 

EnsureDir $SRC_DIR/temp
cd $SRC_DIR/temp

# Install the depecndencies

InstallPCRE2

InstallApache

InstallMongoDB

InstallJansson

InstallLibUUID

InstallMongoC

InstallLibExif

InstallSQLite

#InstallHTMLCXX

#InstallHCXSelect

InstallHTSLib

InstallPCRE

InstallLucene

InstallSolr


# Get all of the grassroots code

GetGrassrootsRepos


# Set the dependencies.propeties file up
WriteDependencies


# Configure Lucene
WriteLuceneProperties


# Weite the main config file
WriteGrassrootsServerConfig


WriteApacheGrassrootsConfig


WriteFieldTrialsServiceConfigs


WriteSearchGrassrootsConfig 


WriteUsersSubmissionConfig

ConfigureDjango

InstallDemoDatabases


