//
//  TrackersViewController+TrackerCellDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

extension TrackersViewController: TrackerCellDelegate {
    func didTapOnComplete(on cell: TrackerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let recordIndex = completedTracker.firstIndex { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
        
        if let recordIndex {
            completedTracker.remove(at: recordIndex)
        } else {
            let newRecord = TrackerRecord.init(id: tracker.id, date: currentDate)
            completedTracker.append(newRecord)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}
