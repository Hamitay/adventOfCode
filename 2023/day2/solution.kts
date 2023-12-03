import java.io.File

val lines = File("input").readLines()
val testInput = File("testInput").readLines()

// Part 1
val games = lines.map { Game.fromString(it) }


val firstResult = games
        .filter { it.isPossibleGame(12, 13, 14) }
        .map { it.id }
        .sumOf { it.toInt() }

println(firstResult)

// Part 2
val secondResult = games
        .sumOf { it.getGamePower() }

println(secondResult)

data class Game(val id: String, val redCubes: Int, val blueCubes: Int, val greenCubes: Int) {

    fun isPossibleGame(redCubes: Int, greenCubes:Int, blueCubes:Int): Boolean {
        return redCubes >= this.redCubes && blueCubes >= this.blueCubes && greenCubes >= this.greenCubes
    }

    fun getGamePower(): Int {
        return this.redCubes*this.greenCubes*this.blueCubes
    }

    companion object {
        fun fromString(gameStr: String): Game {
            val id = gameStr.split(":")
                    .first()
                    .replace("Game ", "")

            fun findColor(color: String, input: String): Int {
                val match = "\\d* ${color}".toRegex()
                        .find(input)
                        ?.value ?: return 0

                return "\\d*".toRegex().find(match)?.value?.toIntOrNull() ?: 0
            }


            val cubes = gameStr
                    .split(";")
                    .map {
                        listOf(
                                findColor("red", it),
                                findColor("blue", it),
                                findColor("green", it)
                        )
                    }.fold(listOf(0,0,0)) { acc, pulls ->
                        listOf(acc[0].coerceAtLeast(pulls[0]), acc[1].coerceAtLeast(pulls[1]), acc[2].coerceAtLeast(pulls[2]))
                    }

            return Game(id, redCubes = cubes[0], blueCubes = cubes[1], greenCubes = cubes[2])
        }
    }
}