FROM ubuntu

RUN apt-get update && \
 apt-get install -y gnupg software-properties-common curl apt-transport-https && \
 curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
 curl https://baltocdn.com/helm/signing.asc | sudo apt-key add - \
 curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
 apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
 echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
 echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
 apt-get update && \
 apt-get install terraform awscli helm kubectl