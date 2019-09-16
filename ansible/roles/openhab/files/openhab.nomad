job "openhab-job" {

  region = "global"

  datacenters = ["hcnp"]

  type = "service"

  group "openhab-service" {

    count = 1

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "openhab" {

      driver = "docker"

      env {
        EXTRA_JAVA_OPTS = "-Duser.timezone=Australia/Adelaide"
        USER_ID = 9001
        GROUP_ID = 9001
      }

      config {
        image = "openhab/openhab:latest"
        dns_servers = [
          "rpi-53"
        ]
        dns_search_domains = [
          "rpi-53"
        ]
#        labels {
#          traefik.frontend.rule = PathPrefixStrip:/openhab
#          traefik.backend = openhab
#          traefik.port = 8080
#          traefik.enable = true
#        }
        port_map {
          http = 8080
        }
        port_map {
          https = 443
        }
        port_map {
          ssh = 8101
        }
        port_map {
          lsp = 5007
        }
        volumes = [
          "/etc/localtime:/etc/localtime:ro",
          "/etc/timezone:/etc/timezone:ro",
          "/home/pi/Sync/openhab/addons:/openhab/addons",
          "/home/pi/Sync/openhab/conf:/openhab/conf",
          "/home/pi/Sync/openhab/userdata:/openhab/userdata",
        ]
      }

      resources {
        cpu = 500 # 500MHz
        memory = 512 # MB
        network {
          port "http" {
            static = 8080
          }
          port "https" {
            static = 8443
          }
          port "ssh" {
            static = 8101
          }
          port "lsp" {
            static = 5007
          }
        }
      }

      service {
        name = "openhab"
        port = "http"
#        tags = [
#          traefik.frontend.rule = PathPrefixStrip:/openhab,
#          traefik.backend = openhab,
#          traefik.port = 8080,
#          traefik.enable = true
#        ]
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "30s"
          timeout  = "5s"
          port     = "http"
        }
      }
      
    }

  }

}
