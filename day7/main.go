package main

import (
	"container/list"
	"fmt"
)

type LRUCache struct {
	cache map[int]int
	lst   *list.List
	cap   int //容量上限
}

func NewLRUCache(cap int) *LRUCache {
	l := new(LRUCache)
	l.cap = cap
	l.cache = make(map[int]int, cap)
	l.lst = list.New()
	return l
}

func (l *LRUCache) Add(key, value int) {

	if len(l.cache) < l.cap {
		l.cache[key] = value
		l.lst.PushFront(key)
	} else {
		back := l.lst.Back()
		fmt.Println(back)
		delete(l.cache, back.Value.(int))
		l.lst.Remove(back)
		l.cache[key] = value
		l.lst.PushFront(key)
	}
}

func (l *LRUCache) find(key int) *list.Element {
	if l.lst.Len() == 0 {
		return nil
	}
	head := l.lst.Front()
	for {
		if head == nil {
			return nil
		}
		if head.Value.(int) == key {
			return head
		} else {
			head = head.Next()
		}
	}
	return nil
}

func (l *LRUCache) Get(key int) (int, bool) {
	value, exists := l.cache[key]
	ele := l.find(key)
	if ele != nil {
		l.lst.MoveToFront(ele)
	}
	return value, exists
}

func testLRU() {
	l := NewLRUCache(10)
	for i := 0; i < 10; i++ {
		l.Add(i, i)
	}
	for i := 0; i < 10; i += 2 {
		l.Get(i)
	}
	for i := 10; i < 15; i++ {
		l.Add(i, i)
	}
	for i := 0; i < 10; i++ {
		_, exists := l.Get(i)
		fmt.Printf("key: %d,  exists %t\n", i, exists)
	}
}

func main1() {
	testLRU()
}
