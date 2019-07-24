# Build tools  {#installation_guide}

Although each component of the Grassroots infrastructure can be built in isolation, it can be much easier to manage all of the components together. That is what this package achieves.

# Installing dependencies

There are various third party packages that Grassroots uses and there is an installation script to simplify this process. 

The first stage is to make sure that the required OS packages are installed. On most systems the following packages are already installed, but you can make sure by running:

```
sudo apt install gcc wget automake unzip flex make git cmake zlib1g-dev g++
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


## Other dependencies 


The other dependencies can be installed using the supplied installation script at ```build-config/linux/install_dependencies```. 

The first stage is to edit this file and set the path that you want to install the Grassroots dependencies to. This is specified by the ```GRASSROOTS_EXTRAS_INSTALL_PATH``` variable within this file. 



Once you have set this to the path that you would like to install to, you can run this script *e.g.*

```
linux/install_dependencies
```

# Configuration

The default layout for the subdirectories containing the Grassroots can be achieved by:

```
mkdir grassroots
cd grassroots
git clone https://github.com/TGAC/grassroots-build-tools.git build-config
git clone https://github.com/TGAC/grassroots-core.git core
mkdir clients
mkdir handlers
mkdir libs
mkdir servers
mkdir services
cd servers
git clone https://github.com/TGAC/grassroots-server-apache-httpd.git httpd-server
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
	|--- libs 
	|
	|--- servers
	|
	|--- services
```

Where any client, server or service components can be cloned inside the *clients*, *handlers*, *servers* or *services* directories respectively.

You can view the available repositories of each type by going to one of the links below:
 
 * [Clients](https://github.com/TGAC?q=grassroots-client)
 * [Handlers](https://github.com/TGAC?q=grassroots-handler)
 * [Libs](https://github.com/TGAC?q=grassroots-lib)
 * [Services](https://github.com/TGAC?q=grassroots-service)
 * [Servers](https://github.com/TGAC?q=grassroots-server)


## Setting user preferences

The next stage is to set your preferences which is done in a file called ```build-config/<PLATFORM NAME>/dependencies.properties```. For example if you are running on Linux, then this would be ```build-config/linux/dependencies.properties```. An example one is provided so you can get an initial version of your preferences file by making a copy of this by doing

```
cd build-config
cp linux/example-dependencies.properties linux/dependencies.properties
```

We can now proceed to amending this file, ```linux/dependencies.properties```,   to your chosen layout.


### General configuration

The three main variables are:

 * **DIR_GRASSROOTS_INSTALL**: This is the Grassroots folder where the libraries, services, configuration, *etc.* will be stored. So to set to this to ```/opt/grassroots```, the setting would be
 
    ```export DIR_GRASSROOTS_INSTALL := /opt/grassroots```

 * **DIR_APACHE**: This is the path to your [Apache Httpd](http://httpd.apache.org/) installation. So to set to this to ```/opt/apache```, the setting would be

    ```export DIR_APACHE := /opt/apache```

  If however you are using an Apache Httpd that is spread across different directories, such as is often the case when using the OS package manager, then simply leave this blank 

    ```export DIR_APACHE :=```

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


# Apache httpd installation

Although any web server could potentially be used as Grassroots server, the default is to use the [Apache httpd](http://httpd.apache.org) web server as it has the the benefit of being able to add functionality easily with its modular approach.

On Linux, there are 2 options for installing httpd; using  the OS package manager or building it from source

## Using an Apache httpd from an OS Package Manager

To install httpd using the package manager on Debian and its derivatives such as Ubuntu, Mint, *etc.*, you can run the following commands

```
sudo apt install apache2
sudo apt install apache2-dev
sudo a2enmod cache socache socache_shmcb 
```



# Building Grassroots

To build the Grassroots system, navigate to the build subfolder which is ```<PLATFORM>```. So, for example,
to build it for linux, go to the appropriate build folder

```
cd linux
```

and then type

```
make all
```

and the system will proceed to build. To then install it, type

```
make install
```

# Additional build tool functionality


As well as the standard targets to build the Grassroots system, the makefile has a number of other targets to perform useful operations. These are listed below.

## Keeping Grassroots up to date

If you wish to get the latest versions of all of the Grassroots repositories that you have checked out, you can run 

```
make git-pull
```

to run ```git pull``` on all of the Grassroots repositories that you have checked out. 

## See which checked out repositories have local changes

If you are are developing some of the Grassroots repositories and you wish to see which projects have local changes you can run 

```
make git-check
```

to list all of the repositories that have changes.


## Show the Grassroots build configuration 

If you are having problems building Grassroots which revolve around missing files, you can check the configuration of which folders Grassroots is using to build itself by typing: 

```
make show-config
```
 
