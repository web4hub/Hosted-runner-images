FROM ubuntu:24.04 AS base

ARG IMAGE_VERSION=20260925.9
ARG IMAGE_OWNER="web4hub"
ARG RUNNER_IMAGES_REF=6c436f9fa29afd860fc7781ce6c4eb5ea27c9e53

ENV IMAGE_OWNER=$IMAGE_OWNER
ENV ImageVersion=$IMAGE_VERSION
ENV IMAGE_VERSION=$IMAGE_VERSION
ENV ImageOS="Linux"
ENV IMAGE_TARGET_PLATFORM="GitHub"
ENV POWERSHELL_DISTRIBUTION_CHANNEL="GitHub-Actions-$ImageOS"
ENV IMAGEDATA_NAME="ubuntu:24.04"
ENV NVM_DIR="/etc/skel/.nvm"
ENV HELPER_SCRIPTS="/tmp/scripts/helpers"
ENV INSTALLER_SCRIPT_FOLDER="/tmp/toolsets"
ENV DEBIAN_FRONTEND=noninteractive

# The repository intentionally keeps the slim-image build surface small.
# Fetch the exact upstream runner-image release that supplies the provisioning scripts.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates git curl sudo lsb-release jq dpkg && \
    git clone --filter=blob:none --no-checkout https://github.com/actions/runner-images.git /tmp/runner-images && \
    git -C /tmp/runner-images sparse-checkout init --cone && \
    git -C /tmp/runner-images sparse-checkout set images/ubuntu-slim && \
    git -C /tmp/runner-images checkout "$RUNNER_IMAGES_REF" && \
    mkdir -p /tmp/scripts /tmp/toolsets && \
    cp -a /tmp/runner-images/images/ubuntu-slim/scripts/. /tmp/scripts/ && \
    cp -a /tmp/runner-images/images/ubuntu-slim/toolsets/. /tmp/toolsets/ && \
    rm -rf /tmp/runner-images /var/lib/apt/lists/*

# Keep this fork's toolset declaration authoritative.
COPY toolsets/ /tmp/toolsets/

RUN find /tmp/scripts -name "*.sh" -type f -exec chmod +x {} \; && \
    chmod +x /tmp/scripts/entrypoint.sh && \
    cp /tmp/scripts/entrypoint.sh /opt/entrypoint.sh

RUN echo 'set -eo pipefail' >> /etc/bash.bashrc

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo lsb-release jq dpkg && \
    touch /run/.containerenv && \
    /tmp/scripts/build/configure-apt-sources.sh && \
    /tmp/scripts/build/configure-apt.sh && \
    /tmp/scripts/build/install-apt-vital.sh && \
    /tmp/scripts/build/install-ms-repos.sh && \
    /tmp/scripts/build/configure-image-data-file.sh && \
    /tmp/scripts/build/configure-environment.sh && \
    /tmp/scripts/build/install-actions-cache.sh && \
    /tmp/scripts/build/install-apt-common.sh && \
    /tmp/scripts/build/install-azcopy.sh && \
    /tmp/scripts/build/install-azure-cli.sh && \
    /tmp/scripts/build/install-azure-devops-cli.sh && \
    /tmp/scripts/build/install-bicep.sh && \
    /tmp/scripts/build/install-aws-tools.sh && \
    /tmp/scripts/build/install-git.sh && \
    /tmp/scripts/build/install-git-lfs.sh && \
    /tmp/scripts/build/install-github-cli.sh && \
    /tmp/scripts/build/install-google-cloud-cli.sh && \
    /tmp/scripts/build/install-nvm.sh && \
    /tmp/scripts/build/install-nodejs.sh && \
    /tmp/scripts/build/install-powershell.sh && \
    /tmp/scripts/build/configure-dpkg.sh && \
    /tmp/scripts/build/install-yq.sh && \
    /tmp/scripts/build/install-python.sh && \
    /tmp/scripts/build/install-zstd.sh && \
    /tmp/scripts/build/install-pipx-packages.sh && \
    /tmp/scripts/build/install-docker-cli.sh && \
    /tmp/scripts/build/configure-system.sh && \
    /tmp/scripts/helpers/cleanup.sh

RUN sed -i '/set -eo pipefail/d' /etc/bash.bashrc

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["bash"]
