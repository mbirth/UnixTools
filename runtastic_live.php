#!/usr/bin/php
<?php

$basedir = dirname($argv[0]);
$config = parse_ini_file($basedir . '/CONFIG');

$user_url = $config['RUNTASTIC_USER_URL'];

// $fetch_url = sprintf('https://www.runtastic.com/de/benutzer/%s/friends_live_sessions', $user_url);
$fetch_url   = sprintf('https://www.runtastic.com/en/users/%s/friends_live_sessions', $user_url);
$status_file = sprintf('/tmp/runtastic_%s.json', $user_url);

$stamp = time();
echo sprintf('STARTED: %s', date('Y-m-d H:i:s', $stamp)) . PHP_EOL;

$data = file_get_contents($fetch_url);
#$data = file_get_contents('runtastic_live5.html');

$data = '<?xml encoding="utf-8" ?><root>' . $data . '</root>';

libxml_use_internal_errors(true);   // prevent generation of PHP Warnings
$dom = new DOMDocument();
$dom->loadHTML($data, LIBXML_NOERROR|LIBXML_NOWARNING|LIBXML_NOENT);
libxml_clear_errors();   // we KNOW it's no well-formed XML, so drop all complaints
libxml_use_internal_errors(false);

$xp = new DOMXpath($dom);

$f_list = $xp->query('//div[contains(@class, "run_session")]');
$f_num  = $f_list->length;

echo sprintf('Found %u active friend%s:', $f_num, ($f_num!=1)?'s':'') . PHP_EOL;

$f_arr = array();
foreach ($f_list as $f) {
    $name = $xp->query('.//a[@title]/@title', $f)->item(0)->nodeValue;
    $profile_url = $xp->query('.//a[@title]/@href', $f)->item(0)->nodeValue;
    $avatar = $xp->query('.//img/@src', $f)->item(0)->nodeValue;
    $session_url = $xp->query('.//a[not(@title)]/@href', $f)->item(0)->nodeValue;
    $activity = strtr(trim($xp->query('.//div[@class="content"]/text()', $f)->item(0)->textContent), "\r\n", "  ");

    echo sprintf('%s: %s (%s)', $name, $activity, $session_url) . PHP_EOL;

    $f_arr[$profile_url] = array(
        'name' => $name,
        'profile_url' => $profile_url,
        'avatar' => $avatar,
        'session_url' => $session_url,
        'activity' => $activity,
    );
}

if (file_exists($status_file)) {
    $o_arr = json_decode(@file_get_contents($status_file), true);
} else {
    $o_arr = array();
}

file_put_contents($status_file, json_encode($f_arr));

/************************************************************************************/

$new = array_diff_key($f_arr, $o_arr);
$old = array_intersect_key($f_arr, $o_arr);   // will be ignored
$stopped = array_diff_key($o_arr, $f_arr);

echo sprintf('STARTED:%u, STILL GOING:%u, STOPPED:%u', count($new), count($old), count($stopped)) . PHP_EOL;

/************************************************************************************/

if (count($new) + count($stopped) == 0) {
    echo 'Nothing to notify about.' . PHP_EOL;
    exit(1);
}

if (count($new) + count($stopped) == 1) {
    if (count($new) > 0) {
        $friend = reset($new);
        $title  = str_replace(' is out ', ' started ', $friend['activity']);
    } else {
        $friend = reset($stopped);
        $title  = str_replace(' is out ', ' finished ', $friend['activity']);
    }
    $message   = $friend['name'] . ': ' . $title;
    if (count($old) > 0) {
        $message .= PHP_EOL . sprintf('%u other%s still going strong.', count($old), count($old)>1?'s':'');
    }
    $url       = $friend['session_url'];
    $url_title = 'Runtastic session';
} else {
    $title = sprintf('%u Runtastic updates', count($new) + count($stopped));
    $names = array();
    $message   = '';
    foreach ($new as $f) {
        $names[] = $f['name'];
        $message .= str_replace(' is out ', ' started ' , $f['activity']) . ' (' . $f['session_url'] . ')' . PHP_EOL;
    }
    foreach ($stopped as $f) {
        $names[] = $f['name'];
        $message .= str_replace(' is out ', ' finished ' , $f['activity']) . ' (' . $f['session_url'] . ')' . PHP_EOL;
    }
    if (count($old) > 0) {
        $message .= sprintf('%u other%s still going strong.', count($old), count($old)>1?'s':'');
    }
    $title .= ': ' . implode(', ', $names);
    $url       = sprintf('https://www.runtastic.com/en/users/%s/friends/live', $user_url);
    $url_title = 'Runtastic Live';
}

/****************************************************************************************/

function notify_pushover($recipient, $subject, $message, $url, $url_title, $priority = 0, $timestamp = '', $sound = '')
{
    global $config;

    $pushover_api = 'https://api.pushover.net/1/messages.json';
    $notify_data = array(
        'token' => $config['RUNTASTIC_PUSHOVER_TOKEN'],
        'user' => $recipient,
        'title' => $subject,
        'message' => $message,
        'url' => $url,
        'url_title' => $url_title,
        'priority' => $priority,
        'timestamp' => $timestamp,
        'sound' => $sound,
    );

    $data_str = http_build_query($notify_data);

    $context = stream_context_create(array(
        'http' => array(
            'method' => 'POST',
            'header' => "Content-Type: application/x-www-form-urlencoded\r\n" .
                        "Content-Length: " . strlen($data_str) . "\r\n",
            'content' => $data_str,
        ),
    ));

    print_r($notify_data);

    return file_get_contents($pushover_api, false, $context);
}

function notify_email($recipient, $subject, $message, $url, $url_title)
{
    $subject = '[Runtastic] ' . $subject;
    $message .= PHP_EOL . PHP_EOL . $url_title . ': ' . $url;

    echo 'Subject: ' . $subject . PHP_EOL . $message . PHP_EOL;

    return mail($recipient, $subject, $message);
}

$result = notify_pushover($config['PUSHOVER_RECIPIENT'], $title, $message, $url, $url_title, 0, $stamp, 'bike');
// $result = notify_email($config['EMAIL_RECIPIENT'], $title, $message, $url, $url_title);

if ($result === false) {
    echo 'ERROR: Problem sending notification.' . PHP_EOL;
    exit(2);
}

exit(0);
