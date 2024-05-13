# HIGH-AVAILABILITY FIREWALLS SCENARIOS

## Network Topology

image:
[Network Topology](./images/network_topology.png)

### R1

```
interface FastEthernet0/0
 ip address 10.1.1.10 255.255.255.0
 speed auto
 duplex auto
!
interface FastEthernet0/1
 ip address 10.2.2.10 255.255.255.0
 speed auto
 duplex auto
!
interface FastEthernet1/0
 no ip address
 shutdown
 speed auto
 duplex auto
!
interface FastEthernet1/1
 no ip address
 shutdown
 speed auto
 duplex auto
!
ip forward-protocol nd
!
!
no ip http server
no ip http secure-server
ip route 0.0.0.0 0.0.0.0 10.1.1.2
ip route 0.0.0.0 0.0.0.0 10.1.1.1
```

### R2

```
interface FastEthernet0/0
 ip address 200.1.1.10 255.255.255.0
 speed auto
 duplex auto
!
interface FastEthernet0/1
 ip address 200.2.2.10 255.255.255.0
 speed auto
 duplex auto
!
interface FastEthernet1/0
 no ip address
 shutdown
 speed auto
 duplex auto
!
interface FastEthernet1/1
 no ip address
 shutdown
 speed auto
 duplex auto
!
ip forward-protocol nd
!
!
no ip http server
no ip http secure-server
ip route 10.0.0.0 255.0.0.0 200.1.1.1
ip route 10.0.0.0 255.0.0.0 200.1.1.2
ip route 192.1.0.0 255.255.254.0 200.1.1.1 # dmz
```

### LB1A

```
high-availability {
    vrrp {
        group LB1Cluster {
            interface eth1
            rfc3768-compatibility
            virtual-address 10.0.0.1/30
            vrid 1
        }
        sync-group LB1Cluster {
            member LB1Cluster
        }
    }
}
interfaces {
    ethernet eth0 {
        address 10.1.1.1/24
        hw-id 08:00:27:b3:6a:49
    }
    ethernet eth1 {
        address 10.0.0.1/30
        hw-id 08:00:27:b5:42:52
    }
    ethernet eth2 {
        address 10.0.0.5/30
        hw-id 08:00:27:aa:bf:d4
    }
    ethernet eth3 {
        address 10.0.0.9/30
        hw-id 08:00:27:9a:44:08
    }
    ethernet eth4 {
        hw-id 08:00:27:da:7f:ce
    }
    ethernet eth5 {
        hw-id 08:00:27:b3:6b:1e
    }
    loopback lo {
    }
}
load-balancing {
    wan {
        disable-source-nat
        interface-health eth2 {
            nexthop 10.0.0.6
        }
        interface-health eth3 {
            nexthop 10.0.0.10
        }
        rule 1 {
            inbound-interface eth0
            interface eth2 {
                weight 1
            }
            interface eth3 {
                weight 1
            }
            protocol all
        }
        sticky-connections {
            inbound
        }
    }
}
protocols {
    static {
        route 10.2.2.0/24 {
            next-hop 10.1.1.10 {
            }
        }
    }
}
service {
    conntrack-sync {
        accept-protocol tcp,udp,icmp
        disable-external-cache
        failover-mechanism {
            vrrp {
                sync-group LB1Cluster
            }
        }
        interface eth1 {
        }
        mcast-group 225.0.0.50
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name LB1A
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
}
```

### LB1B

```
high-availability {
    vrrp {
        group LB1Cluster {
            interface eth1
            rfc3768-compatibility
            virtual-address 10.0.0.1/30
            vrid 1
        }
        sync-group LB1Cluster {
            member LB1Cluster
        }
    }
}
interfaces {
    ethernet eth0 {
        address 10.1.1.2/24
        duplex auto
        hw-id 08:00:27:87:24:0f
        smp-affinity auto
        speed auto
    }
    ethernet eth1 {
        address 10.0.0.2/30
        duplex auto
        hw-id 08:00:27:7d:a0:6c
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.0.0.17/30
        duplex auto
        hw-id 08:00:27:a0:e1:1c
        smp-affinity auto
        speed auto
    }
    ethernet eth3 {
        address 10.0.0.13/30
        duplex auto
        hw-id 08:00:27:0d:ac:1e
        smp-affinity auto
        speed auto
    }
    ethernet eth4 {
        duplex auto
        hw-id 08:00:27:82:c3:9d
        smp-affinity auto
        speed auto
    }
    ethernet eth5 {
        duplex auto
        hw-id 08:00:27:22:25:e5
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
load-balancing {
    wan {
        disable-source-nat
        interface-health eth2 {
            failure-count 1
            nexthop 10.0.0.18
            success-count 1
        }
        interface-health eth3 {
            failure-count 1
            nexthop 10.0.0.14
            success-count 1
        }
        rule 1 {
            inbound-interface eth0
            interface eth2 {
                weight 1
            }
            interface eth3 {
                weight 1
            }
            protocol all
        }
        sticky-connections {
            inbound
        }
    }
}
protocols {
    static {
        route 0.0.0.0/0 {
            next-hop 10.0.0.14 {
            }
            next-hop 10.0.0.18 {
            }
        }
        route 10.0.0.0/30 {
            next-hop 10.0.0.1 {
            }
        }
        route 10.0.0.12/30 {
            next-hop 10.0.0.14 {
            }
        }
        route 10.0.0.16/30 {
            next-hop 10.0.0.18 {
            }
        }
        route 10.2.2.0/24 {
            next-hop 10.1.1.10 {
            }
        }
    }
}
service {
    conntrack-sync {
        accept-protocol tcp,udp,icmp
        disable-external-cache
        event-listen-queue-size 8
        failover-mechanism {
            vrrp {
                sync-group LB1Cluster
            }
        }
        interface eth1 {
        }
        mcast-group 225.0.0.50
        sync-queue-size 1
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name LB1B
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
```

### FW1

```
firewall {
    all-ping enable
    broadcast-ping disable
    config-trap disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name FROM-INSIDE-TO-OUTSIDE {
        default-action drop
        rule 10 {
            action accept
            destination {
                port 5000-6000
            }
            protocol udp
        }
        rule 20 {
            action accept
            description "Accept ICMP Echo Request"
            icmp {
                type 8
            }
            protocol icmp
        }
    }
    name FROM-OUTSIDE-TO-INSIDE {
        default-action drop
        rule 10 {
            action accept
            state {
                established enable
                related enable
            }
        }
    }
    name TO-INSIDE {
        rule 20 {
            action accept
            description "Accept Established-Related Connections"
            state {
                established enable
                related enable
            }
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
    twa-hazards-protection disable
}
interfaces {
    ethernet eth0 {
        address 10.0.0.14/30
        duplex auto
        hw-id 08:00:27:0b:7d:e5
        smp-affinity auto
        speed auto
    }
    ethernet eth1 {
        address 10.0.0.25/30
        duplex auto
        hw-id 08:00:27:33:6b:e0
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.0.0.6/30
        duplex auto
        hw-id 08:00:27:37:61:27
        smp-affinity auto
        speed auto
    }
    ethernet eth3 {
        address 10.0.0.21/30
        duplex auto
        hw-id 08:00:27:7a:08:5d
        smp-affinity auto
        speed auto
    }
    ethernet eth4 {
        duplex auto
        hw-id 08:00:27:26:98:4a
        smp-affinity auto
        speed auto
    }
    ethernet eth5 {
        duplex auto
        hw-id 08:00:27:57:82:ee
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
nat {
    source {
        rule 10 {
            outbound-interface eth3
            source {
                address 10.0.0.0/8
            }
            translation {
                address 192.1.0.1-192.1.0.10
            }
        }
        rule 20 {
            outbound-interface eth1
            source {
                address 10.0.0.0/8
            }
            translation {
                address 192.1.0.1-192.1.0.10
            }
        }
    }
}
protocols {
    static {
        route 0.0.0.0/0 {
            next-hop 10.0.0.22 {
            }
            next-hop 10.0.0.26 {
            }
        }
        route 10.0.0.0/12 {
            next-hop 10.0.0.5 {
            }
            next-hop 10.0.0.13 {
            }
        }
        route 10.0.0.0/24 {
            next-hop 10.0.0.5 {
            }
            next-hop 10.0.0.13 {
            }
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name FW1
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
zone-policy {
    zone DMZ {
        description "DMZ (Server Farm)"
        interface eth4
    }
    zone INSIDE {
        default-action drop
        description "Inside (Internal Network)"
        from OUTSIDE {
            firewall {
                name TO-INSIDE
            }
        }
        interface eth2
        interface eth0
    }
    zone OUTSIDE {
        default-action drop
        description "Outside (Internet)"
        from INSIDE {
            firewall {
                name FROM-INSIDE-TO-OUTSIDE
            }
        }
        interface eth1
        interface eth3
    }
}
```

### FW2

```
firewall {
    all-ping enable
    broadcast-ping disable
    config-trap disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name FROM-INSIDE-TO-OUTSIDE {
        default-action drop
        rule 10 {
            action accept
            destination {
                port 5000-6000
            }
            protocol udp
        }
        rule 20 {
            action accept
            description "Accept ICMP Echo Request"
            icmp {
                type 8
            }
            protocol icmp
        }
    }
    name FROM-OUTSIDE-TO-INSIDE {
        default-action drop
        rule 10 {
            action accept
            state {
                established enable
                related enable
            }
        }
    }
    name TO-INSIDE {
        rule 20 {
            action accept
            description "Accept Established-Related Connections"
            state {
                established enable
                related enable
            }
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
    twa-hazards-protection disable
}
interfaces {
    ethernet eth0 {
        address 10.0.0.10/30
        duplex auto
        hw-id 08:00:27:b0:46:3e
        smp-affinity auto
        speed auto
    }
    ethernet eth1 {
        address 10.0.0.29/30
        duplex auto
        hw-id 08:00:27:7b:0c:4e
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.0.0.18/30
        duplex auto
        hw-id 08:00:27:1b:99:1c
        smp-affinity auto
        speed auto
    }
    ethernet eth3 {
        address 10.0.0.33/30
        duplex auto
        hw-id 08:00:27:24:3e:54
        smp-affinity auto
        speed auto
    }
    ethernet eth4 {
        duplex auto
        hw-id 08:00:27:7a:55:3c
        smp-affinity auto
        speed auto
    }
    ethernet eth5 {
        duplex auto
        hw-id 08:00:27:88:8b:b5
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
nat {
    source {
        rule 10 {
            outbound-interface eth3
            source {
                address 10.0.0.0/8
            }
            translation {
                address 192.1.0.11-192.1.0.20
            }
        }
        rule 20 {
            outbound-interface eth1
            source {
                address 10.0.0.0/8
            }
            translation {
                address 192.1.0.11-192.1.0.20
            }
        }
    }
}
protocols {
    static {
        route 0.0.0.0/0 {
            next-hop 10.0.0.30 {
            }
            next-hop 10.0.0.34 {
            }
        }
        route 10.0.0.0/12 {
            next-hop 10.0.0.9 {
            }
            next-hop 10.0.0.17 {
            }
        }
        route 10.0.0.0/24 {
            next-hop 10.0.0.9 {
            }
            next-hop 10.0.0.17 {
            }
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name FW2
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
zone-policy {
    zone DMZ {
        description "DMZ (Server Farm)"
        interface eth4
    }
    zone INSIDE {
        description "Inside (Internal Network)"
        from OUTSIDE {
            firewall {
                name TO-INSIDE
            }
        }
        interface eth0
        interface eth2
    }
    zone OUTSIDE {
        description "Outside (Internet)"
        from INSIDE {
            firewall {
                name FROM-INSIDE-TO-OUTSIDE
            }
        }
        interface eth1
        interface eth3
    }
}
```

### LB2A

```
high-availability {
    vrrp {
        group LB2Cluster {
            interface eth1
            rfc3768-compatibility
            virtual-address 192.168.100.1/24
            vrid 2
        }
        sync-group LB2Cluster {
            member LB2Cluster
        }
    }
}
interfaces {
    ethernet eth0 {
        address 200.1.1.1/24
        duplex auto
        hw-id 08:00:27:03:ff:b4
        smp-affinity auto
        speed auto
    }
    ethernet eth1 {
        address 10.0.0.38/30
        duplex auto
        hw-id 08:00:27:ca:81:67
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.0.0.22/30
        duplex auto
        hw-id 08:00:27:10:d8:52
        smp-affinity auto
        speed auto
    }
    ethernet eth3 {
        address 10.0.0.30/30
        duplex auto
        hw-id 08:00:27:62:50:a5
        smp-affinity auto
        speed auto
    }
    ethernet eth4 {
        duplex auto
        hw-id 08:00:27:a7:49:c3
        smp-affinity auto
        speed auto
    }
    ethernet eth5 {
        duplex auto
        hw-id 08:00:27:35:76:df
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
load-balancing {
    wan {
        disable-source-nat
        interface-health eth2 {
            failure-count 1
            nexthop 10.0.0.21
            success-count 1
        }
        interface-health eth3 {
            failure-count 1
            nexthop 10.0.0.29
            success-count 1
        }
        rule 1 {
            inbound-interface eth0
            interface eth2 {
                weight 1
            }
            interface eth3 {
                weight 1
            }
            protocol all
        }
        sticky-connections {
            inbound
        }
    }
}
protocols {
    static {
        route 200.2.2.0/24 {
            next-hop 200.1.1.10 {
            }
        }
    }
}
service {
    conntrack-sync {
        accept-protocol tcp,udp,icmp
        disable-external-cache
        event-listen-queue-size 8
        failover-mechanism {
            vrrp {
                sync-group LB2Cluster
            }
        }
        interface eth1 {
        }
        mcast-group 225.0.0.50
        sync-queue-size 1
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name LB2A
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
```

### LB2B

```
high-availability {
    vrrp {
        group LB2Cluster {
            interface eth1
            rfc3768-compatibility
            virtual-address 192.168.100.1/24
            vrid 2
        }
        sync-group LB2Cluster {
            member LB2Cluster
        }
    }
}
interfaces {
    ethernet eth0 {
        address 200.1.1.2/24
        duplex auto
        hw-id 08:00:27:0c:41:04
        smp-affinity auto
        speed auto
    }
    ethernet eth1 {
        address 10.0.0.37/30
        duplex auto
        hw-id 08:00:27:5d:4f:5d
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.0.0.34/30
        duplex auto
        hw-id 08:00:27:79:8c:2b
        smp-affinity auto
        speed auto
    }
    ethernet eth3 {
        address 10.0.0.26/30
        duplex auto
        hw-id 08:00:27:40:3c:9b
        smp-affinity auto
        speed auto
    }
    ethernet eth4 {
        duplex auto
        hw-id 08:00:27:30:f5:73
        smp-affinity auto
        speed auto
    }
    ethernet eth5 {
        duplex auto
        hw-id 08:00:27:9a:79:85
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
load-balancing {
    wan {
        disable-source-nat
        interface-health eth2 {
            failure-count 1
            nexthop 10.0.0.33
            success-count 1
        }
        interface-health eth3 {
            failure-count 1
            nexthop 10.0.0.26
            success-count 1
        }
        rule 1 {
            inbound-interface eth0
            interface eth2 {
                weight 1
            }
            interface eth3 {
                weight 1
            }
            protocol all
        }
        sticky-connections {
            inbound
        }
    }
}
protocols {
    static {
        route 200.2.2.0/24 {
            next-hop 200.1.1.10 {
            }
        }
    }
}
service {
    conntrack-sync {
        accept-protocol tcp,udp,icmp
        disable-external-cache
        event-listen-queue-size 8
        failover-mechanism {
            vrrp {
                sync-group LB2Cluster
            }
        }
        interface eth1 {
        }
        mcast-group 225.0.0.50
        sync-queue-size 1
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name LB2B
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
```
