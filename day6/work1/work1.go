package work1

import (
	"fmt"
	"time"
)

func Timeshow() {
	format := "2006-01-02 15:04:05"
	format2 := "20060102150405"
	s1 := time.Now().Format(format)
	fmt.Println(s1)
	loc, _ := time.LoadLocation("Asia/Shanghai")
	t, _ := time.ParseInLocation(format, s1, loc)
	now := t.Format(format2)
	fmt.Println(now)
}
