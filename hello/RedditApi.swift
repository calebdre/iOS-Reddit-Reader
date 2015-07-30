import Foundation

class RedditApi {
    private let baseUri = "http://reddit.com";
    
    func getFrontPage(){
        getPage("", option: RedditApiReturnOptions.PostTitles){(titleList) in
            let titles = titleList as! [String]
            for title: String in titles{
                println(title)
            }
        }
    }
    
    func getPage(page:String, option: RedditApiReturnOptions, callback: ([AnyObject]) -> Void){
        let url = generateUri(page);
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) in
            
            switch(option){
                case .PostList:
                    callback(self.getPosts(data))
                
                case .PostTitles:
                    callback(self.getPostTitles(data))
            }
        };
        
        task.resume();
    }
    
    private func generateUri(page: String) -> NSURL {
        var urlString = ""
        urlString += baseUri
        urlString += page
        urlString += "/.json"
        
        return NSURL(string: urlString)!
    }
    
    private func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        

        if let json = NSJSONSerialization.JSONObjectWithData(inputData, options: nil, error: &error) as? NSDictionary {
            println("json parsed");
            return json
        }else if let unwrappedError = error {
            println("jsonError: \(unwrappedError)")
        }
        
        return NSDictionary()
    }
    
    private func getPosts(data: NSData) -> [AnyObject]{
        let data = self.parseJSON(data)
        let results = data["data"] as! NSDictionary
        let posts = results["children"] as! [AnyObject]
    
        return posts;
    }
    
    private func getPostTitles(data: NSData) -> [String]{
        let posts = getPosts(data) as! [NSDictionary]
        
        var titles = [String]()
        
        for allPostData: NSDictionary in posts {
            let postData = allPostData["data"] as! NSDictionary
            let title = postData["title"] as! String
            
            titles.append(title);
        }
        
        return titles;
    }
}

enum RedditApiReturnOptions{
    case PostList
    case PostTitles
}