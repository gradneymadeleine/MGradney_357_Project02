import Foundation

class json
{
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

}
