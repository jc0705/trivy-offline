FROM ghcr.io/aquasecurity/trivy:latest

RUN trivy image --download-db-only

RUN curl -LO https://github.com/oras-project/oras/releases/download/v0.12.0/oras_0.12.0_linux_amd64.tar.gz && \
    mkdir -p oras-install/ && \
    tar -zxf oras_0.12.0_*.tar.gz -C oras-install/ && \
    ./oras-install/oras pull ghcr.io/aquasecurity/appshield:latest -a && \    
    rm -rf oras_0.12.0_*.tar.gz oras-install/ && \
    tar -zxvf bundle.tar.gz && rm -rf bundle.tar.gz && \
    mkdir -p /root/.cache/trivy/policy/content && \
    mv ./docker/ /root/.cache/trivy/policy/content/ && \
    mv ./kubernetes/ /root/.cache/trivy/policy/content/ && \
    mv ./.manifest /root/.cache/trivy/policy/content/

ENTRYPOINT [ "trivy", "image", "--skip-update" ]
