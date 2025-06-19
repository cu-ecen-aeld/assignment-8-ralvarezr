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

#############################################################################
echo "🔍 Verificando dependencias para compilar Buildroot..."

# Lista de dependencias necesarias
deps=(
    gcc g++ make wget git rsync file
    bash diff patch unzip fakeroot
    perl python3 bc flex bison
    ssh scp
)

missing_deps=()

# Verificar si cada dependencia del sistema está instalada
for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        echo "❌ Falta: $dep"
        missing_deps+=("$dep")
    fi
done

# Verificar si está el cross-compiler (toolchain)
if ! command -v aarch64-none-linux-gnu-gcc &>/dev/null; then
    echo "❌ Falta: aarch64-none-linux-gnu-gcc (toolchain cruzado)"
    missing_deps+=("gcc-aarch64-linux-gnu")
fi

# Si hay faltantes, intentar instalarlos
if [ ${#missing_deps[@]} -ne 0 ]; then
    echo "⚠️ Se encontraron ${#missing_deps[@]} dependencias faltantes."

    if command -v apt-get &>/dev/null; then
        echo "💡 Instalando automáticamente con apt-get..."
        apt-get update
        apt-get install -y "${missing_deps[@]}"
    else
        echo "❌ No se puede instalar automáticamente. Instálalas manualmente:"
        echo "${missing_deps[@]}"
        exit 1
    fi
else
    echo "✅ Todas las dependencias están instaladas."
fi

# echo "Clean the buildroot folder"
# ./clean.sh

#############################################################################
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
