// +build slow

package azure_test

import (
	"strings"
	"testing"
	"time"

	"github.com/NeowayLabs/klb/tests/lib/azure/fixture"
)

func backupVM(t *testing.T, f fixture.F, vmname string, prefix string) string {

	res := execWithIPC(t, f, func(output string) {
		f.Shell.Run(
			"./testdata/backup_vm.sh",
			vmname,
			f.ResGroupName,
			prefix,
			f.Location,
			output,
		)
	})
	res = strings.TrimSpace(res)
	return strings.Trim(res, "\n")
}

func deleteBackups(t *testing.T, f fixture.F, vmname string, bkpprefix string) {
	f.Shell.Run("./testdata/delete_backups.sh", vmname, bkpprefix)
}

func testVMBackupOsDiskOnly(t *testing.T, f fixture.F) {
	vmSize := "Basic_A2"
	sku := "Standard_LRS"
	bkpprefix := "klb-bkp"

	resources := createVMResources(t, f)
	vm := createVM(t, f, resources.availSet, resources.nic, vmSize, sku)

	defer deleteBackups(t, f, vm, bkpprefix)
	backupVM(t, f, vm, bkpprefix)

	// TODO: call restore procedure
	// TODO: validate VMs have the same osdisk
}

func testVMBackup(t *testing.T, f fixture.F) {

	vmSize := "Basic_A2"
	sku := "Standard_LRS"
	bkpprefix := "klb-bkp"

	resources := createVMResources(t, f)
	vm := createVM(t, f, resources.availSet, resources.nic, vmSize, sku)

	disks := []VMDisk{
		// Different sizes is important to validate behavior
		{Name: genUniqName(), Size: 50, Sku: sku},
		{Name: genUniqName(), Size: 20, Sku: sku},
		{Name: genUniqName(), Size: 100, Sku: sku},
	}
	attachDisks(t, f, vm, disks)

	defer deleteBackups(t, f, vm, bkpprefix)
	backupVM(t, f, vm, bkpprefix)

	// TODO: call restore procedure
	// TODO: validate VMs have the same osdisk
	// TODO: validate VMs have the same disks
}

func TestVMBackup(t *testing.T) {
	t.Parallel()
	vmtesttimeout := 45 * time.Minute
	fixture.Run(t, "VMBackupOsDiskOnly", vmtesttimeout, location, testVMBackupOsDiskOnly)
	fixture.Run(t, "VMBackup", vmtesttimeout, location, testVMBackup)
}
