# Build tools

Although each component of the Grassroots infrastructure can be built in isolation, it can be much easier to manage all of the components together. That is what this package achieves.

# Configuration

The default layout for the subdirectories containing the Grassroots can be achieved by:

```
mkdir grassroots
cd grassroots
git clone https://github.com/TGAC/grassroots-build-tools.git build-config
git clone https://github.com/TGAC/grassroots-core.git core
mkdir clients
mkdir handlers
mkdir servers
mkdir services
```

which gives the layout shown below

```
grassroots
	|
	|--- build-config
	|
	|--- clients
	|
	|--- core
	|
	|--- handlers 
	|
	|--- servers
	|
	|--- services
```

Where any client, server or service components can be cloned inside the *clients*, *handlers*, *servers* or *services* directories respectively.

You can view the available repositories of each type by going to one of the links below:
 
 * [Clients](https://github.com/TGAC?q=grassroots-client)
 * [Handlers](https://github.com/TGAC?q=grassroots-handler)
 * [Services](https://github.com/TGAC?q=grassroots-service)
 * [Servers](https://github.com/TGAC?q=grassroots-server)

# Installing dependencies

There are various third party packages that Grassroots uses and there is an installation script to simplify this process. 

The first stage is to make sure that the required OS packages are installed. On most systems the following packages are already installed, but you can make sure by running:

```
sudo apt install gcc wget automake unzip
```

## Libcurl

Check to see whether libcurl is installed by running the following command

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


The other dependencies can be installed using the supplied installation script at ```linux/install_dependencies.sh```. The first stage is to edit this file and set the path that you want to install the Grassroots dependencies to. this is specified by the ```GRASSROOTS_EXTRAS_INSTALL_PATH``` variable. Once you''ve set this to the path that you would like to install to, you can run this script. This is done by sourcing this script, *e.g.*

```
. linux/install_dependencies
```

or 

```
source linux/install_dependencies
```

## Setting user preferences

The next stage is to set your preferences which is done in a file called ```linux/dependencies.properties```. An example one is provided so you can get an initial version of your preferences file by making a copy of this by doing

```
cp linux/example-dependencies.properties linux/dependencies.properties
```

We can now proceed to amending this file to your chosen layout.


### General configuration

The three main variables are:

 * **DIR_GRASSROOTS_INSTALL**: This is the Grassroots folder where the libraries, services, configuration, *etc.* will be stored. So to set to this to ```/opt/grassroots```, the setting would be
 
  ```export DIR_GRASSROOTS_INSTALL := /opt/grassroots```

 * **DIR_APACHE**: This is the path to your Apache Httpd installation. So to set to this to ```/opt/apache```, the setting would be

  ```export DIR_GRASSROOTS_INSTALL := /opt/apache```

 * **DIR_GRASSROOTS_EXTRAS**: This should be set to the value you used for ```GRASSROOTS_EXTRAS_INSTALL_PATH``` when you installed the dependencies. So to set to this to ```/opt/grassroots/extras```, the setting would be
 

  ```export DIR_GRASSROOTS_EXTRAS := /opt/grassroots/extras``` 

### iRODS support
 

If you have [iRODS](https://irods.org/) installed and you wish to the Grassroots iRODS functionality such as the [search service](https://github.com/TGAC/grassroots-service-irods), *etc.*, then this can be configured here too.

The variables are:
 * **IRODS_ENABLED**: Set this to 0 to disable the iRODS support and 1 to enable it. For example, to enable the iRODS functionality within Grassroots: 

    ```export IRODS_ENABLED := 1```
 
 * **IRODS_VERSION**: This specifies the major version of the iRODS installation. For recent installations this will be 4.x, so the setting is
 
  ```export IRODS_VERSION := 4```


### DRMAA support

Grassroots has support for running jobs on high performance computing clusters using [DRMAA](http://www.drmaa.org) via [LSF](https://www.ibm.com/support/knowledgecenter/en/SSETD4/product_welcome_platform_lsf.html), [Slurm](https://slurm.schedmd.com/) or [HTCondor](https://research.cs.wisc.edu/htcondor/). When Grassroots is built, you have to specify which system, if any, you wish to use it with. The 3 variables are  ```SLURM_DRMAA_ENABLED```, ```LSF_DRMAA_ENABLED``` and ```HTCONDOR_DRMAA_ENABLED``` and setting them to 0 disables and setting one of them to 1 enables the DRMAA support for that system. So for example, to disable all DRMAA support, the configuration would be:

```
export SLURM_DRMAA_ENABLED := 0
export LSF_DRMAA_ENABLED := 0
export HTCONDOR_DRMAA_ENABLED := 0
```

To enable HTCondor support, the configuration would be:

```
export SLURM_DRMAA_ENABLED := 0
export LSF_DRMAA_ENABLED := 0
export HTCONDOR_DRMAA_ENABLED := 1
``` 


Once you have finished setting up the ```dependencies.properties``` file, you can then proceed to building Grassroots. 

# Building Grassroots

To build the Grassroots system, type

```make all```

and the system will proceed to build. To then install it, type

```make install```

# Additional build tool functionality


As well as the standard targets to build the Grassroots system, the makefile has a number of other targets to perform useful operations. These are listed below.

## Keeping Grassroots up to date

If you wish to get the latest versions of all of the Grassroots repositories that you have checked out, you can run 

```
make git-pull
```

to run ```git pull``` on all of the Grassroots repositories that you have checked out. 

## See which checked out repositories have local changes

If you are are developing some of the Grassroots repos and you wish to see which projects have local changes you can run 

```
make git-check
```

to list all of the repositories that have changes.


## Show the Grassroots build configuration 

If you are having problems building Grassroots which revolve around missing files, you can check the configuration of which folders Grassroots is using to build itself by typing: 

```
make show-config
```
 