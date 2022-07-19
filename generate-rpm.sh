#!/bin/sh

set -e

# By default use the current path as the root for source and build.
# This can be configured using command line args for out of tree builds.
source_path="$PWD"
build_path="$PWD/rpmbuild"
while getopts s:b: flag
do
    case "${flag}" in
        s) source_path=${OPTARG};;
        b) build_path=${OPTARG};;
        *) echo "unknown flag ${flag}"; exit 1 ;;
    esac
done

version="$(sed s/-/~/ VERSION)"
pkg_name="squashfs-run-${version}"
mkdir -p "${build_path}"
(cd "${build_path}" && mkdir -p SOURCES BUILD RPMS SRPMS SPECS)

tar_path="${build_path}/${pkg_name}"
mkdir -p "${tar_path}"

cp "${source_path}/squashfs-run.c" "${tar_path}"
cp "${source_path}/Makefile" "${tar_path}"
cp "${source_path}/LICENSE" "${tar_path}"
cp "${source_path}/VERSION" "${tar_path}"

tar_file="${build_path}/SOURCES/${pkg_name}.tar.gz"
tar -czf "${tar_file}" --directory "${build_path}" "${pkg_name}"

spec_file="${build_path}/SPECS/squashfs-run.spec"
cp squashfs-run.spec.in "${spec_file}"
sed -i "s|SQUASHFS_RUN_VERSION|${version}|g" "${spec_file}"
