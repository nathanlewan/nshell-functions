Describe 'compare-hashtable' {
    Context 'simple-text output' {

        it 'should return simple string with lastName removed' {
            $initialObject = @{
                username = "nlewan"
                lastName = "lewan"
            }
    
            $newObject = @{
                username = "nlewan"
            }

            compare-hashtable -objA $initialObject -objB $newObject -objType "Hashtable"
            $test = compare-hashtable -objA $initialObject -objB $newObject -objType "Hashtable"

            $test.GetType() | should be "String"
            $test | should be "[-]: (key):lastName (value):lewan"
        }

        it 'should return simple string with lastName and firstName removed' {
            $initialObject = @{
                username = "nlewan"
                lastName = "lewan"
                firstName = "nathan"
            }
    
            $newObject = @{
                username = "nlewan"
            }

            $test = compare-hashtable -objA $initialObject -objB $newObject -objType "Hashtable"

            $test.gettype().BaseType.Name | should be "Array"
            $test.length | should be 2
            $test.contains("[-]: (key):firstName (value):nathan") | should be $true
            $test.contains("[-]: (key):lastName (value):lewan") | should be $true
        }

        it 'should return simple string with lastName and firstName removed, username modified' {
            $initialObject = @{
                username = "nathanl"
                lastName = "lewan"
                firstName = "nathan"
            }
    
            $newObject = @{
                username = "nlewan"
            }

            $test = compare-hashtable -objA $initialObject -objB $newObject -objType "Hashtable"

            $test.gettype().BaseType.Name | should be "Array"
            $test.length | should be 3
            $test.contains("[*]: (key):username   (old_value):nathanl -> (new_value):nlewan") | should be $true
            $test.contains("[-]: (key):firstName (value):nathan") | should be $true
            $test.contains("[-]: (key):lastName (value):lewan") | should be $true
        }

        it 'should return simple string with lastName and firstName removed, username modified' {
            $initialObject = @{
                username = "nathanl"
                address = @{
                    street = "crusade road"
                    number = "515"
                    people = @("me", "you", "us")
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

            clear
            compare-hashtable -objA $initialObject -objB $newObject -objType "Hashtable"

            $test.gettype().BaseType.Name | should be "Array"
            $test.length | should be 3
            $test.contains("[*]: (key):username   (old_value):nathanl -> (new_value):nlewan") | should be $true
            $test.contains("[-]: (key):firstName (value):nathan") | should be $true
            $test.contains("[-]: (key):lastName (value):lewan") | should be $true
        }
    }
}