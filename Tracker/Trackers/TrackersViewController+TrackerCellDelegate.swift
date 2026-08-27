//
//  TrackersViewController+TrackerCellDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

extension TrackersViewController: TrackerCellDelegate {
    func didTapOnComplete(on cell: TrackerCell) {
        AnalyticsService.shared.report(event: "click", screen: "Main", item: "track")
        let currentDate = datePicker.date
        
        guard
            checkIfDateBeforeTomorrow(date: currentDate),
            let indexPath = collectionView.indexPath(for: cell),
            let tracker = viewModel.tracker(at: indexPath)
        else { return }
        
        viewModel.toggleCompletion(for: tracker, on: currentDate)
    }
    
    private func checkIfDateBeforeTomorrow(date: Date) -> Bool {
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else {
            return false
        }
        return date < tomorrow
    }
    
}
