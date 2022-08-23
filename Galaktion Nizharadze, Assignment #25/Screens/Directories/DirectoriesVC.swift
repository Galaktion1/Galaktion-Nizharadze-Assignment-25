//
//  ViewController.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import UIKit

class DirectoriesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    private func createDir(title: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(title)
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func getAllDirectories() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentDirectory = paths.first else { return }
        if let allItems = try? FileManager.default.contentsOfDirectory(atPath: documentDirectory) {
            allDirectories = allItems
        }
    }
    
    
    @objc func addTapped() {
        self.presentAlertForFileNaming { [weak self] (title) in
            self?.createDir(title: title)
            self?.allDirectories.append(title)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ContentsOfFolderVC()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        if let allItems = try? FileManager.default.contentsOfDirectory(atPath: documentDirectory) {
            do {
                let currentDirURL = paths[0] + "/" + allItems[indexPath.row]
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

