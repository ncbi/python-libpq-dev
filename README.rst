libpq-dev
=========

Overview
--------

The ``libpq-dev`` library is built following `Debian's libpq-dev package`_ 
idea: it contains a minimal set of `PostgreSQL`_ binaries and headers required 
for building 3rd-party applications for `PostgreSQL`_.

Moreover this package provides even smaller subset of binaries than 
`Debian's libpq-dev package`_ and was designed this way on purpose. The main 
goal is to provide all requirements for building `Psycopg2`_.

This package is meant to be built as `platform-specific`_ binary 
`Python wheels`_, contains only PostgreSQL binaries and 0 Python code.

Rationale
---------
The `Psycopg2`_ library is built as a wrapper around ``libpq`` and mostly 
written in C. It is distributed as an ``sdist`` and being built during 
installation. For this reason it requires some `PostgreSQL`_ binaries and 
headers to be present during installation.

For simple environments where database server and application server combine 
the same host it is not an issue but it might be a different case for 
distributed systems. This leads to the need to install some of `PostgreSQL`_ 
binaries on the application server as well.

On top of that there might be a situation when single application server needs 
to host several applications that use different versions of `PostgreSQL`_ and 
thus `Psycopg2`_ needs to be `built against different versions`_ of ``libpq``.

Contents
--------

The package contains:

    - **pg_config**
    - **libpq.a** (static build of ``libpq``)
    - a number of additional headers

For full list of files please take a look into ``setup.cfg/[files]/data_files``.

Once more, 0 Python sources or any other stuff.

Usage
-----

The usage is pretty simple and straight forward: install ``libpq-dev`` of 
required version (the same version as your PostgreSQL version) before 
installing `Psycopg2`_.

::

    $ pip install libpq-dev==9.4.3

    $ pip install psycopg2

Please note that `Psycopg2`_ prefers static linking against ``libpq`` so if you 
distributing your application and all its dependencies with wheels or something 
like `Platter`_ then you don't need need to ship ``libpq-dev`` as long as you 
have `Psycopg2`_ wheel built with it.

Limitation and Known Issues
---------------------------

Currently ``libpq-dev`` is being built only for ``Linux`` with 
``Python 2.7, 3.3, 3.4`` from `PostgreSQL 9.*` sources.

If there will be demand for other platforms, Python versions or older 
PostgreSQL versions new builds will be added.

Also please note that there is `known issue with PIP`_ and some Python packages 
(including `Psycopg2`_) that doesn't allow you to do:

::

    $ pip install libpq-dev==9.4.3 psycopg2

or put these names into `requirements.txt` and then run ``pip install -r 
requirements.txt``. This is because `Psycopg2`_ requires ``pg_config`` and 
other PostgreSQL binaries to be present in order to run ``egg_info`` command 
(which is executed by `PIP` during normal installation process).

Unfortunately there is nothing we can do about it right now but we hope that 
either this will be handled somehow in future `PIP` releases or fixed in 
`Psycopg2`_.


Further Development
-------------------

We assume that there might be demand in builds for additional platforms or 
Python versions.

Also there may be other Python libraries that may be used with this package. 
In case this package is missing some binaries requried by libraries other that 
`Pscyopg2`_ they will be added.


.. _Debian's libpq-dev package: https://packages.debian.org/sid/libpq-dev
.. _PostgreSQL: http://www.postgresql.org/
.. _Psycopg2: https://pypi.python.org/pypi/psycopg2
.. _platform-specific: https://packaging.python.org/en/latest/distributing.html#platform-wheels
.. _Python wheels: http://pythonwheels.com/
.. _built against different versions: http://www.leeladharan.com/importerror-psycopg-so:-undefined-symbol:-lo-truncate64
.. _Platter: http://platter.pocoo.org/
.. _known issue with PIP: https://github.com/pypa/pip/issues/25
