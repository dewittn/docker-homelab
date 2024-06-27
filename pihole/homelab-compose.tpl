---
services:
  pihole:
    build:
      context: .
      dockerfile_inline: |
        FROM pihole/pihole:latest
        ADD 03-custom.conf /etc/dnsmasq.d/
    networks:
      - traefik
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    environment:
      TZ: "America/New_York"
      WEBPASSWORD: "op://$APP_ENV/pihole/password"
      ServerIP: op://$APP_ENV/pihole/ServerIP
      DNS1: 127.0.0.1:5335
    volumes:
      - etc-pihole:/etc/pihole
      - etc-dnsmasq:/etc/dnsmasq.d
    restart: unless-stopped
    labels:
      - "traefik.http.services.pihole.loadbalancer.server.port=80"
      - "traefik.http.routers.pihole.rule=Host(`op://$APP_ENV/pihole/ServerIP`) || Host(`op://$APP_ENV/pihole/website`)"

volumes:
    etc-pihole:
    etc-dnsmasq: