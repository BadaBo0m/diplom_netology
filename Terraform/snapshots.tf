resource "yandex_compute_snapshot_schedule" "default" {
  name           = "my-name"

  schedule_policy {
    # USE GMT time "mm hh dd mm DOW"
    expression = "0 0 * * *"
  }

  snapshot_count = 7

  snapshot_spec {
      description = "snapshot-description"
      labels = {
        snapshot-label = "my-snapshot-label-value"
      }
  }

  labels = {
    my-label = "my-label-value"
  }

  disk_ids = [
    yandex_compute_instance.vm-1.boot_disk[0].disk_id,
    yandex_compute_instance.vm-2.boot_disk[0].disk_id,
    yandex_compute_instance.vm-3.boot_disk[0].disk_id,
    yandex_compute_instance.vm-4.boot_disk[0].disk_id,
    yandex_compute_instance.vm-5.boot_disk[0].disk_id,
    yandex_compute_instance.vm-6.boot_disk[0].disk_id,
    yandex_compute_instance.vm-7.boot_disk[0].disk_id,
    ]
}
