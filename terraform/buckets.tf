
resource "google_storage_bucket" "processor_public" {
  name                        = "${var.environment}-nogales-public"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "processor_public_access" {
  bucket = google_storage_bucket.processor_public.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket" "processor_private" {
  name                        = "${var.environment}-nogales-private"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "wordpress_1" {
  name                        = "${var.environment}-wordpress-1"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}