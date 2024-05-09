import Foundation

public extension Int {
    var roman: String? {
        var romanString: String = ""
        if (!(1...3999).contains(self)){ return nil }
        let map: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        
        var num = self
        
        while (num > 0){
            for ex in map{
                if(ex.0 <= num){
                    num = num - ex.0
                    romanString.append(contentsOf: ex.1)
                    break
                }
            }
        }
        
        return romanString
    }
}
