# Use an official Python image as the base
FROM python:3.9  

# Setup environment variables
ENV APP_HOME=/home/app  
WORKDIR $APP_HOME  

# Install required system dependencies and tools
RUN apt-get update && apt-get install -y \
    curl unzip wget gnupg2 software-properties-common && \
    rm -rf /var/lib/apt/lists/*  # Cleanup to reduce image size

# Install Terraform
RUN wget -q https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip && \
    unzip terraform_1.5.4_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.5.4_linux_amd64.zip

# Install ArgoCD
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash  

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Python dependencies
COPY requirements.txt .  
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt  

# Expose application port
EXPOSE 8080  

# Copy and set startup script
COPY startup.sh .  
RUN chmod +x startup.sh  

# Define entrypoint
ENTRYPOINT ["./startup.sh"]
