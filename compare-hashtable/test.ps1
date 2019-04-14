clear

Describe 'compare-nsobject' {
    Context 'test function: checkEntry - Hashtable detection' {

        it 'should return @(Hashtable, <empty>)' {
            $Object = @{
                username = "nathanl"
            }
              

            $test = compare-nsObject -objA $Object -runCheckEntry $true

            $test | should be @("OBJA: Hashtable", "OBJB: ")
            $test.Length | should be 2

        }

        it 'should return @(<empty>, Hashtable)' {
            $Object = @{
                username = "nathanl"
            }
              

            $test = compare-nsObject -objb $Object -runCheckEntry $true

            $test | should be @("OBJA: ", "OBJB: Hashtable")
            $test.Length | should be 2

        }

        it 'should return @(Hashtable, Hashtable)' {
            $ObjectA = @{
                username = "nathanl"
            }
            $ObjectB = @{
                username = "nathanl"
            }
              

            $test = compare-nsObject -objb $ObjectA -objA $ObjectB -runCheckEntry $true

            $test | should be @("OBJA: Hashtable", "OBJB: Hashtable")
            $test.Length | should be 2

        }

    }




    Context 'test function: checkEntry - Array detection' {

        it 'should return @(Array, <empty>)' {
            $Object = @("nathanl")
              

            $test = compare-nsObject -objA $Object -runCheckEntry $true

            $test | should be @("OBJA: Array", "OBJB: ")
            $test.Length | should be 2

        }

        it 'should return @(<empty>, Array)' {
            $Object = @("nathanl")
              

            $test = compare-nsObject -objb $Object -runCheckEntry $true

            $test | should be @("OBJA: ", "OBJB: Array")
            $test.Length | should be 2

        }

        it 'should return @(Array, Array)' {
            $ObjectA = @("nathanl")
            $ObjectB = @("nathanl")
              

            $test = compare-nsObject -objb $ObjectA -objA $ObjectB -runCheckEntry $true

            $test | should be @("OBJA: Array", "OBJB: Array")
            $test.Length | should be 2

        }

    }





    Context 'test function: checkEntry - String detection' {

        it 'should return @(String, <empty>)' {
            $Object = "nathanl"
              

            $test = compare-nsObject -objA $Object -runCheckEntry $true

            $test | should be @("OBJA: String", "OBJB: ")
            $test.Length | should be 2

        }

        it 'should return @(<empty>, String)' {
            $Object = "nathanl"
              

            $test = compare-nsObject -objb $Object -runCheckEntry $true

            $test | should be @("OBJA: ", "OBJB: String")
            $test.Length | should be 2

        }

        it 'should return @(String, String)' {
            $ObjectA = "nathanl"
            $ObjectB = "nathanl"
              

            $test = compare-nsObject -objb $ObjectA -objA $ObjectB -runCheckEntry $true

            $test | should be @("OBJA: String", "OBJB: String")
            $test.Length | should be 2

        }

    }
}