
import Foundation
import UIKit

class ViewPostController : UIViewController {
    
    var detail: NSDictionary!
    
    @IBOutlet weak var label: UILabel?
    
    override func viewDidLoad() {
        label?.text = detail["title"] as? String
    }
}