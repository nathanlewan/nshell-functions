<#
    Comments for code are written here, line numbers that the comments refer to
    are the number listed at the start of the comment line:

    [1]: we have parameters: 
            (objectA) -> original object
            (objectB) -> new object
            (how many spaces will be printed for the logged line) -> indentations
            (type of object we are comparing) -> hashtable, string, or array

    [2]: if (objectA) is a (hashtable), process these steps.

         [3]: begin foreach loop to test every entry in the (objectA) hashtable. Each
              entry is given the variable (level)

            [4]: determine what kind of object the value of (level) is and set to
                variable (leveltype)

            [5-6]: if (leveltype) is 'Object[]', then dig a little deeper to set 
                    (leveltype) to the specific type of object.

            [7-8]: if (leveltype) is a hashtable, then console log the key name
                    and process these steps

                    [9 -11 RECURSE]: if $objectB contains the current entry of ObjectA,
                                then recurse on the entry, comparing ObjectA.(level) 
                                with ObjectB.(level).
                                We pass a new entry for indentation (spaces), as well as
                                the (leveltype) of hashtable.
                                Otherwise we console log that the entry was removed.

            [12 -13]: if (leveltype) is an array, then console log the key name
                    and process these steps.

                    [14 -16 RECURSE]: if $objectB contains the current entry of ObjectA,
                                then recurse on the entry, comparing ObjectA.(level) 
                                with ObjectB.(level).
                                We pass a new entry for indentation (spaces), as well as
                                the (leveltype) of array.
                                Otherwise we console log that the entry was removed.

            [17 -18 ]: if (leveltype) is a string, then console log the key name
                    and process these steps.

                    [19 - 21]: get the value of entry for ObjectB. If it is blank,
                               set to null.

                    [22]: if the entry for ObjectA and ObjectB are not equal
                          [23]: if ObjectA is null, [write]: attribute added
                          [24]: if ObjectB is null,, [write]: attribute removed
                          [25]: else [write]: attribute modified
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

                # 9
                if ( $objB.contains($level.key) ) {
                    # 10
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                    continue
                } else {
                    # 11
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            # 12
            if ($levelType -eq "Array") {
            
                # 13
                write-host "$spaces [$levelType]: $($level.key)"

                # 14
                if ( $objB.contains($level.key) ) {
                    # 15
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                    continue
                } else {
                    # 16
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            # 17
            if ($levelType -eq "String") {
            
                # 18
                write-host $spaces, "running here 2" -ForegroundColor green
                write-host "$spaces [$levelType]: $($level.key)"
                
                # compare with ObjB
                $objA_val = $objA.get_item($($level.key))
                
                # 19
                if ( $null -ne $objB ) {

                    # 20 
                    if ( $objB.contains($level.key)) {
                        $objB_val = $objB.get_item($($level.key))
                    } else {
                        $objB_val = $null
                    }
                } else {

                    # 21
                    $objB_val = $null
                }
                
                # 22
                if ($objA_val -ne $objB_val) {
                    
                    # 23
                    if ($null -eq $objA_val) {
                        write-host "$spaces  |_ attribute added:    [ (key):$($level.key) (value):$objB_val ]" -ForegroundColor Green
                    # 24
                    } elseif ($null -eq $objB_val) {
                        write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) (value):$objA_val ]" -ForegroundColor Red
                    # 25
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
                continue 
            }
            
            if ($levelType -eq "Hashtable") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue
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
            
            $levelType = $($level.gettype().name).tostring()
            if ($levelType -eq "Object[]") {
                $levelType = $($($level.GetType()).basetype.name).tostring()
            }
              
            if ($levelType -eq "Array") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue
            }
            
            if ($levelType -eq "Hashtable") {
                HCCcompare -objA $objA[$counter] -objB $objB[$counter] -spaces "$spaces  " -objType $levelType
                continue
            }
            
            if ($levelType -eq "String") {
        
                # compare with ObjA
                $objB_val = $objB[$counter]
                
                
                if ( $objA.contains($objB_val) ) {
                    $objA_val = $objA[$counter]
                } else {
                    $objA_val = $null
                }
                
                
                
                if ($objA_val -ne $objB_val) {
                    
                    if ($null -eq $objA_val) {
                        write-host "$spaces  |_ attribute added:    [ (value):$objB_val ]" -ForegroundColor green
                    }
                }
            }

            $counter++
           
        }


    }
}
