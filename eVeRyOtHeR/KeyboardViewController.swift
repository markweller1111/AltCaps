import UIKit

class KeyboardViewController: UIInputViewController {

    private var isAltCapsEnabled = true

    private let keys: [[String]] = [
        ["q","w","e","r","t","y","u","i","o","p"],
        ["a","s","d","f","g","h","j","k","l"],
        ["z","x","c","v","b","n","m"]
    ]

    private var toggleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    private func setupKeyboard() {
        view.backgroundColor = .systemBackground

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        // Letter rows
        for row in keys {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 4

            for key in row {
                let button = createKeyButton(title: key)
                rowStack.addArrangedSubview(button)
            }

            mainStack.addArrangedSubview(rowStack)
        }

        // Bottom row (Toggle, Globe, Space, Delete)
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 4
        bottomRow.distribution = .fillProportionally

        toggleButton = createKeyButton(title: "AltCaps: ON")
        toggleButton.backgroundColor = .systemBlue
        toggleButton.setTitleColor(.white, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleAltCaps), for: .touchUpInside)

        let globe = createKeyButton(title: "🌐")
        globe.addTarget(self, action: #selector(nextKeyboard), for: .touchUpInside)

        let space = createKeyButton(title: "space")
        space.widthAnchor.constraint(equalToConstant: 160).isActive = true

        let delete = createKeyButton(title: "⌫")

        bottomRow.addArrangedSubview(toggleButton)
        bottomRow.addArrangedSubview(globe)
        bottomRow.addArrangedSubview(space)
        bottomRow.addArrangedSubview(delete)

        mainStack.addArrangedSubview(bottomRow)
    }

    private func createKeyButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func toggleAltCaps() {
        isAltCapsEnabled.toggle()
        let title = isAltCapsEnabled ? "AltCaps: ON" : "AltCaps: OFF"
        toggleButton.setTitle(title, for: .normal)
        toggleButton.backgroundColor = isAltCapsEnabled ? .systemBlue : .systemGray
    }

    @objc private func nextKeyboard() {
        advanceToNextInputMode()
    }

    @objc private func keyTapped(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }
        let proxy = textDocumentProxy

        switch key {
        case "space":
            proxy.insertText(" ")
        case "⌫":
            proxy.deleteBackward()
        case "🌐":
            advanceToNextInputMode()
        default:
            handleCharacterInput(key)
        }
    }

    private func handleCharacterInput(_ character: String) {
        let proxy = textDocumentProxy
        proxy.insertText(character)

        // Only transform if toggle is enabled
        if isAltCapsEnabled {
            transformCurrentWord()
        }
    }

    private func transformCurrentWord() {
        guard let beforeCursor = textDocumentProxy.documentContextBeforeInput else { return }

        // Find the current word (characters since last space/newline)
        let separators = CharacterSet.whitespacesAndNewlines
        let components = beforeCursor.components(separatedBy: separators)
        guard let currentWord = components.last, !currentWord.isEmpty else { return }

        let transformed = alternateCapsExcludingFirst(currentWord)

        // Delete the original word
        for _ in 0..<currentWord.count {
            textDocumentProxy.deleteBackward()
        }

        // Insert transformed word
        textDocumentProxy.insertText(transformed)
    }

    private func alternateCapsExcludingFirst(_ text: String) -> String {
        guard text.count > 1 else { return text }

        var result = ""
        var shouldCapitalize = true

        for (index, char) in text.enumerated() {
            if index == 0 {
                result.append(char) // Always preserve first letter exactly
            } else {
                if shouldCapitalize {
                    result.append(String(char).uppercased())
                } else {
                    result.append(String(char).lowercased())
                }
                shouldCapitalize.toggle()
            }
        }

        return result
    }
}
