import Foundation


//read file
func read() -> Dictionary<String, String>
{
    var passDict = Dictionary<String, String>()
    do{
        let fileURL = try FileManager.default
            .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("passwords.json")
        let data = try Data(contentsOf: fileURL) //getting data from the JSON file using the file URL
        passDict = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, String>
    }
    catch
    {
        print(error)
        
    }
    return passDict
}

//write file
func write(dict: Dictionary<String, String>) -> Void
{
    do{
        let fileURL = try FileManager.default
            .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("passwords.json")
        
        try JSONSerialization.data(withJSONObject: dict).write(to: fileURL)
    }
    catch
    {
        print(error)
        
    }
}

func unwrapWithGaurd(input: String?) -> String
{
    guard let unwrappedString = input else {
        print("Sorry,that did not work")
        return "" //need this return or there will be an error
    }
    print("Success: \(unwrappedString)")
    return unwrappedString
}

class Ask
{
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String
    {
        print(output) //output is the questionText ask our question
        //handle response
        guard let response = readLine() else {
            //they didn't have a valid answer
            print("Invalid input")
            return
                AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
    
        //they typed in a valid answer
        //verify response is acceptable
        //OR we don't care what the response is
        if(inputArr.contains(response) || inputArr.isEmpty)
        {
            return response
        }
        else
        {
            print("Invalid input")
            return
                AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
    }
}


//encrypt password
func encryptPassword(password: String) -> String
{
    var encrypt = ""
    let shift = encrypt.count
    for letter in encrypt
    {
        encrypt += String(translateEncypt(l: letter, trans: shift))
        
    }
    return encrypt
}

//encrypt
func translateEncypt(l: Character, trans: Int) -> Character
{
    if let ascii = l.asciiValue
    {
        var outputInt = ascii
        if ascii >= 97 && ascii <= 122
        {
            // a = 97
            //97 - 97 = 0
            //0+27 = 27
            //27 % 26 = 1
            //1 + 97 = 98
            //98 = b
            outputInt = (((ascii-97)+UInt8(trans))%26)+97
        }
        else if (ascii >= 65 && ascii <= 90)
        {
            outputInt = (((ascii-65)+UInt8(trans))%26)+65
        }
        
        //65 -> 65 the Character value -> "A"
        return Character(UnicodeScalar(outputInt))
    }
    
    return Character("")
}

//decryt password
func decryptPassword(password: String) -> String
{
    var decrypt = ""
    let shift = decrypt.count
    for letter in decrypt
    {
        decrypt += String(translateEncypt(l: letter, trans: shift))
    }
    return decrypt
}

//decrypt function
func translateDecrypt(l: Character, trans: Int) -> Character
{
    if let ascii = l.asciiValue
    {
        var outputInt = ascii
        if ascii >= 97 && ascii <= 122
        {
            let place = ascii-UInt8(trans)
            if(place < 97)
            {
                outputInt = outputInt + 26
            }
            else if(place > 122)
            {
                outputInt = outputInt - 26
            }
            outputInt = (((ascii-97)+UInt8(trans))%26)+97
        }
        else if (ascii >= 65 && ascii <= 90)
        {
            let place = ascii-UInt8(trans)
            if(place < 65)
            {
                outputInt = outputInt + 26
            }
            else if (place > 90)
            {
                outputInt = outputInt - 26
            }
            outputInt = (((ascii-65)+UInt8(trans))%26)+65
        }
        
        //65 -> 65 the Character value -> "A"
        return Character(UnicodeScalar(outputInt))
    }
    print(l)
    return Character("")
}

//view all the passwords
func viewAll(dict: Dictionary<String,String>) -> Void
{
    for (key, _) in dict
    {
        print("All the keys in the dictionary: \n Key: ", key)
    }
}
// view one password
func viewSingle(key: String, dict: Dictionary<String,String>) -> Void
{
    var d = dict
    let view = Ask.AskQuestion(questionText: "What is the key to the password you want to see? ", acceptableReplies: [String]())
    let decrypt = decryptPassword(password: view)
    let reverse = reverseInput(stringToReverse: decrypt)
    d[key] = reverse
    print("Here is the password: \n", d)
    
}
//delete a password
func deletePassword(key: String, dict: Dictionary<String, String>) -> Dictionary<String, String>
{
    var d = dict
    //use the .removevalue
    if let deletepass = d.removeValue(forKey: key)
    {
        print("Deleted \(key) from the dictionary ")
        
    }
    else
    {
        print("Did not/could not delete password from dictionary")
    }
    return d
}


//add a password
func addPassword(key: String, dict: Dictionary<String, String>) -> Dictionary<String, String>
{
    var d = dict
    //need to get input of password and passphrase
    let newPass = Ask.AskQuestion(questionText:" What do password do you want to add? ", acceptableReplies: [String]()) //need the user input, so can't use updateValue
    let newPassphrase = Ask.AskQuestion(questionText: "What do you want for your passphrase?", acceptableReplies: [String]())
    //need to combine them
    let newPWPH = newPass + newPassphrase
    //need to reverse
    let reverse = reverseInput(stringToReverse: newPWPH)
    //need to encrypt
    let encrypt = encryptPassword(password: reverse)
    d[key] = encrypt
    print("Added new password")
    return d
}
//string.reversed()
func reverseInput(stringToReverse input: String) -> String
{
    return String(input.reversed()) // will reverse array of chracters back to string, ie [w, o, r, r, u, B]
}

func program()
{
    var passDict = read()
    var input = ""
    var keeprunning: Bool = true
    while (keeprunning == true)
    {
        input = Ask.AskQuestion(questionText: "Please type the letter of the action you want to do:" , acceptableReplies: ["a", "b","c","d", "e"])
        if(input == "a")
        {
            print(viewAll(dict: passDict))
            
        }
        else if(input == "b")
        {
            input = Ask.AskQuestion(questionText: "What is the key for the password you want to see?", acceptableReplies: [String]())
            print(viewSingle(key: input, dict: passDict))
        }
        else if(input == "c")
        {
            input = Ask.AskQuestion(questionText: "What is the key for the password you want to delete?", acceptableReplies: [String]())
            print(deletePassword(key: input, dict: passDict))
        }
        else if(input == "d")
        {
            input = Ask.AskQuestion(questionText: "What is the password you want to add?", acceptableReplies: [String]())
            passDict = addPassword(key: input, dict: passDict)
        }
        else if(input == "f")
        {
            print("Thank you")
            keeprunning = false
            write(dict: passDict)
            break
        }
    
        
    }
}
program()





