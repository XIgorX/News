//
//  ViewController.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//

import UIKit

//the json file url
let newsURL = "https://api.tinkoff.ru/v1/news";

//A string array to save all the names
var newsArray = [NSDictionary]()

var refreshControl: UIRefreshControl!

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refresh Control
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl?.addTarget(self, action: #selector(self.refreshAction), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        //calling the function that will fetch the json
        getJsonFromUrl();
    }
    
    @objc func refreshAction(refreshControl: UIRefreshControl)
    {
        // Code to refresh table view
        //getJsonFromUrl();
        
        newsArray.remove(at: 0)
        self.tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: newsURL)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "payload")!)
                
                //getting array from json and converting it to NSArray
                if let news = jsonObj!.value(forKey: "payload") as? NSArray {
                    //looping through all the elements
                    for item in news{
                        
                        //converting the element to a dictionary
                        if let itemDict = item as? NSDictionary {
                            
                            //getting the text from the dictionary
                            //if let title = itemDict.value(forKey: "text") {
                                
                                //adding the item to the array
                            newsArray.append(itemDict)
                            //}
                            
                        }
                    }
                }
                
                //sort array
                
                //newsArray = newsArray.sorted{(($0["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String) < (($1["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String)}
                
                for i in 0..<newsArray.count-1
                {
                    let pass = (newsArray.count - 1) - i
                    
                    for j in 0..<pass
                    {
                        let key = ((newsArray[j]["publicationDate"]! as? NSDictionary)?.value(forKey: "milliseconds") as! UInt)
                        
                        if key < ((newsArray[j+1]["publicationDate"]! as? NSDictionary)?.value(forKey: "milliseconds") as! UInt)
                        {
                            (newsArray[j], newsArray[j+1]) = (newsArray[j+1], newsArray[j])
                        }
                    }
                }
                
                //reload data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:  UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let workout = self.workouts[indexPath.row] as? Workout
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NewsTableViewCell!
        //cell!.textCell?.text = workout?.title
        //cell!.backgroundColor = workout?.color
        //cell!.countLabel.text = "\(indexPath.row+1)"
        //cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        cell?.labelTitle.text = newsArray[indexPath.row].value(forKey: "text") as? String;
       
        
        return cell!
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        //let row = indexPath.row
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController
        vc?.payloadID =  (newsArray[indexPath.row].value(forKey: "id") as? String)!;
        self.navigationController?.pushViewController(vc!, animated: true)
        
        // https://api.tinkoff.ru/v1/news_content?id={ payload[i].id}.
        
    }
}

