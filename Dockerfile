FROM alpine:latest

MAINTAINER Martin Rosgaard <mhros (at) protonmail.com>

## Specify install paths for NetCDF and dependencies
ENV NCnDEP /NetCDF-and-deps 
ENV ZLIB=$NCnDEP/zlib-1.2.11 HDF5=$NCnDEP/hdf5-1.8.18 NETCDF=$NCnDEP/netcdf-c4.4.1.1_f4.4.4 

## Make application aware of NetCDF library at runtime and put NetCDF utils in PATH
ENV LD_LIBRARY_PATH=$NETCDF/lib PATH=$NETCDF/bin:$PATH

## Create temporary path for downloaded source files and cd into it
WORKDIR ${NCnDEP}_SRC

## Copy {fetch,build}.netcdf scripts into the temporary path
COPY *.netcdf ./
## The scripts use environment variables defined above,
## URLs and options may need adjustment for other software versions

## Install necessary packages, run fetch- and build scripts, remove temporary path
RUN apk add --no-cache alpine-sdk m4 file bash bash-doc bash-completion \
gcc gfortran ca-certificates openssl && update-ca-certificates && \
bash fetch.netcdf && bash build.netcdf && rm -r ${NCnDEP}_SRC

WORKDIR /Application
