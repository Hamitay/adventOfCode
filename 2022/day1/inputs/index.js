const fs = require("fs");

const inputsPath = {
  test: "./inputs/test",
  puzzle: "./inputs/puzzle",
};

const readInput = () => {
  const isTest = process.argv[2] === "test";
  const inputPath = isTest ? inputsPath.test : inputsPath.puzzle;

  return fs.readFileSync(inputPath).toString();
};

module.exports = readInput();
