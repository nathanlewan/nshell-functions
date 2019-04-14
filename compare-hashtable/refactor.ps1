$initialObject = @("nathan", "fin")

$newObject = @("nathan", "fin")


function compare-nsObject 
{


    param
    (
        $objA = $null,
        $objB = $null,
        $layerNumber = 0,
        $returnedSet = @(),
        $runCheckEntry = $false,
        $DEBUG = 0
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

    function prettifyReturn
    {
        param
        (
            $returnObject
        )

        $prettifiedObject = @()
        $longestTypeString = 0

        $returnObject | foreach-object {
            $entryLength = $($_ -split " ")[0].length

            if ($entryLength -gt $longestTypeString) 
            {
                $longestTypeString = $entryLength
            }

        }

        debugLog -message "longestTypeString: $longestTypeString" ###

        $returnObject | ForEach-Object {
            $entry = $_
            $entryOut = $null
            $entryOutTypeArr = $($entry -split " ")
            $entryOutTypeInit = $entryOutTypeArr[0]
            $entryOutType = $entryOutTypeInit
            $entryLength = $entryOutType.length

            while ($entryLength -lt $longestTypeString) {
                $entryOutType = "$entryOutType "
                $entryLength = $entryOutType.length
                debugLog -message "$entryOutType |" ###
            }

            debugLog -message "entryOutType: $entryOutType |" ###
            debugLog -message "entryOutTypeInit: $entryOutTypeInit |" ###
            debugLog -message "entry: $entry" ###
            $entryOut = "$entryOutType $($entryOutTypeArr[1]) $($entryOutTypeArr[2])"
            
            debugLog -message "entryOut: $entryOut" ###

            $prettifiedObject += $entryOut

        }

        return $prettifiedObject

    }


    $entryAType = checkEntry -passedObject $objA
        debugLog -message "objA type: $entryAType" ###
    $entryBType = checkEntry -passedObject $objB
        debugLog -message "objB type: $entryBType" ###

    if ($runCheckEntry -eq $true) {                         # just run the checkEntry function (for testing)
        return @("OBJA: $entryAType", "OBJB: $entryBType")
    }


    if ($entryAType -ne $entryBType)
    {

        $returnedSet += "[$entryBType] [+] $objB"
        $returnedSet += "[$entryAType] [-] $objA"

    } else {

        switch ($entryAType) 
        {
            "Hashtable"
            {
                debugLog -message "layer$layerNumber hashtable" ###

            }

            "Array"
            {
                debugLog -message "layer$layerNumber array" ###
                if ( $initialObject -ne $newObject) {
                    $initialObject | foreach-object {
                        compare-nsObject -objA $_ -objB $newObject[$layerNumber] -DEBUG $DEBUG
                        $layerNumber ++
                    }
                }
            }

            "String"
            {
                debugLog -message "layer$layerNumber string" ###

                if ($initialObject -ne $newObject) {
                    $returnedSet += "[$entryAType] [-] $objA"
                    $returnedSet += "[$entryBType] [+] $objB"
                }

            }
            default
            {

            }
        }
    }

    $finalOut = $(prettifyReturn -returnObject  $returnedSet)
    return $finalOut

}

$test = compare-nsObject -objA $initialObject -objB $newObject -DEBUG 0
$test