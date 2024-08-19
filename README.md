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

4. **Install python environment on virtualenv**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

5. **How to handle secret on ansible**:
   - Create a private folder named `private` in the root directory.