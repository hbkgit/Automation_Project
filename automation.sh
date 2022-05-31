

sudo apt update -y

if [ $( dpkg --status apache2 | grep -c "ok installed" ) -eq 0 ];
then
	sudo apt-get install apache2
else
	echo "apache2 is already installed abcd"
fi


if [ $( systemctl status apache2 | grep -c "active (running)" ) -eq 0 ];
then
	sudo systemctl start apache2
else
	echo "apache2 is active running"
fi



if [ $( systemctl is-enabled apache2 | grep -c "enabled" ) -eq 0 ];
then
	sudo systemctl enable apache2
else 
	echo "apache2 service is already enabled abcd"
fi


tar -cf shubham-httpd-logs-$(date "+%d%m%Y-%H%M%S").tar -C /var/log/apache2 access.log error.log
mv shubham-httpd-logs* /tmp

aws s3 cp /tmp/shubham-httpd-logs-$(date "+%d%m%Y-%H%M%S").tar s3://upgrad-shubham



