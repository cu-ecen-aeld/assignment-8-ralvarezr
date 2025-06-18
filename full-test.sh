#!/bin/bash
# This script can be copied into your base directory for use with
# automated testing using assignment-autotest.  It automates the
# steps described in https://github.com/cu-ecen-5013/assignment-autotest/blob/master/README.md#running-tests
set -e

cd `dirname $0`
test_dir=`pwd`
echo "starting test with SKIP_BUILD=\"${SKIP_BUILD}\" and DO_VALIDATE=\"${DO_VALIDATE}\""

# This part of the script always runs as the current user, even when
# executed inside a docker container.
# See the logic in parse_docker_options for implementation
logfile=test.sh.log
# See https://stackoverflow.com/a/3403786
# Place stdout and stderr in a log file
exec > >(tee -i -a "$logfile") 2> >(tee -i -a "$logfile" >&2)

echo "Running test with user $(whoami)"

set +e

# Verify that fakeroot is installed
if ! command -v fakeroot > /dev/null; then
  echo "fakeroot not found, installing..."
  apt-get update && apt-get install -y fakeroot
fi

# Create a symlink to the fakeroot binary in the expected location
EXPECTED_PATH="/work/buildroot/output/host/bin/fakeroot"
SYSTEM_FAKEROOT="$(command -v fakeroot)"

if [ ! -f "$EXPECTED_PATH" ]; then
  echo "Creating symlink: $EXPECTED_PATH"
  mkdir -p "$(dirname "$EXPECTED_PATH")"
  ln -s "$SYSTEM_FAKEROOT" "$EXPECTED_PATH"
fi

echo "Clean the buildroot folder"
./clean.sh

# If there's a configuration for the assignment number, use this to look for
# additional tests
if [ -f conf/assignment.txt ]; then
    # This is just one example of how you could find an associated assignment
    assignment=`cat conf/assignment.txt`
    if [ -f ./assignment-autotest/test/${assignment}/assignment-test.sh ]; then
        echo "Executing assignment test script"
        ./assignment-autotest/test/${assignment}/assignment-test.sh $test_dir
        rc=$?
        if [ $rc -eq 0 ]; then
            echo "Test of assignment ${assignment} complete with success"
        else
            echo "Test of assignment ${assignment} failed with rc=${rc}"
            exit $rc
        fi
    else
        echo "No assignment-test script found for ${assignment}"
        exit 1
    fi
else
    echo "Missing conf/assignment.txt, no assignment to run"
    exit 1
fi
exit ${unit_test_rc}
