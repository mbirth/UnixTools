#!/usr/bin/php
<?php

define('TRESHOLD', 80);       // %CPU above which to log
define('INTERVAL', 2);        // Interval between 2 analysis runs
define('KEEPLOGS', 150);      // How many runs to detect overload (if a PID appears in ALL logs, it gets killed)
$restartProcs = array(        // list of commandlines to restart (pregexps)
//    'java',
);
$ignoreProcs = array(         // list of commandlines to ignore (pregexps)
    '\/usr\/bin\/X',
    'VirtualBox',
);

$verbose = true;


/*****************************************************************************/

$status = array();

echo 'silver.threadwatcher starting up...' . PHP_EOL;
echo 'Measuring interval: ' . INTERVAL . ' seconds.' . PHP_EOL;
echo 'Usage treshold    : ' . TRESHOLD . ' %cpu.' . PHP_EOL;
echo 'Measurements      : ' . KEEPLOGS . ' time(s).' . PHP_EOL;

while (1==1) {
    $thisstatus = getProcesses(array('%CPU' => TRESHOLD));

    $status[] = $thisstatus;
    $status = array_slice( $status, -KEEPLOGS );

    if ($verbose) echo '[' . date('r') . '] ' . count($thisstatus) . ' process(es) over threshold: ' . implode(', ', array_keys($thisstatus)) . '.' . PHP_EOL;

    if (count($status) >= KEEPLOGS) {
        $bad = reset($status);
        foreach ($status as $i=>$s) {
            if ($i==0) continue;
            foreach ($bad as $pid=>$data) {
                if (!isset($s[$pid])) unset($bad[$pid]);
                    elseif ($s[$pid]['%CPU'] > $bad[$pid]['%CPU']) $bad[$pid] = $s[$pid];
            }
        }
        foreach ($bad as $pid=>$data) {
            echo '[' . date('r') . '] BAD PROCESS DETECTED: [' . $pid . '] max ' . $data['%CPU'] . '% --- ' . $data['COMMAND'] . PHP_EOL;
            foreach ($ignoreProcs as $ipregexp) {
                if (preg_match('/'.$ipregexp.'/i', $data['COMMAND']) > 0) {
                    echo 'Process is on ignore list. Doing nothing...' . PHP_EOL;
                    continue 2;
                }
            }
            $cmd = 'kill -TERM ' . $pid;
            echo 'DO: ' . $cmd . PHP_EOL;
            system($cmd, $retval);
            if ($retval != 0) {
                $cmd = 'kill -KILL ' . $pid;
                echo 'DO: ' . $cmd . PHP_EOL;
                system($cmd, $retval);
                if ($retval != 0) {
                    echo 'Process could not be killed! Aborting for now...' . PHP_EOL;
                    continue;
                }
            }
            foreach ($restartProcs as $rpregexp) {
                if (preg_match('/'.$rpregexp.'/i', $data['COMMAND']) > 0) {
                    echo 'Process is flagged for restart-wanted. Restarting...' . PHP_EOL;
                    $cmd = $data['COMMAND'] . ' >/dev/null 2>&1 &';
                    echo 'DO: ' . $cmd . PHP_EOL;
                    // XXX: Process might get killed when restarting the webserver
                    // so one might create a file at this point with the CMDL to run
                    // and a dispatcher which runs in the background in parallel to this script and
                    // handles running the CMDL from the file created.
                    system($cmd);
                }
            }
        }
    }

    sleep(INTERVAL);
}


/**
 * Runs a ps-call to get a list of running processes and returns
 * a 2d associative array holding all processes with details
 * @param array $treshold If specified, only return processes $key above treshold $value
 * @return array Array of all processes and details
 */
function getProcesses( $treshold = false ) {
    $pslist = array();
    // args should be last column to have the whole line
    exec( 'ps -ewwo pcpu,pid,user,group,args --sort -pcpu', $pslist );
    // $pslist looks something like:
    // %CPU   PID USER     GROUP    COMMAND
    //  0.0     1 root     root     /sbin/init

    $headers = array_shift($pslist);

    // collect separating spaces
    $spaces = array();
    for ($i=0;$i<strlen($headers);$i++) {
        if ($headers{$i} == ' ') $spaces[] = $i;
    }

    // check for constant separators, sieve all non-constant ones
    foreach ($pslist as $line) {
        foreach ($spaces as $i=>$idx) {
            if ($line{$idx} != ' ') unset($spaces[$i]);
        }
    }

    // XXX: Assume, there are no consecutive separators (i.e. 2 spaces together)

    $headers = splitLine($headers, $spaces);

    $result = array();
    foreach ($pslist as $line) {
        $values = splitLine($line, $spaces);
        $mapped = array_combine($headers, $values);
        foreach ($treshold as $key=>$value) {
            if (!isset($mapped[$key]) || $mapped[$key] < $value) {
                continue 2;
            }
        }
        $result[$mapped['PID']] = $mapped;
    }
    return $result;
}

/**
 * Splits a line of text based on splitter-positions from $splitters
 * @param string $line The text to split.
 * @param array $splitters An array containing the positions on which to split (these do not belong the the result!)
 * @return array An array containing the splitted data
 */
function splitLine($line, $splitters) {
    $result = array();
    $lastidx = 0;
    foreach ($splitters as $idx) {
        $result[] = trim(substr($line, $lastidx, $idx-$lastidx));
        $lastidx = $idx+1;
    }
    $result[] = trim(substr($line, $lastidx));
    return $result;
}

?>
