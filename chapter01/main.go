/**
	Chapter 1: Tutorial - Exercises
	This is the main, the entry point
**/

package main

import (
	"fmt"

	"github.com/rvsubbu/donovan-exercises/chapter01/exercises"
)

func main() {
	fmt.Println("=== Chapter 1, Exercise 1 ===")
	exercises.Ex1()

	fmt.Println("\n=== Chapter 1, Exercise 2 ===")
	exercises.Ex2()

	fmt.Println("\n=== Chapter 1, Exercise 3 ===")
	// exercises.DupDetect(2)
	// exercises.DupDetectFiles(2, false)
	exercises.DupDetectFiles(2, false, "a", "b")
	exercises.DupDetectFiles(2, true, "sorteda")
}
