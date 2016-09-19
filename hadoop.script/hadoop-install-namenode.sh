#!/bin/bash
echo "update /etc/hosts"
node01_ip=$(ifconfig eth0 | awk -F':' '/inet addr/{split($2,_," ");print _[1]}')
cat << EOF >> /etc/hosts
$node01_ip node01
$node02_ip node02
$node03_ip node03
$node04_ip node04
$node05_ip node05
EOF

echo "Install Hadoop Packages"
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:hadoop-ubuntu/stable
apt-get update && sudo apt-get -y upgrade
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

apt-get -y install oracle-java7-installer


apt-get -y install hadoop
echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /usr/lib/hadoop/conf/hadoop-env.sh

for file in {core-site.xml,hdfs-site.xml,mapred-site.xml,masters,slaves}; do
  wget https://raw.github.com/kjtanaka/heat_templates/master/hadoop/conf/$file \
      -N -P /usr/lib/hadoop/conf
done
for dir in {/data01,/data02,/data03}; do
  mkdir $dir
  chown hdfs:hdfs $dir
done


chown -R hdfs:hdfs /var/lib/hadoop/cache
echo "hdfs	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers
sudo -u hdfs ssh-keygen -N "" -C "hdfs" -f /usr/lib/hadoop/.ssh/id_rsa
cp /home/ubuntu/.ssh/authorized_keys /usr/lib/hadoop/.ssh/
cat /usr/lib/hadoop/.ssh/id_rsa.pub >> /usr/lib/hadoop/.ssh/authorized_keys
chown hdfs:hdfs /usr/lib/hadoop/.ssh/authorized_keys


