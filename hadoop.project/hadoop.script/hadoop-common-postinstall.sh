
scp -p hdfs@192.168.11.1:.ssh/authorized_keys /tmp/hdfs_auth_keys

   scp -oStrictHostKeyChecking=no  -p /tmp/hdfs_auth_keys hdfs@192.168.11.2:.ssh/authorized_keys
   cat /etc/hosts | ssh -oStrictHostKeyChecking=no  node02 'sudo sh -c "cat > /etc/hosts"'


hadoop namenode -format

./bin/start-all.sh



