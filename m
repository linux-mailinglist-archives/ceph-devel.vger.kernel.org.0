Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B853A10B675
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 20:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK0TLh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 14:11:37 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:40191 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfK0TLh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 14:11:37 -0500
Received: by mail-lj1-f173.google.com with SMTP id s22so6673408ljs.7
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2019 11:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=klRQjf/dPn78HMqCTOV1yWARayPhM/2F9qlkFTWv1+8=;
        b=tG5zgaiattGzPche8FB3FKSVsVzurobd9UjiDHKu3QU7voDsHjxLWa1pXcBTZzUh29
         2Szi3jNI4ageOnSAM2RePZyBx9pPp/mvfIKSOhuc04JOEDsfy/suCouNIkxsMof2lDnb
         TNXos3aprRxmkEN0RB7q4Zh6LeX98pO7asttE7aAGYDtPKt5Uk4cU8AFQE9I0Ql29tzX
         Y9M81ygzBS8EeY07cCpX5eIV02oxppFm1qIbyR46UoaNQ9SiHgHwd0W3IuAlaHlr3I4b
         4KEA2YA39YdWnHAfLHioCdHsKJdgozUsLPBMexE7xuozXpk6mb/GHbWh9KHI45ticJbl
         0eDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=klRQjf/dPn78HMqCTOV1yWARayPhM/2F9qlkFTWv1+8=;
        b=ImgaNItE3IvnH4CAKesgh5unMFjb0Bb7ZfCYfgCBSWNtBjVHmkl0oej5qGjYZsP9Qr
         U+uH/RvBiynJErLd3hawxAab1Os7/L1CFR1DZdFFoXV1zi00R2rhkCS5r5OFogDRluX7
         72mwZ1dYmASankm3rEg1iwaPt2C5+3p3OHCrCy5AYg+ajpqlRUtASrQVAirl04a0cV28
         HRe/JD4F5lh/nf4YhnrMR+WOs0ob4Qgoee78amUH74DzjS59iR5b9Z62rubNh+FpJdAu
         wunCy2xzyzotKwLp9mDlyNxg7HJucNRbFqrZtZOMuW/BIwLQ4utOFcs5mCORmxz68mar
         GXwA==
X-Gm-Message-State: APjAAAWfmeapMO75HV57ww/WtallLnDAIhhnhkm+OUx61k/GtrqbG21v
        PaqKjpvrZ5kmog/udXV7HG+oy/FCfeWJKSyKvPGN8/sq
X-Google-Smtp-Source: APXvYqztotXn78ilBN9FVfHs7hqN9aR9LgXEcysKinD0BLpn3/rewpnFuyhBam+Wum6cs/3vLzfVnIF6kS4owGn3+7A=
X-Received: by 2002:a2e:6e07:: with SMTP id j7mr634025ljc.18.1574881894125;
 Wed, 27 Nov 2019 11:11:34 -0800 (PST)
MIME-Version: 1.0
References: <CAL2-6b+A2tQd=pMoXRewK2KeakDpy0X40vDg0OTWk-ZAm5RfmA@mail.gmail.com>
 <62E3E7FC-DEB5-4EBC-8945-F7FF43C6433C@dreamsnake.net>
In-Reply-To: <62E3E7FC-DEB5-4EBC-8945-F7FF43C6433C@dreamsnake.net>
From:   Vincent Godin <vince.mlist@gmail.com>
Date:   Wed, 27 Nov 2019 20:11:23 +0100
Message-ID: <CAL2-6b+wKe0X1BB2Wts9Q7RX_BQiVk0MaA0=k1LXV_hGwezb5Q@mail.gmail.com>
Subject: Re: mimic 13.2.6 too much broken connexions
To:     "Anthony D'Atri" <aad@dreamsnake.net>, ceph-users@ceph.io,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If it was a network issue, the counters should explose (as i said,
with a log level of 5 on the messenger, we observed more then 80 000
lossy channels per minute) but nothing abnormal is relevant on the
counters (on switchs and servers)
On the switchs  no drop, no crc error, no packet loss, only some
output discards but not enough to be significant. On the NICs on the
servers via ethtool -S, nothing is relevant.
And as i said, an other mimic cluster with different hardware has the
same behavior
Ceph uses connexions pools from host to host but how does it check the
availability of these connexions over the time ?
And as the network doesn't seem to be guilty, what can explain these
broken channels ?

Le mer. 27 nov. 2019 =C3=A0 19:05, Anthony D'Atri <aad@dreamsnake.net> a =
=C3=A9crit :
>
> Are you bonding NIC ports?   If so do you have the correct hash policy de=
fined? Have you looked at the *switch* side for packet loss, CRC errors, et=
c?   What you report could be consistent with this.  Since the host  interf=
ace for a given connection will vary by the bond hash, some OSD connections=
 will use one port and some the other.   So if one port has switch side err=
ors, or is blackholed on the switch, you could see some heart beating impac=
ted but not others.
>
> Also make sure you have the optimal reporters value.
>
> > On Nov 27, 2019, at 7:31 AM, Vincent Godin <vince.mlist@gmail.com> wrot=
e:
> >
> > =EF=BB=BFTill i submit the mail below few days ago, we found some clues
> > We observed a lot of lossy connexion like :
> > ceph-osd.9.log:2019-11-27 11:03:49.369 7f6bb77d0700  0 --
> > 192.168.4.181:6818/2281415 >> 192.168.4.41:0/1962809518
> > conn(0x563979a9f600 :6818   s=3DSTATE_ACCEPTING_WAIT_CONNECT_MSG_AUTH
> > pgs=3D0 cs=3D0 l=3D1).handle_connect_msg accept replacing existing (los=
sy)
> > channel (new one lossy=3D1)
> > We raised the log of the messenger to 5/5 and observed for the whole
> > cluster more than 80 000 lossy connexion per minute !!!
> > We adjusted  the "ms_tcp_read_timeout" from 900 to 60 sec then no more
> > lossy connexion in logs nor health check failed
> > It's just a workaround but there is a real problem with these broken
> > sessions and it leads to two
> > assertions :
> > - Ceph take too much time to detect broken session and should recycle q=
uicker !
> > - The reasons for these broken sessions ?
> >
> > We have a other mimic cluster on different hardware and observed the
> > same behavior : lot of lossy sessions, slow ops and co.
> > Symptoms are the same :
> > - some OSDs on one host have no response from an other osd on a differe=
nt hosts
> > - after some time, slow ops are detected
> > - sometime it leads to ioblocked
> > - after about 15mn the problem vanish
> >
> > -----------
> >
> > Help on diag needed : heartbeat_failed
> >
> > We encounter a strange behavior on our Mimic 13.2.6 cluster. A any
> > time, and without any load, some OSDs become unreachable from only
> > some hosts. It last 10 mn and then the problem vanish.
> > It 's not always the same OSDs and the same hosts. There is no network
> > failure on any of the host (because only some OSDs become unreachable)
> > nor disk freeze as we can see in our grafana dashboard. Logs message
> > are :
> > first msg :
> > 2019-11-24 09:19:43.292 7fa9980fc700 -1 osd.596 146481
> > heartbeat_check: no reply from 192.168.6.112:6817 osd.394 since back
> > 2019-11-24 09:19:22.761142 front 2019-11-24 09:19:39.769138 (cutoff
> > 2019-11-24 09:19:23.293436)
> > last msg:
> > 2019-11-24 09:30:33.735 7f632354f700 -1 osd.591 146481
> > heartbeat_check: no reply from 192.168.6.123:6828 osd.600 since back
> > 2019-11-24 09:27:05.269330 front 2019-11-24 09:30:33.214874 (cutoff
> > 2019-11-24 09:30:13.736517)
> > During this time, 3 hosts were involved : host-18, host-20 and host-30 =
:
> > host-30 is the only one who can't see osds 346,356,and 352 on host-18
> > host-30 is the only one who can't see osds 387 and 394 on host-20
> > host-18 is the only one who can't see osds 583, 585, 591 and 597 on hos=
t-30
> > We can't see any strange behavior on hosts 18, 20 and 30 in our node
> > exporter data during this time
> > Any ideas or advices ?
