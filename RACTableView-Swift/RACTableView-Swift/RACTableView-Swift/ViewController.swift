import UIKit

class ViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var demoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DRxTableView Demo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "DRxTableView"
        view.backgroundColor = .white
        
        view.addSubview(demoButton)
        
        NSLayoutConstraint.activate([
            demoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            demoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            demoButton.widthAnchor.constraint(equalToConstant: 200),
            demoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        demoButton.addTarget(self, action: #selector(demoButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func demoButtonTapped() {
        
    }
} 
