const input = require("./inputs");

const solve = (data) => {
  let max = 0;

  data.split("\n").reduce((prev, curr) => {
    if (curr === "") {
      max = prev > max ? prev : max;
      return 0;
    }

    return parseInt(prev) + parseInt(curr);
  }, 0);

  return max;
};

console.log(solve(input));
