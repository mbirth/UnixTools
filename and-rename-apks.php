#!/usr/bin/php -q
<?php

class APKInfo {
    const AAPT_BIN = '/opt/android-sdk/platform-tools/aapt';
    private $dir;
    private $icon_dir;
    private $xml_file;
    private $dom;
    private $dom_root;

    public static function saveIcon( $apk, $filename ) {
        $info = self::getInfo( $apk );
        if ( $info === false ) return false;
        $ext = substr( $info['application']['icon'], strrpos( $info['application']['icon'], '.' ) );
        $src = 'zip://' . $info['file'] . '#' . $info['application']['icon'];
        copy( $src, $filename );
        return true;
    }

    public static function getInfo( $file ) {
        if ( !file_exists( $file ) ) return false;
        exec( self::AAPT_BIN . ' d badging "' . $file . '"', $out );
        $ainfo = array(
            'file' => $file,
            'size' => filesize( $file ),
            'md5'  => md5_file( $file ),
            'date' => date( 'Y-m-d', filemtime( $file ) ),
        );
        foreach ( $out as $line ) {
            if ( strpos( $line, ':' ) === false ) continue;   // skip empty data keys
            list( $label, $data ) = explode( ':', $line, 2 );
            if ( $data{0} == "'" ) {
                // simple string
                $data = substr( $data, 1, -1 );
            } elseif ( $data{0} == ' ' ) {
                // looks like array

                // parse array parts
                $data_parts = array();
                $part = '';
                $in_string = false;
                for ($i=0;$i<strlen($data);$i++) {
                    if ( $data{$i} == "'" ) {
                        $in_string = !$in_string;
                        $part .= $data{$i};
                    } elseif ( $data{$i} == ' ' && !$in_string ) {
                        if ( !empty($part) ) $data_parts[] = $part;
                        $part = '';
                    } else {
                        $part .= $data{$i};
                    }
                }
                if ( !empty( $part ) ) $data_parts[] = $part;

                $data = array();
                foreach ( $data_parts as $dp ) {
                    if ( empty( $dp ) ) continue;
                    if ( $dp{0} == "'" ) {
                        // array: 'val1' 'val2' 'val3'
                        $data[] = substr( $dp, 1, -1 );
                    } else {
                        if ( strpos( $dp, '=' ) === false ) continue;
                        // hash: name1='val1' name2='val2' name3='val3'
                        list( $dp_name, $dp_value ) = explode( '=', $dp, 2 );
                        $data[ $dp_name ] = substr( $dp_value, 1, -1 );
                    }
                }
            }

            if ( isset( $ainfo[ $label ] ) ) {
                // key already defined
                if ( !is_array( $ainfo[ $label ] ) ) {
                    // convert current value to array
                    $ainfo[ $label ] = array( $ainfo[ $label ] );
                }
                if ( is_array( $data ) ) {
                    // merge arrays
                    $ainfo[ $label ] = array_merge( $ainfo[ $label ], $data );
                } else {
                    // just add new value
                    $ainfo[ $label ][] = $data;
                }
            } else {
                // new key=value pair
                $ainfo[ $label ] = $data;
            }
        }
        return $ainfo;
    }

}

$files = glob( './*.apk' );
foreach ( $files as $file ) {
    $info = APKInfo::getInfo( $file );
    $bname = basename( $file );
    $newname = $info['package']['name'] . '-' . $info['package']['versionCode'] . '-v' . $info['package']['versionName'] . '.apk';
    if ( $newname != $bname ) {
        echo $bname . ' -> ' . $newname . ' ';
        $result = rename( $file, dirname($file) . '/' . $newname );
        if ( $result ) echo '[OK]'; else echo '[ERROR!]';
        echo PHP_EOL;
    } else {
        echo $bname . ' skipped.' . PHP_EOL;
    }
}

exit;

?>