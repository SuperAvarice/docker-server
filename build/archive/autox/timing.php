<?php

return [

    // title for main page and navigation bar
    'title' => env('TITLE', 'NTAXS Live Results'),
    
    // disclaimer that appears under the event title on the navigation bar
    'disclaimer' => '*** Unofficial ***',
    
    // timing sources and their local paths or URLs
    'source' => [
        'NTAXS' => '/var/www/autox/results.html',
	//'SCCA' => 'http://sololive.texasscca.org/',
        //'Some Region' => "http://timing.someregion.org/",
    ],
    
    // classes in lowercase and their category
    // this determines the grouping of classes when the user selects Grouping by Category
    // list in the desired sort order for the categories
    // for indexed and ladies classes you only need to list the class they are derived from
    'category' => [
        'ss' => 'Street',
        'as' => 'Street',
        'bs' => 'Street',
        'cs' => 'Street',
        'ds' => 'Street',
        'es' => 'Street',
        'fs' => 'Street',
        'gs' => 'Street',
        'hs' => 'Street',
        'ssc' => 'Solo Spec',
        'hcs' => 'Heritage Classic',
        'hcr' => 'Heritage Classic',
        'sth' => 'Street Touring',
        'sts' => 'Street Touring',
        'stx' => 'Street Touring',
        'str' => 'Street Touring',
        'stu' => 'Street Touring',
        'stp' => 'Street Touring',
        'ssp' => 'Street Prepared',
        'asp' => 'Street Prepared',
        'bsp' => 'Street Prepared',
        'csp' => 'Street Prepared',
        'dsp' => 'Street Prepared',
        'esp' => 'Street Prepared',
        'fsp' => 'Street Prepared',
        'ssr' => 'Street R',
        'cams' => 'Classic American',
        'camc' => 'Classic American',
        'camt' => 'Classic American',
        'xp' => 'Prepared',
        'bp' => 'Prepared',
        'cp' => 'Prepared',
        'dp' => 'Prepared',
        'ep' => 'Prepared',
        'fp' => 'Prepared',
        'ssm' => 'Street Modifed',
        'sm' => 'Street Modifed',
        'smf' => 'Street Modifed',
        'am' => 'Modified',
        'bm' => 'Modified',
        'cm' => 'Modified',
        'dm' => 'Modified',
        'em' => 'Modified',
        'fm' => 'Modified',
        'fsae' => 'Formula SAE',
        'km' => 'Kart',
        'ja' => 'Junior Kart',
        'jb' => 'Junior Kart',
        'jc' => 'Junior Kart',
    ],

    // classes in lowercase and their display name
    // display names in table headings of the timing source will override
    // for indexed and ladies classes you only need to list the class they are derived from
    'class' => [
        'ss' => 'Super Street',
        'as' => 'A Street',
        'bs' => 'B Street',
        'cs' => 'C Street',
        'ds' => 'D Street',
        'es' => 'E Street',
        'fs' => 'F Street',
        'gs' => 'G Street',
        'hs' => 'H Street',
        'hcs' => 'Heritage Classic Street',
        'ssc' => 'Solo Spec Coupe',
        'sth' => 'Street Touring H',
        'sts' => 'Street Touring S',
        'stx' => 'Street Touring X',
        'str' => 'Street Touring R',
        'stu' => 'Street Touring U',
        'stp' => 'Street Touring P',
        'ssp' => 'Super Street Prepared',
        'asp' => 'A Street Prepared',
        'bsp' => 'B Street Prepared',
        'csp' => 'C Street Prepared',
        'dsp' => 'D Street Prepared',
        'esp' => 'E Street Prepared',
        'fsp' => 'F Street Prepared',
        'ssr' => 'Super Street R',
        'cams' => 'Classic American S',
        'camc' => 'Classic American C',
        'camt' => 'Classic American T',
        'xp' => 'X Prepared',
        'bp' => 'B Prepared',
        'cp' => 'C Prepared',
        'dp' => 'D Prepared',
        'ep' => 'E Prepared',
        'fp' => 'F Prepared',
        'hcr' => 'Heritage Classic Race',
        'ssm' => 'Super Street Modifed',
        'sm' => 'Street Modifed',
        'smf' => 'Street Modifed FWD',
        'am' => 'A Modified',
        'bm' => 'B Modified',
        'cm' => 'C Modified',
        'dm' => 'D Modified',
        'em' => 'E Modified',
        'fm' => 'F Modified',
        'fsae' => 'Formula SAE',
        'km' => 'F125 Shifter Kart',
        'ja' => 'Junior Kart A',
        'jb' => 'Junior Kart B',
        'jc' => 'Junior Kart C',
    ],

    // classes in lowercase and their PAX index
    // for indexed and ladies classes you only need to list the class they are derived from
    'pax' => [
        'ss' => '0.817',
        'as' => '0.814',
        'bs' => '0.808',
        'cs' => '0.805',
        'ds' => '0.794',
        'es' => '0.787',
        'fs' => '0.797',
        'gs' => '0.786',
        'hs' => '0.781',
        'hcs' => '0.791',
        'ssc' => '0.806',
        'sts' => '0.810',
        'stx' => '0.813',
        'str' => '0.823',
        'stu' => '0.824',
        'stp' => '0.815',
        'sth' => '0.811',
        'ssp' => '0.852',
        'asp' => '0.848',
        'bsp' => '0.846',
        'csp' => '0.857',
        'dsp' => '0.835',
        'esp' => '0.828',
        'fsp' => '0.819',
        'ssr' => '0.838',
        'camc' => '0.816',
        'camt' => '0.807',
        'cams' => '0.831',
        'xp' => '0.884',
        'bp' => '0.860',
        'cp' => '0.847',
        'dp' => '0.858',
        'ep' => '0.850',
        'fp' => '0.863',
        'hcr' => '0.812',
        'smf' => '0.839',
        'sm' => '0.853',
        'ssm' => '0.871',
        'am' => '1.000',
        'bm' => '0.956',
        'cm' => '0.890',
        'dm' => '0.895',
        'em' => '0.894',
        'fm' => '0.904',
        'fsae' => '0.958',
        'km' => '0.928',
        'ja' => '0.855',
        'jb' => '0.825',
        'jc' => '0.718',
    ],

    // indexed class identifiers in lowercase and their display name
    // display names in table headings of the timing source will override
    'idx_class' => [
        'n' => 'Novice',
        'p' => 'Pro',
        't' => 'Street Tire Class',
    ],

    // optional indexed class identifiers in lowercase and their multiplier
    // the PAX index for each driver is multiplied by this value
    'idx_mult' => [
        't' => '0.98',
    ],

    // cache time-to-live in minutes
    // hash controls caching of the contents hash if using a local file for the timing source
    // headers controls caching of the ETag and Last-Modified headers returned by the timing source
    // results and old_results control caching of the data from the timing source
    // if results data is still in cache, it is used without checking the timing source for changes
    // if the hash/response headers did not change or the timing source is inaccessible, the old_results data is used
    'ttl' => [
        'hash' => 5,
        'headers' => 5,
        'results' => 0.2,
        'old_results' => 240,
    ],
    
    // position of the main timing table relative to the bottom
    // default is 2 (the next to last table)
    'table_pos' => 2,
    
];
