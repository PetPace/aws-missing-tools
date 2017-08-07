#!/bin/sh

echo "Starting auto-setup for AWS CloudWatch Custom Metrics..."

echo "removing possibly cached instance-id..."
rm -f /var/tmp/aws-mon/instance-id

echo "getting pre-requisites..."
sudo apt-get update
sudo apt-get install libwww-perl libdatetime-perl

echo "backup crontab..."
sudo crontab -l >> aws-auto-setup-crontab.backup

BASE_DIR=`echo $HOME`

echo "add crontab for new metrics"
(sudo crontab -l ; echo " ") | sudo crontab
(sudo crontab -l ; echo "# AWS CloudWatch Custom Metrics") | sudo crontab
(sudo crontab -l ; echo "*/5 * * * * $BASE_DIR/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --aws-credential-file=$BASE_DIR/aws-scripts-mon/awscreds.template") | sudo crontab -
(sudo crontab -l ; echo " ") | sudo crontab
sudo service cron reload

echo "DONE"

