//
//  PageControlCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class PageControlCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.pageIndicatorTintColor = UIColor.AppColors.DTGraphVerticalLine
        pc.currentPageIndicatorTintColor = UIColor.AppColors.teal5
        pc.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        return pc
    }()
    
    // MARK: - Properties
    private var pageChangedAction: ((Int) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pageControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(numberOfPages: Int, currentPage: Int, onPageChanged: @escaping (Int) -> Void) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        self.pageChangedAction = onPageChanged
    }
    
    func updateCurrentPage(_ page: Int) {
        pageControl.currentPage = page
    }
    
    // MARK: - Actions
    @objc private func pageChanged() {
        pageChangedAction?(pageControl.currentPage)
    }
}
