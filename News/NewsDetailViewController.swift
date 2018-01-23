//
//  NewsDetailViewController.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//

import UIKit

let detailContentURL = "https://api.tinkoff.ru/v1/news_content?id=%@";

class NewsDetailViewController: UIViewController {
    
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webView: UIWebView!
    
    var payloadID : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getJsonFromUrl();
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let urlString = String(format: detailContentURL, payloadID)
        
        let url = NSURL(string: urlString)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                var content : String = ""
                
                //printing the json in console
                print(jsonObj!.value(forKey: "payload")!)
                
                //getting dictionary from json and converting it to NSDictionary
                if let payload = jsonObj!.value(forKey: "payload") as? NSDictionary {

                    content = (payload.value(forKey: "content") as? String)!
                }
                
                //sort array
                
                //newsArray = newsArray.sorted{(($0["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String) < (($1["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String)}
                
                //reload data
                DispatchQueue.main.async {
                    //self.textView.attributedText = content
                    //self.textView.text = content
                    self.webView.loadHTMLString(content, baseURL:nil)

                }
            }
        }).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
