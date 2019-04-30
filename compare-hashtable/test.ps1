
Describe 'compare-nsArray' {
    Context 'string detection' {

        it 'should return no changes' {
            $Object1 = @("nathanl")
            $Object2 = @("nathanl")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test | should be $null
            $test.Length | should be 0
        }

        it 'should return @("[+] nathan")' {
            $Object1 = @("nathanl")
            $Object2 = @("nathan")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().Name | should be "String"
            $test | should be "[+] nathan"
            $test.Length | should be 10
        }

        it 'should return @("[+] nathan", "[+] lewan")' {
            $Object1 = @("nathanl")
            $Object2 = @("nathan", "lewan")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().BaseType.Name | should be "Array"
            $test | should be @("[+] nathan", "[+] lewan")
            $test.Length | should be 2
        }

        it 'should return @("[+] nathan", "[+] lewan", "[+] christopher)' {
            $Object1 = @("nathanl")
            $Object2 = @("nathan", "lewan", "christopher")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().BaseType.Name | should be "Array"
            $test | should be @("[+] nathan", "[+] lewan", "[+] christopher")
            $test.Length | should be 3
        }

        it 'should return @("[+] lewan", "[+] christopher)' {
            $Object1 = @("nathan")
            $Object2 = @("nathan", "lewan", "christopher")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().BaseType.Name | should be "Array"
            $test | should be @("[+] lewan", "[+] christopher")
            $test.Length | should be 2
        }

        it 'should return @("[+] lewan", "[+] christopher)' {
            $Object1 = @("nathan")
            $Object2 = @("lewan", "nathan", "christopher")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().BaseType.Name | should be "Array"
            $test | should be @("[+] lewan", "[+] christopher")
            $test.Length | should be 2
        }

        it 'should return @("[+] lewan", "[+] christopher)' {
            $Object1 = @("nathan")
            $Object2 = @("lewan", "christopher", "nathan")

            $test = compare-nsArray -initialArray $Object1 -newArray $Object2
            $test.GetType().BaseType.Name | should be "Array"
            $test | should be @("[+] lewan", "[+] christopher")
            $test.Length | should be 2
        }
    }
}