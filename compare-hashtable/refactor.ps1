<#
    Comments for code are written here, line numbers that the comments refer to
    are the number listed at the start of the comment line:

    [1]: we have (objectA), (objectB), (how many spaces will be printed for the logged 
         line), and the (type of object we are comparing.)

    [2]: begin checking what type of object we are dealing with (hashtable).

         [3]: begin foreach loop to test every entry in the (objectA) hashtable. Eacg
              entry is given the variable (level)

         [4]: determine what kind of object the value of (level)'s key is.
         [5-6]: if the type is 'Object[]', then dig a little deeper to set (leveltype)
                to the specific type of object.

         [7-8]: if this entry is a hashtable, then console log the key name
#>
function HCCcompare {

    # 1
    param ( $objA, $objB, $spaces, $objType )
   
    # 2
    if ( $objType -eq "Hashtable") {
        
        # 3
        foreach ($level in $objA.getenumerator() ) {

            # 4
            $levelType = $($obja.$($level.key).gettype().name).tostring()

            # 5
            if ($levelType -eq "Object[]") {
                # 6
                $levelType = $($($obja.$($level.key).GetType()).basetype.name).tostring()
            }
            
            # 7
            if (  $levelType -eq "Hashtable"  ) {
            
                # 8
                write-host "$spaces [$levelType]: $($level.key)"

                if ( $objB.contains($level.key) ) {
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            if ($levelType -eq "Array") {
            
                write-host "$spaces [$levelType]: $($level.key)"

                if ( $objB.contains($level.key) ) {
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            if ($levelType -eq "String") {
            
                write-host "$spaces [$levelType]: $($level.key)"
                
                # compare with ObjB
                $objA_val = $objA.get_item($($level.key))
                
                if ( $objB -ne $null ) {
                    if ( $objB.contains($level.key)) {
                        $objB_val = $objB.get_item($($level.key))
                    } else {
                        $objB_val = $null
                    }
                } else {
                    $objB_val = $null
                }
                
                
                if ($objA_val -ne $objB_val) {
                    
                    if ($objA_val -eq $null) {
                        write-host "$spaces  |_ attribute added:    [ (key):$($level.key) (value):$objB_val ]" -ForegroundColor Green
                    } elseif ($objB_val -eq $null) {
                        write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) (value):$objA_val ]" -ForegroundColor Red
                    } else {
                        write-host "$spaces  |_ attribute modified: (key):$($level.key) [ (old_value):$objA_val -> (new_value):$objB_val ]" -ForegroundColor Yellow
                    }
                }
            
            }
            
        }
    }
    
    if ( $objType -eq "Array") {
        
        $counter = 0

        $objA | ForEach-Object {
        
            $level = $objA[$counter]
            
            $levelType = $($level.gettype().name).tostring()
            if ($levelType -eq "Object[]") {
                $levelType = $($($level.GetType()).basetype.name).tostring()
            }
              
            if ($levelType -eq "Array") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "Hashtable") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "String") {
        
                write-host "$spaces [$levelType]: $level"
        
                # compare with ObjB
                $objA_val = $objA[$counter]
                
                
                if ( $objB.contains($objA_val) ) {
                    $objB_val = $objB[$counter]
                } else {
                    $objB_val = $null
                }
                
                
                
                if ($objA_val -ne $objB_val) {
                    
                    if ($objA_val -eq $null) {
                        write-host "$spaces  |_ attribute added:    [ (value):$objB_val ]" -ForegroundColor Green
                    } elseif ($objB_val -eq $null) {
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
            
            $levelType = $($level.gettype().name).tostring()
            if ($levelType -eq "Object[]") {
                $levelType = $($($level.GetType()).basetype.name).tostring()
            }
              
            if ($levelType -eq "Array") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "Hashtable") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "String") {
        
                # compare with ObjA
                $objB_val = $objB[$counter]
                
                
                if ( $objA.contains($objB_val) ) {
                    $objB_val = $objB[$counter]
                } else {
                    $objA_val = $null
                }
                
                
                
                if ($objA_val -ne $objB_val) {
                    
                    if ($objA_val -eq $null) {
                        write-host "$spaces  |_ attribute added:    [ (value):$objB_val ]" -ForegroundColor green
                    }
                }
            }

            $counter++
           
        }


    }
}
