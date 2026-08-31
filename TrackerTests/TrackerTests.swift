//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerTest: XCTestCase {
    
    func testViewControllerLight() {
        // given
        let viewModelStub = TrackersViewModelStub()
        let sut = TrackersViewController(viewModel: viewModelStub)
        let lightModeTraits = UITraitCollection(userInterfaceStyle: .light)
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro, traits: lightModeTraits))
    }
    
    func testViewControllerDark() {
        // given
        let viewModelStub = TrackersViewModelStub()
        let sut = TrackersViewController(viewModel: viewModelStub)
        let darkModeTraits = UITraitCollection(userInterfaceStyle: .dark)
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro, traits: darkModeTraits))
    }
}
