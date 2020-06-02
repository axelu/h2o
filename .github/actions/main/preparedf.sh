#!/bin/bash

if [ $1 = "kazuhoh2ociubuntu1904" ]; then
    cp misc/docker-ci/Dockerfile.ubuntu1904 .github/actions/main/Dockerfile
else
    cp misc/docker-ci/Dockerfile .github/actions/main/
fi

# https://help.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions
# remove USER
sed -i '/^USER .*/d' .github/actions/main/Dockerfile
# remove WORKDIR
sed -i '/^WORKDIR .*/d' .github/actions/main/Dockerfile
# remove ENTRYPOINT
sed -i '/^ENTRYPOINT .*/d' .github/actions/main/Dockerfile

# https://askubuntu.com/questions/1238222/the-repository-http-security-ubuntu-com-ubuntu-disco-security-release-no-lon
# https://askubuntu.com/questions/91815/how-to-install-software-or-upgrade-from-an-old-unsupported-release
if [ $1 = "kazuhoh2ociubuntu1904" ]; then
    sed -i '/^FROM / a RUN sed -i -re "s/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g" /etc/apt/sources.list' .github/actions/main/Dockerfile
fi

echo 'RUN echo "127.0.0.1 127.0.0.1.xip.io" >> /etc/hosts' >> .github/actions/main/Dockerfile
echo 'COPY entrypoint.sh /entrypoint.sh' >> .github/actions/main/Dockerfile
echo 'ENTRYPOINT ["/entrypoint.sh"]' >> .github/actions/main/Dockerfile
