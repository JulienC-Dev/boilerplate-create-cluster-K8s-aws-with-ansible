# Boilerplate deploy K8s on AWS VPC Setup with Ansible

This repository contains a boilerplate to deploy a Kubernetes cluster on AWS using Ansible. The Ansible playbook will create a VPC, subnets, security groups, and EC2 instances and deploy a Kubernetes cluster on the EC2 instances.

We also deploy a small application on the Kubernetes cluster to test the deployment.

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
## Steps for Managing Secrets
   # Create a Secure Directory
   - Create a private directory named private in the root of your project to store sensitive files.
   # Use Ansible Vault for Encryption
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
         
   # Configuration for Running Playbooks
   - Configure your ansible.cfg file with the following settings to manage your playbooks securely:
   ```
   [defaults]
   # Disable SSH host key checking
   host_key_checking = False
   # Specifies the path to the file containing your Ansible Vault password, allowing Ansible to decrypt vault files without prompting for a password.
   VAULT_PASSWORD_FILE = ./vault-pass
   # Defines the Python interpreter path on the remote hosts.
   interpreter_python = /usr/local/bin/python
   # Sets the default remote user to root, meaning Ansible will attempt to connect to remote hosts as the root user.
   remote_user = root
   # Specifies the path where Ansible will write its logs.
   log_path=/var/log/private
   ```

   ## Potential Risks
   # Disabling SSH Host Key Checking
   - Man-in-the-Middle (MitM) Attacks: Disabling host key checking means Ansible will not verify the authenticity of the SSH server's key. This can lead to Man-in-the-Middle attacks, where an attacker might intercept the connection and gain access to sensitive data or execute unauthorized commands.
   # Using Root User
   - Privilege Escalation: Setting remote_user to root means that all commands executed through Ansible will have full administrative privileges. This increases the risk of security issues if your playbooks or roles contain vulnerabilities or are used maliciously, potentially granting an attacker root access to the remote system.