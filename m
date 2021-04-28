Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B836D165
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 06:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhD1Eew (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 00:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhD1Eev (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Apr 2021 00:34:51 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97C5C061574
        for <ceph-devel@vger.kernel.org>; Tue, 27 Apr 2021 21:34:05 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g38so72176985ybi.12
        for <ceph-devel@vger.kernel.org>; Tue, 27 Apr 2021 21:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BVybM0xx0i4fnklRaSG07JJ+Kj0xhYh1//5JK5wQD2M=;
        b=dFrtsOSxz6tK0BfXMXGPbh+sjhwOCf+C9GwI2ilBDGzrJGrQ5dps/4LK+vkYYTS1AR
         S43aV9cAI+T7zcG/gkC34Qa9pVkZqkVKFLWBau2RcjSEoKUqk0dZrFvwZ14qHHPjQcbd
         BQVmxk/HRTbkYh6X8BgX4kjqrqmB4l3wuHFGZ4nTKiiopLX2MukKYrjoffrPBY8WLgYO
         KL668fIwv9bUEjNAXkV66UWZhSrao2GkP9B59PzAKpB1SoUZsvgXeqaJqf9d9RU4dnx7
         bAoPkiNG7o83Ay4odwgQ0SNzmLrvEJ2iV5CO2rZyV4rcRFupAXmSgNSNTvrcKm+VcbAq
         XxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BVybM0xx0i4fnklRaSG07JJ+Kj0xhYh1//5JK5wQD2M=;
        b=joFqPtRUXUeq97Z3iR+oV47D5rX3BpCX+VqvCQgDxKLdrMPXJfA1ucZrN53B/SOM5z
         Ovy26raOmd1rjDjT4B2J66/QPQzoVsPTUcMN+npXyz28XjLEsXCcWecuY5gcOmdZ4PWs
         R1erBSc+sBy7+5xGEHgvozN2Qr21kNHx3cnXHwoj/LVc59CXZtNPi8u/IWzVz1j/AjlF
         lGLlfm97iDNAooDg+VlIQk5MeYAkUKgSSQzUqSUFHDKyGWEFdnWFOOqpBc9OJoCa26YN
         PAYawpj9yOmzBuigAOwqBIS8MhtLxzgDBsYNUQ2Ovd9yNgdz2LuqIU3MHGhFsdYumy04
         f/dg==
X-Gm-Message-State: AOAM533v/23Nooy4v/8RkmYJLO7bXeOVIudXWwsWEMs1TTNOjM9ReW8r
        axXWU2xQ2qQXIeLOgr4QSWFwTE2mhvughB0k/rz+zYjjiCM=
X-Google-Smtp-Source: ABdhPJycZIVOU0mtw0PvUy3Pms8mbX3KIITvrF1nE/DZDV5eF8cb9rHLu5hMmFpFY2OVWhAbtq7z6SzvHia7WRJS9NI=
X-Received: by 2002:a25:a345:: with SMTP id d63mr36625276ybi.169.1619584445010;
 Tue, 27 Apr 2021 21:34:05 -0700 (PDT)
MIME-Version: 1.0
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Wed, 28 Apr 2021 12:33:54 +0800
Message-ID: <CAKQB+fseyByQ+FsfwAP5-V312bM4YnTbw5GMX6w6fx9UkVnWBQ@mail.gmail.com>
Subject: CephFS kclient gets stuck when getattr() on a certain file
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I deploy a 3-node Ceph cluster (v15.2.9) and the CephFS is mounted via
kclient (linux-4.14.24) on all of the 3 nodes.  All of the kclients
try to update (read/write) a certain file periodically in order to
know whether the CephFS is alive or not.  After a kclient gets evicted
due to abnormal reboot, a new kclient mounts to the CephFS when the
node comes back.  However, the newly mounted kclient gets stuck when
it tries to getattr on the common file.  Under such conditions, all of
the other kclients are affected and they cannot update the common
file, too.  From the debugfs entris, a request does get stuck:
------
[/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
# cat mdsc
12      mds0    getattr  #100000003ed

[/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
# cat osdc
REQUESTS 0 homeless 0
LINGER REQUESTS
BACKOFFS

[/sys/kernel/debug/ceph/1bbb7753-85e5-4d33-a860-84419fdcfd7d.client3230166]
# ceph -s
  cluster:
    id:     1bbb7753-85e5-4d33-a860-84419fdcfd7d
    health: HEALTH_WARN
            1 MDSs report slow requests

  services:
    mon: 3 daemons, quorum Jerry-ceph-n2,Jerry-x85-n1,Jerry-x85-n3 (age 23h)
    mgr: Jerry-x85-n1(active, since 25h), standbys: Jerry-ceph-n2, Jerry-x85-n3
    mds: cephfs:1 {0=qceph-mds-Jerry-ceph-n2=up:active} 1
up:standby-replay 1 up:standby
    osd: 18 osds: 18 up (since 23h), 18 in (since 23h)
------

The MDS logs (debug_mds =20) are provided:
https://drive.google.com/file/d/1aj101NOTzCsfDdC-neqVTvKpEPOd3M6Q/view?usp=sharing

Some of the logs wrt client.3230166 and ino#100000003ed are shown as below:
2021-04-27T11:57:03.467+0800 7fccbd3be700  4 mds.0.server
handle_client_request client_request(client.3230166:12 getattr
pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
caller_gid=0{}) v2
2021-04-27T11:57:03.467+0800 7fccbd3be700 20 mds.0.98 get_session have
0x56130c5ce480 client.3230166 v1:192.168.92.89:0/679429733 state open
2021-04-27T11:57:03.467+0800 7fccbd3be700 15 mds.0.server  oldest_client_tid=12
2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.cache request_start
request(client.3230166:12 nref=2 cr=0x56130db96480)
2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.server
dispatch_client_request client_request(client.3230166:12 getattr
pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800 caller_uid=0,
caller_gid=0{}) v2

2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0.locker
acquire_locks request(client.3230166:12 nref=3 cr=0x56130db96480)
2021-04-27T11:57:03.467+0800 7fccbd3be700 10
mds.0.cache.ino(0x100000003ed) auth_pin by 0x56130c584ed0 on [inode
0x100000003ed [2,head]
/QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
w=1) (iversion lock)
cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
| ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
0x56130c584a00] now 4
2021-04-27T11:57:03.467+0800 7fccbd3be700 15
mds.0.cache.dir(0x100000003eb) adjust_nested_auth_pins 1 on [dir
0x100000003eb /QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/
[2,head] auth pv=91586 v=91584 cv=0/0 ap=1+4 state=1610874881|complete
f(v0 m2021-04-23T15:00:04.377198+0800 6=6+0) n(v3
rc2021-04-27T11:57:02.625542+0800 b38005818 6=6+0) hs=6+0,ss=0+0
dirty=4 | child=1 dirty=1 waiter=0 authpin=1 0x56130c586a00] by
0x56130c584a00 count now 1/4
2021-04-27T11:57:03.467+0800 7fccbd3be700 10 mds.0
RecoveryQueue::prioritize not queued [inode 0x100000003ed [2,head]
/QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
w=1) (iversion lock)
cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
| ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
0x56130c584a00]
2021-04-27T11:57:03.467+0800 7fccbd3be700  7 mds.0.locker rdlock_start
waiting on (ifile mix->sync w=1) on [inode 0x100000003ed [2,head]
/QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
w=1) (iversion lock)
cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@2}
| ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=0 authpin=1
0x56130c584a00]
2021-04-27T11:57:03.467+0800 7fccbd3be700 10
mds.0.cache.ino(0x100000003ed) add_waiter tag 2000000040000000
0x56130ea1bbe0 !ambig 1 !frozen 1 !freezing 1
2021-04-27T11:57:03.467+0800 7fccbd3be700 15
mds.0.cache.ino(0x100000003ed) taking waiter here
2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.locker
client.3230166 pending pAsLsXsFr allowed pAsLsXsFrl wanted
pAsxXsxFsxcrwb
2021-04-27T11:57:03.468+0800 7fccbd3be700  7 mds.0.locker
handle_client_caps  on 0x100000003ed tid 0 follows 0 op update flags
0x2
2021-04-27T11:57:03.468+0800 7fccbd3be700 20 mds.0.98 get_session have
0x56130b81f600 client.3198501 v1:192.168.50.108:0/2478094748 state
open
2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  head inode
[inode 0x100000003ed [2,head]
/QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
w=1) (iversion lock)
cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
caps={3198501=pAsLsXsFr/pAsLsXsFrw/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
| ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
0x56130c584a00]
2021-04-27T11:57:03.468+0800 7fccbd3be700 10 mds.0.locker  follows 0
retains pAsLsXsFr dirty - on [inode 0x100000003ed [2,head]
/QTS/VOL_1/.ovirt_data_domain/37065419-e7f3-47ca-97df-8af0c67d30a0/dom_md/ids
auth v91583 pv91585 ap=4 recovering s=1048576 n(v0
rc2021-04-27T11:57:02.625542+0800 b1048576 1=1+0) (ifile mix->sync
w=1) (iversion lock)
cr={3198501=0-4194304@1,3198504=0-4194304@1,3221169=0-4194304@1}
caps={3198501=pAsLsXsFr/pAsxXsxFsxcrwb@17,3198504=pAsLsXsFr/pAsxXsxFsxcrwb@9,3230166=pAsLsXsFr/pAsxXsxFsxcrwb@2}
| ptrwaiter=1 request=1 lock=2 caps=1 dirty=1 waiter=1 authpin=1
0x56130c584a00]
2021-04-27T11:57:37.027+0800 7fccbb3ba700  0 log_channel(cluster) log
[WRN] : slow request 33.561029 seconds old, received at
2021-04-27T11:57:03.467164+0800: client_request(client.3230166:12
getattr pAsLsXsFs #0x100000003ed 2021-04-27T11:57:03.469426+0800
caller_uid=0, caller_gid=0{}) currently failed to rdlock, waiting

Any idea or insight to help to further investigate the issue are appreciated.

- Jerry
