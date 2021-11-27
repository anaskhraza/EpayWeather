//
//  TabCell.swift
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import UIKit

class TabCell: UICollectionViewCell {
    private var tabSV: UIStackView!
    
    var tabTitle: UILabel!
    
    
    var indicatorView: UIView!
    
    var indicatorColor: UIColor = .black
    
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.indicatorView.backgroundColor = self.isSelected ? self.indicatorColor : UIColor.clear
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    var tabViewModel: Tab? {
        didSet {
            tabTitle.text = tabViewModel?.title
            tabSV.spacing = 5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tabSV = UIStackView()
        tabSV.axis = .horizontal
        tabSV.distribution = .equalCentering
        tabSV.alignment = .center
        tabSV.spacing = 10.0
        addSubview(tabSV)
        
       
        tabTitle = UILabel()
        tabTitle.textAlignment = .center
        
        self.tabSV.addArrangedSubview(tabTitle)
        
        
        // TabSv Constraints
        tabSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            tabSV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tabSV.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        setupIndicatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tabTitle.text = ""
        
    }
    
    func setupIndicatorView() {
        indicatorView = UIView()
        addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            indicatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
