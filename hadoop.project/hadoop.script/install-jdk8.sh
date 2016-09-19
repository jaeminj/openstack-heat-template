#!/bin/bash -ex

echo "$floating_ip  $(hostname)" >> /etc/hosts
if [ -f /etc/lsb-release ]; then
  DISTRO="Ubuntu"
elif [ -f /etc/redhat-release ]; then
  DISTRO="CentOS"
else
  echo "Unable to determine if Ubuntu or CentOS"
  exit 1
fi

# Set the max heap size
JVM_HEAP_PERCENT=50
TOTAL_MEM=$(free -m | awk '/Mem:/ {print $2}')
let JVM_HEAP=$TOTAL_MEM*$JVM_HEAP_PERCENT/100

case $DISTRO in
    'Ubuntu')
        
        
        # Add OpenJDK 8 repos
        # Check for java-8 availability before adding repo
        JAVA_AVAILABLE=$(aptitude -F "%p" search openjdk-8-jdk)
        if [ "" == "$JAVA_AVAILABLE" ]; then
            apt-get install software-properties-common
            add-apt-repository -y ppa:openjdk-r/ppa
        fi

        apt-get update

        # Install OpenJDK 8
        apt-get install -y openjdk-8-jdk
        ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java
        update-ca-certificates -f
        

        ;;
    
    'CentOS')
        
        
        # Install Java 8, MariaDB, and Tomcat
        yum -y install java-1.8.0-openjdk wget unzip ntp
        ;;
esac




sleep 60


