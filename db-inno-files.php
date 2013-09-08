#!/usr/bin/php
<?php

if (posix_getuid() != 0) {
    echo 'Run as root!' . PHP_EOL;
    exit(1);
}

$mysql_host = 'localhost';
$mysql_port = '3309';
$mysql_user = 'root';
$mysql_password = 'silver';
$mysql_dir = '/var/lib/mysql';

echo 'Querying MySQL.';
$pdo = new PDO('mysql:host=' . $mysql_host . ';port=' . $mysql_port . ';dbname=information_schema', $mysql_user, $mysql_password);
echo '.';
$sql = 'SELECT table_schema, table_name, engine FROM information_schema.tables WHERE engine="InnoDB"';
$stmt = $pdo->prepare($sql);
echo '.';

$stmt->execute();
echo '.';

$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo ' OK' . PHP_EOL;

$tbl_file = 0;
$tbl_ibdt = 0;
foreach ($data as $table) {
    $filename = $mysql_dir . DIRECTORY_SEPARATOR . encode_filename($table['table_schema']) . DIRECTORY_SEPARATOR . encode_filename($table['table_name']) . '.ibd';
    if (!file_exists($filename)) {
        $tbl_ibdt++;
        echo 'ibdata: ' . $table['table_schema'] . '.' . $table['table_name'] . PHP_EOL;
    } else {
        $tbl_file++;
    }
}

echo 'innodb_file_per_table : ' . $tbl_file . PHP_EOL;
echo 'Tables in ibdata1 file: ' . $tbl_ibdt . PHP_EOL;


function encode_filename($filename)
{
    $filename = str_replace('.', '@002e', $filename);
    return $filename;
}
