//
//  ViewController.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//

import UIKit
import CoreData

//the json file url
let newsURL = "https://api.tinkoff.ru/v1/news";

//A string array to save all the names
var newsArray = [News]()

var refreshControl: UIRefreshControl!

// get reference to the persistent container
var persistentContainer : NSPersistentContainer? = nil

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{    
    @IBOutlet weak var tableView: UITableView!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
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
        getJsonFromUrl();
        
        //newsArray.remove(at: 0)
        //self.tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: newsURL)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if (data != nil)
            {
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //printing the json in console
                    print(jsonObj!.value(forKey: "payload")!)
                    
                    //getting array from json and converting it to NSArray
                    if let news = jsonObj!.value(forKey: "payload") as? NSArray {
                        
                        newsArray = [News]()
                        
                        //looping through all the elements
                        for item in news{
                            
                            //converting the element to a dictionary
                            if let itemDict = item as? NSDictionary {
                                
                                //getting the text from the dictionary
                                //if let title = itemDict.value(forKey: "text") {
                                
                                //save to core data
                                
                                //first, delete old
                                
                                // create the delete request for the specified entity
                                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
                                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                                
                                //perform the delete
                                do {
                                    try persistentContainer?.viewContext.execute(deleteRequest)
                                } catch let error as NSError {
                                    print(error)
                                }
                                
                                //}
                                
                                //save
                                
                                //let predicate = NSPredicate(format: "newsID == %@", (itemDict.value(forKey: "id") as? String)!)
                                //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
                                //fetchRequest.predicate = predicate
                                
                                //let newsByID = try self.managedContext.fetch(fetchRequest) as! [News]
                                
                                //if  (newsByID.count == 0)
                                //{
                                    let news = NSEntityDescription.insertNewObject(forEntityName: "News",
                                                                                   into: self.managedContext) as! News
                                    
                                    news.newsID = itemDict.value(forKey: "id") as? String
                                    news.publicationDate = (itemDict.value(forKey: "publicationDate") as? NSDictionary)?.value(forKey: "milliseconds") as! Int64
                                    news.text = itemDict.value(forKey: "text") as? String
                                    
                                    //adding the item to the array
                                    newsArray.append(news)
                                //}
                                //else
                                //{
                                //   news = newsByID[0]
                                    //adding the item to the array
                                    //newsArray.append(news)
                               //}
                            }
                        }
                    }
                    
                    //
                    
                    do {
                        try self.managedContext.save()
                    } catch {
                        print("Failed saving")
                    }
                    
                    }
                }
                    
                else
                {
                    //load from CoreData
                    
                    // Initialize Fetch Request
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                    
                    // Create Entity Description
                    let entityDescription = NSEntityDescription.entity(forEntityName: "News", in: self.managedContext)
                    
                    // Configure Fetch Request
                    fetchRequest.entity = entityDescription
                    
                    do {
                        newsArray = try self.managedContext.fetch(fetchRequest) as! [News]
                        print(newsArray)
                        print(newsArray.count)
                        
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                    
                }
            
                
                    //sort array
                
                    //newsArray = newsArray.sorted{(($0["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String) < (($1["publicationDate"]! as! NSDictionary)["milliseconds"]! as! String)}
            
                    if (newsArray.count>0)
                    {
            
                        for i in 0..<newsArray.count-1
                        {
                            let pass = (newsArray.count - 1) - i
                    
                            for j in 0..<pass
                            {
                                let key = newsArray[j].publicationDate
                        
                                if key < newsArray[j+1].publicationDate
                                {
                                    (newsArray[j], newsArray[j+1]) = (newsArray[j+1], newsArray[j])
                                }
                            }
                        }
                    }
                
                    //reload data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        vc?.payloadID =  (newsArray[indexPath.row].newsID as? String)!;
        self.navigationController?.pushViewController(vc!, animated: true)
        
        // https://api.tinkoff.ru/v1/news_content?id={ payload[i].id}.
        
    }
}

