# Purpose

This is intended for developers who may need to use `Podman` and `Docker` on
the same host (as well as some other VMs, such as `CodeReady Containers`). A
VM is required for each of these on MacOS. In order to consolidate resources,
this Vagrantfile was designed to setup developers with all of the tools
they need in order to develop solely within the Vagrantbox.

> Important: The Vagrantfile configures a VM using the Virtualbox provider with
> a significant amount of resources. Be sure to change to your liking.

## Tooling

These tools are installed in the Vagrantbox by out-of-box:

1. Docker
1. Git
1. Go 1.17
1. KinD
1. Kubectl
1. Oc
1. Podman
1. Python 3 (ships with Ubuntu 20.04) and pip
1. Ruby 3
1. Summon

## Prerequisites

Install the following:

```bash
$ brew install --cask virtualbox
$ brew install --cask vagrant
# install vagrant storage plugin for virtualbox
$ vagrant plugin install vagrant-disksize
```

## Usage

Run the following commands frmo the root of this repository.

1. Start / provision the VM

    ```bash
    $ vagrant up
    ```

1. SSH into it

    ```bash
    $ vagrant ssh
    ```

1. Verify software is installed and there is no errors with the following script


    ```bash
    $ /vagrant/list-software-versions.sh
    ```

1. Utilize synced directory

    If you need to sync files from the vagrantbox to your host machine, simply
    create the file(s) in `/vagrant`.

    > Note: the `/vagrant` path is different than your `vagrant` user's home
    > directory!

    ```bash
    $ vagrant ssh
    # should appear in your host's fs where your vagrant file is
    vagrant@vagrant:~$ touch /vagrant/test
    ```

1. Suspend

    Suspends the VM. This stops the VM and saves its current state. State
    reloads from where you left off. Still uses disk space while suspended.
    State of the VM RAM is stored on disk.

    ```bash
    $ vagrant suspend
    # resume
    $ vagrant up
    ```

1. Stop

    Shutsdown the VM. Cleanly shuts down and preserves disk contents.

    ```bash
    $ vagrant halt
    # reboot
    $ vagrant up
    ```

1. Snapshots

    You can utilize [snapshots](https://www.vagrantup.com/docs/cli/snapshot) to
    test changes with easy rollback capabilities. How these are saved depends
    on the provider (see: [virtualbox](https://www.virtualbox.org/manual/ch01.html#snapshots)).

    > Important: do not mix the pop/push commands with save. It is recommended
    > to delete snapshots in reverse order (depending on the VM provider).

    ```bash
    # save
    $ vagrant snapshot save [vm-name] NAME
    # list
    $ vagrant snapshot list
    # restore
    $ vagrant snapshot restore [vm-name] NAME
    # delete
    vagrant snapshot delete [vm-name] NAME
    ```

1. Destroy

    Stops the VM, powers it down, reclaims disk and RAM entirely. The VM is
    completely removed from the system. This does not remove the
    base vagrantbox from your vagrant library/catalog.

    ```bash
    $ vagrant destroy

## Packaging and Base Boxes

We can package up a currently-running configuration of a vagrantbox
using `vagrant package`. Once a box has been created, it can be managed with the
`vagrant box` command. Boxes can be published publically or privately
(with a licenses).


You can build your own boxes o
References:

- [Package CLI](https://www.vagrantup.com/docs/cli/package)
- [Find Boxes](https://app.vagrantup.com/boxes/search)
- [Base Boxes](https://www.vagrantup.com/docs/boxes/base)
- [Box Distribution](https://www.vagrantup.com/vagrant-cloud/boxes/distributing)

## Troubleshooting

1. Cannot Start using `vagrant up`

    **Error Description**

    Stderr: VBoxManage: error: The virtual machine 'learn-vagrant_default_1646460809186_85690' has terminated unexpectedly during startup with exit code 1 (0x1)
    VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component MachineWrap, interface IMachine

    **Cause**: Oracle VirtualBox or Vagrant never receieved permissions on MacOS.
    
    **Solution**: Go to
    System Preferences -> Security & Privacy > Click on Lock to Make Changes. On the General tab, you may see a notification that either app
    was blocked. Click "Allow" and restart. Run the command again.
