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

Whilst this is the default layout, you can choose any other layout that you wish and amend the user preferences file appropriately which is described in more detail below.

## Setting user preferences

The user preferences