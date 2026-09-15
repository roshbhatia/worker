package main

import (
	"github.com/roshbhatia/worker/internal/watch"
	"os"
)

func main() { os.Exit(watch.Run(os.Args[1:])) }
