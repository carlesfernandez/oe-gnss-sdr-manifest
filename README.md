<!-- prettier-ignore-start -->
[comment]: # (
SPDX-License-Identifier: MIT
)

[comment]: # (
SPDX-FileCopyrightText: 2016-2025 Carles Fernandez-Prades <carles.fernandez@cttc.es>
)
<!-- prettier-ignore-end -->

# Repo Manifests for building systems based on the meta-gnss-sdr layer

This repository provides Repo manifests to setup the OpenEmbedded build system
with the meta-gnss-sdr layer.

**NOTE: PLEASE DO NOT USE THE master BRANCH OF THIS REPO TO BUILD IMAGES, USE
ONE OF THE AVAILABLE BRANCHES INSTEAD.**

OpenEmbedded allows the creation of custom GNU/Linux distributions for embedded
systems. It is a collection of git repositories known as _layers_ each of which
provides _recipes_ to build software packages as well as configuration
information.

Repo is a tool that enables the management of many git repositories given a
single _manifest_ file. Tell repo to fetch a manifest from this repository and
it will fetch the git repositories specified in the manifest and, by doing so,
setup an OpenEmbedded build environment for you!

## Setting up the build host

The process described below is based on
[OpenEmbedded](http://www.openembedded.org) (a build framework for embedded
Linux) and the [Yocto Project](https://www.yoctoproject.org/) (a complete
embedded Linux development environment covering several build profiles across
multiple architectures including ARM, PPC, MIPS, x86, and x86-64). In order to
set up a build host, you will need a machine with a minimum of 50 Gbytes of free
disk space and running a supported Linux distribution. In general, if you have
the current release minus one of Ubuntu, Fedora, openSUSE, CentOS or Debian you
should have no problems. For a more detailed list of distributions that support
the Yocto Project, see the
[Supported Linux Distributions](https://www.yoctoproject.org/docs/2.1/ref-manual/ref-manual.html#detailed-supported-distros)
section in the Yocto Project Reference Manual.

Instead of setting up your machine for building images or the SDK defined by the
meta-gnss-sdr layer, you might prefer building them on a virtualized
environment, so your machine does not need to be on a specific state in order to
enforce reproducibility. To that end, the
https://github.com/carlesfernandez/yocto-geniux repository provides a
`Dockerfile` and a script that automatically sets up a building environment and
builds the images and the SDK for you. Please check the
[README.md](https://github.com/carlesfernandez/yocto-geniux/blob/main/README.md)
file on that repo for more details on its usage and options.

## Copyright and License

Copyright: &copy; 2016-2025 Carles Fern&aacute;ndez-Prades,
[CTTC](https://www.cttc.cat). All rights reserved.

The content of this repository is released under the [MIT](./LICENSES/MIT.txt)
license.

## Acknowledgements

This work was partially supported by CPP2021-008648/ AEI/10.13039/501100011033/
European Union NextGenerationEU/PRTR and Grant PID2021-128373OB-I00 funded by
MCIN/AEI/10.13039/501100011033.
