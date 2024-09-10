#!/bin/sh

# NextCloud to Amazon S3 Backup Script

# Mods :
 # - install awscli through ansible
 # - export env vars (db pass)
 # - use awscli for accessing and modifying s3 bucket



# Name of Amazon S3 Bucket
s3_bucket='sirpinextcloudbackups'

# Path to NextCloud installation
nextcloud_dir='/var/www/nextcloud'

# Path to NextCloud data directory
data_dir='/media/external/CloudDATA'

# MySQL/MariaDB Database credentials
db_host='localhost'
db_user='nextcloud'
db_pass='<pass-goes-here>'
db_name='nextcloud'


echo 'Started'
date +'%a %b %e %H:%M:%S %Z %Y'

# Put NextCloud into maintenance mode. 
# This ensures consistency between the database and data directory.

sudo -u www-data php $nextcloud_dir/occ maintenance:mode --on

# Dump database and backup to S3

mysqldump --single-transaction -h$db_host -u$db_user -p$db_pass $db_name > nextcloud.sql
s3cmd put nextcloud.sql s3://$s3_bucket/NextCloudDB/nextcloud.sql
rm nextcloud.sql

# Sync data to S3 in place, then disable maintenance mode 
# NextCloud will be unavailable during the sync. This will take a while if you added much data since your last backup.

# If upload cache is in the default subdirectory, under each user's folder (Default)
s3cmd sync --recursive --preserve --exclude '*/cache/*' $data_dir s3://$s3_bucket/

# If upload cache for all users is stored directly as an immediate subdirectory of the data directory
# s3cmd sync --recursive --preserve --exclude 'cache/*' $data_dir s3://$s3_bucket/

sudo -u www-data php $nextcloud_dir/occ maintenance:mode --off

date +'%a %b %e %H:%M:%S %Z %Y'
echo 'Finished'