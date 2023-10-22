package main

import (
	"fmt"
	"math/rand"
)

func creatematrix(row, list int) [][]int {
	a := make([][]int, row)
	for i := 0; i < row; i++ {
		a[i] = make([]int, list)
		for j := 0; j < list; j++ {
			a[i][j] = rand.Intn(10)
		}
	}
	return a
}

func addtwo(a, b [][]int) [][]int {
	sum := make([][]int, len(a))
	for i := 0; i < len(a); i++ {
		sum[i] = make([]int, len(a[i]))
		for j := 0; j < len(a[i]); j++ {
			sum[i][j] = a[i][j] + b[i][j]
		}
	}
	return sum
}

func main() {
	a := creatematrix(8, 5)
	b := creatematrix(8, 5)
	sum := addtwo(a, b)
	fmt.Println(a)
	fmt.Println(b)
	fmt.Println(sum)
}
