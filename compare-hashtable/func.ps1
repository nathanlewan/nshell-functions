function compare-hashtable {

    <#
    .Synopsis
       Find differences between hashtables, even if they contain nested hashtables, or nested arrays. 
    .DESCRIPTION
       This allows for multiple different simple output visualizations of the difference between two 
       hashtables.
    .EXAMPLE
       compare-hashtable -objA $initialObject -objB $newObject
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
            HelpMessage = "When printing out info as a string, how big the indent should be (handled automatically)"
        )]
        [Alias("indent")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $spaces = " ", 
        
        [parameter(
            Mandatory = $false,
            Position = 3,
            HelpMessage = "used when called recursively to identify what we are recursing over (handled automatically)"
        )]
        [Alias("type")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        $objType = "Hashtable"
    
    )
   

    if ( $objType -eq "Hashtable") {
        
        foreach ( $level in $objA.getenumerator() ) {

            $levelType = $( $obja.$($level.key).gettype().name ).tostring()

            if ( $levelType -eq "Object[]" ) {

                $levelType = $( $($obja.$($level.key).GetType()).basetype.name ).tostring()

            }
            
            if ( $levelType -eq "Hashtable" ) {

                write-host "$spaces [$levelType]: $($level.key)"

                if ( $objB.contains($level.key) ) {
                    compare-hashtable -objA $objA.$( $level.key ) -objB $objB.$( $level.key ) -spaces "$spaces  " -objType $levelType
                    continue
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$( $level.key ) ]" -ForegroundColor Red
                }

            }
            
            if ( $levelType -eq "Array" ) {
            
                write-host "$spaces [$levelType]: $( $level.key )"

                if ( $objB.contains($level.key) ) {
                    compare-hashtable -objA $objA.$( $level.key ) -objB $objB.$( $level.key ) -spaces "$spaces  " -objType $levelType
                    continue
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$( $level.key ) ]" -ForegroundColor Red
                }

            }
            
            if ( $levelType -eq "String" ) {
            
                write-host "$spaces [$levelType]: $( $level.key )"
                
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
                        write-host "$spaces  |_ attribute added:    [ (key):$( $level.key ) (value):$objB_val ]" -ForegroundColor Green
                    } elseif ($null -eq $objB_val) {
                        write-host "$spaces  |_ attribute removed:  [ (key):$( $level.key ) (value):$objA_val ]" -ForegroundColor Red
                    } else {
                        write-host "$spaces  |_ attribute modified: (key):$( $level.key ) [ (old_value):$objA_val -> (new_value):$objB_val ]" -ForegroundColor Yellow
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
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue 
            }
            
            if ( $levelType -eq "Hashtable" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue
            }
            
            if ( $levelType -eq "String" ) {
        
                write-host "$spaces [$levelType]: $level"
                # compare with ObjB
                $objA_val = $objA[$counter]
                
                
                if ( $objB.contains($objA_val) ) {
                    $objB_val = $objB[$counter]
                } else {
                    $objB_val = $null
                }
                
                if ($objA_val -ne $objB_val) {
                    if ($null -eq $objA_val) {
                        write-host "$spaces  |_ attribute added:    [ (value):$objB_val ]" -ForegroundColor Green
                    } elseif ($null -eq $objB_val) {
                        write-host "$spaces  |_ attribute removed:  [ (value):$objA_val ]" -ForegroundColor Red
                    } else {
                        write-host "$spaces  |_ attribute modified: [ (old_value):$objA_val -> (new_value):$objB_val ]" -ForegroundColor Yellow
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
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue
            }
            
            if ( $levelType -eq "Hashtable" ) {
                compare-hashtable -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
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
                        write-host "$spaces  |_ attribute added:    [ (value):$objB_val ]" -ForegroundColor green
                    }
                }
            }

            $counter++
           
        }
    }
}
