package main

import (
	"fmt"
	"sync"
)

var n int32
var lock sync.RWMutex
var wg2 sync.WaitGroup

func main() {
	wg2.Add(1000)
	for i := 0; i < 1000; i++ {
		go func() {
			defer wg2.Done()
			lock.Lock()
			n++
			lock.Unlock()
		}()
	}
	wg2.Wait()
	fmt.Println(n)
}
