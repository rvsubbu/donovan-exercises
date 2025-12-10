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
	"testing"
)

func BenchmarkStringJoin(b *testing.B) {
	hello := "hello"
	var strs []string

	for i := 0; i < 100; i++ {
		strs = append(strs, hello)
	}

    b.ResetTimer() // ignore setup time

    for i := 0; i < b.N; i++ {
        _ = stringJoin(strs)
    }
}

func BenchmarkLoopConcat(b *testing.B) {
	hello := "hello"
	var strs []string

	for i := 0; i < 100; i++ {
		strs = append(strs, hello)
	}

    b.ResetTimer() // ignore setup time

    for i := 0; i < b.N; i++ {
        _ = loopConcat(strs)
    }
}

func BenchmarkFmtSprint(b *testing.B) {
	hello := "hello"
	var strs []string

	for i := 0; i < 100; i++ {
		strs = append(strs, hello)
	}

    b.ResetTimer() // ignore setup time

    for i := 0; i < b.N; i++ {
        _ = fmtSprint(strs)
    }
}
