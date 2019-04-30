function get-nsType 
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