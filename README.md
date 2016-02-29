# Dyn Bento

Bento is a project that encapsulates [Packer](https://www.packer.io/) templates for building
[Vagrant](https://www.vagrantup.com/) base boxes and AWS AMIs

This is a fork, of the [Chef Bento](https://github.com/chef/bento/blob/master/README.md) project

## Pre-built Boxes
## TODO: 
-[ ] build boxes and place on Artifactory

The following boxes are built from this repository's templates and available from Artifactory

|               | VirtualBox (5.0.12)      |
|  ------------ | -------------            | 
| ubuntu-12.04  | todo                     |
| ubuntu-14.04  | todo                     |


## Using Pre-built Boxes
TODO: fill me in

## Build Your Own Bento Boxes

### Using `bento`

In the `bin` directory of this repo is the `bento` utility which wraps `packer` as well as allowing other related functionality.
This is an opinionated tool that the project uses for building the hosted boxes listed above.

To build multiple templates for all providers (VirtualBox, Fusion, Parallels, etc):

    $ bin/bento build debian-8.1-amd64 debian-8.1-i386

To build a box for a single provider:

    $ bin/bento build --only=virtualbox-iso debian-8.1-amd64

### Using `packer`

Templates can still be built directly by `packer`

To build a template for all providers (VirtualBox, Fusion, Parallels):

    $ packer build debian-8.2-amd64.json

To build a template only for a list of specific providers:

    $ packer build -only=virtualbox-iso debian-8.2-amd64.json

To build a template for all providers except a list of specific providers:

    $ packer build -except=parallels-iso,vmware-iso debian-8.2-amd64.json

If you want to use a another mirror site, use the `mirror` user variable.

    $ packer build -var 'mirror=http://ftp.jaist.ac.jp/pub/Linux/debian-cdimage/release' debian-8.2-amd64.json

Congratulations! You now have box(es) in the ../builds directory that you can then add to Vagrant and start testing cookbooks.

Notes:
* The box_basename can be overridden like other Packer vars with ``-var 'box_basename=debian-8.2'``

## Bugs and Issues

Please use GitHub issues to report bugs, features, or other problems.

## License & Authors

These basebox templates were converted from [veewee](https://github.com/jedi4ever/veewee)
definitions originally based on
[work done by Tim Dysinger](https://github.com/dysinger/basebox) to
make "Don't Repeat Yourself" (DRY) modular baseboxes. Thanks Tim!

