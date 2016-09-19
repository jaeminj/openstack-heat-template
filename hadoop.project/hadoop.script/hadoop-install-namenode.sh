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

cat > core-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>

  <property>
    <name>fs.default.name</name>
    <value>hdfs://node01/</value>
  </property>

  <property>
    <name>hadoop.tmp.dir</name>
    <value>/var/lib/hadoop/cache/${user.name}</value>
  </property>

  <property>
    <name>io.file.buffer.size</name>
    <value>65536</value>
  </property>

  <property>
    <name>webinterface.private.actions</name>
    <value>true</value>
  </property>

</configuration>

EOF

cat > hdfs-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>

  <property>
    <name>dfs.replication</name>
    <value>2</value>
  </property>

  <property>
    <name>dfs.safemode.extension</name>
    <value>0</value>
  </property>

  <property>
    <name>dfs.block.size</name>
    <value>268435456</value>
  </property>

  <property>
    <name>dfs.name.dir</name>
    <value>/data01/dfs/nn,/data02/dfs/nn</value>
  </property>

  <property>
    <name>dfs.data.dir</name>
    <value>/data01/dfs/dn,/data02/dfs/dn,/data03/dfs/dn</value>
  </property>

  <property>
    <name>fs.checkpoint.dir</name>
    <value>/data01/dfs/snn</value>
  </property>

</configuration>
EOF

cat > mapred-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>

  <property>
    <name>mapred.job.tracker</name>
    <value>node01:8021</value>
  </property>

  <property>
    <name>mapred.local.dir</name>
    <value>/data01/mapred/local,/data02/mapred/local,/data03/mapred/local</value>
  </property>

  <property>
    <name>mapreduce.jobtracker.staging.root.dir</name>
    <value>/user</value>
  </property>

  <property>
    <name>mapred.child.java.opts</name>
    <value>-Xmx1024m</value>
  </property>

  <property>
    <name>mapred.tasktracker.map.tasks.maximum</name>
    <value>6</value>
  </property>

  <property>
    <name>mapred.tasktracker.reduce.tasks.maximum</name>
    <value>6</value>
  </property>

  <property>
    <name>mapred.reduce.slowstart.completed.maps</name>
    <value>0.8</value>
  </property>

  <property>
    <name>tasktracker.http.threads</name>
    <value>80</value>
  </property>

  <property>
    <name>io.sort.mb</name>
    <value>256</value>
  </property>

  <property>
    <name>io.sort.factor</name>
    <value>64</value>
  </property>

  <property>
    <name>mapred.compress.map.output</name>
    <value>true</value>
  </property>

  <property>
    <name>mapred.map.output.compression.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
  </property>

</configuration>
EOF

cat > masters <<EOF
node01
node02
EOF

cat > slaves <<EOF
node03
node04
node05
EOF

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


