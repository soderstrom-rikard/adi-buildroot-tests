#!/bin/sh -x

if [ $# -ne 1 ]; then
       echo "Usage: $0 cvs_server_addr"
       echo "Please append SVN repository ip address"
       exit 1
fi       
cvs_server_addr=$1

LTP_SUB_DIR=ltp-full-20101031

## Ignore this step by svn ##
# Checkout current file
#echo "$0:	Checking out from CVS, file [current]"
#cvs -Q -d :pserver:anonymous@$cvs_server_addr:/cvsroot/uclinux533 co -A -P ltp/current
#if [ $? -ne 0 ]
#then
#	echo "$0:	Error, CVS checkout failed"
#	exit 1
#fi

## We don't need patch for Makefile now ##
# Checkout patch file for Makefiles 
#echo "$0:	Checking out from CVS, file [Makefile.patch]"
#cvs -Q -d :pserver:anonymous@$cvs_server_addr:/cvsroot/uclinux533 co -A -P ltp/Makefile.patch
#if [ $? -ne 0 ]
#then
#	echo "$0:	Error, CVS checkout failed"
#	exit 1
#fi

# Checkout ltp source directory
#LTP_WORKING_DIR=`cat ltp/current`
CWD=`pwd`

#echo "$0:	Get ltp working directory [$LTP_WORKING_DIR]"

# Go to working directory
echo "$0:	Go to working directory"
cd $LTP_SUB_DIR

# configure ltp
echo "$0:	Configure ..."
./configure --prefix=$CWD/$LTP_SUB_DIR --host=bfin-uclinux --build=i686-pc-linux-gnu
if [ $? -ne 0 ]
then
	echo "$0:	Error, configure failed" 
	exit 1
fi

## We don't need patch for Makefile now ##
# Patch for Makefiles
#echo "$0:	Patching Makefiles"
#patch -p0 < ../Makefile.patch
#if [ $? -ne 0 ]
#then
#	echo "$0:	Error, patching Makefiles failed"
#	exit 1
#fi

# Build ltp testsuites
echo "$0:	Make ..."
make UCLINUX=1
if [ $? -ne 0 ]
then
	echo "$0:	Error, make failed" 
	exit 1
fi

cd $CWD
exit 0
