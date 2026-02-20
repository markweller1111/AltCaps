import UIKit

class KeyboardViewController: UIInputViewController {

    private var isAltCapsEnabled = true
    private var isShiftEnabled = false
    private var toggleButton: UIButton!

    private let letterRows: [[String]] = [
        ["q","w","e","r","t","y","u","i","o","p"],
        ["a","s","d","f","g","h","j","k","l"],
        ["z","x","c","v","b","n","m"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    private func setupKeyboard() {
        view.backgroundColor = .systemBackground

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6)
        ])

        // Row 1: QWERTY
        mainStack.addArrangedSubview(createLetterRow(letterRows[0]))

        // Row 2: ASDFGHJKL (indented like Apple keyboard)
        let secondRowContainer = UIStackView()
        secondRowContainer.axis = .horizontal
        secondRowContainer.spacing = 4

        let leftSpacer = UIView()
        leftSpacer.widthAnchor.constraint(equalToConstant: 16).isActive = true
        secondRowContainer.addArrangedSubview(leftSpacer)
        secondRowContainer.addArrangedSubview(createLetterRow(letterRows[1]))
        let rightSpacer = UIView()
        rightSpacer.widthAnchor.constraint(equalToConstant: 16).isActive = true
        secondRowContainer.addArrangedSubview(rightSpacer)

        mainStack.addArrangedSubview(secondRowContainer)

        // Row 3: Shift + letters + Delete
        let thirdRow = UIStackView()
        thirdRow.axis = .horizontal
        thirdRow.spacing = 4
        thirdRow.distribution = .fill

        let shift = createSystemKey(title: "⇧", width: 50)
        shift.addTarget(self, action: #selector(toggleShift), for: .touchUpInside)

        let lettersRow = createLetterRow(letterRows[2])

        let delete = createSystemKey(title: "⌫", width: 50)

        thirdRow.addArrangedSubview(shift)
        thirdRow.addArrangedSubview(lettersRow)
        thirdRow.addArrangedSubview(delete)

        mainStack.addArrangedSubview(thirdRow)

        // Bottom Row (Apple style)
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 6
        bottomRow.distribution = .fill

        toggleButton = createSystemKey(title: "AltCaps ON", width: 90)
        toggleButton.backgroundColor = .systemBlue
        toggleButton.setTitleColor(.white, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleAltCaps), for: .touchUpInside)

        let globe = createSystemKey(title: "🌐", width: 50)
        globe.addTarget(self, action: #selector(nextKeyboard), for: .touchUpInside)

        let space = createSystemKey(title: "space", width: 200)

        let returnKey = createSystemKey(title: "return", width: 80)

        bottomRow.addArrangedSubview(toggleButton)
        bottomRow.addArrangedSubview(globe)
        bottomRow.addArrangedSubview(space)
        bottomRow.addArrangedSubview(returnKey)

        mainStack.addArrangedSubview(bottomRow)
    }

    private func createLetterRow(_ letters: [String]) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 4
        row.distribution = .fillEqually

        for letter in letters {
            let button = createKeyButton(title: letter)
            row.addArrangedSubview(button)
        }

        return row
    }

    private func createKeyButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)

        // Apple-style press animation
        button.addTarget(self, action: #selector(keyDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyUp(_:)), for: [.touchUpInside, .touchDragExit])

        return button
    }

    private func createSystemKey(title: String, width: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray4
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true

        // Only animation, NOT keyTapped
        button.addTarget(self, action: #selector(keyDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyUp(_:)), for: [.touchUpInside, .touchDragExit])

        return button
    }

    @objc private func keyDown(_ sender: UIButton) {
        sender.alpha = 0.6
    }

    @objc private func keyUp(_ sender: UIButton) {
        sender.alpha = 1.0
    }

    @objc private func toggleShift() {
        isShiftEnabled.toggle()
    }

    @objc private func toggleAltCaps() {
        isAltCapsEnabled.toggle()
        let title = isAltCapsEnabled ? "AltCaps ON" : "AltCaps OFF"
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
        case "return":
            proxy.insertText("\n")
        case "⌫":
            proxy.deleteBackward()
        case "🌐":
            advanceToNextInputMode()
        case "⇧":
            toggleShift()
        default:
            let character = isShiftEnabled ? key.uppercased() : key
            handleCharacterInput(character)
        }
    }

    private func handleCharacterInput(_ character: String) {
        let proxy = textDocumentProxy
        proxy.insertText(character)

        if isAltCapsEnabled {
            transformCurrentWord()
        }
    }

    private func transformCurrentWord() {
        guard let beforeCursor = textDocumentProxy.documentContextBeforeInput else { return }

        let separators = CharacterSet.whitespacesAndNewlines
        let components = beforeCursor.components(separatedBy: separators)
        guard let currentWord = components.last, !currentWord.isEmpty else { return }

        let transformed = alternateCapsExcludingFirst(currentWord)

        for _ in 0..<currentWord.count {
            textDocumentProxy.deleteBackward()
        }

        textDocumentProxy.insertText(transformed)
    }

    private func alternateCapsExcludingFirst(_ text: String) -> String {
        guard text.count > 1 else { return text }

        var result = ""
        var shouldCapitalize = true

        for (index, char) in text.enumerated() {
            if index == 0 {
                result.append(char)
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
