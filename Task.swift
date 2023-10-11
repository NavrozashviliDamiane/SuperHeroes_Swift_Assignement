// კლასის დეფინიცია "SuperEnemy"
class SuperEnemy {
    var name: String
    var hitPoints: Int
    
    init(name: String, hitPoints: Int) {
        self.name = name
        self.hitPoints = hitPoints
    }
}

// სუპერგმირის პროტოკოლის დეფინიცია
protocol Superhero {
    var name: String { get }
    var alias: String { get }
    var isEvil: Bool { get }
    var superPowers: [String: Int] { get set }
    
    mutating func attack(target: SuperEnemy) -> Int
    mutating func performSuperPower(target: SuperEnemy) -> Int
}

// სუპერგმირის ექსტენზენის დეფინიცია
extension Superhero {
    func printInformation() {
        print("Name: \(name)")
        print("Alias: \(alias)")
        print("Is Evil: \(isEvil)")
        print("Superpowers: \(superPowers)")
    }
}

// SpiderMan struct იმპლემენტაცია
struct SpiderMan: Superhero {
    var name: String
    var alias: String
    var isEvil: Bool
    var superPowers: [String: Int]
    
    mutating func attack(target: SuperEnemy) -> Int {
        let damage = Int.random(in: 20...40)
        target.hitPoints -= damage
        return target.hitPoints
    }
    
    mutating func performSuperPower(target: SuperEnemy) -> Int {
        guard let (superPower, damage) = superPowers.first else {
            return target.hitPoints
        }
        
        target.hitPoints -= damage
        superPowers.removeValue(forKey: superPower)
        
        return target.hitPoints
    }
}

// SuperheroSquad კლასის განსაზღვრა
class SuperheroSquad {
    var superheroes: [Superhero]
    
    init(superheroes: [Superhero]) {
        self.superheroes = superheroes
    }
    
    func listSuperheroes() {
        for superhero in superheroes {
            superhero.printInformation()
        }
    }
    
    func simulateShowdown(enemy: SuperEnemy) {
        var remainingSuperheroes = superheroes
        
        while enemy.hitPoints > 0 && !remainingSuperheroes.isEmpty {
            for (index, var superhero) in remainingSuperheroes.enumerated() {
                if superhero.superPowers.isEmpty {
                    // Use the last normal attack
                    _ = superhero.attack(target: enemy)
                } else {
                    let randomIndex = Int.random(in: 0..<superhero.superPowers.count)
                    let (superPower, _) = Array(superhero.superPowers)[randomIndex]
                    _ = superhero.performSuperPower(target: enemy)
                    print("\(superhero.name) used \(superPower)!")
                }
                
                if enemy.hitPoints <= 0 {
                    print("The enemy was defeated!")
                    return
                }
                
                remainingSuperheroes[index] = superhero
            }
        }
        
        print("The superheroes ran out of superpowers and could not defeat the enemy.")
    }
}

// ტესტ დრაივი
var spiderMan = SpiderMan(name: "Peter Parker", alias: "Spider-Man", isEvil: false, superPowers: ["Web Slinging": 25, "Super Strength": 30])
let superman = SpiderMan(name: "Clark Kent", alias: "Superman", isEvil: false, superPowers: ["Flight": 35, "Heat Vision": 40])

let squad = SuperheroSquad(superheroes: [spiderMan, superman])
squad.listSuperheroes()
let enemy = SuperEnemy(name: "Evil Villain", hitPoints: 100)
squad.simulateShowdown(enemy: enemy)
