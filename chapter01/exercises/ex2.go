/**
	Exercise 1.2: Argument Separator [MEDIUM]
	Difficulty: Medium

	Write a program that prints all command-line arguments separated by a single space, but implements three different approaches:
		1. Using `strings.Join()`
		2. Using a loop with `+=` concatenation
		3. Using `fmt.Sprint()` family of functions

	Compare performance using benchmarks. Which approach would you choose for production code and why?
**/

package exercises

import (
	"fmt"
	"os"
	"strings"
)

func Ex1_2() {
	fmt.Println(stringJoin(os.Args))
	fmt.Println(loopConcat(os.Args))
	fmt.Println(fmtSprint(os.Args))
}

func stringJoin(strs []string) string {
	return strings.Join(strs, " ")
}

func loopConcat(strs []string) string {
	var out string
	for i, s := range strs {
		out += s
		if i < len(strs)-1 {
			out += " "
		}
	}
	return out
}

func fmtSprint(strs []string) string {
	// Use fmt.Sprint in a loop - cleaner than type conversion
	if len(strs) == 0 {
		return ""
	}
	result := fmt.Sprint(strs[0])
	for _, s := range strs[1:] {
		result += " " + fmt.Sprint(s)
	}
	return result
}
