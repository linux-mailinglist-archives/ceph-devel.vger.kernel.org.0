Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEAC36B3A4
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhDZM5S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 08:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbhDZM5S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 26 Apr 2021 08:57:18 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7A9C061574
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 05:56:36 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id j12so1627622ils.4
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 05:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IS3dN1jF3MOfywqFZD0YJc7lbhV1Ju/U6oLZBcWYYKQ=;
        b=dQ0HjvfmkbT66ADeFscEv2IevQQ80SWdr3Vo4wKVB+d0cLOjchJC9sSCkztc5S2HSh
         8dhf595elmAV/Id13etsxMQajY1qBDcUl52x0j0CCea4w31XuKidYPT7J1G/L3BfqIOe
         kZgo3jjgFqKwiF3+RYNREd6Lqu1Nl86CzPMpVmIXRwBcdOQ8tEnsLZkgSkDc/tIoVd8G
         h8kIhmd2gMsi65H2mtpX9gqoZlYRoK4QBVtiMPgiKJpU5BdX+CKubvfwh0ZjptqDyLMB
         f+z1+81Z7w3y6m8OFuu2eWjV/qcsIIwLsxmq8P4lYM/GuWtF58DdvLqJU0WskWguz/3C
         wr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IS3dN1jF3MOfywqFZD0YJc7lbhV1Ju/U6oLZBcWYYKQ=;
        b=IDwbELDCiGqLYIZQAyy7GH0ARy1LFF8m1DjpWT08SAXEdW674tf69cBQCBu0DIGjUD
         Lzqer0BP37qis1ir+3iRd0uvPUhbt9/R2rMJwXQq7DoDWWqFA7s577mrMS3isRb58bYZ
         8aYFIMvXUzX3nJdcmhRRaUwvhSxdRCMeY7qijcv5pI2tvyajJh8KGj0Ik+HK6+/w3/QB
         S4ISp00qrwPwihwZh1DCgTO5IZd9ztAudAnwULGox3nTOt+u13fxg8MipbXG8LqY3brK
         dmnQ0hopPeQd0bEoqwDwXtbntg0ACQkvDPaAGf+uxTmeWpC4EdFML6jrXeWDrDfMCM6D
         BxMA==
X-Gm-Message-State: AOAM531iOHRCv8iCbBDsc+AkWpScj3fa1uEOlm2pStPNBNelMDsj/dmn
        u7qcL1bS3Fw7oHbdN5r60jvuPjcmHY506yMElxI=
X-Google-Smtp-Source: ABdhPJxXfWPa/S1M35zbDLJ+QGlcrX6PAx+3wpNCdRsyCkTnrDIThQn/GdBWOBWWZ8h9fk/iNJ/va13LmmFIsHYrGkM=
X-Received: by 2002:a05:6e02:58c:: with SMTP id c12mr13993180ils.152.1619441795965;
 Mon, 26 Apr 2021 05:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <CANYwiLbFN=g7dt2mKQBZsT7G0r0jZ_Le3oZa-CeHrYtisN7ufw@mail.gmail.com>
 <96f023e868516b441cfd8f37ebbb56441b71b386.camel@kernel.org>
In-Reply-To: <96f023e868516b441cfd8f37ebbb56441b71b386.camel@kernel.org>
From:   Rainer Stumbaum <rainer.stumbaum@gmail.com>
Date:   Mon, 26 Apr 2021 14:56:24 +0200
Message-ID: <CANYwiLZ+9LWWJ=-s3MkvxQKepVgDPdNp2XABJiHjMZdUtyKPYQ@mail.gmail.com>
Subject: Re: Kernel Panic: 0010:ceph_get_snapdir+0x77/0x80 (Ceph 15.2.10 -
 Proxmox Linux version 5.4.106-1-pve)
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

I applied the patch to our current pve-kernel, which is based on 5.4 .
Unfortunately the mounted CephFS directory does not show .snap
directories anymore now... . I reverted to the original Proxmox kernel
again and the .snap directories appeared again.

Here the Dockerfile I used to buid that:
----
FROM debian:buster AS build-env

ADD http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg
/etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
RUN chmod 644 /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg &&\
    echo "deb http://download.proxmox.com/debian/pve buster
pve-no-subscription" > /etc/apt/sources.list.d/pve.list

RUN apt-get update
RUN apt-get install -y build-essential git-buildpackage cmake bison
flex doxygen lsb-release pkgconf \
                       dh-python python-sphinx kmod libdw-dev
libelf-dev libiberty-dev libnuma-dev libpve-common-perl \
                       libslang2-dev libssl-dev lz4 python-minimal
rsync xmlto zlib1g-dev asciidoc-base bc cpio

VOLUME /export
WORKDIR /build

RUN cd /build/ &&\
    git clone git://git.proxmox.com/git/pve-kernel.git &&\
    cd /build/pve-kernel/ &&\
    git checkout pve-kernel-5.4

RUN cd /build/pve-kernel/patches/kernel/ &&\
    wget -O 0008-ceph-snapdirs-error-handling.patch
https://github.com/ceph/ceph-client/commit/e769f38dfc9bb8320961a8f453453afb764c9ac9.patch

RUN cd /build/pve-kernel/ &&\
    make
----
Here how to run it...
rstumbaum@test01(dev):~/docker-pve-kernel-build$ docker build . -t pve-kernel
docker run -v $HOME/docker-pve-kernel-build/export:/export -it pve-kernel

No idea on how to go from here. Should I try the 5.11 kernel and patch that?

Best regards
Rainer

Rainer

Am Mi., 21. Apr. 2021 um 16:34 Uhr schrieb Jeff Layton <jlayton@kernel.org>:
>
> On Wed, 2021-04-21 at 15:41 +0200, Rainer Stumbaum wrote:
> > Hi,
> >
> > I run a 5 node Proxmox virtualization environment (VE) Cluster with
> > Ceph Octopus 15.2.10 on
> > each of the nodes(1).
> >
> > To hand out file shares to some of the virtual machines (VMs) on that
> > Proxmox VE I created two
> > VMs that mount a CephFS filesystem using the kernel driver and export
> > this mount using the
> > nfs-kernel-server.
> >
> > NFS Ganesha at the time was no option due to this missing feature(2).
> >
> > So failover works but during high operation times e.g. backup I get a
> > kernel panic and the NFS
> > exports hang indefinately.
> > I already built around this (if kernel panic reboot and therefore
> > failover to the other NFS serving
> > VM) and moved the backup schedule to the weekend instead of daily at
> > night, but during high
> > operation times the kerne panik still occurs.
> >
> > So here is such a kernel panic:
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.689309] ------------[
> > cut here ]------------
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.689794] invalid
> > opcode: 0000 [#1] SMP NOPTI
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.690046] CPU: 3 PID:
> > 690 Comm: nfsd Tainted: G        W         5.4.106-1-pve #1
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.690302] Hardware name:
> > QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.690672] RIP:
> > 0010:ceph_get_snapdir+0x77/0x80 [ceph]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.690945] Code: 00 89 7d
> > c0 89 50 08 48 c7 80 68 01 00 00 80 8a 7d c0 c7 80 b0 fe ff ff 01 00
> > 00 00 48 c7 80 60 fd ff ff 00 00 00 00 5b 5d c3 <0f> 0b 0f 1f 80 00 00
> > 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 53 48
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.691552] RSP:
> > 0018:ffffaa1000a13ba0 EFLAGS: 00010a06
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.691865] RAX:
> > ffff95fb4d4bbad0 RBX: ffff95fac6ce2a20 RCX: 0000000000008000
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.692213] RDX:
> > 00000000000081a4 RSI: ffff95fb4d4bbb68 RDI: ffff95fb4d4bbb58
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.692558] RBP:
> > ffffaa1000a13ba8 R08: ffff95fb4d4bbad0 R09: 0000000000000001
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.692909] R10:
> > ffff95fb4c569000 R11: 0000000000000001 R12: ffff95fabcf06ce0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.693270] R13:
> > ffff95fb4ebaf9c0 R14: 0000000000000007 R15: ffffffffc03ba0f0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.693613] FS:
> > 0000000000000000(0000) GS:ffff95fb7bb80000(0000)
> > knlGS:0000000000000000
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.693991] CS:  0010 DS:
> > 0000 ES: 0000 CR0: 0000000080050033
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.694347] CR2:
> > 00007efd09db2180 CR3: 00000001321c4000 CR4: 0000000000340ee0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.694739] Call Trace:
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.695135]
> > ceph_get_parent+0x6b/0x130 [ceph]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.695571]
> > reconnect_path+0xa9/0x2e0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.695962]  ?
> > nfsd_proc_setattr+0x1c0/0x1c0 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.696368]
> > exportfs_decode_fh+0x139/0x340
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.696762]  ?
> > exp_find_key+0xe2/0x160 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.697175]  ?
> > cache_revisit_request+0xa5/0x110 [sunrpc]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.697629]  ? __kmalloc+0x197/0x280
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.698092]  ?
> > security_prepare_creds+0xba/0xf0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.698526]
> > fh_verify+0x3f5/0x5d0 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.698958]
> > nfsd3_proc_getattr+0x70/0x100 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.699378]
> > nfsd_dispatch+0xa6/0x220 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.699794]
> > svc_process_common+0x35c/0x700 [sunrpc]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.700226]  ?
> > nfsd_svc+0x2d0/0x2d0 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.700671]
> > svc_process+0xd6/0x110 [sunrpc]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.701123]  nfsd+0xe9/0x150 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.701560]  kthread+0x120/0x140
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.701983]  ?
> > nfsd_destroy+0x60/0x60 [nfsd]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.702391]  ?
> > kthread_park+0x90/0x90
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.702801]  ret_from_fork+0x22/0x40
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.703205] Modules linked
> > in: ipmi_devintf ipmi_msghandler ceph libceph libcrc32c fscache
> > kvm_amd ccp kvm irqbypass bochs_drm crct10dif_pclmul crc32_pclmul
> > drm_vram_helper ghash_clmulni_intel ttm aesni_intel drm_kms_helper
> > crypto_simd cryptd glue_helper drm input_leds joydev fb_sys_fops
> > serio_raw pcspkr syscopyarea sysfillrect sysimgblt mac_hid qemu_fw_cfg
> > nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_tables autofs4
> > psmouse virtio_net net_failover failover virtio_scsi uhci_hcd ehci_hcd
> > i2c_piix4 pata_acpi floppy
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.705803] ---[ end trace
> > a3432c256d64dfe1 ]---
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.706359] RIP:
> > 0010:ceph_get_snapdir+0x77/0x80 [ceph]
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.706914] Code: 00 89 7d
> > c0 89 50 08 48 c7 80 68 01 00 00 80 8a 7d c0 c7 80 b0 fe ff ff 01 00
> > 00 00 48 c7 80 60 fd ff ff 00 00 00 00 5b 5d c3 <0f> 0b 0f 1f 80 00 00
> > 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 53 48
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.708051] RSP:
> > 0018:ffffaa1000a13ba0 EFLAGS: 00010a06
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.708637] RAX:
> > ffff95fb4d4bbad0 RBX: ffff95fac6ce2a20 RCX: 0000000000008000
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.709236] RDX:
> > 00000000000081a4 RSI: ffff95fb4d4bbb68 RDI: ffff95fb4d4bbb58
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.709834] RBP:
> > ffffaa1000a13ba8 R08: ffff95fb4d4bbad0 R09: 0000000000000001
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.710438] R10:
> > ffff95fb4c569000 R11: 0000000000000001 R12: ffff95fabcf06ce0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.711044] R13:
> > ffff95fb4ebaf9c0 R14: 0000000000000007 R15: ffffffffc03ba0f0
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.711672] FS:
> > 0000000000000000(0000) GS:ffff95fb7bb80000(0000)
> > knlGS:0000000000000000
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.712272] CS:  0010 DS:
> > 0000 ES: 0000 CR0: 0000000080050033
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.712846] CR2:
> > 00007efd09db2180 CR3: 00000001321c4000 CR4: 0000000000340ee0
> > Apr 21 01:09:01 nfsshares2056-b Keepalived_vrrp[693]: Script
> > `check_proc_nfsd` now returning 2
> > Apr 21 01:09:01 nfsshares2056-b Keepalived_vrrp[693]:
> > VRRP_Script(check_proc_nfsd) failed (exited with status 2)
> > Apr 21 01:09:01 nfsshares2056-b Keepalived_vrrp[693]: (nfs_storage)
> > Entering FAULT STATE
> > Apr 21 01:09:01 nfsshares2056-b Keepalived_vrrp[693]: (nfs_storage)
> > sent 0 priority
> > Apr 21 01:09:01 nfsshares2056-b kernel: [167045.940023] printk:
> > systemd-shutdow: 50 output lines suppressed due to ratelimiting
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] Linux version
> > 5.4.106-1-pve (build@pve) (gcc version 8.3.0 (Debian 8.3.0-6)) #1 SMP
> > PVE 5.4.106-1 (Fri, 19 Mar 2021 11:08:47 +0100) ()
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] Command line:
> > BOOT_IMAGE=/boot/vmlinuz-5.4.106-1-pve
> > root=UUID=807e491f-7f9f-4cc9-879f-bf5814459db8 ro quiet
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] KERNEL supported cpus:
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000]   Intel GenuineIntel
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000]   AMD AuthenticAMD
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000]   Hygon HygonGenuine
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000]   Centaur CentaurHauls
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000]   zhaoxin   Shanghai
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] x86/fpu:
> > Supporting XSAVE feature 0x001: 'x87 floating point registers'
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] x86/fpu:
> > Supporting XSAVE feature 0x002: 'SSE registers'
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] x86/fpu:
> > Supporting XSAVE feature 0x004: 'AVX registers'
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] x86/fpu:
> > xstate_offset[2]:  576, xstate_sizes[2]:  256
> > Apr 21 01:10:45 nfsshares2056-b kernel: [    0.000000] x86/fpu:
> > Enabled xstate features 0x7, context size is 832 bytes, using
> > 'compacted' format.
> >
> >
> > So how to continue from here?
> >
> > Best regards
> > Rainer
> >
> >
> > (1)
> > https://git.proxmox.com/?p=ceph.git;a=summary
> > https://git.proxmox.com/?p=pve-kernel.git;a=summary
> > (2)
> > https://lists.nfs-ganesha.org/archives/list/support@lists.nfs-ganesha.org/message/AC3O5BYUW4O7Z3BQJZMQFBIHWEWU2XQS/
>
> Looks like this hit the BUG_ON() in ceph_get_snapdir:
>
>     BUG_ON(!S_ISDIR(parent->i_mode));
>
> The parent for this inode turned out to not be a directory for some
> reason. I'm not sure what would cause this outside of an MDS bug or
> something similar.
>
> Note that I have a patch queued that will get rid of that BUG_ON(),
> which should make v5.12:
>
>     https://github.com/ceph/ceph-client/commit/e769f38dfc9bb8320961a8f453453afb764c9ac9
>
> If you're hitting this regularly, you may want to apply that and re-
> test, as it may give us a bit more info about the inode in question (and
> should prevent this panic).
>
> Cheers,
> --
> Jeff Layton <jlayton@kernel.org>
>
