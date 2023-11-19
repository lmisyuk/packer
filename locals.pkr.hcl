locals {
  current_date = formatdate("DDMMYYYY", timestamp())
  current_time   = formatdate("hhmmss", timestamp())
}