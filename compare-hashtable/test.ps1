Describe 'compare-hashtable' {
    Context 'simple-text output' {

        it 'should return simple-text output' {
            $initialObject = @{
                username = "nathanl"
                address = @{
                    street = "crusade road"
                    number = "515"
                    people = @("me", "you", "us")
                    things = @{
                      thisThing = "this"
                      thatThing = "that"
                  }
                }
              }
              
              $newObject = @{
                username = "nlewan"
                address = @{
                    street = "crusade ave"
                    number = "55"
                    people = @("me", "you", "him")
                }
              }

            $test = compare-hashtable -objA $initialObject -objB $newObject

            $test.gettype().BaseType.Name | should be "Array"
            $test.length | should be 6
            $test.contains("[-] , (key):address -> (arr):people , (value):us") | should be $true
            $test.contains("[+] , (key):address -> (arr):people , (value):him") | should be $true
            $test.contains("[-] , (key):address , (key):things") | should be $true
            $test.contains("[*] , (key):address -> (key):number , (old_value):515  | (new_value):55") | should be $true
            $test.contains("[*] , (key):address -> (key):street , (old_value):crusade road  | (new_value):crusade ave") | should be $true
            $test.contains("[*] , (key):username , (old_value):nathanl | (new_value):nlewan") | should be $true

        }
    }
}