#!/bin/sh
####################################
#
# Backup script
#
####################################

# What to backup. 
backup_sources=("/home/user1" "/root" "/var/www")
backup_retention_day=10

# Where to backup to.
backup_destination="/backup"

# Create archive filename.
day_retention=$(date +"%Y-%m-%d" -d "$backup_retention_day day ago")
archive_retention_directory="$day_retention"
day=$(date +"%Y-%m-%d")
archive_directory="$day"

backup_retention_destination="$backup_destination/$archive_retention_directory"
backup_destination="$backup_destination/$archive_directory"

# Print start status message.
echo $(date +"%m-%d-%Y %T")
echo "Starting backup ($backup_retention_day retention day) from $day_retention to $archive_directory to $backup_destination ..."
echo

echo $(date +"%m-%d-%Y %T")
echo "Moving retention backup daily ($backup_retention_destination => $backup_destination) directory ..."
echo
mv $backup_retention_destination $backup_destination

# Backup the files using rsync.
for backup_source in ${backup_sources[*]}
do
  echo $(date +"%m-%d-%Y %T")
  echo "Rsyncing backup daily ($backup_source => $backup_destination) directory ..."
  echo
  rsync -ahW --delete --no-compress $backup_source $backup_destination
done

# Print end status message.
echo $(date +"%m-%d-%Y %T")
echo "Ending $archive_directory backup."
echo
