//
//  ContentsOfDirVC.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import UIKit

class ContentsOfFolderVC: UIViewController {
    
    private let tableView = UITableView()
    
    var contents: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let heightOfRow: CGFloat = 120
    var currentDirTitle: String!
    var currentDirPath: String!
    
    
    private let fileAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add File", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        confTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        confFileAddButton()
    }
    
    
    private func confTableView() {
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: view.frame.height - 200)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DirectoryTableViewCell.self, forCellReuseIdentifier: "DirectoryTableViewCell")
        fileAddButton.addTarget(self, action: #selector(fileAddAction), for: .touchUpInside)
    }
    
    @objc func fileAddAction() {
        self.presentAlertForFileNaming { [weak self] (title) in
            self?.contents.append(title)
            self?.write(text: "Hello, world", to: title)
        }
    }
    
    private func write(text: String, to fileNamed: String) {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(currentDirTitle) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
    private func confFileAddButton() {
        view.addSubview(fileAddButton)
        NSLayoutConstraint.activate([
            fileAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fileAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fileAddButton.heightAnchor.constraint(equalToConstant: 50),
            fileAddButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

}

extension ContentsOfFolderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryTableViewCell") as! DirectoryTableViewCell
        cell.titleLabel.text = contents[indexPath.row]
        cell.iconLabel.text = "📑"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightOfRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContentsOfFileVC()

        do {
            let currentFileURL = URL(string: "file://" + currentDirPath + "/" + contents[indexPath.row])!
            let text2 = try String(contentsOf: currentFileURL, encoding: .utf8)
            vc.text = text2
            vc.currentFileURL = currentFileURL
        }
        catch {
            print(error)
        }
        
        self.present(vc, animated: true)
    }
}
