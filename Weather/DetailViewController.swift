//
//  DetailViewController.swift
//  Weather
//
//  Created by Michael Baldwin on 8/2/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var hours: [Hour] = []

}

// MARK: - View lifecycle

extension DetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Table view data source
extension DetailViewController {
    
    private enum CellIdentifiers {
        static let hourCell = "hourCell"
    }
    
    private enum TableSections {
        static let count = 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.hourCell, for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let hour = hours[indexPath.row]
        cell.textLabel?.text = hour.summary
    }

}

// MARK: - Navigation
extension DetailViewController {

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
