<?php
header('Content-Type: text/cache-manifest');
$filesToCache = array(
    './index.php', 
    './statics/scripts/base.min.js', 
    './statics/scripts/jquery-1.8.2.js', 
    './statics/styles/base.min.css',
    './statics/gif/section_1.gif',
    './statics/gif/section_2.gif',
    './statics/gif/section_3.gif',
    './statics/gif/section_4.gif',
    './statics/gif/section_5.gif',
    './statics/images/light_index.png',
    './statics/images/mobile_page_1.png',
    './statics/images/mobile_page_5.png',
    './statics/images/mobile_page_btn.png',
    './statics/images/post_card.png',
    './statics/images/text_page_1.png',
    './statics/images/text_page_2.png',
    './statics/images/text_page_3.png',
    './statics/images/text_page_4.png',
    './statics/images/text_page_5.png',
    './statics/music/music.mp3'
);
?>
CACHE MANIFEST

CACHE:
<?php
// Print files that we need to cache and store hash data
$hashes = '';
foreach($filesToCache as $file) {
    echo $file."\n";
    $hashes.=md5_file($file);
};
?>

NETWORK:
*

# Hash Version: <?=md5($hashes)?>