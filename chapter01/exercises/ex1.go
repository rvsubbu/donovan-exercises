/**
	Exercise 1.1: Command-Line Arguments Enhancement [ELEMENTARY]
	Difficulty: Easy
	Modify the echo program to print the index and value of each argument, one per line.
**/

package exercises

import (
	"fmt"
	"os"
)

func Ex1_1() {
	for i, arg := range os.Args {
		fmt.Printf("Arg[%d]: %s\n", i, arg)
	}
}
