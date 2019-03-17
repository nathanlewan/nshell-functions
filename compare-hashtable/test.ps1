clear

Describe 'compare-hashtable' {
    Context 'test function: checkObject' {

        it 'should return Hashtable' {
            $Object = @{
                username = "nathanl"
            }
              

            $test = compare-nsObject -object $Object

            $test | should be "Hashtable"
            $test.length | should be 9

        }

        it 'should return Array' {
            $Object = @(
                "nathanl"
            )
              

            $test = compare-nsObject -object $Object

            $test | should be "Array"
            $test.length | should be 5

        }

        it 'should return String' {
            $Object = "nathanl"
              

            $test = compare-nsObject -object $Object

            $test | should be "String"
            $test.length | should be 6

        }
    }
}