<?php

$ds = DIRECTORY_SEPARATOR;
$map = [
    'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u', 'ý' => 'y', 'ć' => 'c', 'č' => 'c',
    'ď' => 'd', 'ě' => 'e', 'ĺ' => 'l', 'ň' => 'n', 'ŕ' => 'r', 'ř' => 'r', 'š' => 's', 'ť' => 't',
    'ů' => 'u', 'ž' => 'z',
    'Á' => 'A', 'É' => 'E', 'Í' => 'I', 'Ó' => 'O', 'Ú' => 'U', 'Ý' => 'Y', 'Ć' => 'C', 'Č' => 'C',
    'Ď' => 'D', 'Ě' => 'E', 'Ĺ' => 'L', 'Ň' => 'N', 'Ŕ' => 'R', 'Ř' => 'R', 'Š' => 'S', 'Ť' => 'T',
    'Ů' => 'U', 'Ž' => 'Z',
    ' ' => '_', '¦' => '', '|' => '', "'" => '', ',' => '', ')' => '', '(' => '', '[' => '', ']' => '',
    "@" => "",
];

$i = 0;
$dirs = [];
$paths = [];
$names1 = [];
$names2 = [];

echo "reading folders:\n\n";

foreach ($iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator("./",
        RecursiveDirectoryIterator::SKIP_DOTS
    ), RecursiveIteratorIterator::SELF_FIRST) as $item) {
    $path = $iterator->getSubPath();
    $sub = $iterator->getSubPathName();
    $name = $iterator->getFileName();
    $fixname = strtolower(strtr($name, $map));
    $fixname = preg_replace('!_+!', '_', $fixname);
    $fixname = str_replace("_.", '.', $fixname);
    $fixname = str_replace("._", '.', $fixname);
    $fixname = str_replace("_-_", '-', $fixname);
    if ($item->isDir()) {
        if ($name != $fixname) {
            $dirs[$sub] = substr_count($sub, "/");
            $names1[$sub] = $name;
            $names2[$sub] = $fixname;
            $paths[$sub] = $path;
            echo "+";
            $i++;
        } else {
            echo ".";
        }
    }
}

arsort($dirs);
if (count($dirs)) {

    echo "\n\nfixing folders:\n\n";

    foreach ($dirs??=[] as $k => $v) {
        if ($paths[$k] == "") {
            $paths[$k] = ".";
        }
        echo "> $paths[$k]/$names2[$k]\n";
        @rename("$paths[$k]/$names1[$k]", "$paths[$k]/$names2[$k]");
    }

    echo "\n\nFolders fixed. Please re-run the script.\n";

    exit;
}

echo "\n\nfixing files:\n\n";

foreach ($iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator("./",
        RecursiveDirectoryIterator::SKIP_DOTS
    ), RecursiveIteratorIterator::SELF_FIRST) as $item) {
    $path = $iterator->getSubPath();
    $sub = $iterator->getSubPathName();
    $name = $iterator->getFileName();
    $fixname = strtolower(strtr($name, $map));
    $fixname = preg_replace('!_+!', '_', $fixname);
    $fixname = str_replace("_.", '.', $fixname);
    $fixname = str_replace("_-", '-', $fixname);
    $fixname = str_replace("._", '.', $fixname);
    $fixname = str_replace(".-", '.', $fixname);
    $fixname = str_replace("_-_", '-', $fixname);
    if ($item->isDir()) {
        echo "> $name\n";
        continue;
    } else {
        if (strlen($path) == 0 && $name != $fixname) {
            echo "  * $fixname\n";
            @rename($name, $fixname);
        }
        if (strlen($path) && $name != $fixname) {
            echo "  * $fixname\n";
            @rename($path . $ds . $name, $path . $ds . $fixname);
        }
    }
}

echo "\nDone.\n";
