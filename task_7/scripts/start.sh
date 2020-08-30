#!/bin/bash

yum install -y mailx
ln -s /vagrant/scripts/cron_task.sh /etc/cron.hourly/