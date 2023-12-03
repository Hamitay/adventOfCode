import java.io.File

val inputPath = "input"

// val testLines = listOf("1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet")

val lines = File(inputPath).readLines()

// Part 1
val firstResult = lines
        .map { filterDigits(it) }
        .map { getCalibrationDigits(it) }
        .sumOf { it.toInt() }

println(firstResult)

// Part 2
val testLines = File("testInput").readLines()
val digitLiterals = listOf("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")

val secondResult = lines
        .map { replaceWithDigits(it) }
        .map { filterDigits(it) }
        .map { getCalibrationDigits(it) }
        .sumOf { it.toInt() }

println(secondResult)

fun replaceWithDigits(input: String): String {
    // Massage one and two because f-it
    val massagedInput = input
        .replace("one", "oonee")
        .replace("two", "ttwoo")

    return digitLiterals.foldIndexed(massagedInput) { idx, acc, literal ->
        acc.replace(literal, (idx+1).toString())
    }
}

fun filterDigits(input: String): String {
    return input.filter(Char::isDigit)
}

fun getCalibrationDigits(input: String): String {
    return "${input.first()}${input.last()}"
}