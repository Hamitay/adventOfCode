import java.io.File
import kotlin.math.pow

val input = File("input").readLines()
val testInput = File("testInput").readLines()

// Part 1
val game = input.mapIndexed { index, str -> Card.fromString(str, index) }

val firstResult = game
        .sumOf{  it.getScore() }
println(firstResult)

// Part 2
val secondResult = getAllCards(game)
println(secondResult)

fun getAllCards(cards: List<Card>): Int {
    val cardMap = cards.associate { it.id to 1 }.toMutableMap()

    cards.forEach { card ->
        val cardsToUpdate = card.getMatchingNumbersSize()

        (card.id+1..card.id+cardsToUpdate).forEach {
            cardMap[it] = cardMap[it]!! + cardMap[card.id]!!
        }
    }

    return cardMap.map { it.value }.sum()
}
data class Card(
        val id: Int,
        val winningNumbers: HashSet<Int>,
        val numbers: List<Int>
) {
    companion object {
        fun fromString(str: String, id: Int): Card {
            val rawNumbers = str.split(":")[1]
                .split("|")

            val winningNumbers = rawNumbers[0]
                    .trim()
                    .split("\\s+".toRegex())
                    .map { it.toInt() }
                    .toHashSet()

            val numbers = rawNumbers[1]
                    .trim()
                    .split("\\s+".toRegex())
                    .map { it.toInt() }

            return Card(id, winningNumbers, numbers)
        }
    }

    fun getMatchingNumbersSize(): Int  {
        return numbers.filter { winningNumbers.contains(it) }.size
    }

    fun getScore(): Double {
        val matches = getMatchingNumbersSize().toDouble()

        if (matches == 0.0) {
            return 0.0
        }

        return 2.0.pow(matches - 1)
    }
}