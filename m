Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C481F83054
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 13:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfHFLLw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 07:11:52 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41997 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfHFLLw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Aug 2019 07:11:52 -0400
Received: by mail-ot1-f65.google.com with SMTP id l15so91454522otn.9
        for <ceph-devel@vger.kernel.org>; Tue, 06 Aug 2019 04:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mmVJPXFrJcBSEnPq6z6dNWwpYsS6W5Pg2Y6oOK03XAs=;
        b=DORep7xUrJ0QniyECf/UEjGqE8A8F+DtDGfoBwQkMM/lfKd7Y4F6zZ+PhF4sTWco/a
         etwJZh6HOckh3nICyb9ly+nIaSC20xJ7eBA7HKft8gappAagsXwciGHHRXM4iRHpTJ9Y
         hEeUi/+fixVN5qJp9FiBc7IOP49EvXS07+FlPD3FkPInMnzMcrj6xZBivKGHAliEIDL1
         ldout4uCV+Mk9KPmODakEMpq6wE7SNd3aaVqc2wPIa6N205sT2sJtBV2uCtZm+MdBWgM
         nltaNtTjKEuiZoPSOIEaCE6O/LFeclC8A39Pg2187csbIErlunPRQtr1nEZB8uFwTOjl
         8YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mmVJPXFrJcBSEnPq6z6dNWwpYsS6W5Pg2Y6oOK03XAs=;
        b=ndStmaK5yC1x9ngvH/L5WbHlDQjLWXMuWBgyicBc+idxTm65QYBWr5zz0VYCJUmsEA
         shsDxEb8UQmYZvnVMmwyudPYUVvoFLJteBjWM68hEZy/hi3yltdExLC54xJhvTq3DPjm
         2/3l/AUukr04KPpKp+XQQ6sZrrdY0J8imc2OYnYFbgI9wRwEB6ardDuz5R+LD8jocoVH
         uA6QG5zAIxWD6claJRoB9OcoUt/nGnl/H0xzUclouGLHQ6tOqv91hf6WDAd0QHSQ869O
         XmZj/D3n6JlumokEbCEj8TaMFLLdeELmEHE6mXDPQ9sqwGGs+XpOczCwpHNCF5EJi72p
         G/rA==
X-Gm-Message-State: APjAAAXvQWlhU9it7Zq1M0UlxQ0geCFCv4ef5gECNb5wgBd6tuNht4os
        zGRa0zKOF+AwH+EQutQCsnI34gqwM6fT4XbjKPg=
X-Google-Smtp-Source: APXvYqwiceWtpYv0+ZdgDNbFRP5dP4/L+DjGWf9SCqqn/5F7SMZbGkTjCgH2b9R1PsiOONLO4lQS+cInxAk9MiYidVo=
X-Received: by 2002:a9d:590b:: with SMTP id t11mr2718429oth.239.1565089910614;
 Tue, 06 Aug 2019 04:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
 <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
 <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
 <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com>
 <CAOi1vP8bSFvh600_q7SiMnOkV0BTKutD=qKP66Lh0FcNtH0kLw@mail.gmail.com> <CAKQB+ftuKxkkBN73rQx5x7-oqy=39fAac-4M-P0m3vm6KMZXew@mail.gmail.com>
In-Reply-To: <CAKQB+ftuKxkkBN73rQx5x7-oqy=39fAac-4M-P0m3vm6KMZXew@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Tue, 6 Aug 2019 19:11:35 +0800
Message-ID: <CAKQB+fuscd=W02Faj9syH0_C78A_yqm7abAYDpAb+S_6fuq0Jg@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

After simplifying the environment and the issue can be re-produced
much easier.  The IP and infrastructure are simply described as below:

CephFS Kernel Client (172.16.10.7, linux-4.14)
Node1 (172.16.10.17)
  - OSD0~2
Node2 (172.16.10.18)
  - OSD3~7
Node3 (172.16.10.19)
  - OSD8~12

The client mounts the CephFS right after the Node1 is setup.  And
every time a new Node joins the cluster, some files will be added to
the CephFS.  The issue always happens after the Nodes3 joins the
cluster and the stuck write op seems to be sent to the old pg acting
set although the epoch of osdmap on the client is already the same to
the one on ceph.

osdmap epoch 69
##############
Tue Aug  6 16:04:25 CST 2019
epoch 69 barrier 30 flags 0x188000
pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 64 pg_num_mask 63
flags 0x1 lfor 0 read_tier -1 write_tier -1
pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
flags 0x1 lfor 0 read_tier -1 write_tier -1
osd0    172.16.10.17:6802       100%    (exists, up)    100%
osd1    172.16.10.17:6806       100%    (exists, up)    100%
osd2    172.16.10.17:6810       100%    (exists, up)    100%
osd3    172.16.10.18:6801       100%    (exists, up)    100%
osd4    172.16.10.18:6805       100%    (exists, up)    100%
osd5    172.16.10.18:6809       100%    (exists, up)    100%
osd6    172.16.10.18:6813       100%    (exists, up)    100%
osd7    172.16.10.18:6817       100%    (exists, up)    100%
osd8    (unknown sockaddr family 0)       0%    (exists)        100%

(IO on Cephfs ...)

osdmap epoch 103
###############
Tue Aug  6 16:04:26 CST 2019
epoch 103 barrier 30 flags 0x188000
pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
127 flags 0x1 lfor 0 read_tier -1 write_tier -1
pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
flags 0x1 lfor 0 read_tier -1 write_tier -1
osd0    172.16.10.17:6802       100%    (exists, up)    100%
osd1    172.16.10.17:6806       100%    (exists, up)    100%
osd2    172.16.10.17:6810       100%    (exists, up)    100%
osd3    172.16.10.18:6801       100%    (exists, up)    100%
osd4    172.16.10.18:6805       100%    (exists, up)    100%
osd5    172.16.10.18:6809       100%    (exists, up)    100%
osd6    172.16.10.18:6813       100%    (exists, up)    100%
osd7    172.16.10.18:6817       100%    (exists, up)    100%
osd8    172.16.10.19:6801       100%    (exists, up)    100%
osd9    172.16.10.19:6805       100%    (exists, up)    100%
osd10   172.16.10.19:6809       100%    (exists, up)    100%
osd11   172.16.10.19:6813       100%    (exists, up)    100%
osd12   172.16.10.19:6817       100%    (exists, up)    100%

(IO on Cephfs ...)

osdmap epoch 103
###############
Tue Aug  6 16:04:38 CST 2019
epoch 103 barrier 30 flags 0x188000
pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
127 flags 0x1 lfor 0 read_tier -1 write_tier -1
pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
flags 0x1 lfor 0 read_tier -1 write_tier -1
osd0    172.16.10.17:6802       100%    (exists, up)    100%
osd1    172.16.10.17:6806       100%    (exists, up)    100%
osd2    172.16.10.17:6810       100%    (exists, up)    100%
osd3    172.16.10.18:6801       100%    (exists, up)    100%
osd4    172.16.10.18:6805       100%    (exists, up)    100%
osd5    172.16.10.18:6809       100%    (exists, up)    100%
osd6    172.16.10.18:6813       100%    (exists, up)    100%
osd7    172.16.10.18:6817       100%    (exists, up)    100%
osd8    172.16.10.19:6801       100%    (exists, up)    100%
osd9    172.16.10.19:6805       100%    (exists, up)    100%
osd10   172.16.10.19:6809       100%    (exists, up)    100%
osd11   172.16.10.19:6813       100%    (exists, up)    100%
osd12   172.16.10.19:6817       100%    (exists, up)    100%
REQUESTS 13 homeless 0
389     osd2    1.23964a4b      1.4b    [2,4,12]/2      [2,4,12]/2
 e103    10000000028.00000006    0x400024        1       write
365     osd5    1.cde1721f      1.1f    [5,10,2]/5      [5,10,2]/5
 e103    10000000017.00000007    0x400024        1       write
371     osd5    1.9d081620      1.20    [5,12,2]/5      [5,12,2]/5
 e103    10000000025.00000007    0x400024        1       write
375     osd5    1.8b5def1f      1.1f    [5,10,2]/5      [5,10,2]/5
 e103    1000000001f.00000006    0x400024        1       write
204     osd7    1.4dbcd0b2      1.32    [7,5,0]/7       [7,5,0]/7
 e103    10000000017.00000001    0x400024        1       write
373     osd7    1.8f57faf5      1.75    [7,11,2]/7      [7,11,2]/7
 e103    10000000027.00000007    0x400024        1       write
369     osd8    1.cec2d5dd      1.5d    [8,2,7]/8       [8,2,7]/8
 e103    10000000020.00000007    0x400024        1       write
378     osd8    1.3853fefc      1.7c    [8,3,2]/8       [8,3,2]/8
 e103    1000000001c.00000006    0x400024        1       write
384     osd8    1.342be187      1.7     [8,6,2]/8       [8,6,2]/8
 e103    1000000001b.00000006    0x400024        1       write
390     osd11   1.1ac10bad      1.2d    [11,5,2]/11     [11,5,2]/11
 e103    10000000028.00000007    0x400024        1       write
364     osd12   1.345417ca      1.4a    [12,7,2]/12     [12,7,2]/12
 e103    10000000017.00000006    0x400024        1       write
374     osd12   1.50114f4a      1.4a    [12,7,2]/12     [12,7,2]/12
 e103    10000000026.00000007    0x400024        1       write
381     osd12   1.d670203f      1.3f    [12,2,4]/12     [12,2,4]/12
 e103    10000000021.00000006    0x400024        1       write

(IO stop ...)

osdmap epoch 103
###############
Tue Aug  6 16:04:39 CST 2019
epoch 103 barrier 30 flags 0x188000
pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
127 flags 0x1 lfor 0 read_tier -1 write_tier -1
pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
flags 0x1 lfor 0 read_tier -1 write_tier -1
osd0    172.16.10.17:6802       100%    (exists, up)    100%
osd1    172.16.10.17:6806       100%    (exists, up)    100%
osd2    172.16.10.17:6810       100%    (exists, up)    100%
osd3    172.16.10.18:6801       100%    (exists, up)    100%
osd4    172.16.10.18:6805       100%    (exists, up)    100%
osd5    172.16.10.18:6809       100%    (exists, up)    100%
osd6    172.16.10.18:6813       100%    (exists, up)    100%
osd7    172.16.10.18:6817       100%    (exists, up)    100%
osd8    172.16.10.19:6801       100%    (exists, up)    100%
osd9    172.16.10.19:6805       100%    (exists, up)    100%
osd10   172.16.10.19:6809       100%    (exists, up)    100%
osd11   172.16.10.19:6813       100%    (exists, up)    100%
osd12   172.16.10.19:6817       100%    (exists, up)    100%
REQUESTS 1 homeless 0
204     osd7    1.4dbcd0b2      1.32    [7,5,0]/7       [7,5,0]/7
 e103    10000000017.00000001    0x400024        1       write


Strangely, the acting set of pg 1.32 shown on ceph is [7,1,9] instead
of [7,5,0].

[root@Jerry-x85-n2 ceph]# ceph pg dump | grep ^1.32
dumped all
1.32          1                  0        0         0       0  4194304
  3        3 active+clean 2019-08-06 16:03:33.978990    68'3   103:98
[7,1,9]          7  [7,1,9]

[root@Jerry-x85-n2 ceph]# grep -rn "replicas change" ceph-osd.7.log | grep 1.32
ceph-osd.7.log:1844:2019-08-06 15:59:53.276 7fa390256700 10 osd.7
pg_epoch: 66 pg[1.32( empty local-lis/les=64/65 n=0 ec=47/16 lis/c
64/64 les/c/f 65/65/0 66/66/64) [7,5,0] r=0 lpr=66 pi=[64,66)/1
crt=0'0 mlcod 0'0 unknown mbc={}] [7,5,2] -> [7,5,0], replicas changed
ceph-osd.7.log:15330:2019-08-06 16:02:38.769 7fa390256700 10 osd.7
pg_epoch: 84 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=66/67 n=2
ec=47/16 lis/c 66/66 les/c/f 67/67/0 66/84/64) [7,5,0] r=0 lpr=84
pi=[66,84)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,5,0] ->
[7,5,0], replicas changed
ceph-osd.7.log:25741:2019-08-06 16:02:53.618 7fa390256700 10 osd.7
pg_epoch: 90 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=84/85 n=1
ec=47/16 lis/c 84/84 les/c/f 85/85/0 90/90/64) [7,1,8] r=0 lpr=90
pi=[84,90)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,5,0] ->
[7,1,8], replicas changed
ceph-osd.7.log:37917:2019-08-06 16:03:17.932 7fa390256700 10 osd.7
pg_epoch: 100 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=90/91 n=1
ec=47/16 lis/c 90/90 les/c/f 91/97/0 100/100/64) [7,1,9] r=0 lpr=100
pi=[90,100)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,1,8] ->
[7,1,9], replicas changed

Related logs with debug_osd=10 and debug_ms=1 are provided in the
https://drive.google.com/open?id=1gYksDbCecisWtP05HEoSxevDK8sywKv6 .
Currently, I am tracing the code to figure out the root cause.  Any
ideas or insights will be appreciated, thanks!

- Jerry

On Wed, 31 Jul 2019 at 09:49, Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> On Tue, 30 Jul 2019 at 23:02, Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Tue, Jul 30, 2019 at 11:20 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > >
> > > Hello Ilya,
> > >
> > > On Mon, 29 Jul 2019 at 16:42, Ilya Dryomov <idryomov@gmail.com> wrote:
> > > >
> > > > On Fri, Jul 26, 2019 at 11:23 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > > >
> > > > > Some additional information are provided as below:
> > > > >
> > > > > I tried to restart the active MDS, and after the standby MDS took
> > > > > over, there is no client session recorded in the output of `ceph
> > > > > daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
> > > > > stuck write op finished immediately.  Thanks.
> > > >
> > > > So it happened again with the same OSD?  Did you see this with other
> > > > OSDs?
> > >
> > > Yes.  The issue always happened on the same OSD from previous
> > > experience.  However, it did happen with other OSD on other node from
> > > the Cephfs kernel client's point of view.
> >
> > Hi Jerry,
> >
> > I'm not sure what you mean by "it did happen with other OSD on other
> > node from the Cephfs kernel client's point of view".
> >
>
> Hi Ilya,
>
> Sorry, it simply means that I had only seen OSD on Node2 and Node3
> shown in the osdc debug output when encountering the issue but I
> didn't seen stuck write op sent to OSD on Node1.  So, in the
> beginning, I think that there might be some network connection issues
> among nodes.
>
> Node1 (where the kernel client umount stuck)
>    - OSD.0
>    - OSD.1
>    - ...
> Node2
>    - OSD.5
>    - OSD.6
>    - ...
> Node3
>    - OSD.10
>    - OSD.11
>    - ...
>
> > >
> > > >
> > > > Try enabling some logging on osd.13 since this seems to be a recurring
> > > > issue.  At least "debug ms = 1" so we can see whether it ever sends the
> > > > reply to the original op (i.e. prior to restart).
> > >
> > > Get it, I will raise the debug level to retrive more logs for further
> > > investigateion.
> > >
> > > >
> > > > Also, take note of the epoch in osdc output:
> > > >
> > > > 36      osd13   ... e327 ...
> > > >
> > > > Does "ceph osd dump" show the same epoch when things are stuck?
> > > >
> > >
> > > Unfortunately, the environment was gone.  But from the logs captured
> > > before, the epoch seems to be consistent between client and ceph
> > > cluster when thing are stuck, right?
> > >
> > > 2019-07-26 12:24:08.475 7f06efebc700  0 log_channel(cluster) log [DBG]
> > > : osdmap e306: 15 total, 15 up, 15 in
> > >
> > > BTW, logs of OSD.13 and dynamic debug kernel logs of libceph captured
> > > on the stuck node are provided in
> > > https://drive.google.com/drive/folders/1gYksDbCecisWtP05HEoSxevDK8sywKv6?usp=sharing.
> >
> > The libceph log confirms that it had two laggy requests but it ends
> > before you restarted the OSD.  The OSD log is useless: we really need
> > to see individual ops coming in and replies going out.  It appears that
> > the OSD simply dropped those ops expecting the kernel to resend them
> > but that didn't happen for some reason.
>
> Thanks for the analysis.  I will raise the debug level and hope more
> clues can be capatured.
>
> - Jerry
>
> >
> > Thanks,
> >
> >                 Ilya
