import Foundation
import UIKit

class ViewPostsController : UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tv: UITableView!
    var items = [NSDictionary]()
    
    override func viewDidLoad() {
        let api = RedditApi();
        tv.setContentOffset(CGPointMake(0, 150), animated: false)
        api.getPage("", option: RedditApiReturnOptions.PostTitlesAndMeta){(data) in
            let data = data as! [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.items = data
                self.tv!.reloadData()
            })
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let row = items[indexPath.row]
        
        cell.textLabel?.text = row["title"] as? String
        cell.detailTextLabel?.text = row["domain"] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var svc = segue.destinationViewController as! ViewPostController
        let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
        
        svc.detail = items[selectedIndex!.row]
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        presentViewController(ViewPostController(), animated: true){ () -> Void in
            
        }
    }
}