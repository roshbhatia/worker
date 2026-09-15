package repo

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/roshbhatia/go-utils/paths"
)

func WorkerDir(root string) string {
	return keyed(paths.AgentWorker(), root)
}

func WorkerKeyed(name string) bool {
	cut := strings.LastIndex(name, "-")
	if cut <= 0 || len(name)-cut-1 != 16 {
		return false
	}
	for _, r := range name[cut+1:] {
		if (r < '0' || r > '9') && (r < 'a' || r > 'f') {
			return false
		}
	}
	return true
}

func keyed(dir, root string) string {
	sum := sha256.Sum256([]byte(root))
	digest := hex.EncodeToString(sum[:])[:16]
	return fmt.Sprintf("%s/%s-%s", dir, filepath.Base(root), digest)
}
