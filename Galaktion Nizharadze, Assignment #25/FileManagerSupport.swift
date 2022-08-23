//
//  FileManagerSupport.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import Foundation

class FileManagerSupport {
    
    static let shared = FileManagerSupport()
    private init() {}
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    
    func createDir(title: String) {
        
        let docURL = URL(string: path)!
        let dataPath = docURL.appendingPathComponent(title)
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
     func getAllDirectories(completion: ([String]) ->() ) {
        
        if let allItems = try? FileManager.default.contentsOfDirectory(atPath: path) {
            completion(allItems)
        }
    }
    
    func write(text: String, to fileNamed: String, currentDirTitle: String) {
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(currentDirTitle) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func deleteDoc(pathAttribute: String ) {
        
        let newPath = path + pathAttribute
        do {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: newPath) {
               // Delete file
               try fileManager.removeItem(atPath: newPath)
           } else {
               print("File does not exist")
           }
       } catch {
           print("An error took place: \(error)")
       }
    }
    
}
