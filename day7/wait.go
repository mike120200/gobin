package main

import (
	"fmt"
	"sync"
	"time"
)

var wg sync.WaitGroup

func Add() {
	time.Sleep(1000 * time.Millisecond)
	fmt.Println("over")
	wg.Done()
}

func main5() {
	wg.Add(2)
	go Add()
	go Add()
	wg.Wait()
}
