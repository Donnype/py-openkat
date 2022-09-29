# Openkat

An experimental sandbox environment to easily experiment with (some) functionality of [openkat](https://openkat.nl/).
This version of openkat runs all services in a single process and replaces services such as
[Bytes](https://github.com/minvws/nl-kat-bytes), Rabbitmq and Celery with an in-memory implementation.
As a consequence, the current version does not guarantee persistence beyond the lifetime of the process.
It speaks for itself that this library **should not be used in a production environment**.
To properly deploy an openkat instance,
please refer to the [official documentation](https://github.com/minvws/nl-kat-coordination) on Github.


## Overview

### Features

These features of openkat are currently present in this package
- The Rocky interface: UI around reporting on Findings
- The Octopoes models: for modelling the Objects Of Interest (OOIs)
- The Boefjes/Normalizers: the python scripts that find OOIs (excluding the containerized versions)
- The Scheduler: dispatching Boefjes and Normalizers automatically

### Benefits
The benefits and extra features of this package are:
- Lightweight: a single process for the app, reducing overhead of the official services and installation times
- A default superuser and development organization
- OTP disabled to optimize for restarting the service even after an update
- Adding plugins by creating plugins in a custom `plugins` folder

### Missing Features

However, some features are excluded from this version on purpose:
- Audit trailing using Bytes
- Miscellaneous functionality in the interface, such as specifying a depth of an OOI tree and custom images in the KATalogus
- Deletion Propagation: you have to manually delete every single OOI
- ScanProfile inheritance: you have to manually add scan profiles to observed OOIs
- Valid times: you cannot browse the OOI history through time


### Coming Features

Some missing features are still to be added:
- Bits
- Object persistence beyond server lifetime

## Installation

```shell
$ pip install py-openkat
```

### Dependencies

To use the Dockerized boefjes, you must have Docker installed on your machine.

## Usage

To start the instance, run

```shell
$ python -m openkat
```

and navigate to http://localhost:8000.
Login with email `super@user.com` and password `superuser`.
You can start adding your objects now (see the official documentation).
Note: restarting the service clears your object database.


### Adding your own plugins

To extend the functionality of openkat with custom Boefjes create a file (e.g `kat.py`)
with the following contents:
```python3
import openkat

openkat.start(plugin_dir="plugins")
```
Then, create a directory in your current working directory called `plugins` and copy
[an internal Boefje](https://github.com/Donnype/nl-kat-boefjes/tree/869167d1b723a1a58c044d45f668fbade33cf372/boefjes/plugins)
(starting with `kat_`) into the `plugins` folder.

If you are like me and just want a one-liner:
```shell
$ mkdir plugins && \
  mkdir plugins/kat_dns2 && \
  for file in "__init__.py" "boefje.py" "description.md" "main.py" "normalizer.py" "requirements.txt" ; \
  do curl https://raw.githubusercontent.com/Donnype/nl-kat-boefjes/869167d1b723a1a58c044d45f668fbade33cf372/boefjes/plugins/kat_dns/$file > plugins/kat_dns2/$file; \
  done
```

Change the folder name, and at least the `id`, and `name` of the `Boefje` model definition in `boefje.py`, together with
the `name` and `module` (this should be `"{the folder name}.{module name}"`) of the `Normalizer` model definition.
Be careful not to use an existing folder name or this will overwrite an existing boefje (and require re-installation).

Have I told you I like one-liners? (Note: `sed` behaves differently on OS X)
```shell
$ sed -i -e "s/id\=\"dns-records\"/id\=\"my-id\"/g" \
    -e "s/module\=\"kat_dns\.normalize\"/module\=\"kat_dns2.normalize\"/g" \
    -e "s/name\=\"DnsRecords\"/name\=\"MyBoefje\"/g" \
    -e "s/name\=\"kat_dns_normalize\"/name\=\"kat_dns2_normalize\"/g" \
    plugins/kat_dns2/boefje.py
```

Start the service by running
```shell
$ python -m kat
```
and you should be able to use it as usual, but with the added functionality.

## Contributing

Dependencies:
- `poetry`
- `yarn`


To setup a development environment, run
```shell
$ make init
```

To build, run
```shell
$ make build
```
