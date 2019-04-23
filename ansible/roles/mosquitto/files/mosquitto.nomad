job "mosquitto" {

  region = "global"
  
  datacenters = ["dc1"]
  
  type = "service"

  group "app" {
    count = 1

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "mosquitto" {
      driver = "docker"

      config {
        image = "google/mosquitto:latest"
        force_pull = true
        volumes = [
      	  "/:/rootfs:ro",
          "/var/run:/var/run:rw",
          "/sys:/sys:ro",
          "/var/lib/docker/:/var/lib/docker:ro",
          "/cgroup:/cgroup:ro"
        ]
        port_map {
          http = 8080
        }
      }

      service {
        name = "mosquitto"

        port = "http"

        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu    = 50
        memory = 100

        network {
          port "http" { }
        }
      }
    }
  }
}
