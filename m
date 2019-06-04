Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1734CD3
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfFDQHB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 12:07:01 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:38032 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfFDQHB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 12:07:01 -0400
Received: by mail-lf1-f53.google.com with SMTP id b11so16884830lfa.5
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 09:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9cyhs++gqwaFArY423xYBDsQwzdZS3GI1AuZbkSGH9Q=;
        b=lEmqFhjPg9jbwxrYzYVFS4G9yS1yKgBpnEvUdaBV4ZQEP+R0RWvyqPG1ia14Xbe/ej
         SKvaY7swlxTiMhKMhPqP1n00KtL4mw74+ISBeQmhAoEp8bhTs7sUE5N2VfBDs+/V7Phk
         An8Mj9dYFGQIJuKXqdX3I0FMsn1cF31Cq5uQ0shtCzWPZ2RKyy75dk080/TTwd1MpkbG
         eG5LZV29joJ1ZpfThO3WU36ISTcsMxEyjVMAKWUMvND27EWIe8u9kGY4lJTZB+AobWOs
         PPQv7FxYSExecnvnZ4kNqjPe5UXpQ0wUI+UGlbtzN3fLr44h2FEJeNE3hDmftNeDJmcr
         QxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9cyhs++gqwaFArY423xYBDsQwzdZS3GI1AuZbkSGH9Q=;
        b=A7zLn52x3QNJ2/29nArfp8nMoXWWQI5R72Q/uVLEqq6ZEQg7Ab1x152Vw/LPTHQiWE
         VEnAwkOqHFxJFpM6NAeEqVQ2cc1M7eTzR/HdbIu4Y67Ac72TNiNCtGVct9VVSD7CZRtb
         iTB/lv4U2crtrToTbhOn1y688KR2Z0F6vTWI1D78CILJHM0kwRCk284NQycr3X6R09lC
         VdS9jr9gvQ5EJKEMa5q8+mB8fA5a9NWIgLMs9QyHV88E3e6SvMJwBEO83rwU8LDSQPZ7
         igVvppS5ykZjpeNFNDiik5GZmd9X62GNyuZraUHZejHwT0aojMM1W06d4HfNJX0XhJhU
         6yJg==
X-Gm-Message-State: APjAAAXdqe+Zn75LZMIhr15ZWq7U4VD2njYzuUVPVwbVV9OWg6LPlC3U
        uJMxSdvKV6UZz7dgk6wDmlP3hVs55e0SX7Tuac56yd5YneCCPw==
X-Google-Smtp-Source: APXvYqzwvMM5j0MSzoLtsHm7pjhfkB3uBYHHdyITWc1K+WP/Et1XwAkCrxNk3cpC+lzTQjTNJ2hR2Pizc2CPV42G/00=
X-Received: by 2002:ac2:5922:: with SMTP id v2mr17001788lfi.180.1559664418175;
 Tue, 04 Jun 2019 09:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAE63xUM=y_EJjtdzJud_=cL4-iPX6CBBUMGbAQ5q+yZ9RCr8iA@mail.gmail.com>
 <alpine.DEB.2.11.1906041336210.12100@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906041336210.12100@piezo.novalocal>
From:   Ugis <ugis22@gmail.com>
Date:   Tue, 4 Jun 2019 19:06:46 +0300
Message-ID: <CAE63xUP9tYzyTHqasDBh8dkeVDJoBnTUKC8BHzHXf8xVH1OQwQ@mail.gmail.com>
Subject: Re: rbd blocking, no health warning
To:     Sage Weil <sage@newdream.net>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Actually it seems that mgr-mon communication is impaired. Mon did not
notice several events, like pg fixing. Here follow details:

>
> This is definitely a bug.  Did the ceph health indicate there was a slow
> mon request?

Not today, but I have been struggling lately with health warnings like:
2019-06-03 06:25:05.582 7f57e1599700  0 log_channel(cluster) log [WRN]
: Health check update: 2 slow ops, oldest one blocked for 210113 sec,
daemons [mon,ceph1,mon,ceph6] have slow ops. (SLOW_OPS)

Regarding this I have found open bug:
https://tracker.ceph.com/issues/24531 and did just restart mon-ceph6
and warning did go away. As I understand this bug is still open and
this is only available workaround.

> Note that 633956sec is ~1 week... so that also looks fishy.  Is it
> possible the clocks shifted on your OSD nodes?
Clocks are in sync.

> >
> > Question: why ceph health detail did not inform about blocking osd
> > issue? Is it a bug?

> That also sounds like a bug.
>
> What does your 'ceph -s' say?  Is it possible your mgr is down or
> something?  (The OSD health alerts are fed via the mgr to the mon.)
>
mgr had been up last days.

# ceph -s
  cluster:
    id:     ....
    health: HEALTH_OK

  services:
    mon: 3 daemons, quorum ceph1,ceph3,ceph6 (age 22h)
    mgr: ceph3(active, since 4d), standbys: ceph6, ceph1
    mds: cephfs_cards:1 {0=ceph3=up:active} 2 up:standby
    osd: 50 osds: 50 up (since 5h), 50 in (since 29h)

May be this is related(in case mgr-mon communication is impaired) may
be not but while health detail showed:
# ceph health detail
HEALTH_OK

#ceph -s showed
...
    pgs:     10807 active+clean
             1     active+recovering+repair

I guess "ceph health detail" should show degraded pg?

only way I could get affected pg is:
# ceph pg dump | grep repair
dumped all
51.311      949                  0        0         0       0
3959836672           0          0 3024     3024
active+recovering+repair 2019-06-04 12:45:44.637012   372024'541394
372027:1595236 [21,33,17]         21 [21,33,17]             21
372024'541394 2019-06-04 09:56:30.003549   372024'541394 2019-06-04
09:56:30.003549             0
My feeling was that this pg was not actually repairing(confirmed
below). I have had degraded pgs before, after instructing those to
repair usually ceph fixed inconsistencies in several minutes, this one
was hanging for hours.

I just tried also
# ceph pg deep-scrub 51.311
instructing pg 51.311 on osd.21 to deep-scrub
but did not notice any changes.

noticed osd.21

# tail -f /var/log/ceph/ceph-osd.21.log
2019-06-04 18:31:02.960 7fb9bde61700 -1 osd.21 372028
get_health_metrics reporting 1 slow ops, oldest is
osd_op(client.132208000.1:200705740 51.13404b11
51:88d202c8:::rbd_data.5924292ae8944a.0000000000111cd6:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
2924544~12288] snapc 0=[] ondisk+write e372024)
2019-06-04 18:31:03.984 7fb9bde61700 -1 osd.21 372028
get_health_metrics reporting 1 slow ops, oldest is
osd_op(client.132208000.1:200705740 51.13404b11
51:88d202c8:::rbd_data.5924292ae8944a.0000000000111cd6:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
2924544~12288] snapc 0=[] ondisk+write e372024)
2019-06-04 18:31:04.980 7fb9bde61700 -1 osd.21 372028
get_health_metrics reporting 1 slow ops, oldest is
osd_op(client.132208000.1:200705740 51.13404b11
51:88d202c8:::rbd_data.5924292ae8944a.0000000000111cd6:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
2924544~12288] snapc 0=[] ondisk+write e372024)
2019-06-04 18:31:06.000 7fb9bde61700 -1 osd.21 372028
get_health_metrics reporting 1 slow ops, oldest is
osd_op(client.132208000.1:200705740 51.13404b11
51:88d202c8:::rbd_data.5924292ae8944a.0000000000111cd6:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
2924544~12288] snapc 0=[] ondisk+write e372024)

restarted osd.21

grep'ed logs from osd.21 regarding pg 51.311 - it turns out it had
been fixed 1min after repair start but "ceph -s" did not notice it.

cat /var/log/ceph/ceph-osd.21.log | grep "51.311"
2019-06-04 09:55:41.860 7fb9a8636700  0 log_channel(cluster) log [DBG]
: 51.311 repair starts
2019-06-04 09:56:08.607 7fb9a8636700 -1 log_channel(cluster) log [ERR]
: 51.311 soid 51:88d202c8:::rbd_data.5924292ae8944a.0000000000111cd6:head
: data_digest 0x2e4cfea6 != data_digest 0x3d267a8b from shard 21,
object info inconsistent
2019-06-04 09:56:29.999 7fb9a8636700 -1 log_channel(cluster) log [ERR]
: 51.311 repair 0 missing, 1 inconsistent objects
2019-06-04 09:56:29.999 7fb9a8636700 -1 log_channel(cluster) log [ERR]
: 51.311 repair 1 errors, 1 fixed
2019-06-04 18:33:27.679 7f7e8e11d700  1 osd.21 pg_epoch: 372028
pg[51.311( v 372024'541394 (369590'538370,372024'541394]
local-lis/les=371314/371329 n=949 ec=351229/251376 lis/c 371314/371314
les/c/f 371329/371616/0 371314/371314/371314) [21,33,17] r=0
lpr=372024 crt=372024'541394 lcod 0'0 mlcod 0'0 unknown mbc={}]
state<Start>: transitioning to Primary
2019-06-04 18:33:28.787 7f7e8e11d700  1 osd.21 pg_epoch: 372029
pg[51.311( v 372024'541394 (369590'538370,372024'541394]
local-lis/les=371314/371329 n=949 ec=351229/251376 lis/c 371314/371314
les/c/f 371329/371616/0 371314/371314/371314) [21,33,17] r=0
lpr=372024 crt=372024'541394 lcod 0'0 mlcod 0'0 peering mbc={}]
state<Started/Primary/Peering>: Peering, affected_by_map, going to
Reset
2019-06-04 18:33:28.787 7f7e8e11d700  1 osd.21 pg_epoch: 372029
pg[51.311( v 372024'541394 (369590'538370,372024'541394]
local-lis/les=371314/371329 n=949 ec=351229/251376 lis/c 371314/371314
les/c/f 371329/371616/0 372029/372029/372029) [33,17] r=-1 lpr=372029
pi=[371314,372029)/1 crt=372024'541394 lcod 0'0 unknown mbc={}]
start_peering_interval up [21,33,17] -> [33,17], acting [21,33,17] ->
[33,17], acting_primary 21 -> 33, up_primary 21 -> 33, role 0 -> -1,
features acting 4611087854031667199 upacting 4611087854031667199
2019-06-04 18:33:28.787 7f7e8e11d700  1 osd.21 pg_epoch: 372031
pg[51.311( v 372024'541394 (369590'538370,372024'541394]
local-lis/les=371314/371329 n=949 ec=351229/251376 lis/c 371314/371314
les/c/f 371329/371616/0 372031/372031/372031) [21,33,17] r=0
lpr=372031 pi=[371314,372031)/1 crt=372024'541394 lcod 0'0 mlcod 0'0
unknown NOTIFY mbc={}] start_peering_interval up [33,17] ->
[21,33,17], acting [33,17] -> [21,33,17], acting_primary 33 -> 21,
up_primary 33 -> 21, role -1 -> 0, features acting 4611087854031667199
upacting 4611087854031667199
2019-06-04 18:33:28.787 7f7e8e11d700  1 osd.21 pg_epoch: 372031
pg[51.311( v 372024'541394 (369590'538370,372024'541394]
local-lis/les=371314/371329 n=949 ec=351229/251376 lis/c 371314/371314
les/c/f 371329/371616/0 372031/372031/372031) [21,33,17] r=0
lpr=372031 pi=[371314,372031)/1 crt=372024'541394 lcod 0'0 mlcod 0'0
unknown mbc={}] state<Start>: transitioning to Primary

after osd.21 restart(or coincidence with some other efforts like
deep-scrubbing) "ceph -s" shows all pgs active+clean.

So it really seems that mon does not notice all events that happen.

Ugis
