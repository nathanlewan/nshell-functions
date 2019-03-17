$initialObject = @{
  username = "nathanl"
  favFoods = @{
        snack = "pizza"
        lunch = "soup"
  }
}

$newObject = @{
  username = "nathan"
  
}

$DEBUG = 1

clear

function compare-nsObject 
{


    param
    (
        $objA = $null,
        $objB = $null,
        $returnedSet = @()
    )


    function checkEntry 
    {
        param ( $passedObject = $null )

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

        if ($DEBUG = 1)
        {
            write-host "[DEBUG]: $message"
        }
    }

    function hashIterate
    {
        param 
        ( 
            $objA,
            $objB,
            $direction,
            $returnedSet
        )

        debugLog -message "called hashIterate" ###

        foreach ($entry in $objA.getenumerator())
        {
            debugLog -message "layer1 entryKey: $($entry.key)" ###
            debugLog -message "layer1 entryValue: $($entry.value)" ###

            $thisEntryAType = checkEntry -passedObject $($entry.value)

            debugLog -message "layer1 entryType: $thisEntryAType" ###

            switch ($thisEntryAType)
            {
                "Hashtable"
                {
                    compare-nsObject `
                        -objA $($objA.$($entry.key)) `
                        -objB $($objB.$($entry.key)) `
                        -returnedSet $returnedSet

                    compare-nsObject `
                        -objA $($objB.$($entry.key)) `
                        -objB $($objA.$($entry.key)) `
                        -returnedSet $returnedSet
                }

                "Array"
                {

                }

                "String"
                {
                    if ($objB.contains($entry.key))
                    {
                        if( $($objB.get_item($entry.key)) -ne $($entry.value)) {
                            if ($direction -eq "add")
                            {
                                $returnedSet += "[*]  $($objB.get_item($entry.key))"
                            }
                        }
                    }
                    else
                    {
                        switch ($direction)
                        {

                            "remove"
                            {
                                $returnedSet += "[-]  $($entry.value)"
                            }

                            "add"
                            {
                                $returnedSet += "[+]  $($entry.value)"
                            }
                        }
                    }
                }

                default
                {

                }
            }
        }

        return $returnedSet
    }


    $entryAType = checkEntry -passedObject $objA
        debugLog -message "objA type: $entryAType" ###
    $entryBType = checkEntry -passedObject $objB
        debugLog -message "objB type: $entryBType" ###


    if ($entryAType -ne $entryBType)
    {

        $returnedSet += "[+] $objB"
        $returnedSet += "[-] $($objA.values)"

    } else {

        switch ($entryAType) 
        {
            "Hashtable"
            {
                debugLog -message "layer1 hashtable" ###

                hashIterate `
                    -objA $initialObject `
                    -objB $newObject `
                    -direction "remove" `
                    -returnedSet $returnedSet

                hashIterate `
                    -objA $newObject `
                    -objB $initialObject `
                    -direction "add" `
                    -returnedSet $returnedSet

            }

            "Array"
            {

            }

            "String"
            {

            }
            default
            {

            }
        }
    }

        


    return $returnedSet

}

$test = compare-nsObject -objA $initialObject -objB $newObject