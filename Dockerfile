FROM python:3.10-slim

RUN mkdir -p /opt/ansible
WORKDIR /opt/ansible
COPY /ansible/ . 
ADD /private/ .

RUN apt-get update && apt-get upgrade -y && \
apt install nano -y && \
pip install ansible && pip install -r requirements-ansible.txt && \
ansible-galaxy collection install amazon.aws && \
apt-get install -y openssh-server && \
apt-get update && apt-get upgrade -y

CMD ["python" ,"execution_playbook.py"]