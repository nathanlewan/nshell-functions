function find-nsInArray
    {
        
        param (
            $searchArray,
            $searchItem
        )

        $searchText = ""

        $searchItem | foreach-object {
            $typeOfItem = get-nsType -passedObject $_

            if ($typeOfItem -eq "Array") {
                #$_ | ForEach-Object {
                #    $searchText += '($_ -eq "' + $_ + '") -and '
                #}
            } else {
                $searchText += '($_ -eq "' + $_ + '") -and '
            }
        }

        $searchText = $searchText.TrimEnd(" ","-","a","n","d"," ")
        write-verbose "$appendSpaces     [initArray]:built search string: $searchText"

        return $searchArray | Where-Object { (Invoke-Expression $searchText) }

    }