//
//  ViewController.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import UIKit

class DirectoriesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let manager = FileManagerSupport.shared
    
    var allDirectories = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confNavigationController()
        getAllDirectories()
        confTableView()
    }
    
    private func confNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Directories"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
    }
    
    private func confTableView() {
        tableView.register(DirectoryTableViewCell.self, forCellReuseIdentifier: "DirectoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func getAllDirectories() {
        manager.getAllDirectories { [weak self] allDirectories in
            self?.allDirectories = allDirectories
        }
    }
    
    
    @objc func addTapped() {
        self.presentAlertForFileNaming { [weak self] (title) in
            self?.manager.createDir(title: title)
            self?.getAllDirectories()
        }
    }
}

extension DirectoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allDirectories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryTableViewCell") as! DirectoryTableViewCell
        cell.titleLabel.text = allDirectories[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pathAttribute = "/" + allDirectories[indexPath.row]
            manager.deleteDoc(pathAttribute: pathAttribute)
            self.allDirectories.remove(at: indexPath.row)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ContentsOfFolderVC()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentDirectory = paths.first else { return }
        if let allItems = try? FileManager.default.contentsOfDirectory(atPath: documentDirectory) {
            do {
                
                let currentDirURL = documentDirectory + "/" + allDirectories[indexPath.row]
                vc.contents = try FileManager.default.contentsOfDirectory(atPath: currentDirURL)
                vc.currentDirTitle = allItems[indexPath.row]
                vc.currentDirPath = currentDirURL
            } catch {
                print(error)
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

