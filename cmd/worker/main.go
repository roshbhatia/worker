package main

import (
	"github.com/roshbhatia/worker/internal/worker"
	"os"
)

func main() { os.Exit(worker.Run(os.Args[1:])) }
