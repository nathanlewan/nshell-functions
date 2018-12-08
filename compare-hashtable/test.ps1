#import-module PesterMatchHashtable

Describe 'HCCHashCompare' {
    Context 'modified-attributes' {

        it 'should return hashtable with ADDED, MODIFIED, and DELETED keys with blank hashtables for values' {
            $initialObject = $null
            $newObject = $null

            $test = $null
            $test = HCCHashCompare -initialObject $initialObject -newObject $newObject


            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED | should MatchHashTable @{}
            $test.MODIFIED | should MatchHashTable @{}
            $test.DELETED | should MatchHashTable @{}
        }

        it 'should return hashtable with ADDED equalled to USERNAME = ALICE' {
            $initialObject = $null
            $newObject = @{
                username = "Alice";
            }

            $test = $null
            $test = HCCHashCompare -initialObject $initialObject -newObject $newObject

            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED | should MatchHashTable @{ username = "Alice" }
            $test.MODIFIED | should MatchHashTable @{}
            $test.DELETED | should MatchHashTable @{}
        }

        it 'should return hashtable with MODIFIED equalled to USERNAME = JERRY' {
            $initialObject = @{
                username = "Alice";
            }
            $newObject = @{
                username = "Jerry";
            }

            $test = $null
            $test = HCCHashCompare -initialObject $initialObject -newObject $newObject

            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED | should MatchHashTable @{}
            $test.MODIFIED | should MatchHashTable @{ username = "Jerry" }
            $test.DELETED | should MatchHashTable @{}
        }

        it 'should return hashtable with REMOVED equalled to USERNAME = BOB' {
            $initialObject = @{
                username = "Bob";
            }
            $newObject = @{
            }

            $test = $null
            $test = HCCHashCompare -initialObject $initialObject -newObject $newObject

            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED | should MatchHashTable @{}
            $test.MODIFIED | should MatchHashTable @{}
            $test.DELETED | should MatchHashTable @{ username = "Bob" }
        }

    }

}