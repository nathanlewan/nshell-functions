$initial = @("nlewan", "lewan", @("test1", @("test2")))
$new = @("nlewan", "nathan")



function compare-nsArray {

    param 
    (
        $initialArray,
        $newArray,
        $returnOutObject = @(),
        $recursiveCall = $false,
        $DEBUG = 1
    )

    function checkEntry 
    {
        param 
        ( 
            $passedObject = $null 
        )

        if ($null -eq $passedObject)
        {
            return $null
        }

        $typeCheck = $( 
            $passedObject.gettype().name 
            ).tostring()

        if ( $typeCheck -eq "Object[]" ) {
            $typeCheck = $( 
                $($passedObject.GetType()).basetype.name
            ).tostring()
        }

        return $typeCheck
    }

    function debugLog
    {
        param ( $message )

        if ($DEBUG -eq 1)
        {
            write-host "[DEBUG]: $message"
        }
    }

    $initialArrayLength = $initialArray.Length
    $newArrayLength = $newArray.Length



    # check for additions

    $arraySpotCounter = 0

    while ($arraySpotCounter -lt $newArrayLength) {

        $newArrayItem = $newArray[$arraySpotCounter]

        $recursionNeeded = $(  (checkEntry -passedObject $newArrayItem) -eq "array"  )

        if `
            ( `
                ($recursionNeeded -eq $true) `
                -and ($newArrayItem.count -gt 0) `
                -and ($initialArrayMatchingItem -gt 0) `
            )

            {
                debugLog -message "newArray needs recursion" ###

                $initialArrayMatchingItem = $initialArray[$arraySpotCounter]

                $returnOutObject = compare-nsArray `
                    -initialArray $initialArrayMatchingItem `
                    -newArray $newArrayItem `
                    -returnOutObject $returnOutObject `
                    -recursiveCall $true
            }

        else 

            {
                if (  -not($initialArray.contains($newArrayItem))  )
                {
                    if (  $recursionNeeded -eq $true  ) 
                    {
                        $returnOutObject += "[+] $newArrayItem"
                    } else {
                        $returnOutObject += "[+] $newArrayItem"
                    }
                    
                }
            }

        $arraySpotCounter ++
        

    }



    # check for removals

    $arraySpotCounter = 0
    
    while ($arraySpotCounter -lt $initialArrayLength) {

        $initialArrayItem = $initialArray[$arraySpotCounter]


        $recursionNeeded = $(  (checkEntry -passedObject $initialArrayItem) -eq "array"  )

        if `
            ( `
                ($recursionNeeded -eq $true) `
                -and ($newArrayItem.count -gt 0) `
                -and ($initialArrayMatchingItem -gt 0) `
            )

            {

                debugLog -message "initialArray needs recursion" ###

                $newArrayMatchingItem = $newArray[$arraySpotCounter]

                $returnOutObject = compare-nsArray `
                    -initialArray $initialArrayItem `
                    -newArray $newArrayMatchingItem `
                    -returnOutObject $returnOutObject `
                    -recursiveCall $true

            }

        else 

            {
                if (  -not($newArray.contains($initialArrayItem))  )
                {
                    if (  $recursionNeeded -eq $true  )
                    {
                        $returnOutObject += "[-] " +  $InitialArrayItem[0]    ##### here be problems
                    } else {
                        $returnOutObject += "[-] $InitialArrayItem"
                    }
                    
                }
            }

        $arraySpotCounter ++

    }

    if (  $recursiveCall -eq $true  )
    {

        return $returnOutObject

    } else 
    {

        return @{
            newArray = $newArray
            changes = $returnOutObject
        }

    }
    

}

$test = compare-nsArray -initialArray $initial -newArray $new

$test