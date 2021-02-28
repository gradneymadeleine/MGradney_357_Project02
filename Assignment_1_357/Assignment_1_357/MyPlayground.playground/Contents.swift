import Foundation

var dict: [String:String] =
    [
        "Twitter":"iDkWha7mYPa33!s",
        "Facebook" : "WJS13FLI3$29",
        "Instagram" : "SwiftUI14ED!"
    ]
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

class Pass
{
    static func AskPass(passwordQuestion output: String, passwordReplies input: [String], caseSensitive: Bool = false)-> String
    {
        print(output)
        guard let response = readLine() else
        {
            print("Invalid input")
            return AskPass(passwordQuestion: output, passwordReplies: input)
            
        }
        if(input.contains(response))
        {
            return response
        }
        else
        {
            print("Invalid input")
            return AskPass(passwordQuestion: output, passwordReplies: input)
        }
    }
}
