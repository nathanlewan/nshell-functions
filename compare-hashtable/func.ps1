function HCChashCompare {

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


    # internal functions
    
    function defineInitialVars {

        # preliminary status definitions
        $rootItemStatus = "notChecked"
        $itemOutADDEDStatus = "empty"
        $itemOutMODIFIEDStatus = "empty"
        $itemOutREMOVEDStatus = "empty"

    }







    # create return object
    $returnObject = @{}
    $returnObject.add("ADDED",@{})
    $returnObject.add("MODIFIED",@{})
    $returnObject.add("REMOVED",@{})




    # loop through items in newObject
    foreach ( $rootItem in $newObject.GetEnumerator() ) {

        # key value pair we are looking at
        $rootItemKey = $rootItem.key
        $rootItemValue = $rootItem.value

        defineInitialVars

        # find out if $initialObject contains this item
            if ( $initialObject.get_item($rootItemKey) ) {
                
                # if $initialObject contains this item, is it modifed?
                $initVal = $initialObject.get_item($rootItemKey)
                $newVal = $newObject.get_item($rootItemKey)

                if ( $initVal -eq $newVal ) {
                    $rootItemStatus = "dataMatches"
                } else {
                    $rootItemStatus = "dataMismatch"
                }

            } else {
                
                $rootItemStatus = "newItem"
            }

        # find out if we already have data in our $returnObject
            if ( $returnObject.ADDED.count -ne 0 ) {
                $itemOutADDEDStatus = "notEmpty"
            }
            if ( $returnObject.MODIFIED.count -ne 0 ) {
                $itemOutMODIFIEDStatus = "notEmpty"
            }
            if ( $returnObject.DELETED.count -ne 0 ) {
                $itemOutDeletedStatus = "notEmpty"
            }


        if ( $rootItemStatus -eq "newItem" ) {
            $returnObject.ADDED.add( $rootItemKey, $rootItemValue )
        }

        if ( $rootItemStatus -eq "dataMismatch" ) {
            $returnObject.MODIFIED.add( $rootItemKey, $rootItemValue )
        }

    }

    # loop through items in initialObject
    #foreach ( $rootItem in $initialObject.GetEnumerator() ) {

    #    defineInitialVars

    #}



    return $returnObject
}








$initialObject = @{
                username = "Bob";
            }
            $newObject = @{
            username = "Mary";
            }

$test = $null
$test = HCCHashCompare -initialObject $initialObject -newObject $newObject