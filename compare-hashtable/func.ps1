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
            $rootItemType = "notChecked"
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
                    $rootItemType = $valA.GetType().name.tostring()
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
                    switch ($rootItemType) {
                        "hashtable" {
                            $returnObject.MODIFIED.add( $rootItemKey, $rootItemValue )
                            checkItems -hashA $newObject.$rootItemKey -hashB $initialObject.$rootItemKey -checkType "additions"
                            checkItems -hashA $initialObject.$rootItemKey -hashB $newObject.$rootItemKey -checkType "removals"
                        }
                        default {
                            $returnObject.MODIFIED.add( $rootItemKey, $rootItemValue )
                        }
                    }
                    
                }
                
            }

        }
    }

    checkItems -hashA $newObject -hashB $initialObject -checkType "additions"
    checkItems -hashA $initialObject -hashB $newObject -checkType "removals"


    return $returnObject
}





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

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject