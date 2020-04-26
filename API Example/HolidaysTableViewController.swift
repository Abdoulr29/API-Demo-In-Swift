//
//  HolidaysTableViewController.swift
//  API Example
//
//  Created by Dan Merfeld on 11/17/19.
//  Copyright © 2019 TheoryThree Interactive. All rights reserved.
//

import UIKit

class HolidaysTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var holidaysList = [Holiday](){
        didSet{
                DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "Result"
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(holidaysList.count)")
        return holidaysList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // configure cell
    
        let holiday = holidaysList[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso

        return cell
    }
}

extension HolidaysTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays{ [weak self] result in
            
        switch result {
         case .failure(let error):
            print(error)
         case .success(let holidays):
             self?.holidaysList = holidays
         }
       }
    }
}
