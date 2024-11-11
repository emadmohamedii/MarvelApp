//
//  UITableViewCellWithShimmer.swift
//  CommonUI
//
//  Created by Emad Habib on 10/11/2024.
//
import UIKit

public extension UITableView {
    
    func insertRows<T>(newItems: [T], into dataArray: inout [T], section: Int = 0, animation: UITableView.RowAnimation = .fade) {
        let startIndex = dataArray.count
        dataArray.append(contentsOf: newItems)
        
        let indexPaths = (startIndex..<dataArray.count).map { IndexPath(row: $0, section: section) }
        
        self.beginUpdates()
        self.insertRows(at: indexPaths, with: animation)
        self.endUpdates()
    }
}
