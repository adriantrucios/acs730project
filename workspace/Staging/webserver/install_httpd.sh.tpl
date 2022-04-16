#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
myimage=`curl https://acs730project-dev.s3.amazonaws.com/peach_staging.jpg`
echo "<h1>Welcome to ACS730 ${prefix}! My private IP is $myip in ${env} environment</h1><br><img src='https://acs730project-public.s3.amazonaws.com/linux.jpg'> <br>Group10: <br>Adrian Trucios Montoya <br>Aparna Pavitra Palem <br>Gopal Sharma <br>Rahulkumar Chandrakantbhai Vaniya" >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
