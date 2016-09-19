#!/bin/bash 

case "" in
12.04)

image_name=ubuntu_12_04
image_url=http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img


wget  && openstack image create --disk-format qcow2 --container-format bare   --public --file   
 

;;
14.04)

image_name=ubuntu_14_04
image_url=https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

wget  && openstack image create --disk-format qcow2 --container-format bare   --public --file   

;;
16.04)

image_name=ubuntu_16_04
image_url=https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img


wget  && openstack image create --disk-format qcow2 --container-format bare   --public --file   

#glance image-download --name  --os-image-url   --disk-format qcow2  --container-format bare

;;
esac

