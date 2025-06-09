import SwiftData
import Foundation

@Model
final class ToDoItemDB {
    let id: String
    let text: String
    let deadline: Date?
    // REFACT: переименовать переменную в isDone
    let isCompleted: Bool
    let creationDate: Date

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
