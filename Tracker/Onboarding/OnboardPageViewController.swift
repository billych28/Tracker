//
//  OnboardPageViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 19.08.2026.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    private var pages: [UIViewController] = []
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .YPColors.gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let actionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        let title = NSLocalizedString("onboarding_button_title", comment: "Text displayed on next button")
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(transitionStyle: .scroll,navigationOrientation: .horizontal, options: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        dataSource = self
        delegate = self
        
        setupPages()
        setupUI()
        setupButton()
    }
    
    private func setupPages() {
        let firstPageTitle = NSLocalizedString("onboarding_first_page_title", comment: "Title on first page of onboarding")
        let secondPageTitle = NSLocalizedString("onboarding_second_page_title", comment: "Title on second page of onboarding")
        
        let firstPage = OnboardingChildViewController(
            image: UIImage(resource: .onboarding1),
            title: firstPageTitle,
        )
        let secondPage = OnboardingChildViewController(
            image: UIImage(resource: .onboarding2),
            title: secondPageTitle,
        )
        
        pages = [firstPage, secondPage]
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    private func setupUI() {
        view.addSubview(actionButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            actionButton.heightAnchor.constraint(equalToConstant: 54),
            
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            didTapActionButton()
        }
        
        actionButton.addAction(action, for: .touchUpInside)
    }
    
    private func didTapActionButton() {
        guard
            let currentVC = viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentVC)
        else {
            return
        }
        
        let nextIndex = currentIndex + 1
        
        if nextIndex >= pages.count {
            navigateToMainScreen()
            return
        }
        
        let nextVC = pages[nextIndex]
        
        view.isUserInteractionEnabled = false
        setViewControllers([nextVC], direction: .forward, animated: true) { [weak self] completed in
            guard let self else { return }
            
            view.isUserInteractionEnabled = true
            
            if completed,
               let visibleVC = viewControllers?.first,
               let finalIndex = pages.firstIndex(of: visibleVC) {
                pageControl.currentPage = finalIndex
            }
        }
    }
    
    private func navigateToMainScreen() {
        guard let windowScene = view.window?.windowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let mainAppVC = MainTabBarController()
        let navigationController = UINavigationController(rootViewController: mainAppVC)
        
        window.rootViewController = navigationController
    }
}

// MARK: - UIPageViewControllerDataSource + UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = pages.firstIndex(of: viewController),
            index > 0
        else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = pages.firstIndex(of: viewController),
            index < pages.count - 1
        else {
            return nil
        }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

