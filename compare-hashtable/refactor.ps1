$initialObject = @{
    user1 = @{
        firstname = "nathan"
        lastname = "lewan"
    }
}
$newObject = @{
    user1 = @{
        firstname = "sofie"
        lastname = "lewan"
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
                HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                
            }
            
            if ($levelType -eq "Array") {
            
                write-host "$spaces $($level.key) --- $levelType"
                HCCcompare -objA $objA.$($level.key) -objB $objB.$($level.key) -spaces "$spaces  " -objType $levelType
                
            }
            
            if ($levelType -eq "String") {
            
                write-host "$spaces $($level.key) --- $levelType"
                
                # compare with ObjB
                $objA_val = $objA.get_item($($level.key))
                $objB_val = $objB.get_item($($level.key))
                
                if ($objA_val -ne $objB_val) {
                    write-host "$spaces not matching, $($level.key) :   $objA_val ::: $objB_val"
                }
            
            }
            
        }
    }
    
    if ( $objType -eq "Array") {
        
        $objA | ForEach-Object {
        
            $level = $_
            
            $levelType = $($level.gettype().name).tostring()
            if ($levelType -eq "Object[]") {
                $levelType = $($($level.GetType()).basetype.name).tostring()
            }
              
            if ($levelType -eq "Array") {
                HCCcompare -objA $level -objB $level -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "Hashtable") {
                HCCcompare -objA $level -objB $level -spaces "$spaces  " -objType $levelType
            }
            
            if ($levelType -eq "String") {
        
                write-host "$spaces $level --- $levelType"
        
            }
           
        }
    }
}


HCCcompare -objA $initialObject -objB $newObject -spaces "  " -objType "Hashtable"