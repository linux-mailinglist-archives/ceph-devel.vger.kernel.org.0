Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2FF372263
	for <lists+ceph-devel@lfdr.de>; Mon,  3 May 2021 23:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhECVWB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 May 2021 17:22:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhECVWB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 May 2021 17:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620076867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oDct55SJURHoBiX/SyMG6a200F4IdYZIl18+Q7Uq3G0=;
        b=W/SOLmgVeuntIrdaLwmU0+PUzIMnxzCv9TbdHByvn6ZasuVz7PKFhtn6qrcuo/HYfgIEsP
        48oZEYuc6FoW6AyGlbclwhlhqOR9iuwKrn7dD8LjjKo+EKZo0Vp67RWe1v2O5C71duWRsI
        5jxSMORJT+9BVBTGKgLz9B7IwEFKhwU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-mnGCp3upMHWFFdjESbxkvg-1; Mon, 03 May 2021 17:21:00 -0400
X-MC-Unique: mnGCp3upMHWFFdjESbxkvg-1
Received: by mail-qv1-f69.google.com with SMTP id b10-20020a0cf04a0000b02901bda1df3afbso5984900qvl.13
        for <ceph-devel@vger.kernel.org>; Mon, 03 May 2021 14:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDct55SJURHoBiX/SyMG6a200F4IdYZIl18+Q7Uq3G0=;
        b=X8oRyoAxnNXb1oTZbvU2nw+9O7Zu5A4S7nGbqiaavCRPiBGbRefAgWhaVtCMj5iPHo
         fuTbTmtt2h3NTWEVZtG7AWqSztkDHh++fc37bFLA0AMZkbdreLB743t68vMvbWHuQIIj
         tdhkYQMBtcX13qHirsouuoXfR9Me7DWwEjBzK6u5frkR8lmYaxLOsPy2k+e30JC5g2uL
         XfPg/ZVhWic3G1T1c8u7+bABAJofHia2DNarWA7WGa1J5LF/cbYIPvjM7eKVqi992/Ry
         SWRadbNliTvvc9oXcmwfwkkMF1BPl0FFU3G+u4jQwujfonEtVapf3cdJeX3GHhaanSan
         3HVA==
X-Gm-Message-State: AOAM531TLHnS5ywC9wyUYHIPi7o+rvetSdUntpz/fLIpQDLLUNlh1BN6
        ub+oXVNUACbSHHk8HnDgowPmRg/NIyszauP8kVIF2cGe+THnRRJup9JycanKrBSB4Jfq/IvwxlT
        fadlzwZg0oR3HNCBfKSZy56xcRZQl0oQ3YGvzZw==
X-Received: by 2002:ac8:5508:: with SMTP id j8mr18689048qtq.386.1620076859684;
        Mon, 03 May 2021 14:20:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR20ReLwvEW0f8yYRKzF4ry1H+j6Cj0PiGcPiN9Q34+8+GbrnBpbE00+ctGqVmoAT1iNW88eDoikrN8MGjInE=
X-Received: by 2002:ac8:5508:: with SMTP id j8mr18689008qtq.386.1620076859011;
 Mon, 03 May 2021 14:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fseyByQ+FsfwAP5-V312bM4YnTbw5GMX6w6fx9UkVnWBQ@mail.gmail.com>
In-Reply-To: <CAKQB+fseyByQ+FsfwAP5-V312bM4YnTbw5GMX6w6fx9UkVnWBQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 3 May 2021 14:20:48 -0700
Message-ID: <CAJ4mKGbVz5gZPFPDx61ZUaCaoxWrWQMSFuzRMOrMx0xnfapaHQ@mail.gmail.com>
Subject: Re: CephFS kclient gets stuck when getattr() on a certain file
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I haven't looked at the logs, but it's expected that when a client
disappears and it's holding caps, the MDS will wait through the
session timeout period before revoking those capabilities. This means
if all your clients are reading the file, writes will be blocked until
the session timeout passes. The details of exactly what operations
will be allowed vary quite a lot depending on the exact system state
when the client disappeared (if it held write caps, most read
operations will also be blocked and new clients trying to look at it
will certainly be blocked).

I don't remember exactly how specific kernel client blocklists are,
but there may be something going on there that makes things extra hard
on the rebooted node if it's maintaining the same IP addresses.

If you have other monitoring software to detect failures, there are
ways to evict clients before the session timeout passes (or you could
have the rebooted node do so) and these are discussed in the docs.
-Greg

On Tue, Apr 27, 2021 at 9:35 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Hi,
>
> I deploy a 3-node Ceph cluster (v15.2.9) and the CephFS is mounted via
> kclient (linux-4.14.24) on all of the 3 nodes.  All of the kclients
> try to update (read/write) a certain file periodically in order to
> know whether the CephFS is alive or not.  After a kclient gets evicted
> due to abnormal reboot, a new kclient mounts to the CephFS when the
> node comes back.  However, the newly mounted kclient gets stuck when
> it tries to getattr on the common file.  Under such conditions, all of
> the other kclients are affected and they cannot update the common
> file, too.  From the debugfs entris, a request does get stuck:
> ------
> [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> # cat mdsc
> 12      mds0    getattr  #100000003ed
>
> [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> # cat osdc
> REQUESTS 0 homeless 0
> LINGER REQUESTS
> BACKOFFS
>
> [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> # ceph -s
>   cluster:
>     id:     1bbb7753-85e5-4d33-a860-84419fdcfd7d
>     health: HEALTH_WARN
>             1 MDSs report slow requests
>
>   services:
>     mon: 3 daemons, quorum Jerry-ceph-n2,Jerry-x85-n1,Jerry-x85-n3 (age 23h)
>     mgr: Jerry-x85-n1(active, since 25h), standbys: Jerry-ceph-n2, Jerry-x85-n3
>     mds: cephfs:1 {0=qceph-mds-Jerry-ceph-n2=up:active} 1
> up:standby-replay 1 up:standby
>     osd: 18 osds: 18 up (since 23h), 18 in (since 23h)
> ------
>
> The MDS logs (debug_mds =20) are provided:
> https://drive.google.com/file/d/1aj101NOTzCsfDdC-neqVTvKpEPOd3M6Q/view?usp=sharing
>
> Some of the logs wrt client.3230166 and ino#100000003ed are shown as below:
> 2021-04-27T11:57:03.467+0800 7fccbd3be700  4 mds.0.server
> handle_client_request client_request(client.3230166:12 getattr
> pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
> caller_gid=0{}) v2
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 20 mds.0.98 get_session have
> 0x56130c5ce480 client.3230166 v1:192.168.92.89:0/679429733 state open
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 15 mds.0.server  oldest_client_tid=12
> 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.cache request_start
> request(client.3230166:12 nref=2 cr=0x56130db96480)
> 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.server
> dispatch_client_request client_request(client.3230166:12 getattr
> pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
> caller_gid=0{}) v2
>
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0.locker
> acquire_locks request(client.3230166:12 nref=3 cr=0x56130db96480)
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 10
> mds.0.cache.ino(0x100000003ed) auth_pin by 0x56130c584ed0 on [inode
> 0x100000003ed [2,head]
> /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> w=1) (iversion lock)
> cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> | ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> 0x56130c584a00] now 4
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 15
> mds.0.cache.dir(0x100000003eb) adjust_nested_auth_pins 1 on [dir
> 0x100000003eb /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/
> [2,head] auth pv=91586 v=91584 cv=0/0 ap=1+4 state=1610874881|complete
> f(v0 m2021-04-23T15:00:04.377198+0800 6=6+0) n(v3
> rc2021-04-27T11:57:02.625542+0800 b38005818 6=6+0) hs=6+0,ss=0+0
> dirty=4 | child=1 dirty=1 waiter=0 authpin=1 0x56130c586a00] by
> 0x56130c584a00 count now 1/4
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0
> RecoveryQueue::prioritize not queued [inode 0x100000003ed [2,head]
> /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> w=1) (iversion lock)
> cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> | ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> 0x56130c584a00]
> 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.locker rdlock_start
> waiting on (ifile mix->sync w=1) on [inode 0x100000003ed [2,head]
> /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> w=1) (iversion lock)
> cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> | ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> 0x56130c584a00]
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 10
> mds.0.cache.ino(0x100000003ed) add_waiter tag 2000000040000000
> 0x56130ea1bbe0 !ambig 1 !frozen 1 !freezing 1
> 2021-04-27T11:57:03.467+0800 7fccbd3be700 15
> mds.0.cache.ino(0x100000003ed) taking waiter here
> 2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.locker
> client.3230166 pending pAsLsXsFr allowed pAsLsXsFrl wanted
> pAsxXsxFsxcrwb
> 2021-04-27T11:57:03.468+0800 7fccbd3be700  7 mds.0.locker
> handle_client_caps  on 0x100000003ed tid 0 follows 0 op update flags
> 0x2
> 2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.98 get_session have
> 0x56130b81f600 client.3198501 v1:192.168.50.108:0/2478094748 state
> open
> 2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  head inode
> [inode 0x100000003ed [2,head]
> /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> w=1) (iversion lock)
> cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
> | ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
> 0x56130c584a00]
> 2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  follows 0
> retains pAsLsXsFr dirty - on [inode 0x100000003ed [2,head]
> /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> w=1) (iversion lock)
> cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> caps={3198501=pAsLsXsFr/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
> | ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
> 0x56130c584a00]
> 2021-04-27T11:57:37.027+0800 7fccbb3ba700  0 log_channel(cluster) log
> [WRN] : slow request 33.561029 seconds old, received at
> 2021-04-27T11:57:03.467164+0800: client_request(client.3230166:12
> getattr pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800
> caller_uid=0, caller_gid=0{}) currently failed to rdlock, waiting
>
> Any idea or insight to help to further investigate the issue are appreciated.
>
> - Jerry
>

