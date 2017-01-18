Repo Manifests for building systems based on the meta-gnss-sdr layer
====================================================================

This repository provides Repo manifests to setup the OpenEmbedded build system
with the meta-gnss-sdr layer.

OpenEmbedded allows the creation of custom linux distributions for embedded
systems. It is a collection of git repositories known as *layers* each of
which provides *recipes* to build software packages as well as configuration
information.

Repo is a tool that enables the management of many git repositories given a
single *manifest* file.  Tell repo to fetch a manifest from this repository and
it will fetch the git repositories specified in the manifest and, by doing so,
setup an OpenEmbedded build environment for you!


Setting up the build host
---------------

The process described below is based on [OpenEmbedded](http://www.openembedded.org) (a build framework for embedded Linux) and the [Yocto Project](https://www.yoctoproject.org/) (a complete embedded Linux development environment covering several build profiles across multiple architectures including ARM, PPC, MIPS, x86, and x86-64). In order to set up a build host, you will need a machine with a minimum of 50 Gbytes of free disk space and running a supported Linux distribution. In general, if you have the current release minus one of Ubuntu, Fedora, openSUSE, CentOS or Debian you should have no problems. For a more detailed list of distributions that support the Yocto Project, see the [Supported Linux Distributions](http://www.yoctoproject.org/docs/2.2/ref-manual/ref-manual.html#detailed-supported-distros) section in the Yocto Project Reference Manual.

### Tested Environment

Ubuntu 16.04 64 bits in a Virtual Machine

```
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath libsdl1.2-dev xterm
```

Configure Git:

```
$ git config --global user.name "Your Name"
$ git config --global user.email your.name@example.com
```


Getting Started
---------------
1.  Install Repo.

    Download the Repo script.

        $ curl http://storage.googleapis.com/git-repo-downloads/repo > repo

    Make it executable.

        $ chmod a+x repo

    Move it on to your system path.

        $ sudo mv repo /usr/local/bin/

2.  Initialize a Repo client.

    Create an empty directory to hold your working files.

        $ mkdir oe-repo
        $ cd oe-repo

    Tell Repo where to find the manifest

        $ repo init -u git://github.com/carlesfernandez/oe-gnss-sdr-manifest.git -b morty

    A successful initialization will end with a message stating that Repo is
    initialized in your working directory. Your client directory should now
    contain a .repo directory where files such as the manifest will be kept.

    **Note on the branch name**: This repository has several branches, which names follow those of [Yocto Project Releases](https://wiki.yoctoproject.org/wiki/Releases). Each branch will download and build different versions of the software packages. Most recent stuff is in the ```master``` branch, but it can be unstable.

    To learn more about repo, look at https://source.android.com/source/using-repo.html

3.  Fetch all the repositories.

        $ repo sync

    Now go put on the coffee machine as this may take 20 minutes depending on
    your connection.

4.  Initialize the OpenEmbedded Environment.

        $ TEMPLATECONF=`pwd`/meta-gnss-sdr/conf source ./oe-core/oe-init-build-env ./build ./bitbake

    This copies default configuration information into the ```./build/conf```
    directory and sets up some environment variables for OpenEmbedded.  You may
    wish to edit the configuration options at this point. The default target is ```MACHINE=zedboard-zynq7``` but you can override that defining an environment variable:

        $ export MACHINE=raspberrypi3

5.  Build an image.

    This process downloads several gigabytes of source code and then proceeds to
    do an awful lot of compilation so make sure you have plenty of space (25 GB
    minimum). Go drink some beer.

        $ bitbake gnss-sdr-dev-image

    If everything goes well, you should have a compressed root filesystem
    tarball as well as kernel and bootloader binaries available in your
    *work/deploy* directory.  If you run into problems, the most likely
    candidate is missing packages.  Check out the [list of required packages for each operating system](http://www.yoctoproject.org/docs/2.2/ref-manual/ref-manual.html#required-packages-for-the-host-development-system).

6.  Build an SDK for cross compiling GNSS-SDR on an x86 machine.

    Run:

        $ bitbake -c populate_sdk gnss-sdr-dev-image

    When this completes the SDK is in ```./tmp-glibc/deploy/sdk/``` as an .sh file
    you copy to the machine you want to cross compile on and run the file.
    It will default to installing the SDK in ```/usr/local```, and you can ask it to
    install anywhere you have write access to.

Using the SDK
---------------

Install it by running:

        $ sudo sh ./tmp-glibc/deploy/sdk/oecore-x86_64-armv7ahf-neon-toolchain-nodistro.0.sh


This will ask you what directory to install the SDK into. Which directory doesn't matter, just make sure wherever it goes that you have enough disk space. The default is ```/usr/local```. You can also install it in your home directory if you do not have root access.

Running the environment script will set up most of the variables we'll need to compile. You will need to do this each time you want to run the SDK (and since the environment variable are only set for the current shell, you need to source it for every console you will run the SDK from)

        $ . /usr/local/oecore-x86_64/environment-setup-armv7ahf-neon-oe-linux-gnueabi

Cross compile GNSS-SDR and install on target:

        $ git clone https://github.com/gnss-sdr/gnss-sdr.git
        $ cd gnss-sdr
        $ git checkout next
        $ cd build
        $ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr ..
        $ make
        $ sudo make install DESTDIR=/usr/local/oecore-x86_64/sysroots/armv7ahf-neon-oe-linux-gnueabi/



Build a root filesystem with GNSS-SDR already installed
---------------

In order to obtain a filesystem with GNSS-SDR already installed and ready to be copied to your SD card, you can bit bake the following image:

        $ bitbake gnss-sdr-demo-image
        $ bitbake -c populate_sdk gnss-sdr-demo-image

This will create a root filesystem at ```./tmp-glibc/deploy/images/zedboard-zynq7/gnss-sdr-demo-image-zedboard-zynq7-YYYYMMDDHHMMSS.rootfs.tar.gz```.

As well, executing ```./tmp-glibc/deploy/sdk/oecore-x86_64-armv7ahf-neon-toolchain-nodistro.0.sh``` as sudo will install the SDK, providing the full root filesystem at ```/usr/local/oecore-x86_64/sysroots/armv7ahf-neon-oe-linux-gnueabi/```.

Such filesystem, as in the case of the ```gnss-sdr-dev-image``` recipe, will have root access without password by default.


Building a minimal image with GNSS-SDR installed
---------------

You can save some megabytes and building time by configuring an image with no GUI, no development, no debugging and no profiling tools, but still with GNSS-SDR installed. Edit the "GUI support"  and the "Extra image configuration defaults" sections of your ```./conf/local.conf``` file as:

        # Comment this line to remove GUI support:
        #DISTRO_FEATURES_append = " opengl x11"
        # If you remove GUI support, please also uncomment the following two lines:
        PACKAGECONFIG_pn-gnuradio = "uhd logging"
        PACKAGECONFIG_pn-gr-ettus = ""

and

        #EXTRA_IMAGE_FEATURES = "debug-tweaks tools-profile tools-sdk dev-pkgs dbg-pkgs"
        EXTRA_IMAGE_FEATURES = ""

and then build the gnss-sdr-minimal-image:

        $ bitbake gnss-sdr-minimal-image


Staying Up to Date
------------------
To pick up the latest changes for all source repositories, run:

    $ repo sync

Enter the OpenEmbedded environment:

    $ . oe-core/oe-init-build-env ./build ./bitbake

If you forget to setup these environment variables prior to running bitbake, your OS will complain that it can't find bitbake on the path.  Don't try to install bitbake using a package manager, just run the command.

You can then rebuild as before:

    $ bitbake gnss-sdr-dev-image

Starting from Fresh
-------------------
So it is borked.  You're not really sure why.  But it doesn't work any more.

There are several degrees of *starting fresh*.

 1. clean a package: ```bitbake <package-name> -c cleansstate```
 2. re-download package: ```bitbake <package-name> -c cleanall```
 3. destroy everything but downloads: ```rm -rf build``` (or whereever your sstate and work directories are)
 4. destroy it all (not recommended): ```rm -rf build && rm -rf sources```


Customize
---------
Sooner or later, you'll want to customize some aspect of the image either
adding more packages, picking up some upstream patches, or tweaking your kernel.
To this, you'll want to customize the Repo manifest to point at different
repositories and branches or pull in additional meta-layers. Check out the [OpenEmbedded Layer Index](http://layers.openembedded.org/layerindex/branch/morty/layers/).

Clone this repository (or fork it on github):

    $ git clone git://github.com/carlesfernandez/oe-gnss-sdr-manifest.git

Make your changes (and contribute them back if they are generally useful :) ),
and then re-initialize your repo client

    $ repo init -u <file:///path/to/your/git/repository.git>

Credits
---------

This repo is based on https://github.com/balister/oe-gnuradio-manifest

In case of success, you own philip@balister.org a cold beer.
