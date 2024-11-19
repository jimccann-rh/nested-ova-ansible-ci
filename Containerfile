FROM registry.access.redhat.com/ubi8/python-311@sha256:ec2f4c89e18373c75a72f5b47da4d3ee826e8961a9c6a26ba2fd3112f5a41e4a

USER root
RUN dnf install -y jq git bind-utils unzip
RUN mkdir -p /usr/app
RUN chown -R default /usr/app

USER default
COPY . .

RUN pip install ansible envsubst pyvmomi envbash ansible-runner
RUN pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

RUN curl -O -L https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64
RUN chmod +x yq_linux_amd64
RUN mkdir -p /opt/app-root/src/.local/bin
RUN mv yq_linux_amd64 /opt/app-root/src/.local/bin/yq
RUN ln -s /opt/app-root/src /usr/app
