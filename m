Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0019375F9A
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 07:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhEGFD7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 01:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhEGFD7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 May 2021 01:03:59 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BF9C061574
        for <ceph-devel@vger.kernel.org>; Thu,  6 May 2021 22:03:00 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id m9so10409073ybm.3
        for <ceph-devel@vger.kernel.org>; Thu, 06 May 2021 22:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/fQx1Xz8MxcRxCsWvqqJoU+gIpBaxRkn3H6jtuo1Qs=;
        b=E2RQx7sm3/CDb6MWYKgW5K8vtAUEs1yGWNqJiVXpxrATPj9wRV5duPvelbyJrjLa+O
         Ew4SxgkGD7v9Q5fbaDUhcCGpxiRKHzGwL4PIIs8QA0vYTOeQKXppY37tjM72W3tpMoMO
         80tDzprPWy3FFB13ThlDohqplgXAm3UhRL1ILl7VVzRkEdMHEEemQLNAKySiG8x1slZF
         hhPl0I9H8i2kYw1zfA9Xv+O0Sc7Fu5X72swJEeIM+VfPMq1RlfoQpX/BQEmu8UHIFlrQ
         U/tA1VMW5yfgquFhx4zc/JQP9VExuDfC4b3C9QpqsViCuovgItqDLocokQPwHYsK1jeC
         kskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/fQx1Xz8MxcRxCsWvqqJoU+gIpBaxRkn3H6jtuo1Qs=;
        b=tYROzAYc+Mesz9GOiyppxKSo526RJept0IKnh1bkJ2n1O9ePZAedCsOmH/WfdeyoVK
         fZL8W2qESi3yQkP+ofv2FbtjdzSQmaAFcCFclxr7nxNVpM0qAw6Rr0fpWJy0BtJLHe+k
         7T1G19fjFVWZbEFwbdarCKh/ooLQHVIkKNHAwRVXdl4DTpgX1pWvzluUzTGxMhKxNcTN
         yV9M6XV+dmgVH5k8idWzHtRbAdHBHnCkMEIn2R+T0pRl+bMQB7hmv52ue3VFwoklnIlQ
         i1PiAVo2I76HbnQ9yWSKTiNzX8vxfOVNv6zn0Mc38pur83hNllk83nQo2xV4HmYeiqzG
         rHBQ==
X-Gm-Message-State: AOAM531cAhAHoR6NMQoYw3wx/+r8xvlen1SJb3DP5dBHTmRE2Dc6nVZC
        sGDf6wa2+PS4UXRWoQdlxz5knQziFtuSIWOzE/uCj1BjqH0=
X-Google-Smtp-Source: ABdhPJy8dHV0WXrQ7DmZ5EWDJDYcjGxbfk+e1iTMcQvStLiaDccjTudIpG6bn537o0MTJX+GatHllDSe3xqnoiIxra0=
X-Received: by 2002:a25:a345:: with SMTP id d63mr10603758ybi.169.1620363779283;
 Thu, 06 May 2021 22:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fseyByQ+FsfwAP5-V312bM4YnTbw5GMX6w6fx9UkVnWBQ@mail.gmail.com>
 <CAJ4mKGbVz5gZPFPDx61ZUaCaoxWrWQMSFuzRMOrMx0xnfapaHQ@mail.gmail.com> <6917f4e83c0c90db684e0a4dfb979fb671162fb2.camel@kernel.org>
In-Reply-To: <6917f4e83c0c90db684e0a4dfb979fb671162fb2.camel@kernel.org>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Fri, 7 May 2021 13:02:47 +0800
Message-ID: <CAKQB+fs5D7PaoJFAZtwJ5gEnV69HFOBZgKQuxQBOTM4k1wyw-g@mail.gmail.com>
Subject: Re: CephFS kclient gets stuck when getattr() on a certain file
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

First, thanks for all the great information and directions!  Since the
issue can be steadily re-produced in my environment, and it doesn't
occur before I upgraded ceph from v15.2.4 to v15.2.9.  I checked the
changlogs between v15.2.4 and v15.2.9, and reverted some possible PR
related to CephFS and mds.  Luckily, after reverting all the commits
of the "mds: reduce memory usage of open file table prefetch #37382
(pr#37383), https://github.com/ceph/ceph/pull/37383" RP, the issue
never occurs.

However, those commits are kind of complicated and I'm still looking
into it in order to figure out the root cause.  If there is anything I
can do to locate the bug, please let me know, thanks!

- Jerry

On Tue, 4 May 2021 at 20:02, Jeff Layton <jlayton@kernel.org> wrote:
>
> IIUC, when a client reboots and mounts again, it becomes a new client,
> for all intents and purposes. So if the MDS is still maintaining the
> session from the old (pre-reboot) client, the new client will generally
> need to wait until that session is evicted before it can grab any caps
> that that client previously held. This was one of the reasons we added
> some of the reboot recovery stuff into libcephfs to support the nfs-
> ganesha client use-case.
>
> Assuming that's the case here, we might be able to eventually improve
> that by having kclients set their identity on the session at mount time
> (a'la ceph_set_uuid), and then it could tell the MDS that it was safe to
> release the state that that client previously held. That would mean
> generating a unique per-client ID that was invariant across reboots, but
> we could consider it.
>
> -- Jeff
>
> On Mon, 2021-05-03 at 14:20 -0700, Gregory Farnum wrote:
> > I haven't looked at the logs, but it's expected that when a client
> > disappears and it's holding caps, the MDS will wait through the
> > session timeout period before revoking those capabilities. This means
> > if all your clients are reading the file, writes will be blocked until
> > the session timeout passes. The details of exactly what operations
> > will be allowed vary quite a lot depending on the exact system state
> > when the client disappeared (if it held write caps, most read
> > operations will also be blocked and new clients trying to look at it
> > will certainly be blocked).
> >
> > I don't remember exactly how specific kernel client blocklists are,
> > but there may be something going on there that makes things extra hard
> > on the rebooted node if it's maintaining the same IP addresses.
> >
> > If you have other monitoring software to detect failures, there are
> > ways to evict clients before the session timeout passes (or you could
> > have the rebooted node do so) and these are discussed in the docs.
> > -Greg
> >
> > On Tue, Apr 27, 2021 at 9:35 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > I deploy a 3-node Ceph cluster (v15.2.9) and the CephFS is mounted via
> > > kclient (linux-4.14.24) on all of the 3 nodes.  All of the kclients
> > > try to update (read/write) a certain file periodically in order to
> > > know whether the CephFS is alive or not.  After a kclient gets evicted
> > > due to abnormal reboot, a new kclient mounts to the CephFS when the
> > > node comes back.  However, the newly mounted kclient gets stuck when
> > > it tries to getattr on the common file.  Under such conditions, all of
> > > the other kclients are affected and they cannot update the common
> > > file, too.  From the debugfs entris, a request does get stuck:
> > > ------
> > > [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> > > # cat mdsc
> > > 12      mds0    getattr  #100000003ed
> > >
> > > [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> > > # cat osdc
> > > REQUESTS 0 homeless 0
> > > LINGER REQUESTS
> > > BACKOFFS
> > >
> > > [/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
> > > # ceph -s
> > >   cluster:
> > >     id:     1bbb7753-85e5-4d33-a860-84419fdcfd7d
> > >     health: HEALTH_WARN
> > >             1 MDSs report slow requests
> > >
> > >   services:
> > >     mon: 3 daemons, quorum Jerry-ceph-n2,Jerry-x85-n1,Jerry-x85-n3 (age 23h)
> > >     mgr: Jerry-x85-n1(active, since 25h), standbys: Jerry-ceph-n2, Jerry-x85-n3
> > >     mds: cephfs:1 {0=qceph-mds-Jerry-ceph-n2=up:active} 1
> > > up:standby-replay 1 up:standby
> > >     osd: 18 osds: 18 up (since 23h), 18 in (since 23h)
> > > ------
> > >
> > > The MDS logs (debug_mds =20) are provided:
> > > https://drive.google.com/file/d/1aj101NOTzCsfDdC-neqVTvKpEPOd3M6Q/view?usp=sharing
> > >
> > > Some of the logs wrt client.3230166 and ino#100000003ed are shown as below:
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700  4 mds.0.server
> > > handle_client_request client_request(client.3230166:12 getattr
> > > pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
> > > caller_gid=0{}) v2
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 20 mds.0.98 get_session have
> > > 0x56130c5ce480 client.3230166 v1:192.168.92.89:0/679429733 state open
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 15 mds.0.server  oldest_client_tid=12
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.cache request_start
> > > request(client.3230166:12 nref=2 cr=0x56130db96480)
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.server
> > > dispatch_client_request client_request(client.3230166:12 getattr
> > > pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
> > > caller_gid=0{}) v2
> > >
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0.locker
> > > acquire_locks request(client.3230166:12 nref=3 cr=0x56130db96480)
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 10
> > > mds.0.cache.ino(0x100000003ed) auth_pin by 0x56130c584ed0 on [inode
> > > 0x100000003ed [2,head]
> > > /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> > > auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> > > rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> > > w=1) (iversion lock)
> > > cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> > > caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> > > > ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> > > 0x56130c584a00] now 4
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 15
> > > mds.0.cache.dir(0x100000003eb) adjust_nested_auth_pins 1 on [dir
> > > 0x100000003eb /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/
> > > [2,head] auth pv=91586 v=91584 cv=0/0 ap=1+4 state=1610874881|complete
> > > f(v0 m2021-04-23T15:00:04.377198+0800 6=6+0) n(v3
> > > rc2021-04-27T11:57:02.625542+0800 b38005818 6=6+0) hs=6+0,ss=0+0
> > > dirty=4 | child=1 dirty=1 waiter=0 authpin=1 0x56130c586a00] by
> > > 0x56130c584a00 count now 1/4
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0
> > > RecoveryQueue::prioritize not queued [inode 0x100000003ed [2,head]
> > > /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> > > auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> > > rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> > > w=1) (iversion lock)
> > > cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> > > caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> > > > ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> > > 0x56130c584a00]
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.locker rdlock_start
> > > waiting on (ifile mix->sync w=1) on [inode 0x100000003ed [2,head]
> > > /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> > > auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> > > rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> > > w=1) (iversion lock)
> > > cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> > > caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
> > > > ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
> > > 0x56130c584a00]
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 10
> > > mds.0.cache.ino(0x100000003ed) add_waiter tag 2000000040000000
> > > 0x56130ea1bbe0 !ambig 1 !frozen 1 !freezing 1
> > > 2021-04-27T11:57:03.467+0800 7fccbd3be700 15
> > > mds.0.cache.ino(0x100000003ed) taking waiter here
> > > 2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.locker
> > > client.3230166 pending pAsLsXsFr allowed pAsLsXsFrl wanted
> > > pAsxXsxFsxcrwb
> > > 2021-04-27T11:57:03.468+0800 7fccbd3be700  7 mds.0.locker
> > > handle_client_caps  on 0x100000003ed tid 0 follows 0 op update flags
> > > 0x2
> > > 2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.98 get_session have
> > > 0x56130b81f600 client.3198501 v1:192.168.50.108:0/2478094748 state
> > > open
> > > 2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  head inode
> > > [inode 0x100000003ed [2,head]
> > > /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> > > auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> > > rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> > > w=1) (iversion lock)
> > > cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> > > caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
> > > > ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
> > > 0x56130c584a00]
> > > 2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  follows 0
> > > retains pAsLsXsFr dirty - on [inode 0x100000003ed [2,head]
> > > /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
> > > auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
> > > rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
> > > w=1) (iversion lock)
> > > cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
> > > caps={3198501=pAsLsXsFr/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
> > > > ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
> > > 0x56130c584a00]
> > > 2021-04-27T11:57:37.027+0800 7fccbb3ba700  0 log_channel(cluster) log
> > > [WRN] : slow request 33.561029 seconds old, received at
> > > 2021-04-27T11:57:03.467164+0800: client_request(client.3230166:12
> > > getattr pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800
> > > caller_uid=0, caller_gid=0{}) currently failed to rdlock, waiting
> > >
> > > Any idea or insight to help to further investigate the issue are appreciated.
> > >
> > > - Jerry
> > >
> >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
