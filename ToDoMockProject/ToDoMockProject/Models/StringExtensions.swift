import Foundation

extension Int {
    
    func todosDeclension() -> String {
        let remainder10 = self % 10
        let remainder100 = self % 100
        
        // 11-14 - исключения
        if (11...14).contains(remainder100) {
            return "\(self) задач"
        }
        
        switch remainder10 {
        case 1:
            return "\(self) задача"
        case 2, 3, 4:
            return "\(self) задачи"
        default:
            return "\(self) задач"
        }
    }
}
