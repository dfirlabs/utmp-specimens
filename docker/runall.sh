#!/bin/bash

EXIT_SUCCESS=0
EXIT_FAILURE=1

SPECIMENS_PATH="specimens"

if test -d ${SPECIMENS_PATH}
then
	echo "Specimens directory: ${SPECIMENS_PATH} already exists."

	exit ${EXIT_FAILURE}
fi

mkdir -p ${SPECIMENS_PATH}

VERSIONS=("14.04" "16.04" "18.04" "20.04" "22.04" "24.04" "26.04")
SPECIMENS_PATH="${PWD}/${SPECIMENS_PATH}"

CURRENT_GID=$( id -g )
CURRENT_UID=$( id -u )

set -e

for VERSION in ${VERSIONS[@]}
do
	TAG="utmp-specimens/ubuntu${VERSION}"

	docker build \
	    --build-arg GID=${CURRENT_GID} \
	    --build-arg UID=${CURRENT_UID} \
	    --build-arg VERSION=${VERSION} \
	    -f docker/ubuntu.Dockerfile \
	    -t ${TAG} \
	    .

	docker run \
	    -u ${CURRENT_UID}:${CURRENT_GID} \
	    -v ${SPECIMENS_PATH}:/home/ubuntu/specimens:z \
	    ${TAG} \
	    ./generate-specimens-linux.sh

	mv ${SPECIMENS_PATH}/wtmp ${SPECIMENS_PATH}/wtmp-${VERSION}
done

exit ${EXIT_SUCCESS}
