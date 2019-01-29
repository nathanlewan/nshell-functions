function compare-hashtable {

    <#
    .Synopsis
       Find differences between hashtables even if they contain nested hashtables, or nested arrays. 
    .DESCRIPTION
       This allows for multiple different simple output visualizations of the difference between two 
       hashtables. Hashtables can contain nested hashtables, or nested arrays.

    .PARAMETER objA
        The first object to be compared. Usually it is the initial object. It can be an array, or a 
        hashtable.

    .PARAMETER  objB
        The second object to be compared. Usually it is the object as it has been modified. It can be an 
        array, or a hashtable.

    .PARAMETER objType
        The type of object we are comparing. This is used mainly for recursive function calls within this
        command. As this supports arrays, hashtables, and objects containing both, this is used to define 
        what we are iterating over at any given time.

    .PARAMETER outputFormat
        This is to choose how the information is outputted. 
            'simple-text' ... will output text strings identifying changes (comma delimited).
            'object' ........ will output a PScustomObject of the differences.

    .EXAMPLE
       compare-hashtable -objA $initialObject -objB $newObject -outputFormat "simple-string"
    #>

    param ( 
        
        [parameter(
            Mandatory = $false,
            Position = 0,
            HelpMessage = "The first HashTable Object that you want to compare"
        )]
        [Alias("initialObject")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $objA = @{},
        
        [parameter(
            Mandatory = $false,
            Position = 1,
            HelpMessage = "The second HashTable Object that you want to compare"
        )]
        [Alias("newObject")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $objB = @{}, 

        [parameter(
            Mandatory = $false,
            Position = 2,
            HelpMessage = "type of object being looked at. Used in recursive capacity (handled automatically)"
        )]
        [String[]]
        [Alias("object")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $objType = "Hashtable",
        
        [parameter(
            Mandatory = $false,
            Position = 4,
            HelpMessage = "pick what type of output you want to display: 
            'simple-text' .... simple add/remove/modify text output
            'object' ......... output differences as a PScustomObject"
        )]
        [String[]]
        [Alias("outform")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $outputFormat = "simple-text"
    
    )
   

    $outObject = @()

    if ( $objType -eq "Hashtable") {
        
        foreach ( $level in $objA.getenumerator() ) {

            $levelType = $( $obja.$($level.key).gettype().name ).tostring()

            if ( $levelType -eq "Object[]" ) {

                $levelType = $( $($obja.$($level.key).GetType()).basetype.name ).tostring()

            }
            
            if ( $levelType -eq "Hashtable" ) {

                #write-host "$spaces [$levelType]: $($level.key)"

                if ( $objB.contains($level.key) ) {

                    compare-hashtable `
                        -objA $objA.$( $level.key ) `
                        -objB $objB.$( $level.key ) `
                        -objType $levelType

                    continue
                } else {
                    switch ($outputFormat)
                    {
                        "simple-text" {
                            $outObject += "[-] , (key):$( $level.key )"
                        }
                        "object" {

                        }
                        default {
                            $outObject += "error_no_valid_outputFormat_option"
                        }
                    }
                }

            }
            
            if ( $levelType -eq "Array" ) {
            
                #write-host "$spaces [$levelType]: $( $level.key )"

                if ( $objB.contains($level.key) ) {

                    compare-hashtable `
                        -objA $objA.$( $level.key ) `
                        -objB $objB.$( $level.key ) `
                        -objType $levelType

                    continue
                } else {
                    switch ($outputFormat)
                    {
                        "simple-text" {
                            $outObject += "[-] , (key):$( $level.key )"
                        }
                        "object" {

                        }
                        default {
                            $outObject += "error_no_valid_outputFormat_option"
                        }
                    }

                }

            }
            
            if ( $levelType -eq "String" ) {
            
                #write-host "$spaces [$levelType]: $( $level.key )"
                
                # compare with ObjB
                $objA_val = $objA.get_item( $($level.key) )
                
                if ( $null -ne $objB ) {
                    if ( $objB.contains($level.key) ) {
                        $objB_val = $objB.get_item( $($level.key) )
                    } else {
                        $objB_val = $null
                    }
                } else {
                    $objB_val = $null
                }
                
                if ( $objA_val -ne $objB_val ) {
                    if ( $null -eq $objA_val ) {

                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[+] , (key):$( $level.key ) , (value):$objB_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    } elseif ($null -eq $objB_val) {

                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[-] , (key):$( $level.key ) , (value):$objA_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    } else {

                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[*] , (key):$( $level.key ) , (old_value):$objA_val , (new_value):$objB_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    }
                } 
            }
        }
    }
    
    if ( $objType -eq "Array" ) {
        
        $counter = 0

        $objA | ForEach-Object {
        
            $level = $objA[$counter]
            
            $levelType = $( $level.gettype().name ).tostring()
            if ( $levelType -eq "Object[]" ) {
                $levelType = $( $($level.GetType()).basetype.name ).tostring()
            }
              
            if ( $levelType -eq "Array" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -objType $levelType
                continue 
            }
            
            if ( $levelType -eq "Hashtable" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -objType $levelType
                continue
            }
            
            if ( $levelType -eq "String" ) {
        
                #write-host "$spaces [$levelType]: $level"
                # compare with ObjB
                $objA_val = $objA[$counter]
                
                
                if ( $objB.contains($objA_val) ) {
                    $objB_val = $objB[$counter]
                } else {
                    $objB_val = $null
                }
                
                if ($objA_val -ne $objB_val) {
                    if ($null -eq $objA_val) {
                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[+] , (value):$objB_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    } elseif ($null -eq $objB_val) {
                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[-] , (value):$objA_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    } else {
                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[*] , (old_value):$objA_val , (new_value):$objB_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    }
                }
            }

            $counter++
           
        }





        
        $counter = 0

        $objB | ForEach-Object {
        
            $level = $objB[$counter]
            
            $levelType = $( $level.gettype().name ).tostring()
            if ( $levelType -eq "Object[]" ) {
                $levelType = $( $($level.GetType() ).basetype.name).tostring()
            }
              
            if ( $levelType -eq "Array" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces -objType $levelType
                continue
            }
            
            if ( $levelType -eq "Hashtable" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces -objType $levelType
                continue
            }
            
            if ( $levelType -eq "String" ) {
        
                # compare with ObjA
                $objB_val = $objB[$counter]
                
                
                if ( $objA.contains($objB_val) ) {
                    $objA_val = $objA[$counter]
                } else {
                    $objA_val = $null
                }
                
                
                
                if ( $objA_val -ne $objB_val ) {
                    
                    if ( $null -eq $objA_val ) {

                        switch ($outputFormat)
                        {
                            "simple-text" {
                                $outObject += "[+] , (value):$objB_val"
                            }
                            "object" {

                            }
                            default {
                                $outObject += "error_no_valid_outputFormat_option"
                            }
                        }

                    }
                }
            }

            $counter++
           
        }
    }

    return $outObject
}
