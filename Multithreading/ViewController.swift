//
//  ViewController.swift
//  Multithreading
//
//  Created by Roman on 28.02.2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var passwordGenButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var backgroundButton: UIButton!



    // MARK: - Vars
    var timeSpend: Double = 0.0

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true

    }

    // MARK: - Functions
    func generatePassword() -> String {
        var pass: String = ""
        for _ in 1...3 {
            let x = String().printable.randomElement() ?? " "
            pass += String(x)
        }
        return pass
    }

    // MARK: - Actions
    @IBAction func passwordGenAction(_ sender: UIButton) {
        passwordLabel.text = "Loading..."
        indicator.startAnimating()
        self.passwordField.isSecureTextEntry = true
        self.passwordGenButton.isEnabled = false

        self.timeSpend = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.timeSpend += 0.1
        }

        let pass = generatePassword()
        passwordField.text = pass

        // Создаем объект Thread
        let thread = Thread {
            bruteForce(passwordToUnlock: pass)
            timer.invalidate()
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.passwordField.isSecureTextEntry = false
                self.timeSpend = round(self.timeSpend * 1000) / 1000
                self.passwordLabel.text = pass + " :" + String(self.timeSpend)
                self.passwordGenButton.isEnabled = true
            }
        }
        // Задаем потоку QOS
        thread.qualityOfService = .default
        thread.name = "brute"
        // Стартуем выполнение операций на потоке
        thread.start()
    }

    @IBAction func backgroundAction(_ sender: UIButton) {
        isBlack.toggle()
    }
}
