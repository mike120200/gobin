package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"sync"
)

var filechan = make(chan string, 10000)

var wg sync.WaitGroup

var writeFinish = make(chan struct{})

func readFile(filename string) {
	defer func() {
		wg.Done()
	}()

	fin, err := os.Open(filename)
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	defer fin.Close()
	reader := bufio.NewReader(fin)
	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				if len(line) > 0 {
					line += "\n"
					filechan <- line
				}
				break
			} else {
				fmt.Println(err)
				break
			}
		} else {
			filechan <- line
		}
	}
}

func writeFile(filename string) {
	defer close(writeFinish)
	fout, err := os.OpenFile(filename, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, os.ModePerm)
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	defer fout.Close()
	writer := bufio.NewWriter(fout)
	for {
		line, ok := <-filechan
		if len(line) == 0 {
			if ok {
				writer.WriteString(line)
			} else {
				break
			}
		} else {
			writer.WriteString(line)
		}
	}
	writer.Flush()
}

func main1() {
	wg.Add(3)
	for i := 1; i <= 3; i++ {
		fileName := "dir/" + strconv.Itoa(i)
		go readFile(fileName)
	}
	go writeFile("dir/merge")
	wg.Wait()
	close(filechan)
	<-writeFinish
}
