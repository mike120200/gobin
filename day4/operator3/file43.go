package main

import "fmt"

type Student struct {
	name                   string
	Chinese, Math, English float32
}

func createstudent(name string, C, M, E float32) Student {
	s := Student{name: name, Chinese: C, Math: M, English: E}
	return s
}

func averageeveryone(s Student) float32 {
	average := (s.Chinese + s.Math + s.English) / 3
	return average
}

func averageclass(s []Student) float32 {
	var sum float32
	for i := 0; i < len(s); i++ {
		sum += averageeveryone(s[i])
	}
	sum /= float32(len(s))
	fmt.Printf("班级的平均分为%g\n", sum)
	return sum
}

func main() {
	a := createstudent("欧阳", 100, 98, 98)
	b := createstudent("李", 78, 98, 98)
	c := createstudent("王", 98, 98, 98)
	d := createstudent("张", 80, 98, 98)
	e := createstudent("林", 10, 98, 98)
	s := make([]Student, 5)
	s[0] = a
	s[1] = b
	s[2] = c
	s[3] = d
	s[4] = e
	fmt.Printf("这位同学的平均分是%g\n", averageeveryone(s[1]))
	averageclass(s)
}
