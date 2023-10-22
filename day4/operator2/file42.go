package main

import "fmt"

func jungleseasonif(month int) {
	if month == 12 || month == 1 || month == 2 {
		fmt.Printf("现在的季节是冬季\n")
	}
	if month == 3 || month == 4 || month == 5 {
		fmt.Printf("现在的季节是春季\n")
	}
	if month == 6 || month == 7 || month == 8 {
		fmt.Printf("现在的季节是夏季\n")
	}
	if month == 9 || month == 10 || month == 11 {
		fmt.Printf("现在的季节是秋季\n")
	}
}

func jungleseasonswitch(month int) {
	switch month {
	case 12, 1, 2:
		fmt.Printf("现在的季节是冬季")
	case 3, 4, 5:
		fmt.Printf("现在的季节是春季")
	case 6, 7, 8:
		fmt.Printf("现在的季节是夏季")
	case 9, 10, 11:
		fmt.Printf("现在的季节是秋季")
	}
}

func main() {
	jungleseasonif(8)
	jungleseasonswitch(12)
}
