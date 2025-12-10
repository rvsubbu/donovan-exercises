/**
	Exercise 1.3: Duplicate Line Counter with Line Numbers [HARD]
	Difficulty: Hard

	Extend the duplicate line finder to:
		1. Show the line numbers where each duplicate occurs
		2. Support reading from multiple files simultaneously
		3. Handle very large files (>1GB) efficiently
		4. Provide a flag to show only duplicates that appear more than N times

	FAANG Interview Aspect: How would you optimize memory usage for extremely large files? What if the file doesn't fit in memory?

	Notes:
		Uses sha256 hashing of each line to handle large files. Collision probability is low, but non-zero.
		Possible improvements to reduce collision probability further:
			1. sha512?
			2. Store the line length along each line data? Will tell me that there is a collision, but I can't find the previous value anyway
			3. Store the first 32 chars of orig line along each line data? Will tell me that there is a collision, but I can't find the previous value anyway
		To eliminate collisions completely:
			Make two passes, in the second pass store the full strings and counts
		Possible optimization if the data is going to have long lines (>32 bytes)
			Use [32]byte as the key instead of strings, and always use the hash value
			Current fmt.Sprint of hash key makes us use 64 bytes for longer strings
			May also consider a 128 bit hash; doubles the collision probability, but still small
		Deliberate choice to use an unbuffered channel, channel consumer is much faster than file i/o
**/

package exercises

import (
	"bufio"
    "crypto/sha256"
	"fmt"
	"os"
	"sync"
)

type rawLineData struct {
	lineText string
	fileName string
	lineNum int
}

type lineData struct {
	locations map[string][]int
	count int
}

func hashString(s string) string {
	// Accept the risk of collisions

    return fmt.Sprintf("%x", sha256.Sum256([]byte(s)))
}

func getKey(s string) string {
	if len(s) < 32 {
		return s
	}
	return hashString(s)
}

func collectLines(fileName string, lines chan<- rawLineData, wg *sync.WaitGroup) {
	defer wg.Done()

	var input *bufio.Scanner
	if fileName == "stdin" {
		input = bufio.NewScanner(os.Stdin)
	} else {
		file, err := os.Open(fileName)
		if err != nil {
			fmt.Printf("Error in opening %s, discarding it\n", fileName)
			return
		}
		defer file.Close()
		input = bufio.NewScanner(file)
	}
	lineNum := 0
	for input.Scan() {
		inputText := input.Text()
		lineNum++
		rawLineDatum := rawLineData{lineText: getKey(inputText), lineNum: lineNum, fileName: fileName}
		lines<- rawLineDatum
	}
}

func DupDetectFiles(threshold int, sorted bool, files ...string) {
	if len(files) == 0 {
		// Read stdin as no file is specified
		DupDetect(threshold)
		return
	}

	if sorted {
		// Assumption; only one file, it is sorted, enough to give starting and ending line nums
		DupDetectSorted(threshold, files[0])
		return
	}

	var wg sync.WaitGroup 
	lines := make(chan rawLineData)
	counts := make(map[string]lineData)
	done := make(chan bool)

	go func() {
		for rawLineDatum := range lines {
			lineDatum, ok := counts[rawLineDatum.lineText]
			if !ok {
				lineDatum.locations = make(map[string][]int)
				lineDatum.locations[rawLineDatum.fileName] = []int{rawLineDatum.lineNum}
			} else {
				lineDatum.locations[rawLineDatum.fileName] = append(lineDatum.locations[rawLineDatum.fileName], rawLineDatum.lineNum)
			}
			lineDatum.count++
			counts[rawLineDatum.lineText] = lineDatum
		}
		fmt.Println("----")
		for line, lineDatum := range counts {
			if lineDatum.count > threshold {
				fmt.Printf("%d\t%s\n", lineDatum.count, line)
				for fileName, lineNums := range lineDatum.locations {
					fmt.Printf("\tFileName: %s, lineNums: %+v\n", fileName, lineNums)
				}
			}
		}
		done<-true
	}()

	for _, f := range files {
		wg.Add(1)
		go collectLines(f, lines, &wg)
	}
	wg.Wait()
	close(lines)
	<-done
}

func DupDetectSorted(threshold int, fileName string) {
	// Assumption; sorted file, enough to give starting and ending line nums

	file, err := os.Open(fileName)
	if err != nil {
		fmt.Printf("Error in opening %s, discarding it\n", fileName)
		return
	}
	defer file.Close()
	input := bufio.NewScanner(file)

	counts := make(map[string]lineData)
	i := 1
	prevInputText := ""

	for input.Scan() {
		inputText := input.Text()
		lineDatum, ok := counts[inputText]
		if !ok {
			lineDatum.locations = make(map[string][]int)
			lineDatum.locations[fileName] = []int{i}
			if prevInputText != "" {
				prevLineDatum.locations[fileName] = append(prevLineDatum.locations[fileName], i-1)
				counts[prevInputText] = prevLineDatum
			}
			prevInputText = inputText
		}
		lineDatum.count++
		counts[inputText] = lineDatum
		i++
	}
	fmt.Println("")
	for line, lineDatum := range counts {
		if lineDatum.count > threshold {
			fmt.Printf("%d\t%s\tstart: %d, end: %d\n", lineDatum.count, line, lineDatum.locations[fileName][0], lineDatum.locations[fileName][1])
		}
	}
}

func DupDetect(threshold int) {
	// Reads only stdin
	counts := make(map[string]lineData)
	input := bufio.NewScanner(os.Stdin)
	i := 1
	for input.Scan() {
		inputText := input.Text()
		lineDatum, ok := counts[inputText]
		if !ok {
			lineDatum.locations = make(map[string][]int)
			lineDatum.locations["stdin"] = []int{i}
		} else {
			lineDatum.locations["stdin"] = append(lineDatum.locations["stdin"], i)
		}
		lineDatum.count++
		counts[inputText] = lineDatum
		i++
	}
	fmt.Println("")
	for line, lineDatum := range counts {
		if lineDatum.count > threshold {
			fmt.Printf("%d\t%s\t%+v\n", lineDatum.count, line, lineDatum.locations["stdin"])
		}
	}
}

func OriginalDupDetect() {
	// DupDetect from Donovan & Ritchie
	counts := make(map[string]int)
	input := bufio.NewScanner(os.Stdin)
	for input.Scan() {
		counts[input.Text()]++
	}
	// NOTE: ignoring potential errors from input
	for line, n := range counts {
		if n > 1 {
			fmt.Printf("%d\t%s\n", n, line)
		}
	}
}
