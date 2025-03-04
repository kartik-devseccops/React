FROM python:3.9

# setup environment variable
ENV DockerHOME=/home/app

# set work directory
RUN mkdir -p $DockerHOME

# where your code lives
WORKDIR $DockerHOME

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip3 install --upgrade pip

# copy whole project to your docker home directory.
COPY . $DockerHOME

# run this command to install all dependencies
RUN pip3 install -r requirements.txt

RUN apt update

#RUN apt install  software-properties-common gnupg2 curl -y

#RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg

#RUN install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/

#RUN apt-add-repository -y "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

RUN apt-get update
 
RUN wget https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip

RUN unzip terraform_1.5.4_linux_amd64.zip

RUN mv terraform /usr/local/bin/

RUN rm -rf terraform_1.5.4_linux_amd64.zip
#RUN apt-get install terraform

RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v2.7.10/argocd-linux-amd64

RUN install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

RUN rm argocd-linux-amd64

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

RUN tar xvf helm-v3.9.3-linux-amd64.tar.gz

RUN mv linux-amd64/helm /usr/local/bin

RUN rm helm-v3.9.3-linux-amd64.tar.gz

# RUN apt-get install gcc \
#   && pip install -r requirements.txt

# port where the Django app runs
EXPOSE 3000

# reaching the execution directory for the project
WORKDIR $DockerHOME/devopsui/devops_ui

# RUN SERVICE
ENTRYPOINT ["/bin/bash", "../../startup.sh"]

# start server
#CMD ["python", "manage.py", "runserver", "0.0.0.0:3000"]`;


