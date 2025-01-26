#!/bin/bash
# Build CentOS 7-based container
docker build -t slurm-rpm-builder:centos7 -f ../centos7/SLURM.build.Dockerfile.centos7.9 ..

# Build AlmaLinux 9-based container
docker build -t slurm-rpm-builder:almalinux9 -f ../almalinux9/SLURM.build.Dockerfile.almalinux9 ..
