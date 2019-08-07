Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CA85230
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2019 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388640AbfHGRiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Aug 2019 13:38:06 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36235 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387999AbfHGRiG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Aug 2019 13:38:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id r6so107530679oti.3
        for <ceph-devel@vger.kernel.org>; Wed, 07 Aug 2019 10:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAtWA7zkxIyAP1zdtxlRCSLC4J0ahC7nq1gwrtp+Cbc=;
        b=m58duGKasBRFPfrzZViBINFc9Jc/E0dkTrPs0Z+TfRV4RI4gY9dK7FzgxG+TvqQw+R
         sewby+0CRV7mhllRHu0DHdu7z3dhHL9MzUBqMa8BNL/yo3OZuR/U9N46BcshwWIpaYHo
         fWwHK26u8F124BN44Jquwe7rHsUXm9JjB4PH2PODs/oTll/7ueu5JOvYDJQZL2YCnm6u
         bE0QvDeTCF9felCz05TR534qoof8WQFL2ituqUVXc+nnN1LoRoaRnaA2t3SZ6zdlvOmc
         Hmg4lQ4fCkvMnG+jjeJRZQ+NHVUpMntrOSwfBcP6nUEGTeL4MP9ZYIWt5AsL6RgTy5T8
         IoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAtWA7zkxIyAP1zdtxlRCSLC4J0ahC7nq1gwrtp+Cbc=;
        b=DIRYrxfFdrtpvBcOvIJCwMkxoS/XCwNw+xhIXwfwFL12PKb6vhNNmqMK8RvULQmyv0
         6m5LHKkNN2KnfHst58zCevADK9IfS4BmuJKSGHzAiQ1N7ZXgF6S8G+tS1iEDTRUxm7sc
         MYa/Qpepr+VMTtsUfb8vbY4JLCT4fFFVVf6jseib1DI13V0Wxh4pTxuYFI2uX9hcUeLE
         zc4ETWZ+kUCzGSfj1K7x0Korhc41l9XvlMe52MHr/6fMUjV96CWmrwIdtMzjiNy1Ah7h
         BLcT57H60YWoyGHvqOG2MEEJU1rz/emjGwAFBaCDZsF7HIfwTv8FXbJgnhNOd/2EzmU/
         E0yg==
X-Gm-Message-State: APjAAAUooaqMCck/1DO9mgu7R8ojg87/FU+6LHRbvRlaNHv0288O0MHq
        7PUyZfNFywtUJ0CtAdr+nsGLzMbNsy22/x+C9tnC1XZG
X-Google-Smtp-Source: APXvYqzDBdU/uY4Q0e4UQx2oG1dzQQufWhs2L2GhSGIna2QCeuOnw3+zZr/dO3+H3qTlVsPhu7uy9rf3pX9S0wysJ5M=
X-Received: by 2002:a05:6638:149:: with SMTP id y9mr11499205jao.76.1565199484964;
 Wed, 07 Aug 2019 10:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
 <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
 <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
 <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com>
 <CAOi1vP8bSFvh600_q7SiMnOkV0BTKutD=qKP66Lh0FcNtH0kLw@mail.gmail.com>
 <CAKQB+ftuKxkkBN73rQx5x7-oqy=39fAac-4M-P0m3vm6KMZXew@mail.gmail.com>
 <CAKQB+fuscd=W02Faj9syH0_C78A_yqm7abAYDpAb+S_6fuq0Jg@mail.gmail.com> <CAOi1vP8cvc6+S-GSiy-xKw4P+o4vtc=q4eggfaza_hG0yYf9HA@mail.gmail.com>
In-Reply-To: <CAOi1vP8cvc6+S-GSiy-xKw4P+o4vtc=q4eggfaza_hG0yYf9HA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Aug 2019 19:41:02 +0200
Message-ID: <CAOi1vP_7k7M6Quwfr+fZ_Hb4WCA73HVb8J69143mmjAZzh0Lxg@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 7, 2019 at 10:15 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Aug 6, 2019 at 1:11 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > Hi,
> >
> > After simplifying the environment and the issue can be re-produced
> > much easier.  The IP and infrastructure are simply described as below:
> >
> > CephFS Kernel Client (172.16.10.7, linux-4.14)
> > Node1 (172.16.10.17)
> >   - OSD0~2
> > Node2 (172.16.10.18)
> >   - OSD3~7
> > Node3 (172.16.10.19)
> >   - OSD8~12
> >
> > The client mounts the CephFS right after the Node1 is setup.  And
> > every time a new Node joins the cluster, some files will be added to
> > the CephFS.  The issue always happens after the Nodes3 joins the
> > cluster and the stuck write op seems to be sent to the old pg acting
> > set although the epoch of osdmap on the client is already the same to
> > the one on ceph.
> >
> > osdmap epoch 69
> > ##############
> > Tue Aug  6 16:04:25 CST 2019
> > epoch 69 barrier 30 flags 0x188000
> > pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 64 pg_num_mask 63
> > flags 0x1 lfor 0 read_tier -1 write_tier -1
> > pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
> > flags 0x1 lfor 0 read_tier -1 write_tier -1
> > osd0    172.16.10.17:6802       100%    (exists, up)    100%
> > osd1    172.16.10.17:6806       100%    (exists, up)    100%
> > osd2    172.16.10.17:6810       100%    (exists, up)    100%
> > osd3    172.16.10.18:6801       100%    (exists, up)    100%
> > osd4    172.16.10.18:6805       100%    (exists, up)    100%
> > osd5    172.16.10.18:6809       100%    (exists, up)    100%
> > osd6    172.16.10.18:6813       100%    (exists, up)    100%
> > osd7    172.16.10.18:6817       100%    (exists, up)    100%
> > osd8    (unknown sockaddr family 0)       0%    (exists)        100%
> >
> > (IO on Cephfs ...)
> >
> > osdmap epoch 103
> > ###############
> > Tue Aug  6 16:04:26 CST 2019
> > epoch 103 barrier 30 flags 0x188000
> > pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
> > 127 flags 0x1 lfor 0 read_tier -1 write_tier -1
> > pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
> > flags 0x1 lfor 0 read_tier -1 write_tier -1
> > osd0    172.16.10.17:6802       100%    (exists, up)    100%
> > osd1    172.16.10.17:6806       100%    (exists, up)    100%
> > osd2    172.16.10.17:6810       100%    (exists, up)    100%
> > osd3    172.16.10.18:6801       100%    (exists, up)    100%
> > osd4    172.16.10.18:6805       100%    (exists, up)    100%
> > osd5    172.16.10.18:6809       100%    (exists, up)    100%
> > osd6    172.16.10.18:6813       100%    (exists, up)    100%
> > osd7    172.16.10.18:6817       100%    (exists, up)    100%
> > osd8    172.16.10.19:6801       100%    (exists, up)    100%
> > osd9    172.16.10.19:6805       100%    (exists, up)    100%
> > osd10   172.16.10.19:6809       100%    (exists, up)    100%
> > osd11   172.16.10.19:6813       100%    (exists, up)    100%
> > osd12   172.16.10.19:6817       100%    (exists, up)    100%
> >
> > (IO on Cephfs ...)
> >
> > osdmap epoch 103
> > ###############
> > Tue Aug  6 16:04:38 CST 2019
> > epoch 103 barrier 30 flags 0x188000
> > pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
> > 127 flags 0x1 lfor 0 read_tier -1 write_tier -1
> > pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
> > flags 0x1 lfor 0 read_tier -1 write_tier -1
> > osd0    172.16.10.17:6802       100%    (exists, up)    100%
> > osd1    172.16.10.17:6806       100%    (exists, up)    100%
> > osd2    172.16.10.17:6810       100%    (exists, up)    100%
> > osd3    172.16.10.18:6801       100%    (exists, up)    100%
> > osd4    172.16.10.18:6805       100%    (exists, up)    100%
> > osd5    172.16.10.18:6809       100%    (exists, up)    100%
> > osd6    172.16.10.18:6813       100%    (exists, up)    100%
> > osd7    172.16.10.18:6817       100%    (exists, up)    100%
> > osd8    172.16.10.19:6801       100%    (exists, up)    100%
> > osd9    172.16.10.19:6805       100%    (exists, up)    100%
> > osd10   172.16.10.19:6809       100%    (exists, up)    100%
> > osd11   172.16.10.19:6813       100%    (exists, up)    100%
> > osd12   172.16.10.19:6817       100%    (exists, up)    100%
> > REQUESTS 13 homeless 0
> > 389     osd2    1.23964a4b      1.4b    [2,4,12]/2      [2,4,12]/2
> >  e103    10000000028.00000006    0x400024        1       write
> > 365     osd5    1.cde1721f      1.1f    [5,10,2]/5      [5,10,2]/5
> >  e103    10000000017.00000007    0x400024        1       write
> > 371     osd5    1.9d081620      1.20    [5,12,2]/5      [5,12,2]/5
> >  e103    10000000025.00000007    0x400024        1       write
> > 375     osd5    1.8b5def1f      1.1f    [5,10,2]/5      [5,10,2]/5
> >  e103    1000000001f.00000006    0x400024        1       write
> > 204     osd7    1.4dbcd0b2      1.32    [7,5,0]/7       [7,5,0]/7
> >  e103    10000000017.00000001    0x400024        1       write
> > 373     osd7    1.8f57faf5      1.75    [7,11,2]/7      [7,11,2]/7
> >  e103    10000000027.00000007    0x400024        1       write
> > 369     osd8    1.cec2d5dd      1.5d    [8,2,7]/8       [8,2,7]/8
> >  e103    10000000020.00000007    0x400024        1       write
> > 378     osd8    1.3853fefc      1.7c    [8,3,2]/8       [8,3,2]/8
> >  e103    1000000001c.00000006    0x400024        1       write
> > 384     osd8    1.342be187      1.7     [8,6,2]/8       [8,6,2]/8
> >  e103    1000000001b.00000006    0x400024        1       write
> > 390     osd11   1.1ac10bad      1.2d    [11,5,2]/11     [11,5,2]/11
> >  e103    10000000028.00000007    0x400024        1       write
> > 364     osd12   1.345417ca      1.4a    [12,7,2]/12     [12,7,2]/12
> >  e103    10000000017.00000006    0x400024        1       write
> > 374     osd12   1.50114f4a      1.4a    [12,7,2]/12     [12,7,2]/12
> >  e103    10000000026.00000007    0x400024        1       write
> > 381     osd12   1.d670203f      1.3f    [12,2,4]/12     [12,2,4]/12
> >  e103    10000000021.00000006    0x400024        1       write
> >
> > (IO stop ...)
> >
> > osdmap epoch 103
> > ###############
> > Tue Aug  6 16:04:39 CST 2019
> > epoch 103 barrier 30 flags 0x188000
> > pool 1 'cephfs_data' type 1 size 3 min_size 2 pg_num 128 pg_num_mask
> > 127 flags 0x1 lfor 0 read_tier -1 write_tier -1
> > pool 2 'cephfs_md' type 1 size 3 min_size 2 pg_num 32 pg_num_mask 31
> > flags 0x1 lfor 0 read_tier -1 write_tier -1
> > osd0    172.16.10.17:6802       100%    (exists, up)    100%
> > osd1    172.16.10.17:6806       100%    (exists, up)    100%
> > osd2    172.16.10.17:6810       100%    (exists, up)    100%
> > osd3    172.16.10.18:6801       100%    (exists, up)    100%
> > osd4    172.16.10.18:6805       100%    (exists, up)    100%
> > osd5    172.16.10.18:6809       100%    (exists, up)    100%
> > osd6    172.16.10.18:6813       100%    (exists, up)    100%
> > osd7    172.16.10.18:6817       100%    (exists, up)    100%
> > osd8    172.16.10.19:6801       100%    (exists, up)    100%
> > osd9    172.16.10.19:6805       100%    (exists, up)    100%
> > osd10   172.16.10.19:6809       100%    (exists, up)    100%
> > osd11   172.16.10.19:6813       100%    (exists, up)    100%
> > osd12   172.16.10.19:6817       100%    (exists, up)    100%
> > REQUESTS 1 homeless 0
> > 204     osd7    1.4dbcd0b2      1.32    [7,5,0]/7       [7,5,0]/7
> >  e103    10000000017.00000001    0x400024        1       write
> >
> >
> > Strangely, the acting set of pg 1.32 shown on ceph is [7,1,9] instead
> > of [7,5,0].
> >
> > [root@Jerry-x85-n2 ceph]# ceph pg dump | grep ^1.32
> > dumped all
> > 1.32          1                  0        0         0       0  4194304
> >   3        3 active+clean 2019-08-06 16:03:33.978990    68'3   103:98
> > [7,1,9]          7  [7,1,9]
> >
> > [root@Jerry-x85-n2 ceph]# grep -rn "replicas change" ceph-osd.7.log | grep 1.32
> > ceph-osd.7.log:1844:2019-08-06 15:59:53.276 7fa390256700 10 osd.7
> > pg_epoch: 66 pg[1.32( empty local-lis/les=64/65 n=0 ec=47/16 lis/c
> > 64/64 les/c/f 65/65/0 66/66/64) [7,5,0] r=0 lpr=66 pi=[64,66)/1
> > crt=0'0 mlcod 0'0 unknown mbc={}] [7,5,2] -> [7,5,0], replicas changed
> > ceph-osd.7.log:15330:2019-08-06 16:02:38.769 7fa390256700 10 osd.7
> > pg_epoch: 84 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=66/67 n=2
> > ec=47/16 lis/c 66/66 les/c/f 67/67/0 66/84/64) [7,5,0] r=0 lpr=84
> > pi=[66,84)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,5,0] ->
> > [7,5,0], replicas changed
> > ceph-osd.7.log:25741:2019-08-06 16:02:53.618 7fa390256700 10 osd.7
> > pg_epoch: 90 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=84/85 n=1
> > ec=47/16 lis/c 84/84 les/c/f 85/85/0 90/90/64) [7,1,8] r=0 lpr=90
> > pi=[84,90)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,5,0] ->
> > [7,1,8], replicas changed
> > ceph-osd.7.log:37917:2019-08-06 16:03:17.932 7fa390256700 10 osd.7
> > pg_epoch: 100 pg[1.32( v 68'3 (0'0,68'3] local-lis/les=90/91 n=1
> > ec=47/16 lis/c 90/90 les/c/f 91/97/0 100/100/64) [7,1,9] r=0 lpr=100
> > pi=[90,100)/1 crt=68'3 lcod 68'2 mlcod 0'0 unknown mbc={}] [7,1,8] ->
> > [7,1,9], replicas changed
> >
> > Related logs with debug_osd=10 and debug_ms=1 are provided in the
> > https://drive.google.com/open?id=1gYksDbCecisWtP05HEoSxevDK8sywKv6 .
> > Currently, I am tracing the code to figure out the root cause.  Any
> > ideas or insights will be appreciated, thanks!
>
> Hi Jerry,
>
> So the original request was dropped by osd.7 because the PG got split:
>
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 dequeue_op
> 0x561adf90f500 prio 127 cost 4194304 latency 0.015565
> osd_op(client.4418.0:204 1.32 1.4dbcd0b2 (undecoded)
> ondisk+write+known_if_redirected e69) v8 pg pg[1.32( v 68'3 (0'0,68'3]
> local-lis/les=100/101 n=1 ec=47/16 lis/c 100/100 les/c/f 101/102/0
> 100/100/64) [7,1,9] r=0 lpr=100 crt=68'3 lcod 68'2 mlcod 0'0
> active+clean]
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 client.4418 has old
> map 69 < 103
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 send_incremental_map
> 69 -> 103 to 0x561ae4cfb600 172.16.10.7:0/3068540720
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 add_map_inc_bl 80 220 bytes
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 add_map_inc_bl 72 240 bytes
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 add_map_inc_bl 71 240 bytes
> 2019-08-06 16:04:25.747 7fa390256700 10 osd.7 103 add_map_inc_bl 70 240 bytes
> 2019-08-06 16:04:25.747 7fa390256700  7 osd.7 pg_epoch: 103 pg[1.32( v
> 68'3 (0'0,68'3] local-lis/les=100/101 n=1 ec=47/16 lis/c 100/100
> les/c/f 101/102/0 100/100/64) [7,1,9] r=0 lpr=100 crt=68'3 lcod 68'2
> mlcod 0'0 active+clean] can_discard_op pg split in 84, dropping
> 2019-08-06 16:04:25.748 7fa390256700 10 osd.7 103 dequeue_op
> 0x561adf90f500 finish
>
> The request was never resent -- this appears to be a kernel client bug.
>
> It would be great if you could reproduce with
>
> echo 'file osd_client +p' > /sys/kernel/debug/dynamic_debug/control
>
> on the kernel client node and the same set of logs on the OSD side.
>
> Looking...

Nothing so far.  The split detection logic appears to work.
There were 11 other requests dropped by the OSDs due to splits and they
were all handled correctly:

Split in epoch 47:

orig  osd2 osd_op(client.4418.0:5 1.f 1.b1e464af (undecoded)
ondisk+write+known_if_redirected e35)
retry osd0 osd_op(client.4418.0:5 1.2f 1.b1e464af (undecoded)
ondisk+retry+write+known_if_redirected e68)

orig  osd0 osd_op(client.4418.0:13 1.10 1.fec32590 (undecoded)
ondisk+write+known_if_redirected e35)
retry osd0 osd_op(client.4418.0:13 1.10 1.fec32590 (undecoded)
ondisk+retry+write+known_if_redirected e68)

Split in epoch 84:

orig  osd5 osd_op(client.4418.0:194 1.20 1.260bc0e0 (undecoded)
ondisk+write+known_if_redirected e69)
retry osd0 osd_op(client.4418.0:194 1.60 1.260bc0e0 (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd3 osd_op(client.4418.0:195 1.33 1.9b583df3 (undecoded)
ondisk+write+known_if_redirected e69)
retry osd1 osd_op(client.4418.0:195 1.73 1.9b583df3 (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd1 osd_op(client.4418.0:197 1.1a 1.a986dc1a (undecoded)
ondisk+write+known_if_redirected e69)
retry osd1 osd_op(client.4418.0:197 1.1a 1.a986dc1a (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd2 osd_op(client.4418.0:198 1.14 1.b93e34d4 (undecoded)
ondisk+write+known_if_redirected e69)
retry osd4 osd_op(client.4418.0:198 1.54 1.b93e34d4 (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd1 osd_op(client.4418.0:199 1.1a 1.92ca525a (undecoded)
ondisk+write+known_if_redirected e69)
retry osd11 osd_op(client.4418.0:199 1.5a 1.92ca525a (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd0 osd_op(client.4418.0:202 1.3b 1.6388bdbb (undecoded)
ondisk+write+known_if_redirected e69)
retry osd0 osd_op(client.4418.0:202 1.3b 1.6388bdbb (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd3 osd_op(client.4418.0:203 1.1e 1.fe5731e (undecoded)
ondisk+write+known_if_redirected e69)
retry osd3 osd_op(client.4418.0:203 1.1e 1.fe5731e (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd7 osd_op(client.4418.0:204 1.32 1.4dbcd0b2 (undecoded)
ondisk+write+known_if_redirected e69)
retry ???

orig  osd0 osd_op(client.4418.0:205 1.10 1.42c29750 (undecoded)
ondisk+write+known_if_redirected e69)
retry osd0 osd_op(client.4418.0:205 1.50 1.42c29750 (undecoded)
ondisk+retry+write+known_if_redirected e103)

orig  osd3 osd_op(client.4418.0:207 1.33 1.918809b3 (undecoded)
ondisk+write+known_if_redirected e69)
retry osd3 osd_op(client.4418.0:207 1.33 1.918809b3 (undecoded)
ondisk+retry+write+known_if_redirected e103)

This shows that both staying in the old PG and moving to the new PG
cases are handled correctly, as staying on the same OSD and moving to
the new OSD.  The request in question (tid 204) is on the right list
as indicated by e103 in osdc output, but it looks like something went
wrong inside calc_target().

What is the exact kernel version you are running?  I know you said
4.14, but you also mentioned some customizations...

Thanks,

                Ilya
