FROM registry.access.redhat.com/ubi9/ubi@sha256:b00d5990a00937bd1ef7f44547af6c7fd36e3fd410e2c89b5d2dfc1aff69fe99

WORKDIR /usr/app/src

RUN dnf install -y python
RUN python3 -m ensurepip --default-pip
RUN pip3 install ansible --user
ENV PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY . .

CMD ./run-from-job.sh