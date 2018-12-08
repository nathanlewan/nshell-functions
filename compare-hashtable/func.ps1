function compare-hashtable {

    param (
        $initialObject,
        $newObject
    )



    # handle if null or empty strings are sent
    if ( ($null -eq $initialObject) -or ("" -eq $initialObject) ) {
        $initialObject = @{}
    }
    if ( ($null -eq $newObject) -or ("" -eq $newObject) ) {
        $newObject = @{}
    }



    # create return object
    $returnObject = @{}
    $returnObject.add("ADDED",@{})
    $returnObject.add("MODIFIED",@{})
    $returnObject.add("REMOVED",@{})



    function checkItems {
        param ( $hashA, $hashB, $checkType )

        # loop through items in hashA
        foreach ( $rootItem in $hashA.GetEnumerator() ) {

            # key value pair we are looking at
            $rootItemKey = $rootItem.key
            $rootItemValue = $rootItem.value

            #initialize status checks
            $rootItemStatus = "notChecked"
            $itemOutADDEDStatus = "empty"
            $itemOutMODIFIEDStatus = "empty"
            $itemOutREMOVEDStatus = "empty"

            # find out if $hashB contains this item
            if ( $hashB.get_item($rootItemKey) ) {
                
                # if $hashB contains this item, is it modifed?
                $valA = $hashA.get_item($rootItemKey)
                $valB = $hashB.get_item($rootItemKey)

                if ( $valA -eq $valB ) {
                    $rootItemStatus = "dataMatches"
                } else {
                    $rootItemStatus = "dataMismatch"
                }

            } else {
                
                $rootItemStatus = "uniqueItem"
            }


            if ( ($rootItemStatus -eq "uniqueItem") -and ($checkType -eq "additions") ) {
                $returnObject.ADDED.add( $rootItemKey, $rootItemValue )
            }

            if ( ($rootItemStatus -eq "uniqueItem") -and ($checkType -eq "removals") ) {
                $returnObject.REMOVED.add( $rootItemKey, $rootItemValue )
            }

            if ( $rootItemStatus -eq "dataMismatch" ) {
                if ( ! $returnObject.MODIFIED.contains($rootItemKey) ) {
                    $returnObject.MODIFIED.add( $rootItemKey, $rootItemValue )
                }
                
            }

        }
    }



    checkItems -hashA $newObject -hashB $initialObject -checkType "additions"
    checkItems -hashA $initialObject -hashB $newObject -checkType "removals"


    return $returnObject
}