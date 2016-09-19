
apt-get install openssh-server -y  
sudo apt-get install libxml2-utils
sudo apt-get install pdsh
echo 'ssh' > /etc/pdsh/rcmd_default

sudo useradd hadoop
sudo -u hadoop ssh-keygen -t rsa
sudo -u hadoop cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo -u hadoop chmod 0600 ~/.ssh/authorized_keys


