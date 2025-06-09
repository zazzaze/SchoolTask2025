import SwiftData
import Foundation

@Model
final class ToDoItemDB {
    var id: String
    var text: String
    var deadline: Date?
    // REFACT: переименовать переменную в isDone
    var isCompleted: Bool
    var creationDate: Date

    init(
        id: String = UUID().uuidString,
        text: String,
        deadline: Date? = nil,
        isDone: Bool = false,
        creationDate: Date = Date()
    ) {
        self.id = id
        self.text = text
        self.deadline = deadline
        self.isCompleted = isDone
        self.creationDate = creationDate
    }
}
