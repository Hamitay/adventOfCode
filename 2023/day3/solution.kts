import java.io.File

val input = File("input").readLines()
val testInput = File("testInput").readLines()

// Part 1
val schematic = Schematic.fromStringInput(input)

val partNumbers = schematic.getPartNumbers()

val result = partNumbers.sumOf { it.value }

println(result)

// Part 2
val gearRatio = schematic.getGearRatio()
println(gearRatio)

data class SchematicNumber(
        val value: Int,
        val minX: Int,
        val maxX: Int,
        val row: Int,
) {
    fun isPartNumber(rawSchematic: List<String>): Boolean {

        // Delimiters
        val minXDel = Math.max(0, minX-1)
        val maxXDel = Math.min(maxX+1, rawSchematic[0].length-1)
        val minRow = Math.max(0, row-1)
        val maxRow = Math.min(row+1, rawSchematic.size-1)

        val neighbors = listOf(rawSchematic[row][minXDel], rawSchematic[row][maxXDel]) +
                rawSchematic[minRow].substring(minXDel, maxXDel+1).toCharArray().toList() +
                rawSchematic[maxRow].substring(minXDel, maxXDel+1).toCharArray().toList()

        return neighbors.any { it != '.' && !it.isDigit() }
    }

    fun isAdjacent(x: Int, y: Int): Boolean {
        val minXDel = minX-1
        val maxXDel = maxX+1
        val minRow = row - 1
        val maxRow = row + 1

        //Find all pairs
        //Upper
        val neighbors = (minXDel..maxXDel).map { Pair(it, minRow) } +
        (minXDel..maxXDel).map { Pair(it, maxRow) } + Pair(minXDel, row) + Pair(maxXDel, row)

        return neighbors.any { it.first == x && it.second == y }
    }
}

data class Schematic(
        val numbers: List<SchematicNumber>,
        val raw: List<String>
) {
    companion object {
        fun fromStringInput(schematicStr: List<String>): Schematic {

            val numbers = schematicStr.foldIndexed(emptyList<SchematicNumber>()) { index, numberList, row ->
                val numbers = "\\d*".toRegex().findAll(row).
                        filter { it.value.isNotBlank() }.
                        map {
                            SchematicNumber(it.value.toInt(), it.range.first, it.range.last, index)
                        }

                numberList + numbers
            }

            return Schematic(numbers, schematicStr)
        }
    }

    fun getPartNumbers(): List<SchematicNumber> {
        return numbers.filter { it.isPartNumber(this.raw) }
    }

    fun getGearRatio(): Int {
        val partNumbers = getPartNumbers()

        return this.raw.foldIndexed(0) { index, acc, row ->
            val possibleGears = "\\*".toRegex().findAll(row).toList()

            var sum = 0
            possibleGears.map { gear ->
                val x = gear.range.first
                val y = index

                val adjacentParts = partNumbers.filter { it.isAdjacent(x, y) }
                if (adjacentParts.size == 2) {
                    sum += adjacentParts[0].value * adjacentParts[1].value
                }
            }

            acc+sum
        }
    }
}