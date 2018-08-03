//
//  DetailViewController.swift
//  Weather
//
//  Created by Michael Baldwin on 8/2/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var next12Hours: [Hour] = []

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
        return next12Hours.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.hourCell, for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let hour = next12Hours[indexPath.row]
        cell.textLabel?.text = hour.summary
    }

}
