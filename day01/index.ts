import { readFile } from "fs/promises";

const input = await readFile("./day01/input.txt", "utf8");
const lines = input.split("\n");

const byElf: string[][] = [];
let currentElf: string[] = [];
for (const value of lines) {
  if (value === "") {
    byElf.push(currentElf);
    currentElf = [];
  } else {
    currentElf.push(value);
  }
}
const sumByElf = byElf.map((values) =>
  values.reduce((prev, curr) => prev + Number(curr), 0)
);

console.log("part 1", Math.max(...sumByElf));

// to optimize later, of course
const sorted = sumByElf.sort((a, b) => b - a);

console.log("part 2", sorted[0] + sorted[1] + sorted[2]);
