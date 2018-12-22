$initialObject = @{
    user1 = @{
        firstname = "nathan"
        lastname = "lewan"
        yes ="no"
        entry = @("1", "2", @("3", "4"))
    }
}
$newObject = @{
    user1 = @{
        firstname = "nathan"
        lastname = "lewan"
        yes ="no"
        entry = @("1", "2", @("3", "5"))
    }
}



function HCCcompare {

    param ( $objA, $objB, $spaces, $objType )
   
    if ( $objType -eq "Hashtable") {
        foreach ($level in $objA.getenumerator() ) {

            $levelType = $($obja.$($level.key).gettype().name).tostring()
            if ($levelType -eq "Object[]") {
                $levelType = $($($obja.$($level.key).GetType()).basetype.name).tostring()
            }
            
            
            if (  $levelType -eq "Hashtable"  ) {
            
                write-host "$spaces $($level.key) --- $levelType"

                if ( $objB.contains($level.key) ) {
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            if ($levelType -eq "Array") {
            
                write-host "$spaces $($level.key) --- $levelType"

                if ( $objB.contains($level.key) ) {
                    HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                } else {
                    write-host "$spaces  |_ attribute removed:  [ (key):$($level.key) ]" -ForegroundColor Red
                }
            }
            
            if ($levelType -eq "String") {
            
                write-host "$spaces $($level.key) --- $levelType"
                
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
        
                write-host "$spaces $level --- $levelType"
        
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

clear

HCCcompare -objA $initialObject -objB $newObject -spaces "  " -objType "Hashtable"