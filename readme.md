# Build tools

Although each component of the Grassroots infrastructure can be built in isolation, it can be much easier to manage all of the components together. That is what this package achieves.

# Configuration

The default layout for the subdirectories containing the Grassroots can be achieved by:

```
mkdir grassroots
cd grassroots
git clone https://github.com/TGAC/grassroots-build-tools.git
git clone https://github.com/TGAC/grassroots-core.git
mkdir clients
mkdir servers
mkdir services
```

which gives the layout shown below

```
grassroots
	|
	|--- build_config
	|
	|--- clients
	|
	|--- core
	|
	|--- servers
	|
	|--- services
```

Where any client, server or service components can be cloned inside the *clients*, *servers* or *services* directories respectively.

# Installing dependencies

There are various third party packages that Grassroots uses and there is an installation script to simplify this process. 

The first stage is to make sure that the required os packages are installed. 

## Libcurl

Check to see whether libsurl is installed by runing the following command

```
locate -b "\libcurl.so"
```

If no file is found it can be installed from one of the following packages:

```
sudo apt install libcurl4-gnutls-dev 
```

or 

```
sudo apt install libcurl4-nss-dev
```
or 

```
sudo apt install libcurl4-openssl-dev
```

You only need to install one of these so simply choose whichever one you prefer.

## zlib

Another required dependency is zlib which can be installed by typing 

```
sudo apt install zlib1g-dev
```

## Other dependencies 


The other dependencies can be installed using the supplied installation script at ```linux/install_dependencies.sh```. The first stage is to edit this file and set the path that you want to install the grassroots dependencies to. this is specified by the ```GRASSROOTS_EXTRAS_INSTALL_PATH``` variable. Once you''ve set this to the path that you would like to install to, you can run this script. This is done by sourcing this script, *e.g.*

```
. linux/install_dependencies
```

or 

```
source linux/install_dependencies
```

## Setting user preferences

The next stage is to set your preferenceces which is done in a file called ```linux/dependencies.properties```. An example one is provided so you can get an initial version of yuor preferences file by making a copy of this by doing

```
cp linux/example-dependencies.properties linux/dependencies.properties
```

We can now proceed to amending this file to your chosen layout.


### General configuration

The three main variables are:

 * **DIR_GRASSROOTS_INSTALL**: This is the grassroots folder where the libraries, services, configuration, *etc.* will be stored. So to set to this to ```/opt/grassroots```, the setting would be
 
  ```export DIR_GRASSROOTS_INSTALL := /opt/grassroots```

 * **DIR_APACHE**: This is the path to your Apache Httpd installation. So to set to this to ```/opt/apache```, the setting would be

  ```export DIR_GRASSROOTS_INSTALL := /opt/apache```
 
 
 * **DIR_GRASSROOTS_EXTRAS**: This shuold be set to the value you used for ```GRASSROOTS_EXTRAS_INSTALL_PATH``` when you installed the dependencies. So to set to this to ```/opt/grassroots/extras```, the setting would be
 

  ```export DIR_GRASSROOTS_EXTRAS := /opt/grassroots/extras``` 

### iRODS support
 

If you have iRODS installed and you wish to the Grassroots iRODS functionality such as the search service, *etc., then this can be configured here too.

The variables are:
 * **IRODS_ENABLED**: Set this to 0 to disbale the iRODS support and 1 to enable it. For example, to enable the iRODS functionality within Grassroots: 

  ```export IRODS_ENABLED := 1```
 
 * **IRODS_VERSION**: This specifies the major version of the iRODS installation. For recent installations this will be 4.x, so the setting is

  ```export IRODS_VERSION := 4```


### DRMAA support