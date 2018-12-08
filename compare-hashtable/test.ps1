Describe 'compare-hashtable' {
    Context 'simple attributes' {

        it 'should return hashtable with 3 main keys having blank hashtables for values' {
            $initialObject = $null
            $newObject = $null

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject


            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 0
        }

        it 'should return hashtable with 3 main keys having blank hashtables for values' {
            $initialObject = ""
            $newObject = ""

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject


            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 0
        }

        it 'should return hashtable with 3 main keys having blank hashtables for values' {
            $initialObject = @{}
            $newObject = @{}

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject


            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 0
        }

        it 'should return hashtable with ADDED equalled to USERNAME = ALICE' {
            $initialObject = $null
            $newObject = @{
                username = "Alice";
            }

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED.count | should be 1
            $test.ADDED.get_item("username") | should be "Alice"
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 0
        }

        it 'should return hashtable with REMOVED equalled to USERNAME = ALICE' {
            $initialObject = @{
                username = "Alice";
            }
            $newObject = $null

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.GetType().name | should be "Hashtable"
            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.REMOVED.get_item("username") | should be "Alice"
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 1
        }


        it 'should return hashtable with MODIFIED equalled to USERNAME = JERRY' {
            $initialObject = @{
                username = "Alice";
            }
            $newObject = @{
                username = "Jerry";
            }

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.get_item("username") | should be "Jerry"
            $test.MODIFIED.count | should be 1
            $test.REMOVED.count | should be 0
        }

        it 'should return hashtable with REMOVED equalled to USERNAME = BOB' {
            $initialObject = @{
                username = "Bob";
            }
            $newObject = @{
            }

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 0
            $test.REMOVED.count | should be 1
            $test.REMOVED.get_item("username") | should be "Bob"
        }

        it 'should return hashtable with simple added, modifed, and removed entries' {
            $initialObject = @{
                username = "bobErator";
                firstname = "bob";
                lastname = "erator";
            }
            $newObject = @{
                username = "bobErator";
                firstname = "robert";
                middlename = "robot";
            }

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.count | should be 3
            $test.ADDED.count | should be 1
            $test.MODIFIED.count | should be 1
            $test.REMOVED.count | should be 1
            $test.ADDED.get_item("middlename") | should be "robot"
            $test.MODIFIED.get_item("firstname") | should be "robert"
            $test.REMOVED.get_item("lastname") | should be "erator"
        }

        it 'should return hashtable with 2 modified entries' {
            $initialObject = @{
                username = "bobErator";
                firstname = "bob";
                lastname = "erator";
            }
            $newObject = @{
                username = "bobErator";
                firstname = "change";
                lastname = "change";
            }

            $test = $null
            $test = compare-hashtable -initialObject $initialObject -newObject $newObject

            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 2
            $test.REMOVED.count | should be 0
            $test.MODIFIED.get_item("firstname") | should be "change"
            $test.MODIFIED.get_item("lastname") | should be "change"
        }

    }

    context 'multivalue attributes: hashtable' {

        it 'should return hashtable with user1 - firstname modified' {
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

            $test.count | should be 3
            $test.ADDED.count | should be 0
            $test.MODIFIED.count | should be 1
            $test.REMOVED.count | should be 0
            $test.MODIFIED.get_item("user1").firstname | should be "sofie"
            $test.MODIFIED.get_item("user1").firstname.count | should be 1
        }

    }

}