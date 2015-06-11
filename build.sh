#!/bin/bash

build_version () {
    cd $source_dir

    version=$1
    echo "Building libpq-dev version $version"
    echo $version > VERSION

    work_dir=`mktemp -d`
    build_dir=$work_dir/build
    mkdir -p $build_dir

    echo "Using $work_dir"
    cd $work_dir

    pg_dir_name=postgresql-$version
    pg_arch_name=$pg_dir_name.tar.bz2

    download_url=ftp://ftp.postgresql.org/pub/source/v$version/$pg_arch_name

    echo "Downloading $download_url"
    wget -q $download_url

    echo "Extracting $pg_arch_name"
    tar xaf $pg_arch_name > /dev/null

    cd $pg_dir_name
    echo "Preparing libpq build..."
    ./configure --prefix $build_dir > /dev/null

    echo "Building PostgreSQL..."
    make -j &> /dev/null
    make install -j &> /dev/null

    cp $build_dir/bin/pg_config $target_dir/bin
    cp $build_dir/lib/libpq.a $target_dir/lib
    cp -r $build_dir/include/libpq* $target_dir/include
    cp -r $build_dir/include/pg_config* $target_dir/include
    cp -r $build_dir/include/postgres_* $target_dir/include

    echo "Building wheels..."
    cd $source_dir
    tox -c setup.cfg --skip-missing-interpreters > /dev/null

    # Clean-up
    echo "Cleaning-up after $version build"
    rm -f VERSION

    rm -f $target_dir/bin/pg_config
    rm -f $target_dir/lib/libpq.a
    rm -rf $target_dir/include/libpq*
    rm -f $target_dir/include/pg_config*
    rm -f $target_dir/include/postgres_*

    rm -rf ./build
    rm -rf ./*.egg-info

    rm -rf $work_dir

    echo "Done libpq-dev-$version"
}

echo "Building $# libpq-dev version(s)"
for ver in "$@"
do
    echo $ver
done
echo

source_dir=`pwd`
target_dir=$source_dir/libpq

venv_dir=`mktemp -d`
echo "Preparing temporary virtualenv in $venv_dir"
echo

cd $venv_dir
virtualenv venv > /dev/null
. ./venv/bin/activate
pip install -U pip > /dev/null
pip install tox~=2.0 > /dev/null

for ver in "$@"
do
    build_version $ver
    echo
done

echo "Removing temporary virtualenv in $venv_dir"
cd $source_dir
deactivate
rm -rf $venv_dir
