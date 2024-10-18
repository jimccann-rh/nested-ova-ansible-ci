FROM registry.access.redhat.com/ubi9/ubi@sha256:b00d5990a00937bd1ef7f44547af6c7fd36e3fd410e2c89b5d2dfc1aff69fe99

WORKDIR /usr/app/src

RUN dnf install -y python jq git bind-utils unzip
RUN python3 -m ensurepip --default-pip
RUN pip3 install ansible envsubst pyvmomi --user
RUN pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git
ENV PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN curl -O -L https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64
RUN chmod +x yq_linux_amd64
RUN mv yq_linux_amd64 /usr/local/bin/yq

COPY . .

CMD ./run-from-job.sh