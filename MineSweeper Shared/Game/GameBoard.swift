import SpriteKit

struct TileCoordinate {
    let x: Int
    let y: Int
    
    var west: TileCoordinate {
        TileCoordinate(x: x - 1, y: y)
    }
    var north: TileCoordinate {
        TileCoordinate(x: x, y: y - 1)
    }
    var south: TileCoordinate {
        TileCoordinate(x: x, y: y + 1)
    }
    var east: TileCoordinate {
        TileCoordinate(x: x + 1, y: y)
    }
    var northEast: TileCoordinate {
        TileCoordinate(x: x + 1, y: y - 1)
    }
    var southEast: TileCoordinate {
        TileCoordinate(x: x + 1, y: y + 1)
    }
    var northWest: TileCoordinate {
        TileCoordinate(x: x - 1, y: y - 1)
    }
    var southWest: TileCoordinate {
        TileCoordinate(x: x - 1, y: y + 1)
    }
}

class GameBoard{
    let node: SKShapeNode
    let size: Int
    var flagCount = 0
    var isFinished: Bool = false
    var isGameFinished: Bool = false
    
    private var tiles: [Tile]
    
    private var numberOfTiles: Int{
        size * size
    }
    
    private var tileSize: CGSize{
        CGSize(
            width: node.frame.width / CGFloat(size),
            height: node.frame.height / CGFloat(size)
        )
    }
    
    init(size: Int){
        self.size = size
        
        node = SKShapeNode()
        node.fillColor = .gray
        node.strokeColor = .clear
        node.position = .zero
        
        tiles = []
        generateBoard()
        
    }
    
    private func generateBoard(){
        
        var tileX = 0
        var tileY = 0
        (0..<numberOfTiles).forEach{ _ in
            let coordinate = TileCoordinate(x: tileX, y: tileY)
            let tile = Tile(coordinate: coordinate)
            tile.node.texture = Resources.tiles.unDiscovered
            node.addChild(tile.node)
            tiles.append(tile)
            
            tileX += 1
            if tileX >= size{
                tileX = 0
                tileY += 1
            }
        }
        
        let numberOfBombs = Int((CGFloat(numberOfTiles) / 10).rounded(.up))
        var bombs: [Tile] = []
        
        while bombs.count < numberOfBombs{
            guard let tile = tiles.randomElement() else {break}
            guard !tile.isBomb else {continue}
            tile.isBomb = true
            //tile.node.texture = Resources.tiles.bomb
            bombs.append(tile)
        }
    }
    
    func repositionBoard(to boardSize: CGSize){
        node.path = CGPath(rect: CGRect(x: -boardSize.width/2, y: -boardSize.height/2, width: boardSize.width, height: boardSize.height), transform: nil)
        
        var column = 0
        var row = 0
        
        tiles.forEach{ tile in
            tile.node.size = tileSize
            
            let x = node.frame.minX + CGFloat(column) * tileSize .width
            let y = node.frame.maxY - CGFloat(row) * tileSize.height
            
            tile.node.position = CGPoint(x: x, y: y)
            
            column += 1
            if column >= size{
                column = 0
                row += 1
            }
        }
    }
    
    func gameOver(){
        isGameFinished = true
        tiles.filter{$0.isBomb}.forEach{$0.node.texture = Resources.tiles.bomb}
    }
    
    func gameFinished(){
        isGameFinished = true
        isFinished = true
        print("Game is Finished")
    }
    
    func countFlagAround(tile: Tile) -> Int{
        var flags = 0
        for x in adjucentTiles(for: tile){
            if x.isFlagged{
                flags += 1
            }
        }
        return flags
    }
    
    func countBombsAround(tile: Tile) -> Int{
        var bombs = 0
        for x in adjucentTiles(for: tile){
            if x.isBomb{
                bombs += 1
            }
        }
        return bombs
    }
    
    func revealTile(at position: CGPoint){
        guard let tile = tileAt(position: position) else {return}
        
        if flagCount == Int((CGFloat(numberOfTiles) / 10).rounded(.up)){
            gameFinished()
            tiles.filter({$0.isBomb}).forEach{if ($0.isBomb == $0.isFlagged){ $0.node.texture = Resources.tiles.flag}}
        }
        
        if countBombsAround(tile: tile) == countFlagAround(tile: tile){
            for x in adjucentTiles(for: tile){
                if !x.isBomb && !x.isFlagged{
                    reveal(tile: x)
                }else if(x.isBomb && !x.isFlagged){
                    gameOver()
                }
            }
        }
        
        if tile.isBomb {
            tile.isRevealed = true
            gameOver()
            tile.node.texture = Resources.tiles.bombRed
            return
        }else{
            reveal(tile: tile)
        }
        
    }
    
    func toggleFlag(at position: CGPoint) {
        
        guard let tile = tileAt(position: position) else {return}
        guard !tile.isRevealed else {return}
        
        tile.isFlagged.toggle()
        if tile.isFlagged{
            flagCount += 1
            tile.node.texture = Resources.tiles.flag
        }else{
            flagCount -= 1
            tile.node.texture = Resources.tiles.unDiscovered
        }
    }
    
    private func reveal(tile: Tile) {
       
        tile.isRevealed = true
        
        if tile.isFlagged{
            flagCount -= 1
        }
        
        let adjucentBombCount = numberOfAdjcentBombs(for: tile)
        tile.node.texture = textureForAdjucentBombCount(adjucentBombCount)
        
        if adjucentBombCount == 0{
            for tile in adjucentTiles(for: tile).filter({!$0.isRevealed}).filter({!$0.isFlagged}){
                if !tile.isBomb {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)){
                        self.reveal(tile: tile)
                    }
                }
            }
        }
        
    }
    
    private func textureForAdjucentBombCount(_ count: Int) -> SKTexture{
        switch count{
        case 0:
            return Resources.tiles.clear
        case 1:
            return Resources.tiles.one
        case 2:
            return Resources.tiles.two
        case 3:
            return Resources.tiles.three
        case 4:
            return Resources.tiles.four
        case 5:
            return Resources.tiles.five
        case 6:
            return Resources.tiles.six
        case 7:
            return Resources.tiles.seven
        case 8:
            return Resources.tiles.eight
        default:
            fatalError("Should not have more that 8 adjucent bombs")
        }
    }
    
    private func adjucentTiles(for t: Tile) -> [Tile]{
        [
            tile(at: t.coordinate.north),
            tile(at: t.coordinate.northEast),
            tile(at: t.coordinate.east),
            tile(at: t.coordinate.southEast),
            tile(at: t.coordinate.south),
            tile(at: t.coordinate.southWest),
            tile(at: t.coordinate.west),
            tile(at: t.coordinate.northWest)
        ].compactMap{$0}
    }
    
    private func numberOfAdjcentBombs(for tile: Tile) -> Int{
        adjucentTiles(for: tile).filter{$0.isBomb}.count
    }
    
    private func tile(at Coordinate: TileCoordinate) -> Tile? {
        guard (0..<size).contains(Coordinate.x) && (0..<size).contains(Coordinate.y) else {return nil}
        let tileIndex = (Coordinate.y * size) + Coordinate.x
        let tile = tiles[tileIndex]
        return tile
    }
    
    private func coordinate(at pixalPosition: CGPoint) -> TileCoordinate{
        let tileX = Int(pixalPosition.x / node.frame.width * CGFloat(size))
        let tileY = Int(pixalPosition.y / node.frame.height * CGFloat(size))
        
        return TileCoordinate(x: tileX, y: tileY)
    }
    
    
    func tileAt(position: CGPoint) -> Tile?{
        let x = position.x + node.frame.width/2
        let y = node.frame.height - position.y - node.frame.height/2
        
        guard x > 0 && x <= node.frame.width && y > 0 && y <= node.frame.height else {return nil}

        let coord = coordinate(at: CGPoint(x: x, y: y))

        return tile(at: coord)
    }
}

