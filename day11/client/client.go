package main

import (
	"day11/common"
	"fmt"
	"net"
)

func main() {
	clientaddr, err := net.ResolveTCPAddr("tcp4", "127.0.0.1:5656")
	common.Checkerr(err)
	conn, err := net.DialTCP("tcp4", nil, clientaddr)
	common.Checkerr(err)
	for i := 0; i < 3; i++ {
		request := fmt.Sprintf("第%d号选手", i)
		conn.Write([]byte(request))
		reponse := make([]byte, 256)
		n, err := conn.Read(reponse)
		common.Checkerr(err)
		fmt.Printf("%v\n", string(reponse[:n]))
	}
	conn.Close()
}
