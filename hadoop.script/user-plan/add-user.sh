
sudo  adduser  --ingroup   <groupname>   <username>


useradd  -g <groupname>   <username>

core.site.xml
hadoop.tmp.dir 
/app/hadoop/tmp


hadoop fs –chmod -R  1777 /app/hadoop/tmp/mapred/staging

chmod 777 /app/hadoop/tmp

hadoop  fs –mkdir /user/username/

 hadoop fs –chown –R username:groupname  /user/username/


