package main

import (
	"fmt"
	"math/rand"
)

func atc() {
	var ch = make([]int, 0, 100)
	var bh = make(map[int]int, 100)
	s := 0

	for i := 0; i < 100; i++ {
		s = rand.Intn(100)
		ch = append(ch, s)
		bh[ch[i]] = 0
	}
	fmt.Printf("有多少个不同的数:%d\n", len(bh))

}

func main() {
	atc()
}
