//
//  PickerToolBar.swift
//  AnyImageKit
//
//  Created by 蒋惠 on 2019/9/17.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class PickerToolBar: UIView {
    
    private lazy var backgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.contentView.backgroundColor = options.theme.backgroundColor.withAlphaComponent(0.7)
        return view
    }()
    
    private(set) lazy var leftButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.clear
        view.setTitleColor(options.theme.textColor, for: .normal)
        view.setTitleColor(options.theme.textColor.withAlphaComponent(0.3), for: .disabled)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    private(set) lazy var originalButton: OriginalButton = {
        let view = OriginalButton(frame: .zero, options: options)
        return view
    }()
    
    private(set) lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = options.theme.mainColor
        let normal = UIColor.create(style: options.theme.style,
                                    light: .white,
                                    dark: options.theme.textColor)
        let disabled = UIColor.create(style: options.theme.style,
                                      light: normal.withAlphaComponent(0.7),
                                      dark: normal.withAlphaComponent(0.3))
        view.setTitleColor(normal, for: .normal)
        view.setTitleColor(disabled, for: .disabled)
        view.setTitle(BundleHelper.pickerLocalizedString(key: "Done"), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    private let style: Style
    private let options: PickerOptionsInfo
    
    init(style: Style, options: PickerOptionsInfo) {
        self.style = style
        self.options = options
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        switch style {
        case .picker:
            addSubview(backgroundView)
            backgroundView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            leftButton.setTitle(BundleHelper.pickerLocalizedString(key: "Preview"), for: .normal)
        case .preview:
            backgroundColor = options.theme.toolBarColor
            leftButton.setTitle(BundleHelper.pickerLocalizedString(key: "Edit"), for: .normal)
        }
        
        let contentView = UILayoutGuide()
        addLayoutGuide(contentView)
        addSubview(leftButton)
        addSubview(originalButton)
        addSubview(doneButton)
        
        contentView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(56)
        }
        leftButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalTo(contentView)
            maker.height.equalTo(30)
        }
        originalButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalTo(contentView)
            maker.height.equalTo(30)
        }
        doneButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().offset(-15)
            maker.centerY.equalTo(contentView)
            maker.size.equalTo(CGSize(width: 60, height: 30))
        }
    }
}

// MARK: - function
extension PickerToolBar {
    
    func setEnable(_ enable: Bool) {
        leftButton.isEnabled = enable
        doneButton.isEnabled = enable
        doneButton.backgroundColor = enable ? options.theme.mainColor : options.theme.buttonDisableColor
    }
}

extension PickerToolBar {
    
    enum Style {
        case picker
        case preview
    }
}
