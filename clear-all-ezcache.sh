#!/bin/sh
df -h | grep sda
for ezc in /var/www/projects/*/*?/bin/php/ezcache.php /var/www/projects/*/*/bin/php/ezcache.php; do
    EZ_BIN=`dirname \`dirname "$ezc"\``
    EZ_ROOT=`dirname "$EZ_BIN"`
    STAMP=`date`
    echo "$STAMP - Found eZ4: $EZ_ROOT"
    cd "$EZ_ROOT"
    /usr/bin/php bin/php/ezcache.php --clear-all -q --purge
    cd -
done
for ezc in /var/www/projects/*/ezpublish/console /var/www/projects/*/*/ezpublish/console; do
    EZ_ROOT=`dirname \`dirname "$ezc"\``
    STAMP=`date`
    echo "$STAMP - Found eZ5: $EZ_ROOT"
    cd "$EZ_ROOT"
    for env in ezpublish/cache/*; do
        ENV=`basename "$env"`
        echo "Cleaning Environment $ENV..."
        /usr/bin/php ezpublish/console cache:clear --no-ansi --no-interaction --env=$ENV
    done
    cd -
done
df -h | grep sda

