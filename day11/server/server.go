package main

import (
	"day11/common"
	"fmt"
	"net"
)

func output(conn net.Conn) {
	defer conn.Close()
	for {
		request := make([]byte, 256)
		n, err := conn.Read(request)
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Printf("hello %s\n", request[:n])
		_, err = conn.Write([]byte("hello " + string(request[:n])))
		fmt.Printf("成功")
	}
}

func main() {
	tcpaddress, err := net.ResolveTCPAddr("tcp", "127.0.0.1:5656")
	common.Checkerr(err)
	listen, err := net.ListenTCP("tcp4", tcpaddress)
	common.Checkerr(err)
	for {
		conn, err := listen.Accept()
		common.Checkerr(err)
		go output(conn)
	}
}
