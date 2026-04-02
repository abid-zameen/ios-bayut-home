//
//  ProjectsViewCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

//protocol ProjectsCollectionViewCellDisplayLogic: AnyObject {
//    func displayProject(viewModel: ProjectsCollectionViewCellModels.ViewModel)
//}
//
//protocol ProjectsCollectionViewCellDelegate: AnyObject {
//    func didTapWhatsapp(for project: ProjectsCollectionViewCellModels.ViewModel)
//}

final class ProjectsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var launchPriceTitle: UILabel?
    @IBOutlet private weak var handOverTitle: UILabel?
    @IBOutlet private weak var dividerView: UIView?
    @IBOutlet private weak var handOverPriceView: UIView?
    @IBOutlet private weak var launchPriceView: UIView?
    @IBOutlet private weak var whatsappButton: PrimaryDarkButton?
    @IBOutlet private weak var handOverValue: UILabel?
    @IBOutlet private weak var bottomView: UIView?
    @IBOutlet private weak var projectLocation: UILabel?
    @IBOutlet private weak var startingPrice: UILabel?
    @IBOutlet private weak var locationProjectIcon: UIImageView?
    @IBOutlet private weak var projectType: UILabel?
    @IBOutlet private weak var projectName: UILabel?
    @IBOutlet private weak var projectImage: UIImageView?
    
    // MARK: - Properties
    
//    weak var delegate: ProjectsCollectionViewCellDelegate?
//    var whatsappCallback: (() -> Void)?
//    private var projectVM: ProjectsCollectionViewCellModels.ViewModel?
    
    @IBAction private func whatsappAction(_ sender: Any) {
       // whatsappCallback?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupViews()
    }
    
    override func configure(with any: Any) {
//        guard let viewModel = any as? ProjectsCollectionViewCellModels.ViewModel else { return }
//        projectVM = viewModel
//        displayProject(viewModel: viewModel)
    }
}

extension ProjectsCollectionViewCell {
    private func setupViews() {
        contentView.clipsToBounds = false
        //bottomView?.layer.cornerRadius = Constants.cornerRadius
       // projectImage?.roundCorners(corners: .allCorners, radius: Constants.cornerRadius)
        //handOverTitle?.text = Constants.handOver
        //launchPriceTitle?.text = Constants.launchPrice
        whatsappButton?.setTitle("Whatsapp", for: .normal)
        whatsappButton?.setupTealColors()
    }
}

//extension ProjectsCollectionViewCell: ProjectsCollectionViewCellDisplayLogic {
//    func displayProject(viewModel: ProjectsCollectionViewCellModels.ViewModel) {
//        projectName.text = viewModel.projectName
//        projectType.text = viewModel.projectType
//        if let price = viewModel.startingPrice, !price.isEmpty {
//            startingPrice.text = price
//            startingPrice.isHidden = false
//        } else {
//            launchPriceView.isHidden = true
//            dividerView.isHidden = true
//        }
//        projectLocation.text = viewModel.projectLocation
//        handOverValue.text = viewModel.handOverValue
//        if let url = viewModel.imageURL {
//            projectImage.sd_setImage(with: url)
//        }
//        whatsappButton.isHidden = !viewModel.showWhatsappButton
//    }
//}
//
//fileprivate enum Constants {
//    static let cornerRadius = 8.0
//    static let launchPrice = "startingFromTitle".localized()
//    static let handOver = "handover".localized()
//}
