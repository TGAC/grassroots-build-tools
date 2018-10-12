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

```
sudo apt install libcurl4-openssl-dev
```

## zlib

Another required dependency is zlib which can be installed by typing 

```
sudo apt install zlib1g-dev
```


## Other dependencies 


The other dependencies can be installed using the supplied installation script at ```linux/install_dependencies.sh```. The first stage is to edit this file and set the path that you want to install the grassroots dependencies to. this is specified by the ```GRASSROOTS_EXTRAS_INSTALL_PATH``` variable. Once you''ve set this to the path that you would like to install to, you can run this script. This is done by sourcing this script, *e.g.*

```
. linux/install_dependencies.sh
```

or 

```
source linux/install_dependencies.sh
```




Whilst this is the default layout, you can choose any other layout that you wish and amend the user preferences file appropriately which is described in more detail below.




## Setting user preferences

The user preferences