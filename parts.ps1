function compare-nsArray {

    <#
    .Synopsis
        Find differences between arrays, including jagged and multidimentional arrays. 
    .DESCRIPTION
        outputs the differences between arrays as a psobject with 'added', 'modified', or 'removed'
        attributes, making it easier to visualize using whatever means you prefer.

    .PARAMETER initialArray
        The first array to be compared. Usually it is the initial array.

    .PARAMETER  newArray
        The second array to be compared. Usually it is the array as it has been modified.

    .EXAMPLE
        compare-hashtable -initialArray $initialObject -newArray $newObject

    .EXAMPLE
        compare-hashtable $initialObject $newObject
    #>

    param 
    (

        [parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = "The first Array Object that you want to compare"
        )]
        [Alias("first")]
        [Array]
        $initialArray,



        [parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "The second Array Object that you want to compare"
        )]
        [Alias("second")]
        [Array]
        $newArray,



        [parameter(
            Mandatory = $false,
            Position = 2,
            HelpMessage = "hold only the output during recursive calls",
            ParameterSetName = "recursiveCall",
            DontShow
        )]
        [Alias("outObject")]
        [Array]
        $returnOutObject = @(),



        [parameter(
            Mandatory = $false,
            Position = 3,
            HelpMessage = "flag this calling of the function as a recursive call",
            ParameterSetName = "recursiveCall",
            DontShow
        )]
        [Alias("recursive")]
        [Bool]
        $recursiveCall = $false,



        [parameter(
            Mandatory = $false,
            Position = 4,
            HelpMessage = "appended spaces on verbose log lines",
            DontShow
        )]
        [String]
        $appendSpaces = "",
        


        [parameter(
            Mandatory = $false,
            Position = 5,
            HelpMessage = "array we are looking at (for verbose logs)",
            DontShow
        )]
        [String]
        $targetArray = "[RootLevel]"

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

    function entryExistsInOtherArray
    {
        param (
            $searchArray,
            $searchItem
        )

        $searchText = ""

        $searchItem | foreach-object {
            $searchText += '($_ -eq "' + $_ + '") -and '
        }

        $searchText = $searchText.TrimEnd(" ","-","a","n","d"," ")

        return $searchArray | Where-Object { (Invoke-Expression $searchText) }

    }


    #$initialArrayLength = $initialArray.Length
    $newArrayLength = $newArray.Length

    write-verbose " "
    write-verbose "$appendSpaces $targetArray (see if newArray contains things initialArray does not)"
    write-verbose " "


    $arraySpotCounter = 0

    while ($arraySpotCounter -lt $newArrayLength) {

        $newArrayItem = $newArray[$arraySpotCounter]

        write-verbose "$appendSpaces     [newArray]: looking at [[$newArrayItem]]"

        $initialArrayItemMatch = entryExistsInOtherArray `
            -searchArray $initialArray `
            -searchItem $newArrayItem

        write-verbose "$appendSpaces     [initArray]: search for match result: [[$initialArrayItemMatch]]"

        if (  $null -eq $initialArrayItemMatch  ) {

            $returnOutObject += ";[+] $newArrayItem"
            write-verbose "$appendSpaces         **"
            write-verbose "$appendSpaces         ** Adding [[$newArrayItem]] as an ADDED entry"
            write-verbose "$appendSpaces         **"

            $arraySpotCounter ++
            continue

        }



        $newArrayItemTypeCheck = (checkEntry -passedObject $newArrayItem)
        $initialArrayItemTypeCheck = (checkEntry -passedObject $initialArrayItemMatch)

        write-verbose "$appendSpaces     [newArray]: Entry Type: [[$newArrayItemTypeCheck]]"
        write-verbose "$appendSpaces     [initArray]: Entry Type: [[$initialArrayItemTypeCheck]]"

        if (  ($newArrayItemTypeCheck -eq "String") -and ($initialArrayItemTypeCheck -eq "String"  )) {

            if (  -not($initialArray.contains($newArrayItem))  ) {

                $returnOutObject += ";[-] $newArrayItem"
                write-verbose "$appendSpaces         **"
                write-verbose "$appendSpaces         ** Adding [[$newArrayItem]] as an ADDED entry"
                write-verbose "$appendSpaces         **"

                $arraySpotCounter ++
                continue

            }

        }



        if (  ($newArrayItemTypeCheck -eq "Array") -and ($initialArrayItemTypeCheck -eq "Array"  )) { 

            $returnOutObject = compare-nsArray `
                -initialArray $initialArrayItemMatch `
                -newArray $newArrayItem `
                -returnOutObject $returnOutObject `
                -recursiveCall $true `
                -appendSpaces "$appendSpaces    " `
                -targetArray "[RecursiveCall]"

        }

        write-verbose " "
        $arraySpotCounter ++

    }


    <#
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
    #>

    if (  $recursiveCall -eq $true  ) {

        return $returnOutObject

    } else {

        $finalReturnObject = @()
        $initialreturnOutObject = $returnOutObject -split ";"

        $initialreturnOutObject | ForEach-Object {
            if (  -not($_ -eq "")  ) {
                $finalReturnObject += $_
            }
        }

        return $finalReturnObject

    }

}





$initial = `
    @(
        "nlewan",
        @("arrayItem1","arrayItem2"), 
        @("secondArray1", "secondArray2", @("nestedArray1","nestedArray2"), @("nestedArray3","nestedArray4"))
     )


$new =  `
    @(
        "nlewan",
        @("arrayItem1","arrayItem2"), 
        @("secondArray1", "secondArray2", @("nestedArray3","nestedArray4"), @("nestedArray1","nestedArray3"))
    )

clear-host

$test = compare-nsArray -initialArray $initial -newArray $new -Verbose

$test