//
//  UITableView+Pagination.swift
//  CommonUI
//
//  Created by Emad Habib on 08/11/2024.
//
import UIKit

public extension UITableView {
    
    // Check if the index path corresponds to one of the last three rows in the last section
    func isLastThreeItemsInLastSection(by indexPath: IndexPath) -> Bool {
        guard let lastRows = getLastThreeRows() else { return false }
        return lastRows.contains(indexPath.row)
    }
    
    // Get the last three rows of the last section
    func getLastThreeRows() -> [Int]? {
        let lastSection = numberOfSections - 1
        
        // Ensure there is at least one section
        guard lastSection >= 0 else { return nil }
        
        // Get the number of rows in the last section
        let totalRowsInLastSection = numberOfRows(inSection: lastSection)
        
        // Ensure there are rows to return
        guard totalRowsInLastSection > 0 else { return nil }
        
        // Calculate the last three rows
        let lastRows = max(0, totalRowsInLastSection - 3)..<totalRowsInLastSection
        
        return Array(lastRows)
    }
}

public extension UITableView {
    func showLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.tintColor = .white
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
    
    func hideLoadingFooter() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
}
