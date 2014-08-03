# Find most recent backup files of each period (where they exist)
last_quarterly_backup_file=$(find /backup/ -maxdepth 1 -type d -name "quarterly.*" | sort -V | head -1)
last_monthly_backup_file=$(find /backup/ -maxdepth 1 -type d -name "monthly.*" | sort -V | head -1)
last_weekly_backup_file=$(find /backup/ -maxdepth 1 -type d -name "weekly.*" | sort -V | head -1)
last_daily_backup_file=$(find /backup/ -maxdepth 1 -type d -name "daily.*" | sort -V | head -1)

# Create a timestamp for each of these files (or set to 0 where no file exists)
if [ $last_quarterly_backup_file ]; then last_quarterly_backup=`date +%s -r $last_quarterly_backup_file`; else last_quarterly_backup=0; fi
if [ $last_monthly_backup_file ]; then last_monthly_backup=`date +%s -r $last_monthly_backup_file`; else last_monthly_backup=0; fi
if [ $last_weekly_backup_file ]; then last_weekly_backup=`date +%s -r $last_weekly_backup_file`; else last_weekly_backup=0; fi
if [ $last_daily_backup_file ]; then last_daily_backup=`date +%s -r $last_daily_backup_file`; else last_daily_backup=0; fi

# Create a timestamp for each period, representing the point in time for which, if the backup file is older, we should run another backup
quarterly_interval=`date -d "-3 month" +%s`
monthly_interval=`date -d "-1 month" +%s`
weekly_interval=`date -d "-1 week" +%s`
daily_interval=`date -d "-1 day" +%s`

# Run the quarterly backup if it has been more than 3 months since the last backup (or no quarterly backup exists)
if [ $last_monthly_backup -lt $monthly_interval ]; then
    echo ""
    echo "Running quarterly backup"
    echo "======================"
    rsnapshot -v quarterly
fi
# Run the monthly backup if it has been more than 1 month since the last backup (or no monthly backup exists)
if [ $last_monthly_backup -lt $monthly_interval ]; then
    echo ""
    echo "Running monthly backup"
    echo "======================"
    rsnapshot -v monthly
fi

# Run the weekly backup if it has been more than 1 week since the last backup (or no weekly backup exists)
if [ $last_weekly_backup -lt $weekly_interval ]; then
    echo ""
    echo "Running weekly backup"
    echo "====================="
    rsnapshot -v weekly
fi

# Run the daily backup if it has been more than 1 day since the last backup (or no daily backup exists)
if [ $last_daily_backup -lt $daily_interval ]; then
    echo ""
    echo "Running daily backup"
    echo "===================="
    rsnapshot -v daily
fi
