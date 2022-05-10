import SpriteKit

struct Resources{
    
    static var tiles: Tiles!
    
    private init() { }
    
    static func initialize(){
        let tilesTexture = SKTexture(imageNamed: "tiles")
        tiles = Tiles(tileSheet: SpriteSheet(atlas: tilesTexture, columns: 14, rows: 1, margin: 0, spaceing: 0))
    }
    
    struct Tiles{
        let clear: SKTexture
        let unDiscovered: SKTexture
        let one: SKTexture
        let two: SKTexture
        let three: SKTexture
        let four: SKTexture
        let five: SKTexture
        let six: SKTexture
        let seven: SKTexture
        let eight: SKTexture
        let flag: SKTexture
        let bomb: SKTexture
        let bombRed: SKTexture
        
        init(tileSheet: SpriteSheet){
            clear = tileSheet.textureFor(row: 0, column: 0)!
            unDiscovered = tileSheet.textureFor(row: 0, column: 9)!
            bomb = tileSheet.textureFor(row: 0, column: 11)!
            bombRed = tileSheet.textureFor(row: 0, column: 12)!
            flag = tileSheet.textureFor(row: 0, column: 10)!
            
            one = tileSheet.textureFor(row: 0 , column: 1)!
            two = tileSheet.textureFor(row: 0 , column: 2)!
            three = tileSheet.textureFor(row: 0 , column: 3)!
            four = tileSheet.textureFor(row: 0 , column: 4)!
            five = tileSheet.textureFor(row: 0 , column: 5)!
            six = tileSheet.textureFor(row: 0 , column: 6)!
            seven = tileSheet.textureFor(row: 0 , column: 7)!
            eight = tileSheet.textureFor(row: 0 , column: 8)!
            
        }
    }
}
