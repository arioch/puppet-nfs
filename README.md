# Puppet NFS

## Requirements

## Tested on...

* Debian 5 (Lenny)
* Debian 6 (Squeeze)

## Example usage

### Install NFS client tools

    node /box/ {
      include nfs
    }

### Install NFS client and server

    node /box/ {
      class { 'nfs':
        server => true;
      }
    }

