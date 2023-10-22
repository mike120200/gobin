package work2

import (
	"fmt"
	"time"
)

func Dayke() {
	now := time.Now()
	sub := 6 - int(now.Weekday())
	interval := sub
	if sub == 0 {
		interval = 7
	}
	saturday := now.Add(24 * time.Duration(interval) * time.Hour)
	fmt.Println(saturday.Format("2006-01-02"))
	for i := 0; i < 3; i++ {
		saturday = saturday.Add(24 * 7 * time.Hour)
		fmt.Println(saturday.Format("2006-01-02"))
	}
}
