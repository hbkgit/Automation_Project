

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
cp shubham-httpd-logs* /tmp

aws s3 cp /tmp/shubham-httpd-logs-$(date "+%d%m%Y-%H%M%S").tar s3://upgrad-shubham

#test –f /var/www/html/inventory.html
if [  -f "/var/www/html/inventory.html" ];
then
	echo "file found"
else
	echo "file not found"
	touch /var/www/html/inventory.html
	echo "Log Type	 Time Created 	Type 	Size" >> /var/www/html/inventory.html

fi
ls -lh shubham-httpd-logs* | awk '{print $5}' 
lgtyp='httpd-logs'
typ='tar'
echo $lgtyp$'\t'$(date "+%d%m%Y-%H%M%S")$'\t'$typ$'\t'$(ls -lh shubham-httpd-logs* | awk '{print $5}') >> /var/www/html/inventory.html


rm shubham-httpd-logs*
if [ -f "/etc/cron.d/automation" ];
then
	continue
else
	touch /etc/cron.d/automation
	printf "0 0 * * * root /root/Automation_Project/auotmation.sh" > /etc/cron.d/automation
fi





