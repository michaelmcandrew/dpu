mysql -BNe "show databases" | while read database ; do
case $database in
    mysql | information_schema | performance_schema )
        # skip the above databases
        ;;
    * )
        # and backup the others
        mysqldump --skip-comments $database > $database.sql
        gzip -fn --rsyncable $database.sql
        ;;
esac
done
exit
