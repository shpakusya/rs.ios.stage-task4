import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        func changeColor (_ image: [[Int]], _ newColor: Int, _ oldColor: Int) -> [[Int]]
        {
            var replaced: Bool = false
            var changedImage = image
            
            for (rowNum, row) in image.enumerated(){
                for (colNum, value) in row.enumerated(){
                    if(value == newColor){
                        if((row.count > colNum + 1)){
                            if(row[colNum + 1] == oldColor){
                                changedImage[rowNum][colNum + 1] = newColor
                                replaced = true
                            }
                        }
                        if((colNum > 0)){
                            if(row[colNum - 1] == oldColor){
                                changedImage[rowNum][colNum - 1] = newColor
                                replaced = true
                            }
                        }
                        
                        //add checks to up and down numbers
                    }
                }
            }
            
            if(replaced == true){
                changedImage = changeColor(changedImage, newColor, oldColor)
            }else{
                return changedImage
            }
            
            return changedImage
        }
        
        var changedImage = image
        
        if(row < changedImage.count && column < changedImage[0].count){
            let oldColor = changedImage[row][column]
            changedImage[row][column] = newColor
            changedImage = changeColor(changedImage, newColor, oldColor)
        }
        
        print("image: \(changedImage)")
        
        return changedImage
    }
}
