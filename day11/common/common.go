package common

import (
	"fmt"
	"os"
)

func Checkerr(err error) {
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(2)
	}
}
