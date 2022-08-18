//
//  ViewControllers.swift
//  ReproOrientationBug
//
//  Created by Russell Porter on 2022-08-18.
//

import UIKit

// Steps to reproduce the bug (view controller presented in wrong orientation):
// 1. Hold the phone in landscape for the following steps:
// 2. Show a portrait root view controller (FirstViewController)
// 3. Present a `fullScreen` modal portrait view controller (FirstModalViewController)
// 4. Present a `overFullScreen` modal portrait view controller
// 5. Dismiss the `overFullScreen` modal view controller and set portrait SecondViewController as root view controller.
//
// Expected result:
// - SecondViewController is shown in portrait.
//
// Actual result:
// - SecondViewController is shown in landscape.

class FirstViewController: PortraitLabelViewController {
    init() {
        super.init(text: "First root view controller (tap for next)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOverlay)))
    }

    @objc private func showOverlay() {
        let firstModalViewController = FirstModalViewController()
        firstModalViewController.modalPresentationStyle = .fullScreen
        present(firstModalViewController, animated: true)
    }
}

class FirstModalViewController: PortraitLabelViewController {
    init() {
        super.init(text: "Full screen modal (tap for next)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
    }

    @objc private func showAlert() {
        let secondModalViewController = SecondModalViewController()
        secondModalViewController.modalPresentationStyle = .overFullScreen
        present(secondModalViewController, animated: true)
    }
}

class SecondModalViewController: PortraitLabelViewController {
    init() {
        super.init(text: "Second modal over full screen (tap for next)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSecondRoot)))
    }

    @objc private func showSecondRoot() {
        // **This dismiss call causes the bug.**
        dismiss(animated: false)

        view.window?.rootViewController = SecondViewController()
    }
}

class SecondViewController: PortraitLabelViewController {
    init() {
        super.init(text: "Second root view controller. Should be shown in portrait.")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PortraitLabelViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    private let text: String
    private let label = UILabel()

    init(text: String) {
        self.text = text

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 0
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
