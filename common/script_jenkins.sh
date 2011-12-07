#!/bin/bash -x

export BOARD_CONFIG=$NODE_NAME
custom_workspace=$WORKSPACE
mkdir -p $custom_workspace/../../../../dl

# Set repository info
MAIN_PROJ_REPO_NAME=buildroot
TEST_FRAME_REPO_URL=git://10.99.22.20/git/unreleased/buildroot-testsuites.git
TEST_FRAME_REPO_NAME=testsuites
KERNEL_REPO_URL=git://10.99.22.20/git/linux-kernel
KERNEL_REPO_NAME=kernel

# Set branch info
INDEX=1
if [ "$INDEX" == "1" ] ; then
    MAIN_PROJ_INDEX=adi
    TEST_FRAME_INDEX=master
    KERNEL_INDEX=trunk
elif [ "$INDEX" == "2" ] ; then
    MAIN_PROJ_INDEX="2011.05"
    TEST_FRAME_INDEX="2011.05"
    KERNEL_INDEX="linux-2.6.37"
fi

# Link to real directory for downloading
cd $custom_workspace
ln -sf ../../../../dl

debug=1
# check if use right source
check_git_info ()
{
    echo "##########"
    if [ -d $custom_workspace ] ; then
        cd $custom_workspace
        git branch
        git remote -v
    fi


    if [ -d $custom_workspace/testsuites ] ; then
        cd $custom_workspace/testsuites
        git branch
        git remote -v
    fi

    if [ -d $custom_workspace/linux/linux-2.6.x ] ; then
        cd $custom_workspace/linux/linux-2.6.x
        git branch
        git remote -v
    fi
    echo "##########"
}

if [ $debug -eq 1 ] ; then
    check_git_info
fi

# Checkout master project, switch to desired branch and get the latest source.
cd $custom_workspace
if [ "`git branch | grep -c \"$MAIN_PROJ_INDEX\"`" -eq 0 ] ; then
    git checkout -b $MAIN_PROJ_INDEX remotes/$MAIN_PROJ_REPO_NAME/$MAIN_PROJ_INDEX
else
    git checkout $MAIN_PROJ_INDEX
fi

git pull $MAIN_PROJ_REPO_NAME $MAIN_PROJ_INDEX

git submodule update --init


if [ $debug -eq 1 ] ; then
    check_git_info
fi


# Checkout test frame and switch to desired branch.
cd $custom_workspace/testsuites
if [ "`git branch | grep -c \"$TEST_FRAME_INDEX\"`" -eq 0 ] ; then
    git checkout -b $TEST_FRAME_INDEX remotes/$TEST_FRAME_REPO_NAME/$TEST_FRAME_INDEX
else

    git checkout $TEST_FRAME_INDEX
fi

# Checkout kernel and switch to desired branch.
cd $custom_workspace/linux/linux-2.6.x
git checkout .
if [ "'git branch | grep -c \"$KERNEL_INDEX\"'" -eq 0 ] ; then
    git checkout -b $KERNEL_INDEX remotes/$KERNEL_REPO_NAME/$KERNEL_INDEX
else
    git checkout $KERNEL_INDEX
fi

# Get the latest source for all submodules.
cd $custom_workspace/
git submodule foreach git pull


if [ $debug -eq 1 ] ; then
    check_git_info
fi


# Start regression test
cd $custom_workspace/testsuites/common/
./run_kernel_test
rm -fr $WORKSPACE/thisrun
cp -fr /home/test/workspace/logs/thisrun $WORKSPACE

