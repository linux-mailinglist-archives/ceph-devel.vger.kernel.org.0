Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3504910D389
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2019 10:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfK2J6D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Nov 2019 04:58:03 -0500
Received: from mail-lf1-f43.google.com ([209.85.167.43]:34285 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfK2J6D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 Nov 2019 04:58:03 -0500
Received: by mail-lf1-f43.google.com with SMTP id l18so4134403lfc.1
        for <ceph-devel@vger.kernel.org>; Fri, 29 Nov 2019 01:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y8pcc5cZ2NurKJJVHn0PkFL/fNiks8t9gKlztRdNjMs=;
        b=pDlopjEuD3+uncoRfRHApq1I5rA511ZpnpyG40yndiGsiHanKY9z7m8qQDodE6fkdV
         L2uq0Me6hDuHx/SonXqMXd5EZbhfkPOdoHDZ+gp9UB5UJR126Ckn7z62TxoYgHaRAks2
         3RGL2kV812i4Jo8vXzbfJziyXHm4IADDwWMQVdcteCSyONwmR93yhwXROJq7GggnUkoT
         bMZUpub7GJCFct1Bn3NZHEdbWGEpHCEB2DIJ8M0TKWLdhR/3OdaYwkJ2Gxtwd7IkdGuK
         oJvQWuOSnGk9hVuSToIIlGcD3TgFKXPh46aUQzD4hHim1Enmh+rf6Dn0vy1lMTgdILF3
         9xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y8pcc5cZ2NurKJJVHn0PkFL/fNiks8t9gKlztRdNjMs=;
        b=FgE9iu+qiZ1OQ+mSv1y/mMezWUdqV2EypMb+500proWu/cYv3TUQ1Nf6LXbPuXeDLH
         yDJif4sRmE9JV02PzMCOrMAQSeg+WJzjSHGOWLjlokDX+M5clhPtplTBDtuE67qlbvgh
         RIsOEsbadGZ47GRHeDrZo6h5nXnvKXW1R5r0r2IxrDNnLLVrMSvyqxQ1JTv4MkDkcHkE
         kQPJXG0huGTqLgPn3skqlIZKgoDqS4WvEWzICqM5+IKHonPFD1de6kKX5/dmEIM+cm68
         9ptDY0YF1uezOlI0nbDolqPsQfDnMEJrMQ1MFbdiibG8VYID0jZel39DPiFyLQItQgLQ
         UDAA==
X-Gm-Message-State: APjAAAU164kcryDEfBxF/zQ4qlog1OeZYfYn36xGKMIJZbgMlArCE3bg
        ilMRaqPztDGvKPY3Vz/hvlA9PPT77Sx9Aalv+K4=
X-Google-Smtp-Source: APXvYqyW2unCwMc5I+QKHhiqktgmzdKlP7oTThskala6ytrAo6ec+CT93cpzfBC/l6oGhjXDd79Zz8b+Cp6fqcavoD4=
X-Received: by 2002:a19:5509:: with SMTP id n9mr34232373lfe.27.1575021479102;
 Fri, 29 Nov 2019 01:57:59 -0800 (PST)
MIME-Version: 1.0
References: <CAL2-6b+A2tQd=pMoXRewK2KeakDpy0X40vDg0OTWk-ZAm5RfmA@mail.gmail.com>
 <62E3E7FC-DEB5-4EBC-8945-F7FF43C6433C@dreamsnake.net> <CAL2-6b+wKe0X1BB2Wts9Q7RX_BQiVk0MaA0=k1LXV_hGwezb5Q@mail.gmail.com>
 <8c4c081a83e640e9bfaaa6679590cefa@dtu.dk>
In-Reply-To: <8c4c081a83e640e9bfaaa6679590cefa@dtu.dk>
From:   Vincent Godin <vince.mlist@gmail.com>
Date:   Fri, 29 Nov 2019 10:57:47 +0100
Message-ID: <CAL2-6b+DW1pENpNucjnnEGaZ4PxkGUOyY4K2fXARc0RX4WjFrg@mail.gmail.com>
Subject: Re: [ceph-users] Re: mimic 13.2.6 too much broken connexions
To:     Frank Schilder <frans@dtu.dk>
Cc:     "Anthony D'Atri" <aad@dreamsnake.net>,
        "ceph-users@ceph.io" <ceph-users@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Franck,
Thank you for your help
Ceph is our Openstack main storage. We have 64 computes (ceph
clients), 36 Ceph-Hosts (client and cluster networks) and 3 Mons :  so
roughly 140 arp entries
Our ARP cache size is based on default so 128/512/1024. As 140 < 512,
default should works (i will check over time the arp cachesize however
We tried these settings below 2 weeks ago (we thought it should
improve our network) but it was worst !
net.core.rmem_max =3D 134217728     (for a 10Gbps with low latency)
net.core.wmem_max =3D 134217728     (for a 10Gbps with low latency)
net.core.netdev_max_backlog =3D 300000
net.core.somaxconn =3D 2000
net.ipv4.ip_local_port_range=3D=E2=80=9910000 65000=E2=80=99
net.ipv4.tcp_rmem =3D 4096 87380 134217728     (for a 10Gbps with low laten=
cy)
net.ipv4.tcp_wmem =3D 4096 87380 134217728     (for a 10Gbps with low laten=
cy)
net.ipv4.tcp_mtu_probing =3D 1
net.ipv4.tcp_sack =3D 0
net.ipv4.tcp_dsack =3D 0
net.ipv4.tcp_fack =3D 0
net.ipv4.tcp_fin_timeout =3D 20
net.ipv4.tcp_slow_start_after_idle =3D 0
net.ipv4.tcp_timestamps =3D 0
net.ipv4.tcp_max_syn_backlog =3D 30000

Client and Cluster Network have a 9000 MTU. Each OSD-Host has two
teaming (LACP): 2x10Gbps for client and 2x10Gbps for cluster. Client
network is one level-2 lan, idem for Cluster network
As i said we didn't see significant errors counters on switchs or server

Vincent


Le ven. 29 nov. 2019 =C3=A0 09:30, Frank Schilder <frans@dtu.dk> a =C3=A9cr=
it :
>
> How large is your arp cache? We have seen ceph dropping connections as so=
on as the level-2 network (direct neighbours) is larger than the arp cache.=
 We adjusted the following settings:
>
> # Increase ARP cache size to accommodate large level-2 client network.
> net.ipv4.neigh.default.gc_thresh1 =3D 1024
> net.ipv4.neigh.default.gc_thresh2 =3D 2048
> net.ipv4.neigh.default.gc_thresh3 =3D 4096
>
> Another important group of parameters for TCP connections seems to be the=
se, with our values:
>
> ## Increase number of incoming connections. The value can be raised to bu=
rsts of request, default is 128
> net.core.somaxconn =3D 2048
> ## Increase number of incoming connections backlog, default is 1000
> net.core.netdev_max_backlog =3D 50000
> ## Maximum number of remembered connection requests, default is 128
> net.ipv4.tcp_max_syn_backlog =3D 30000
>
> With this, we got rid of dropped connections in a cluster of 20 ceph node=
s and ca. 550 client nodes, accounting for about 1500 active ceph clients, =
1400 cephfs and 170 RBD images.
>
> Best regards,
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Frank Schilder
> AIT Ris=C3=B8 Campus
> Bygning 109, rum S14
>
> ________________________________________
> From: Vincent Godin <vince.mlist@gmail.com>
> Sent: 27 November 2019 20:11:23
> To: Anthony D'Atri; ceph-users@ceph.io; Ceph Development
> Subject: [ceph-users] Re: mimic 13.2.6 too much broken connexions
>
> If it was a network issue, the counters should explose (as i said,
> with a log level of 5 on the messenger, we observed more then 80 000
> lossy channels per minute) but nothing abnormal is relevant on the
> counters (on switchs and servers)
> On the switchs  no drop, no crc error, no packet loss, only some
> output discards but not enough to be significant. On the NICs on the
> servers via ethtool -S, nothing is relevant.
> And as i said, an other mimic cluster with different hardware has the
> same behavior
> Ceph uses connexions pools from host to host but how does it check the
> availability of these connexions over the time ?
> And as the network doesn't seem to be guilty, what can explain these
> broken channels ?
>
> Le mer. 27 nov. 2019 =C3=A0 19:05, Anthony D'Atri <aad@dreamsnake.net> a =
=C3=A9crit :
> >
> > Are you bonding NIC ports?   If so do you have the correct hash policy =
defined? Have you looked at the *switch* side for packet loss, CRC errors, =
etc?   What you report could be consistent with this.  Since the host  inte=
rface for a given connection will vary by the bond hash, some OSD connectio=
ns will use one port and some the other.   So if one port has switch side e=
rrors, or is blackholed on the switch, you could see some heart beating imp=
acted but not others.
> >
> > Also make sure you have the optimal reporters value.
> >
> > > On Nov 27, 2019, at 7:31 AM, Vincent Godin <vince.mlist@gmail.com> wr=
ote:
> > >
> > > =EF=BB=BFTill i submit the mail below few days ago, we found some clu=
es
> > > We observed a lot of lossy connexion like :
> > > ceph-osd.9.log:2019-11-27 11:03:49.369 7f6bb77d0700  0 --
> > > 192.168.4.181:6818/2281415 >> 192.168.4.41:0/1962809518
> > > conn(0x563979a9f600 :6818   s=3DSTATE_ACCEPTING_WAIT_CONNECT_MSG_AUTH
> > > pgs=3D0 cs=3D0 l=3D1).handle_connect_msg accept replacing existing (l=
ossy)
> > > channel (new one lossy=3D1)
> > > We raised the log of the messenger to 5/5 and observed for the whole
> > > cluster more than 80 000 lossy connexion per minute !!!
> > > We adjusted  the "ms_tcp_read_timeout" from 900 to 60 sec then no mor=
e
> > > lossy connexion in logs nor health check failed
> > > It's just a workaround but there is a real problem with these broken
> > > sessions and it leads to two
> > > assertions :
> > > - Ceph take too much time to detect broken session and should recycle=
 quicker !
> > > - The reasons for these broken sessions ?
> > >
> > > We have a other mimic cluster on different hardware and observed the
> > > same behavior : lot of lossy sessions, slow ops and co.
> > > Symptoms are the same :
> > > - some OSDs on one host have no response from an other osd on a diffe=
rent hosts
> > > - after some time, slow ops are detected
> > > - sometime it leads to ioblocked
> > > - after about 15mn the problem vanish
> > >
> > > -----------
> > >
> > > Help on diag needed : heartbeat_failed
> > >
> > > We encounter a strange behavior on our Mimic 13.2.6 cluster. A any
> > > time, and without any load, some OSDs become unreachable from only
> > > some hosts. It last 10 mn and then the problem vanish.
> > > It 's not always the same OSDs and the same hosts. There is no networ=
k
> > > failure on any of the host (because only some OSDs become unreachable=
)
> > > nor disk freeze as we can see in our grafana dashboard. Logs message
> > > are :
> > > first msg :
> > > 2019-11-24 09:19:43.292 7fa9980fc700 -1 osd.596 146481
> > > heartbeat_check: no reply from 192.168.6.112:6817 osd.394 since back
> > > 2019-11-24 09:19:22.761142 front 2019-11-24 09:19:39.769138 (cutoff
> > > 2019-11-24 09:19:23.293436)
> > > last msg:
> > > 2019-11-24 09:30:33.735 7f632354f700 -1 osd.591 146481
> > > heartbeat_check: no reply from 192.168.6.123:6828 osd.600 since back
> > > 2019-11-24 09:27:05.269330 front 2019-11-24 09:30:33.214874 (cutoff
> > > 2019-11-24 09:30:13.736517)
> > > During this time, 3 hosts were involved : host-18, host-20 and host-3=
0 :
> > > host-30 is the only one who can't see osds 346,356,and 352 on host-18
> > > host-30 is the only one who can't see osds 387 and 394 on host-20
> > > host-18 is the only one who can't see osds 583, 585, 591 and 597 on h=
ost-30
> > > We can't see any strange behavior on hosts 18, 20 and 30 in our node
> > > exporter data during this time
> > > Any ideas or advices ?
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
