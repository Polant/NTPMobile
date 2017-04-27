//
//  ContainerViewController.swift
//  NTPiosUI
//
//  Created by Anton Poltoratskyi on 2/8/17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

struct ContainerViewSettings {
    static let sidePanelWidth: CGFloat = 300
    static let animationDuration: TimeInterval = 0.25
    static let shadowOpacity: Float = 0.5
}

public enum ContainerPanel {
    case left
    case right
    case central
}

enum ContainersState {
    case allClosed
    case sliding
    case opened
}

open class ContainerViewController: UIViewController {
    
    internal lazy var leftContainer: ContainerView = {
        return ContainerView()
    }()
    
    internal lazy var rightContainer: ContainerView = {
        return ContainerView()
    }()
    
    internal lazy var centralContainer: ContainerView = {
        return ContainerView()
    }()
    
    private lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal var panelsState: ContainersState = .allClosed {
        didSet {
            if oldValue == panelsState { return }
            switch panelsState {
            case .allClosed:
                maskView.removeFromSuperview()
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.maskView.alpha = 0
                }
                break
            case .opened:
                centralContainer.addSubview(maskView)
                maskView.leftAnchor.constraint(equalTo: centralContainer.leftAnchor, constant: 0).isActive = true
                maskView.rightAnchor.constraint(equalTo: centralContainer.rightAnchor, constant: 0).isActive = true
                maskView.topAnchor.constraint(equalTo: centralContainer.topAnchor, constant: 0).isActive = true
                maskView.bottomAnchor.constraint(equalTo: centralContainer.bottomAnchor, constant: 0).isActive = true
                centralContainer.layoutSubviews()
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.maskView.alpha = 0.05
                }
                break
            default:
                break
            }
        }
    }
    
    public var shadowOpacity = ContainerViewSettings.shadowOpacity {
        didSet {
            centralContainer.layer.shadowOpacity = shadowOpacity
        }
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = centralContainer.viewController {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        [leftContainer, rightContainer, centralContainer].forEach {
            $0.backgroundColor = .lightGray
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        centralContainer.layer.shadowOpacity = shadowOpacity
        
        bindCentralContainer()
        bindLeftContainer()
        bindRightContainer()
        
        leftContainer.hide()
        rightContainer.hide()
        
        view.layoutIfNeeded()
        
        addGestureRecognizers()
        processSeguesIfNeeded()
    }
    
    //MARK: - Layouting
    private func bindLeftContainer() {
        let constraints = [NSLayoutConstraint.top(forBinding: view, to: leftContainer),
                           NSLayoutConstraint.bottom(forBinding: view, to: leftContainer),
                           NSLayoutConstraint.leading(forBinding: view, to: leftContainer),
                           NSLayoutConstraint.width(for: leftContainer, constant: ContainerViewSettings.sidePanelWidth)]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bindRightContainer() {
        let constraints = [NSLayoutConstraint.top(forBinding: view, to: rightContainer),
                           NSLayoutConstraint.bottom(forBinding: view, to: rightContainer),
                           NSLayoutConstraint.trailing(forBinding: view, to: rightContainer),
                           NSLayoutConstraint.width(for: rightContainer, constant: ContainerViewSettings.sidePanelWidth)]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bindCentralContainer() {
        let constraints = NSLayoutConstraint.constraints(forBinding: view, to: centralContainer)
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Segues
    func processSeguesIfNeeded() {
        ObjC.catchException { [weak self] in
            guard let wSelf = self else { return }
            wSelf.performSegue(withIdentifier: ContainerSegueIdentifiers.central, sender: wSelf)
            wSelf.performSegue(withIdentifier: ContainerSegueIdentifiers.left, sender: wSelf)
            wSelf.performSegue(withIdentifier: ContainerSegueIdentifiers.right, sender: wSelf)
        }
    }

    //MARK: - Gesture Recognizers
    func addGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        centralContainer.addGestureRecognizer(pan)
        centralContainer.addGestureRecognizer(tap)
    }
    
    private var xTranslation: CGFloat = 0.0
    private var panelWasOpened: Bool = false
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            switch panelsState {
            case .allClosed:
                panelWasOpened = false
                if recognizer.velocity(in: view).x >= 0 && leftContainer.filled {
                    leftContainer.active = true
                    rightContainer.active = false
                } else if rightContainer.filled {
                    leftContainer.active = false
                    rightContainer.active = true
                }
            case .opened:
                panelWasOpened = true
            default:
                break
            }
            panelsState = .sliding
            break
        case .changed:
            var xTranslation = recognizer.translation(in: view).x
            if abs(xTranslation) > ContainerViewSettings.sidePanelWidth {
                xTranslation = xTranslation < 0
                    ? -ContainerViewSettings.sidePanelWidth
                    : ContainerViewSettings.sidePanelWidth
            }
            slidePanel(with: xTranslation,
                       velocity: recognizer.velocity(in: view).x)
            self.xTranslation = xTranslation
            break
        default:
            completeSliding(with: xTranslation)
            break
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        switch panelsState {
        case .allClosed:
            return
        case .opened:
            togglePanel(open: false) { [weak self] in
                self?.panelsState = .allClosed
            }
        default:
            break
        }
    }
    
    //MARK: - Methods
    internal func slidePanel(with translation: CGFloat, velocity: CGFloat) {
        if velocity == 0 { return }
        if leftContainer.active {
            slideLeft(translation: translation, closing: panelWasOpened)
        }
        
        if rightContainer.active {
            slideRight(translation: translation, closing: panelWasOpened)
        }
    }
    
    internal func slideLeft(translation: CGFloat, closing: Bool) {
        if closing {
            if translation > 0 { return }
            move(panel: centralContainer, translation: ContainerViewSettings.sidePanelWidth + translation)
        } else {
            if translation < 0 { return }
            move(panel: centralContainer, translation: translation)
        }
    }
    
    internal func slideRight(translation: CGFloat, closing: Bool) {
        if closing {
            if translation < 0 { return }
            move(panel: centralContainer, translation: translation - ContainerViewSettings.sidePanelWidth)
        } else {
            if translation > 0 { return }
            move(panel: centralContainer, translation: translation)
        }
    }
    
    internal func completeSliding(with translation: CGFloat) {
        if leftContainer.active {
            if panelWasOpened {
                if translation <= -ContainerViewSettings.sidePanelWidth / 2 {
                    togglePanel(open: false)
                } else {
                    togglePanel(open: true)
                }
            } else {
                if translation >= ContainerViewSettings.sidePanelWidth / 2 {
                    togglePanel(open: true)
                } else {
                    togglePanel(open: false)
                }
            }
        }
        
        if rightContainer.active {
            if panelWasOpened {
                if translation >= ContainerViewSettings.sidePanelWidth / 2 {
                    togglePanel(open: false)
                } else {
                    togglePanel(open: true)
                }
            } else {
                if translation <= -ContainerViewSettings.sidePanelWidth / 2 {
                    togglePanel(open: true)
                } else {
                    togglePanel(open: false)
                }
            }
        }
    }
    
    internal func move(panel: ContainerView, translation: CGFloat) {
        panel.leading?.constant = translation
        panel.trailing?.constant = translation
    }
    
    internal func togglePanel(open: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
        if leftContainer.active {
            move(panel: centralContainer,
                 translation: open ? ContainerViewSettings.sidePanelWidth : 0)
        }
        
        if rightContainer.active {
            move(panel: centralContainer,
                 translation: open ? -ContainerViewSettings.sidePanelWidth : 0)
        }
        
        let wrappedCompletion = { [weak self] in
            self?.panelsState = open ? .opened : .allClosed
            completion?()
        }
        
        if animated {
            UIView.animate(withDuration: ContainerViewSettings.animationDuration, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                }, completion: { (finished) in
                    wrappedCompletion()
            })
        } else {
            wrappedCompletion()
        }
    }
    
    // MARK: - Public methods
    public var isLeftVisible: Bool {
        set {
            toggleLeft(animated: false, visible: newValue, completion: nil)
        }
        get {
            return panelsState == .opened && leftContainer.active
        }
    }
    
    public var isRightVisible: Bool {
        set {
            toggleRight(animated: false, visible: newValue, completion: nil)
        }
        get {
            return panelsState == .opened && rightContainer.active
        }
    }
    
    public func toggleLeft(animated: Bool = true, completion: (() -> Void)?) {
        toggleLeft(animated: animated, visible: !isLeftVisible, completion: completion)
    }
    
    public func toggleRight(animated: Bool = true, completion: (() -> Void)?) {
        toggleRight(animated: animated, visible: !isLeftVisible, completion: completion)
    }
    
    public func toggleLeft(animated: Bool, visible: Bool, completion: (() -> Void)?) {
        if !leftContainer.filled {
            debugPrint("Container error, left container is empty")
            return
        }
        togglePanel(open: visible, animated: animated, completion: completion)
    }
    
    public func toggleRight(animated: Bool, visible: Bool, completion: (() -> Void)?) {
        if !rightContainer.filled {
            debugPrint("Container error, right container is empty")
            return
        }
        togglePanel(open: visible, animated: animated, completion: completion)
    }
    
    public func set(_ controller: UIViewController, to panel: ContainerPanel) {
        switch panel {
        case .central:
            setCentral(controller: controller)
            break
        case .left:
            setLeft(controller: controller)
            break
        case .right:
            setRight(controller: controller)
            break
        }
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    public func setCentral(controller: UIViewController) {
        centralContainer.embed(controller)
    }
    
    public func setLeft(controller: UIViewController) {
        leftContainer.embed(controller)
    }
    
    public func setRight(controller: UIViewController) {
        rightContainer.embed(controller)
    }
    
    public func removeLeft() {
        leftContainer.clear()
    }
    
    public func removeRight() {
        rightContainer.clear()
    }
    
    public func removeBoth() {
        leftContainer.clear()
        rightContainer.clear()
    }
    //etc
}
