#!/bin/bash  

# Script to install Sun Java and Hadoop 2.6 


cd /usr/local  
sudo wget http://115.68.145.14/datastore/hadoop-2.6.3.tar.gz 
tar xzf hadoop-2.6.3.tar.gz  
mkdir hadoop  
mv hadoop-2.6.3/* hadoop/  

echo "Now script is updating Bashrc for export Path etc"  

cat >> ~/.bashrc << EOL  
export HADOOP_HOME=/usr/local/hadoop  
export HADOOP_MAPRED_HOME=/usr/local/hadoop  
export HADOOP_COMMON_HOME=/usr/local/hadoop  
export HADOOP_HDFS_HOME=/usr/local/hadoop  
export YARN_HOME=/usr/local/hadoop  
export HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native  
export JAVA_HOME=/usr/  
export PATH=$PATH:/usr/local/hadoop/sbin:/usr/local/hadoop/bin:$JAVA_PATH/bin  
EOL  

cat ~/.bashrc  

source ~/.bashrc  

echo "Now script is updating hadoop configuration files"  

cat >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh << EOL  
export JAVA_HOME=/usr/  
EOL  

cd /usr/local/hadoop/etc/hadoop  

cat > core-site.xml << EOL  
<configuration>  
<property>  
<name>fs.default.name</name>  
<value>hdfs://localhost:9000</value>  
</property>  
</configuration>  
EOL  

cp mapred-site.xml.template mapred-site.xml  
cat > mapred-site.xml << EOL  
<configuration>  
<property>  
<name>mapreduce.framework.name</name>  
<value>yarn</value>  
</property>  
</configuration>  
EOL  

cat > yarn-site.xml << EOL  
<configuration>  
<property>  
<name>yarn.nodemanager.aux-services</name>  
<value>mapreduce_shuffle</value>  
</property>  
</configuration>  
EOL  

cat > hdfs-site.xml << EOL  
<configuration>  
<property>  
<name>dfs.replication</name>  
<value>1</value>  
</property>  
<property>  
<name>dfs.name.dir</name>  
<value>file:///home/hadoop/hadoopinfra/hdfs/namenode </value>  
</property>  
<property>  
<name>dfs.data.dir</name>  
<value>file:///home/hadoop/hadoopinfra/hdfs/datanode </value >  
</property>  
</configuration>  
EOL  

echo "Completed process Now Reloading Bash Profile...."  
cd ~  

echo "You may require reloading bash profile, you can reload using following command."  
echo "source ~/.bashrc"  

echo "To Start you need to format Name Node Once you can use following command."  
echo "hdfs namenode -format"  

echo "Hadoop configured. now you can start hadoop using following commands. "  
echo "start-dfs.sh"  
echo "start-yarn.sh"  

echo "To stop hadoop use following scripts."  
echo "stop-dfs.sh"  
echo "stop-yarn.sh"  
