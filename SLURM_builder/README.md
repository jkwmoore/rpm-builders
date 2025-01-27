# SLURM RPM Builder

This folder contains the instructions for building RPM packages for the SLURM scheduler using CentOS 7 and AlmaLinux 9.

## Features
- Flexible SLURM tarball versioning: Specify the `.tar.bz2` file to build from.
- Support for custom `.rpmmacros` files to control build behavior.
- Support for custom build arguments via ``BUILDARGS`` environment variable.

## Instructions

### Build the Docker Containers
To build the containers for CentOS 7 and AlmaLinux 9:

```bash
# Build CentOS 7-based container
docker build -t slurm-rpm-builder:centos7 -f ../centos7/SLURM.build.Dockerfile.centos7.9 ..

# Build AlmaLinux 9-based container
docker build -t slurm-rpm-builder:almalinux9 -f ../almalinux9/SLURM.build.Dockerfile.almalinux9 ..
```

### Run the Containers

Use the environment variable ``BUILDARGS`` to supply build arguments/options. Add the required tarball to the folder and environment variable. i.e. replace `slurm-24.05.5.tar.bz2` with the tarball version you want to build.

#### With a Custom `.rpmmacros` File
If you want to use a custom `.rpmmacros` file:

##### CentOS7

```bash
# Define environment variables for input and output paths
export TARBALL="slurm-24.05.5.tar.bz2"
export INPUT_VOLUME="$(pwd)/slurm-tarballs"
export OUTPUT_VOLUME="$(pwd)/output"
export RPMMACROS_VOLUME="$(pwd)/my-custom-rpmmacros"
export BUILDARGS="--with lua --with numa"

# Run the Docker container with desired options and volume mappings
docker run --rm \
    -e TARBALL="${TARBALL}" \
    -e BUILDARGS="${BUILDARGS}" \
    -v "${INPUT_VOLUME}:/home/builder/input" \
    -v "${OUTPUT_VOLUME}:/home/builder/rpmbuild/RPMS" \
    -v "${RPMMACROS_VOLUME}:/home/builder/.rpmmacros" \
    slurm-rpm-builder:centos7
```

##### Almalinux 9

```bash
# Define environment variables for input and output paths
export TARBALL="slurm-24.05.5.tar.bz2"
export INPUT_VOLUME="$(pwd)/slurm-tarballs"
export OUTPUT_VOLUME="$(pwd)/output"
export RPMMACROS_VOLUME="$(pwd)/my-custom-rpmmacros"
export BUILDARGS="--with lua --with numa"

# Run the Docker container with desired options and volume mappings
docker run --rm \
    -e TARBALL="${TARBALL}" \
    -e BUILDARGS="${BUILDARGS}" \
    -v "${INPUT_VOLUME}:/home/builder/input" \
    -v "${OUTPUT_VOLUME}:/home/builder/rpmbuild/RPMS" \
    -v "${RPMMACROS_VOLUME}:/home/builder/.rpmmacros" \
    slurm-rpm-builder:almalinux9
```

#### Without a Custom `.rpmmacros` File
If no `.rpmmacros` file is provided, an empty one will be created automatically, so simply remove this line to disable it:

```bash
    -v "${RPMMACROS_VOLUME}:/home/builder/.rpmmacros" \
```




### Output
The RPM files will appear in the `output` directory on your host machine within a prefix denoted by the container OS type and version.
