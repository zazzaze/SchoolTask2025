// REFACT: отсортировать в алфавитном порядке
import SQLite
import SwiftData
import Foundation

class FileCache {
    private(set) var toDoItems: [ToDoItem] = []
    var container: ModelContainer?
    var sqlDatabase: Connection!
    var dataStorageUsed = UserDefaults.standard.string(forKey: "storage_preference") ?? "SwiftData"

    init() {
        connectDatabase()
        let fullSchema = Schema([ToDoItemDB.self])
        self.container = try! ModelContainer(for: fullSchema)
    }

    func append(item: ToDoItem) -> Bool {

        if toDoItems.contains(where: { $0.id == item.id }) {
            return false
        }
        toDoItems.append(item)
        return true
    }

    func remove(id: String) -> ToDoItem? {
        for i in 0..<toDoItems.count where toDoItems[i].id == id {
            return toDoItems.remove(at: i)
        }
        return nil
    }

    func exportJSONToFile(fileURL: URL) {
        let jsons = toDoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsons, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }

    func importJSONFromFile(fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
            for json in jsonArray {
                if let toDoItem = ToDoItem.parse(json: json) {
                    if !append(item: toDoItem) {
                        print("New item with \(toDoItem.id) ID not added: Duplicate ID!")
                    }
                }
            }
        } catch {
            print("Error reading ToDo items from file: \(error.localizedDescription)")
        }
    }

    func exportCSVToFile(fileURL: URL) {
        let csvs = toDoItems.map { $0.csv }
        do {
            let joinedStrings = csvs.joined(separator: "\n")
            try joinedStrings.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }

    func importCSVFromFile(fileURL: URL, isHeaders: Bool) {
        do {
            let csvData = try String(contentsOf: fileURL)
            var lines = csvData.components(separatedBy: .newlines)

            if isHeaders {
                lines.removeFirst()
            }

            var parsedToDoItems: [ToDoItem] = []
            for line in lines {
                if let toDoItem = ToDoItem.parse(csv: line) {
                    parsedToDoItems.append(toDoItem)
                }
            }

            self.toDoItems.append(contentsOf: parsedToDoItems)

        } catch {
            print("Error reading CSV file: \(error.localizedDescription)")
        }
    }
}

func solveQuadraticEquation(a: Double, b: Double, c: Double) -> (x1: Double?, x2: Double?) {
    let discriminant = b * b - 4 * a * c

    if discriminant < 0 {
        return (nil, nil) // Нет действительных корней
    } else if discriminant == 0 {
        let x = -b / (2 * a)
        return (x, x) // Один корень
    } else {
        let x1 = (-b + sqrt(discriminant)) / (2 * a)
        let x2 = (-b - sqrt(discriminant)) / (2 * a)
        return (x1, x2) // Два корня
    }
}

