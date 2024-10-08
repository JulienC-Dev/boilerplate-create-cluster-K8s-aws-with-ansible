# Boilerplate for Deploying Kubernetes on AWS with Ansible

This repository provides a boilerplate for deploying a Kubernetes cluster on AWS using Ansible. The Ansible playbook provisions EC2 instances, sets up the Kubernetes cluster, and deploys Kubernetes objects along with cluster monitoring tools. 
The objective is to enable end-to-end testing of your application before tearing down the cluster.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **Ansible**: Install Ansible on your local machine.

   - To check if Ansible is installed, run:
     ```bash
     ansible --version
     ```
   - If Ansible is not installed, you can install it using:
     ```bash
     pip install ansible
     ```

2. **AWS CLI**: Ensure the AWS CLI is installed and configured with your credentials.

   - To install the AWS CLI, follow the [official guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   - Configure the AWS CLI with your credentials:
     ```bash
     aws configure
     ```

3. **Ansible AWS Collection**: Install the `amazon.aws` collection.

   ```bash
   ansible-galaxy collection install amazon.aws
   ansible-galaxy collection install kubernetes.core
   ```

4. **Create a virtualenv**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
5. **Install Docker on your local machine.**:

   - To install Docker, follow the [official guide](https://docs.docker.com/get-docker/).

6. **Handling Secrets in Ansible**:
When managing secrets in Ansible, it is crucial to treat sensitive information with care. Some variables are more sensitive than others and require special attention to ensure their security.
# Steps for Managing Secrets
   ## Create a Secure Directory
   - Create a private directory named private in the root of your project to store sensitive files.
   - the structure of the private directory should look like this:
   ```
   private/
   ├── vault-pass
   ├── ansible.cfg
   ├── group_vars/
   │   └── vars
   ├── ansible.cfg
   ├── vault-pass
   ├── kubeconfig.yaml
   ```

   ## Use Ansible Vault for Encryption
   Ansible Vault allows you to encrypt files containing sensitive information to prevent exposure in plain text. To use Ansible Vault:
   - Create a file named vault-pass to store the password for encrypting and decrypting your secrets.
   - Use this password with Ansible Vault commands to secure your sensitive data.
   - Generate a random password with openSSL : openssl rand -base64 32 > vault-pass
   -  To encrypt a variable, use the ansible-vault encrypt_string command:
   ```
   ansible-vault encrypt_string 'your_secret_variable' --name 'your_variable_name'
   ```
   - You can use this var in your playbook like this:
   ```
   - {{ "your_variable_name" }}
   ```
         
   ## Configuration for Running Playbooks
   - Configure your ansible.cfg file with the following settings to manage your playbooks securely:
   ```
   [defaults]
   # Disable SSH host key checking
   host_key_checking = False
   # Specifies the path to the file containing your Ansible Vault password, allowing Ansible to decrypt vault files without prompting for a password.
   VAULT_PASSWORD_FILE = ./vault-pass
   # Defines the Python interpreter path on the remote hosts.
   interpreter_python = /usr/local/bin/python
   remote_user = ec2-user
   # Specifies the path where Ansible will write its logs.
   log_path=/var/log/private
   ```

   ## Potential Risks
   ## Disabling SSH Host Key Checking
   - Man-in-the-Middle (MitM) Attacks: Disabling host key checking means Ansible will not verify the authenticity of the SSH server's key. This can lead to Man-in-the-Middle attacks, where an attacker might intercept the connection and gain access to sensitive data or execute unauthorized commands.
   ## Using Root User
   - Privilege Escalation: Setting remote_user to root means that all commands executed through Ansible will have full administrative privileges. This increases the risk of security issues if your playbooks or roles contain vulnerabilities or are used maliciously, potentially granting an attacker root access to the remote system.

## Execution d'un playbook ansible en mode simulation
- ansible-playbook simple_test_playbook_ansible/create_simple_vpc_test.yaml --check -vv

## To pass variables to an Ansible playbook from the command line rather than defining them within the playbook itself, use the following command:
- ansible-playbook create_vpc.yaml -e "@your-path/group_vars/vars.yml"

## Create your dynamic inventory file
Dynamic inventory in Ansible automates the management of infrastructure by dynamically generating host lists based on real-time data from cloud environments.
- ansible-playbook -i aws_ec2.yaml create_cluster.yaml
for testing the dynamic inventory file:
- ansible-inventory -i aws_ec2.yml --list

## Create you own kubeconfig file
A kubeconfig file is a configuration file used by the kubectl command-line tool to interact with a Kubernetes cluster. The kubeconfig file is usually found at ~/.kube/config on a user's system. In our scenario, we need to place the kubeconfig file generated by the Ansible playbook into ~/.kube/config to ensure proper access to the Kubernetes cluster.

## Apply k8s objects with ansible
run the following command to apply the k8s objects:
- ansible-playbook -i aws_ec2.yaml apply_k8s_objects.yaml

## Monitoring the Kubernetes Cluster
To monitor the Kubernetes cluster, you use graphana and prometheus. To access the Grafana dashboard, you need to create a port-forward to the Grafana service running in the Kubernetes cluster. Run the following command:
- kubectl port-forward service/grafana 3000:3000 -n monitoring

## Delete the k8s cluster
To delete the Kubernetes cluster, run the following command:
- ansible-playbook -i aws_ec2.yaml delete_cluster.yaml

## What's Next?
- Helm is a package manager for Kubernetes that simplifies the deployment, management, and upgrading of applications using charts. By leveraging Helm, you can efficiently manage your applications and services on your Kubernetes cluster.
To ensure continuous delivery and high-quality deployments, we use CI/CD pipelines to push the latest versions to Helm. We can also create Ansible playbooks to test and deploy specific versions of the application, perform end-to-end testing, and then destroy the cluster post-testing.

- For a more advanced setup, you can use distinct groups in the inventory file to define masternodes and workernodes, accommodating a multi-node architecture. 

- Dockerise the folder to use it anywhere without the need to install the dependencies.