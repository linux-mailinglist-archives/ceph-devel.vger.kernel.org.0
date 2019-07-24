Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1243972FCD
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 15:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfGXNZ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 09:25:29 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:37896 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfGXNZ2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 09:25:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id C834C15F89C;
        Wed, 24 Jul 2019 06:25:25 -0700 (PDT)
Date:   Wed, 24 Jul 2019 13:25:23 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Matt Benjamin <mbenjami@redhat.com>
cc:     Igor Fedotov <ifedotov@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: seen today on master (vstart rgw cluster)
In-Reply-To: <CAKOnarmkm-dX+Fp+7R9sgQzupn1kLwL77FT8SdXh6qGB5+dpKw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1907241323260.26683@piezo.novalocal>
References: <CAKOnarkzDoo3bWVGuDa7156Qziu9rP0gXKYeYPg_kZQGC_3x0A@mail.gmail.com> <37eafd99-bafd-75d5-acde-c550f3962892@suse.de> <CAKOnarmOeD0GDQTi4dnmU+tZjVDSp37aGXUx_FV1bb_3ga09Mg@mail.gmail.com>
 <CAKOnarmkm-dX+Fp+7R9sgQzupn1kLwL77FT8SdXh6qGB5+dpKw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdeitdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinheprhgvughhrghtrdgtohhmpdgsuhgtkhgvthhsrdgurghtrgdprhhgfidrphhgnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 24 Jul 2019, Matt Benjamin wrote:
> actually, there's more to this (presumably it's something dumb, but...)
> 
> 1. the partition on which the vstart.sh cluster is hosted has 3TB of free space

vstart uses bluestore, which means it creates a file to serve as a 
bluestore's backing block device.  By default it is only 10 GB.

> 2. I at first thought, after seeing your email, that the issue must be
> that I had (shamefully) re-run vstart.sh in a dirty location, which
> seems bogus; so I repeated after nuking the location--no luck, repeats
> (crash here after creating appx. 100K S3 objects)
> 3. I reverted to a local build of our downstream Luminous
> baseline--works as expected

Luminous vstart defaults to filestore.

We could increase the default bluestore file size to something like 1 
TB?  It doesn't really matter since it's a sparse file.

sage



> 
> Matt
> 
> On Tue, Jul 23, 2019 at 4:51 PM Matt Benjamin <mbenjami@redhat.com> wrote:
> >
> > huh, should be impossible--sorry I missed that
> >
> > Matt
> >
> > On Tue, Jul 23, 2019 at 4:51 PM Igor Fedotov <ifedotov@suse.de> wrote:
> > >
> > > Hi Matt,
> > >
> > > I can see ENOSPC error in the log hence looks like your OSD is out-of-space.
> > >
> > >
> > > Thanks,
> > >
> > > Igor
> > >
> > > On 7/23/2019 11:42 PM, Matt Benjamin wrote:
> > > >    -138> 2019-07-23T16:22:57.340-0400 7f67f4243700 20 bdev aio_wait
> > > > 0x55b385d4dc70 done
> > > >    -137> 2019-07-23T16:22:57.340-0400 7f67f4243700 10 bluefs
> > > > wait_for_aio 0x55b360298000 done in 0.000003
> > > >    -136> 2019-07-23T16:22:57.340-0400 7f67f4243700 20 bluefs flush_bdev
> > > >    -135> 2019-07-23T16:22:57.340-0400 7f67f4243700 10
> > > > bdev(0x55b35f1e8700 /lv2tb/ceph-noob/build/dev/osd0/block.wal) flush
> > > > start
> > > >    -134> 2019-07-23T16:22:57.340-0400 7f67f4243700  5
> > > > bdev(0x55b35f1e8700 /lv2tb/ceph-noob/build/dev/osd0/block.wal) flush
> > > > in 0.000007
> > > >    -133> 2019-07-23T16:22:57.340-0400 7f67f4243700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_sync_thread committed 0
> > > > cleaned 0 in 0.001047751s (0.000001379s flush + 0.001046372s kv
> > > > commit)
> > > >    -132> 2019-07-23T16:22:57.340-0400 7f67f4243700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_sync_thread sleep
> > > >    -131> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_finalize_thread wake
> > > >    -130> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_finalize_thread
> > > > kv_committed <0x55b360b9c300>
> > > >    -129> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_finalize_thread
> > > > deferred_stable <>
> > > >    -128> 2019-07-23T16:22:57.340-0400 7f67f4a44700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_state_proc txc
> > > > 0x55b360b9c300 kv_submitted
> > > >    -127> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_committed_kv txc
> > > > 0x55b360b9c300
> > > >    -126> 2019-07-23T16:22:57.340-0400 7f67f4a44700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_state_proc txc
> > > > 0x55b360b9c300 finishing
> > > >    -125> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_finish 0x55b360b9c300
> > > > onodes 0x55b3606122c0
> > > >    -124> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_finish  txc
> > > > 0x55b360b9c300 done
> > > >    -123> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_finish osr
> > > > 0x55b360756360 q now empty
> > > >    -122> 2019-07-23T16:22:57.340-0400 7f67f4a44700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_release_alloc(sync)
> > > > 0x55b360b9c300 []
> > > >    -121> 2019-07-23T16:22:57.340-0400 7f67f4a44700 10 fbmap_alloc
> > > > 0x55b35f1b2700 release done
> > > >    -120> 2019-07-23T16:22:57.340-0400 7f67f4a44700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _kv_finalize_thread sleep
> > > >    -119> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > luod=23'148792 crt=23'148793 lcod 23'148791 mlcod 23'148791
> > > > active+clean] op_commit: 226406
> > > >    -118> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > luod=23'148792 crt=23'148793 lcod 23'148791 mlcod 23'148791
> > > > active+clean] repop_all_committed: repop tid 226406 all committed
> > > >    -117> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean] eval_repop
> > > > repgather(0x55b3820a1680 23'148793 rep_tid=226406 committed?=1 r=0)
> > > >    -116> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]  commit:
> > > > repgather(0x55b3820a1680 23'148793 rep_tid=226406 committed?=1 r=0)
> > > >    -115> 2019-07-23T16:22:57.340-0400 7f67e922d700 15 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]
> > > > log_op_stats osd_op(client.4167.0:100200 5.2
> > > > 5:4511dcfb:::.dir.160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11:head
> > > > [call rgw.guard_bucket_resharding,call rgw.bucket_prepare_op] snapc
> > > > 0=[] ondisk+write+known_if_redirected e23) v8 inb 0 outb 0 lat
> > > > 0.002425
> > > >    -114> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]  sending
> > > > reply on osd_op(client.4167.0:100200 5.2
> > > > 5:4511dcfb:::.dir.160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11:head
> > > > [call rgw.guard_bucket_resharding,call rgw.bucket_prepare_op] snapc
> > > > 0=[] ondisk+write+known_if_redirected e23) v8 0x55b3835d5340
> > > >    -113> 2019-07-23T16:22:57.340-0400 7f67e922d700  1 --
> > > > [v2:10.17.152.22:6800/32427,v1:10.17.152.22:6801/32427] -->
> > > > 10.17.152.22:0/2087252234 -- osd_op_reply(100200
> > > > .dir.160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11 [call
> > > > rgw.guard_bucket_resharding,call rgw.bucket_prepare_op] v23'148793
> > > > uv148793 ondisk = 0) v8 -- 0x55b3835d5340 con 0x55b381f32d80
> > > >    -112> 2019-07-23T16:22:57.340-0400 7f67e922d700 20 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]
> > > > prepare_stats_for_publish reporting purged_snaps []
> > > >    -111> 2019-07-23T16:22:57.340-0400 7f67e922d700 15 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]
> > > > publish_stats_to_osd 23:149046
> > > >    -110> 2019-07-23T16:22:57.340-0400 7f67e922d700 10 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]  removing
> > > > repgather(0x55b3820a1680 23'148793 rep_tid=226406 committed?=1 r=0)
> > > >    -109> 2019-07-23T16:22:57.340-0400 7f67e922d700 20 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]    q front
> > > > is repgather(0x55b3820a1680 23'148793 rep_tid=226406 committed?=1 r=0)
> > > >    -108> 2019-07-23T16:22:57.340-0400 7f67e922d700 15 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]
> > > > do_osd_op_effects client.4167 con 0x55b381f32d80
> > > >    -107> 2019-07-23T16:22:57.341-0400 7f67e922d700 20 osd.0 pg_epoch:
> > > > 23 pg[5.2( v 23'148793 (23'145700,23'148793] local-lis/les=17/18 n=4
> > > > ec=17/17 lis/c=17/17 les/c/f=18/18/0 sis=17) [0] r=0 lpr=17
> > > > crt=23'148793 lcod 23'148792 mlcod 23'148792 active+clean]
> > > > remove_repop repgather(0x55b3820a1680 23'148793 rep_tid=226406
> > > > committed?=1 r=0)
> > > >    -106> 2019-07-23T16:22:57.341-0400 7f67e922d700 20 osd.0 op_wq(2)
> > > > _process empty q, waiting
> > > >    -105> 2019-07-23T16:22:57.341-0400 7f6804263700  1 --
> > > > [v2:10.17.152.22:6800/32427,v1:10.17.152.22:6801/32427] <==
> > > > client.4167 10.17.152.22:0/2087252234 100201 ====
> > > > osd_op(client.4167.0:100201 6.0 6.48f457e8 (undecoded)
> > > > ondisk+write+known_if_redirected e23) v8 ==== 670+0+118234 (crc 0 0 0)
> > > > 0x55b3603ea000 con 0x55b381f32d80
> > > >    -104> 2019-07-23T16:22:57.341-0400 7f6804263700 15 osd.0 23
> > > > enqueue_op 0x55b3818cf080 prio 63 cost 118234 latency 0.000047 epoch
> > > > 23 osd_op(client.4167.0:100201 6.0 6.48f457e8 (undecoded)
> > > > ondisk+write+known_if_redirected e23) v8
> > > >    -103> 2019-07-23T16:22:57.341-0400 7f6804263700 20 osd.0 op_wq(0)
> > > > _enqueue OpQueueItem(6.0 PGOpItem(op=osd_op(client.4167.0:100201 6.0
> > > > 6.48f457e8 (undecoded) ondisk+write+known_if_redirected e23) v8) prio
> > > > 63 cost 118234 e23)
> > > >    -102> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 op_wq(0)
> > > > _process 6.0 to_process <> waiting <> waiting_peering {}
> > > >    -101> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 op_wq(0)
> > > > _process OpQueueItem(6.0 PGOpItem(op=osd_op(client.4167.0:100201 6.0
> > > > 6.48f457e8 (undecoded) ondisk+write+known_if_redirected e23) v8) prio
> > > > 63 cost 118234 e23) queued
> > > >    -100> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 op_wq(0)
> > > > _process 6.0 to_process <OpQueueItem(6.0
> > > > PGOpItem(op=osd_op(client.4167.0:100201 6.0 6.48f457e8 (undecoded)
> > > > ondisk+write+known_if_redirected e23) v8) prio 63 cost 118234 e23)>
> > > > waiting <> waiting_peering {}
> > > >     -99> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 op_wq(0)
> > > > _process OpQueueItem(6.0 PGOpItem(op=osd_op(client.4167.0:100201 6.0
> > > > 6.48f457e8 (undecoded) ondisk+write+known_if_redirected e23) v8) prio
> > > > 63 cost 118234 e23) pg 0x55b360829400
> > > >     -98> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 23
> > > > dequeue_op 0x55b3818cf080 prio 63 cost 118234 latency 0.000166
> > > > osd_op(client.4167.0:100201 6.0 6.48f457e8 (undecoded)
> > > > ondisk+write+known_if_redirected e23) v8 pg pg[6.0( v 23'9408
> > > > (23'6400,23'9408] local-lis/les=21/22 n=9194 ec=21/21 lis/c=21/21
> > > > les/c/f=22/22/0 sis=21) [0] r=0 lpr=21 crt=23'9408 lcod 23'9407 mlcod
> > > > 23'9407 active+clean]
> > > >     -97> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] _handle_message:
> > > > 0x55b3818cf080
> > > >     -96> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_op: op
> > > > osd_op(client.4167.0:100201 6.0
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [create,setxattr user.rgw.idtag (48),setxattr user.rgw.tail_tag
> > > > (48),writefull 0~117321,setxattr user.rgw.manifest (349),setxattr
> > > > user.rgw.acl (165),setxattr user.rgw.etag (32),setxattr
> > > > user.rgw.x-amz-content-sha256 (65),setxattr user.rgw.x-amz-date
> > > > (17),call rgw.obj_store_pg_ver,setxattr user.rgw.source_zone (4)]
> > > > snapc 0=[] ondisk+write+known_if_redirected e23) v8
> > > >     -95> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 23 class
> > > > rgw method obj_store_pg_ver flags=w
> > > >     -94> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > op_has_sufficient_caps session=0x55b360660c80 pool=6
> > > > (default.rgw.buckets.data ) pool_app_metadata={rgw={}} need_read_cap=0
> > > > need_write_cap=1 classes=[class rgw method obj_store_pg_ver rd 0 wr 1
> > > > wl 1] -> yes
> > > >     -93> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_op
> > > > osd_op(client.4167.0:100201 6.0
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [create,setxattr user.rgw.idtag (48),setxattr user.rgw.tail_tag
> > > > (48),writefull 0~117321,setxattr user.rgw.manifest (349),setxattr
> > > > user.rgw.acl (165),setxattr user.rgw.etag (32),setxattr
> > > > user.rgw.x-amz-content-sha256 (65),setxattr user.rgw.x-amz-date
> > > > (17),call rgw.obj_store_pg_ver,setxattr user.rgw.source_zone (4)]
> > > > snapc 0=[] ondisk+write+known_if_redirected e23) v8 may_write ->
> > > > write-ordered flags ondisk+write+known_if_redirected
> > > >     -92> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > get_object_context: obc NOT found in cache:
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -91> 2019-07-23T16:22:57.341-0400 7f67ea22f700 15
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) getattr 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > _
> > > >     -90> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0).collection(6.0_head
> > > > 0x55b360499800) get_onode oid
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > key 0x7f800000000000000617ea2f12213136'0132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV/SUB1/c130_6847944464_1995267.csv!='0xfffffffffffffffeffffffffffffffff'o'
> > > >     -89> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0).collection(6.0_head
> > > > 0x55b360499800)  r -2 v.len 0
> > > >     -88> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) getattr 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > _ = -2
> > > >     -87> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > get_object_context: no obc for soid
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > but can_create
> > > >     -86> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > create_object_context 0x55b367dc8000
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -85> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > populate_obc_watchers
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -84> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > PrimaryLogPG::check_blacklisted_obc_watchers for obc
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -83> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > get_object_context: 0x55b367dc8000
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > rwstate(none n=0 w=0) oi:
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head(0'0
> > > > unknown.0.0:0 s 0 uv 0 alloc_hint [0 0 0]) ssc: 0x55b3647bc840
> > > > snapset: 0=[]:{}
> > > >     -82> 2019-07-23T16:22:57.341-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > find_object_context
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > @head oi=6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head(0'0
> > > > unknown.0.0:0 s 0 uv 0 alloc_hint [0 0 0])
> > > >     -81> 2019-07-23T16:22:57.341-0400 7f67ea22f700 25 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_op oi
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head(0'0
> > > > unknown.0.0:0 s 0 uv 0 alloc_hint [0 0 0])
> > > >     -80> 2019-07-23T16:22:57.341-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_op obc
> > > > obc(6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head(dne)
> > > > rwstate(write n=1 w=0))
> > > >     -79> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] execute_ctx
> > > > 0x55b36058a400
> > > >     -78> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] execute_ctx
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [create,setxattr user.rgw.idtag (48),setxattr user.rgw.tail_tag
> > > > (48),writefull 0~117321,setxattr user.rgw.manifest (349),setxattr
> > > > user.rgw.acl (165),setxattr user.rgw.etag (32),setxattr
> > > > user.rgw.x-amz-content-sha256 (65),setxattr user.rgw.x-amz-date
> > > > (17),call rgw.obj_store_pg_ver,setxattr user.rgw.source_zone (4)] ov
> > > > 0'0 av 23'9409 snapc 0=[] snapset 0=[]:{}
> > > >     -77> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [create,setxattr user.rgw.idtag (48),setxattr user.rgw.tail_tag
> > > > (48),writefull 0~117321,setxattr user.rgw.manifest (349),setxattr
> > > > user.rgw.acl (165),setxattr user.rgw.etag (32),setxattr
> > > > user.rgw.x-amz-content-sha256 (65),setxattr user.rgw.x-amz-date
> > > > (17),call rgw.obj_store_pg_ver,setxattr user.rgw.source_zone (4)]
> > > >     -76> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op  create
> > > >     -75> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.idtag (48)
> > > >     -74> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.tail_tag (48)
> > > >     -73> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > writefull 0~117321
> > > >     -72> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.manifest (349)
> > > >     -71> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.acl (165)
> > > >     -70> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.etag (32)
> > > >     -69> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.x-amz-content-sha256 (65)
> > > >     -68> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.x-amz-date (17)
> > > >     -67> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op  call
> > > > rgw.obj_store_pg_ver
> > > >     -66> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] call method
> > > > rgw.obj_store_pg_ver
> > > >     -65> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [setxattr user.rgw.pg_ver (8)]
> > > >     -64> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.pg_ver (8)
> > > >     -63> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] method called
> > > > response length=0
> > > >     -62> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] do_osd_op
> > > > setxattr user.rgw.source_zone (4)
> > > >     -61> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] make_writeable
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > snapset=0=[]:{}  snapc=0=[]
> > > >     -60> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]  setting DIRTY
> > > > flag
> > > >     -59> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] make_writeable
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > done, snapset=0=[]:{}
> > > >     -58> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] finish_ctx
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > 0x55b36058a400 op modify
> > > >     -57> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]  set mtime to
> > > > 2019-07-23T16:22:57.339071-0400
> > > >     -56> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]  final snapset
> > > > 0=[]:{} in 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -55> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] finish_ctx object
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > marks clean_regions clean_offsets: [117321~18446744073709434294],
> > > > clean_omap: 1, object_new: 0
> > > >     -54> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]  zeroing write
> > > > result code 0
> > > >     -53> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > calc_trim_to_aggressive limit = 23'9408
> > > >     -52> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > calc_trim_to_aggressive approx pg log length =  3008
> > > >     -51> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]
> > > > calc_trim_to_aggressive num_to_trim =  8
> > > >     -50> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean]  op order
> > > > client.4167 tid 100201 (first)
> > > >     -49> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] new_repop rep_tid
> > > > 226407 on osd_op(client.4167.0:100201 6.0
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > [create,setxattr user.rgw.idtag (48),setxattr user.rgw.tail_tag
> > > > (48),writefull 0~117321,setxattr user.rgw.manifest (349),setxattr
> > > > user.rgw.acl (165),setxattr user.rgw.etag (32),setxattr
> > > > user.rgw.x-amz-content-sha256 (65),setxattr user.rgw.x-amz-date
> > > > (17),call rgw.obj_store_pg_ver,setxattr user.rgw.source_zone (4)]
> > > > snapc 0=[] ondisk+write+known_if_redirected e23) v8
> > > >     -48> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] new_repop:
> > > > repgather(0x55b360a71380 0'0 rep_tid=226407 committed?=0 r=0)
> > > >     -47> 2019-07-23T16:22:57.342-0400 7f67ea22f700  7 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9194
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] issue_repop
> > > > rep_tid 226407 o
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > >     -46> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 earliest_dup_version = 6410
> > > >     -45> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 trim 23'9409
> > > > (0'0) modify   6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > by client.4167.0:100201 2019-07-23T16:22:57.339071-0400 0
> > > > ObjectCleanRegions clean_offsets: [117321~18446744073709434294],
> > > > clean_omap: 1, object_new: 0
> > > >     -44> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 trim dup
> > > > log_dup(reqid=client.4167.0:26895 v=23'6409 uv=6409 rc=0)
> > > >     -43> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9408 (23'6400,23'9408] local-lis/les=21/22 n=9195
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > crt=23'9408 lcod 23'9407 mlcod 23'9407 active+clean] append_log
> > > > log((23'6400,23'9408], crt=23'9408) [23'9409 (0'0) modify
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > by client.4167.0:100201 2019-07-23T16:22:57.339071-0400 0
> > > > ObjectCleanRegions clean_offsets: [117321~18446744073709434294],
> > > > clean_omap: 1, object_new: 0]
> > > >     -42> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9409 (23'6400,23'9409] local-lis/les=21/22 n=9195
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > luod=23'9408 lua=23'9408 crt=23'9408 lcod 23'9407 mlcod 23'9407
> > > > active+clean] add_log_entry 23'9409 (0'0) modify
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > by client.4167.0:100201 2019-07-23T16:22:57.339071-0400 0
> > > > ObjectCleanRegions clean_offsets: [117321~18446744073709434294],
> > > > clean_omap: 1, object_new: 0
> > > >     -41> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9409 (23'6400,23'9409] local-lis/les=21/22 n=9195
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > luod=23'9408 lua=23'9408 crt=23'9409 lcod 23'9407 mlcod 23'9407
> > > > active+clean] rollforward: entry=23'9409 (0'0) modify
> > > > 6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head
> > > > by client.4167.0:100201 2019-07-23T16:22:57.339071-0400 0
> > > > ObjectCleanRegions clean_offsets: [117321~18446744073709434294],
> > > > clean_omap: 1, object_new: 0
> > > >     -40> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9409 (23'6400,23'9409] local-lis/les=21/22 n=9195
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > luod=23'9408 lua=23'9408 crt=23'9409 lcod 23'9407 mlcod 23'9407
> > > > active+clean] append_log approx pg log length =  3009
> > > >     -39> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 osd.0 pg_epoch:
> > > > 23 pg[6.0( v 23'9409 (23'6400,23'9409] local-lis/les=21/22 n=9195
> > > > ec=21/21 lis/c=21/21 les/c/f=22/22/0 sis=21) [0] r=0 lpr=21
> > > > luod=23'9408 lua=23'9408 crt=23'9409 lcod 23'9407 mlcod 23'9407
> > > > active+clean] append_log transaction_applied = 1
> > > >     -38> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 trim proposed
> > > > trim_to = 23'6400
> > > >     -37> 2019-07-23T16:22:57.342-0400 7f67ea22f700  6
> > > > write_log_and_missing with: dirty_to: 0'0, dirty_from:
> > > > 4294967295'18446744073709551615, writeout_from: 23'9409, trimmed: ,
> > > > trimmed_dups: , clear_divergent_priors: 0
> > > >     -36> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) queue_transactions ch
> > > > 0x55b360499800 6.0_head
> > > >     -35> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_create osr
> > > > 0x55b360dd05a0 = 0x55b360b70000 seq 9413
> > > >     -34> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0).collection(6.0_head
> > > > 0x55b360499800) get_onode oid
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > key 0x7f800000000000000617ea2f12213136'0132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV/SUB1/c130_6847944464_1995267.csv!='0xfffffffffffffffeffffffffffffffff'o'
> > > >     -33> 2019-07-23T16:22:57.342-0400 7f67ea22f700 15
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _touch 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > >     -32> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _assign_nid 75832
> > > >     -31> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _touch 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > = 0
> > > >     -30> 2019-07-23T16:22:57.342-0400 7f67ea22f700 15
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _setattrs 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > 11 keys
> > > >     -29> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _setattrs 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > 11 keys = 0
> > > >     -28> 2019-07-23T16:22:57.342-0400 7f67ea22f700 15
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _write 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > 0x0~1ca49
> > > >     -27> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_write
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > 0x0~1ca49 - have 0x0 (0) bytes fadvise_flags 0x0
> > > >     -26> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _choose_write_options
> > > > prefer csum_order 12 target_blob_size 0x80000 compress=0 buffered=0
> > > >     -25> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_write_big 0x0~10000
> > > > target_blob_size 0x80000 compress 0
> > > >     -24> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_write_small
> > > > 0x10000~ca49
> > > >     -23> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _pad_zeros pad 0x0 + 0x5b7
> > > > on front/back, now 0x0~d000
> > > >     -22> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_alloc_write txc
> > > > 0x55b360b70000 2 blobs
> > > >     -21> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 fbmap_alloc
> > > > 0x55b35f1b2700 allocate 0x20000/10000,20000,0
> > > >     -20> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 fbmap_alloc
> > > > 0x55b35f1b2700 allocate extent: 0x27fff0000~10000/10000,20000,0
> > > >     -19> 2019-07-23T16:22:57.342-0400 7f67ea22f700 -1
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_alloc_write failed to
> > > > allocate 0x20000 allocated 0x 10000 min_alloc_size 0x10000 available
> > > > 0x 0
> > > >     -18> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 fbmap_alloc
> > > > 0x55b35f1b2700 release 0x27fff0000~10000
> > > >     -17> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10 fbmap_alloc
> > > > 0x55b35f1b2700 release done
> > > >     -16> 2019-07-23T16:22:57.342-0400 7f67ea22f700 -1
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _do_write _do_alloc_write
> > > > failed with (28) No space left on device
> > > >     -15> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore.sharedblob(0x55b3836e4d20) put 0x55b3836e4d20 removing self
> > > > from set 0x55b360499900
> > > >     -14> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore.BufferSpace(0x55b3836e4d38 in 0x55b360000000) _clear
> > > >     -13> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore.sharedblob(0x55b383706e00) put 0x55b383706e00 removing self
> > > > from set 0x55b360499900
> > > >     -12> 2019-07-23T16:22:57.342-0400 7f67ea22f700 20
> > > > bluestore.BufferSpace(0x55b383706e18 in 0x55b360000000) _clear
> > > >     -11> 2019-07-23T16:22:57.342-0400 7f67ea22f700 10
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _write 6.0_head
> > > > #6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#
> > > > 0x0~1ca49 = -28
> > > >     -10> 2019-07-23T16:22:57.342-0400 7f67ea22f700 -1
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) _txc_add_transaction error
> > > > (28) No space left on device not handled on operation 10 (op 2,
> > > > counting from 0)
> > > >      -9> 2019-07-23T16:22:57.342-0400 7f67ea22f700 -1
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) ENOSPC from bluestore,
> > > > misconfigured cluster
> > > >      -8> 2019-07-23T16:22:57.342-0400 7f67ea22f700  0 _dump_transaction
> > > > transaction dump:
> > > > {
> > > >      "ops": [
> > > >          {
> > > >              "op_num": 0,
> > > >              "op_name": "create",
> > > >              "collection": "6.0_head",
> > > >              "oid":
> > > > "#6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#"
> > > >          },
> > > >          {
> > > >              "op_num": 1,
> > > >              "op_name": "setattrs",
> > > >              "collection": "6.0_head",
> > > >              "oid":
> > > > "#6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#",
> > > >              "attr_lens": {
> > > >                  "_": 336,
> > > >                  "_user.rgw.acl": 165,
> > > >                  "_user.rgw.etag": 32,
> > > >                  "_user.rgw.idtag": 48,
> > > >                  "_user.rgw.manifest": 349,
> > > >                  "_user.rgw.pg_ver": 8,
> > > >                  "_user.rgw.source_zone": 4,
> > > >                  "_user.rgw.tail_tag": 48,
> > > >                  "_user.rgw.x-amz-content-sha256": 65,
> > > >                  "_user.rgw.x-amz-date": 17,
> > > >                  "snapset": 35
> > > >              }
> > > >          },
> > > >          {
> > > >              "op_num": 2,
> > > >              "op_name": "write",
> > > >              "collection": "6.0_head",
> > > >              "oid":
> > > > "#6:17ea2f12:::160132e5-57d2-4fbd-87a8-76acd281fe29.4137.11_CSV%2fSUB1%2fc130_6847944464_1995267.csv:head#",
> > > >              "length": 117321,
> > > >              "offset": 0,
> > > >              "bufferlist length": 117321
> > > >          },
> > > >          {
> > > >              "op_num": 3,
> > > >              "op_name": "omap_setkeys",
> > > >              "collection": "6.0_head",
> > > >              "oid": "#6:00000000::::head#",
> > > >              "attr_lens": {
> > > >                  "0000000023.00000000000000009409": 253,
> > > >                  "_fastinfo": 186
> > > >              }
> > > >          }
> > > >      ]
> > > > }
> > > >
> > > >      -7> 2019-07-23T16:22:57.346-0400 7f680225f700 10 osd.0 23
> > > > tick_without_osd_lock
> > > >      -6> 2019-07-23T16:22:57.346-0400 7f680225f700 20
> > > > bluestore(/lv2tb/ceph-noob/build/dev/osd0) statfs
> > > > store_statfs(0x10000/0x40000000/0x2bfffe000, data
> > > > 0x202e3eee8/0x23ffc0000, compress 0x0/0x0/0x0, omap 0xbeaef3, meta
> > > > 0x3f41510d)
> > > >      -5> 2019-07-23T16:22:57.346-0400 7f680225f700 20 osd.0 23
> > > > scrub_random_backoff lost coin flip, randomly backing off
> > > >      -4> 2019-07-23T16:22:57.346-0400 7f680225f700 10 osd.0 23
> > > > promote_throttle_recalibrate 0 attempts, promoted 0 objects and 0 B;
> > > > target 25 obj/sec or 5 MiB/sec
> > > >      -3> 2019-07-23T16:22:57.346-0400 7f680225f700 20 osd.0 23
> > > > promote_throttle_recalibrate  new_prob 1000
> > > >      -2> 2019-07-23T16:22:57.346-0400 7f680225f700 10 osd.0 23
> > > > promote_throttle_recalibrate  actual 0, actual/prob ratio 1, adjusted
> > > > new_prob 1000, prob 1000 -> 1000
> > > >      -1> 2019-07-23T16:22:57.348-0400 7f67ea22f700 -1
> > > > /lv2tb/ceph-noob/src/os/bluestore/BlueStore.cc: In function 'void
> > > > BlueStore::_txc_add_transaction(BlueStore::TransContext*,
> > > > ObjectStore::Transaction*)' thread 7f67ea22f700 time
> > > > 2019-07-23T16:22:57.343642-0400
> > > > /lv2tb/ceph-noob/src/os/bluestore/BlueStore.cc: 11456:
> > > > ceph_abort_msg("unexpected error")
> > > >
> > > >   ceph version v15.0.0-3007-g805e2b06876
> > > > (805e2b068766dcd87e4348404776a9ef7746dbc7) octopus (dev)
> > > >   1: (ceph::__ceph_abort(char const*, int, char const*,
> > > > std::__cxx11::basic_string<char, std::char_traits<char>,
> > > > std::allocator<char> > const&)+0xdf) [0x55b35506c5ce]
> > > >   2: (BlueStore::_txc_add_transaction(BlueStore::TransContext*,
> > > > ceph::os::Transaction*)+0xd28) [0x55b355690f18]
> > > >   3: (BlueStore::queue_transactions(boost::intrusive_ptr<ObjectStore::CollectionImpl>&,
> > > > std::vector<ceph::os::Transaction,
> > > > std::allocator<ceph::os::Transaction> >&,
> > > > boost::intrusive_ptr<TrackedOp>, ThreadPool::TPHandle*)+0x40f)
> > > > [0x55b3556ad19f]
> > > >   4: (non-virtual thunk to
> > > > PrimaryLogPG::queue_transactions(std::vector<ceph::os::Transaction,
> > > > std::allocator<ceph::os::Transaction> >&,
> > > > boost::intrusive_ptr<OpRequest>)+0x54) [0x55b3553964b4]
> > > >   5: (ReplicatedBackend::submit_transaction(hobject_t const&,
> > > > object_stat_sum_t const&, eversion_t const&,
> > > > std::unique_ptr<PGTransaction, std::default_delete<PGTransaction> >&&,
> > > > eversion_t const&, eversion_t const&, std::vector<pg_log_entry_t,
> > > > std::allocator<pg_log_entry_t> > const&,
> > > > std::optional<pg_hit_set_history_t>&, Context*, unsigned long,
> > > > osd_reqid_t, boost::intrusive_ptr<OpRequest>)+0xac6) [0x55b3554f9db6]
> > > >   6: (PrimaryLogPG::issue_repop(PrimaryLogPG::RepGather*,
> > > > PrimaryLogPG::OpContext*)+0xc06) [0x55b3552f8e46]
> > > >   7: (PrimaryLogPG::execute_ctx(PrimaryLogPG::OpContext*)+0x113c)
> > > > [0x55b35534b64c]
> > > >   8: (PrimaryLogPG::do_op(boost::intrusive_ptr<OpRequest>&)+0x34a4)
> > > > [0x55b35534f344]
> > > >   9: (PrimaryLogPG::do_request(boost::intrusive_ptr<OpRequest>&,
> > > > ThreadPool::TPHandle&)+0xde1) [0x55b355357011]
> > > >   10: (OSD::dequeue_op(boost::intrusive_ptr<PG>,
> > > > boost::intrusive_ptr<OpRequest>, ThreadPool::TPHandle&)+0x359)
> > > > [0x55b3551f5ea9]
> > > >   11: (PGOpItem::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
> > > > ThreadPool::TPHandle&)+0x62) [0x55b3554320a2]
> > > >   12: (OSD::ShardedOpWQ::_process(unsigned int,
> > > > ceph::heartbeat_handle_d*)+0x949) [0x55b355211069]
> > > >   13: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
> > > > [0x55b3557d43d4]
> > > >   14: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x55b3557d64a0]
> > > >   15: (()+0x7594) [0x7f680abb1594]
> > > >   16: (clone()+0x3f) [0x7f6809953f4f]
> > > >
> > > >       0> 2019-07-23T16:22:57.354-0400 7f67ea22f700 -1 *** Caught signal
> > > > (Aborted) **
> > > >   in thread 7f67ea22f700 thread_name:tp_osd_tp
> > > >
> > > >   ceph version v15.0.0-3007-g805e2b06876
> > > > (805e2b068766dcd87e4348404776a9ef7746dbc7) octopus (dev)
> > > >   1: (()+0x12080) [0x7f680abbc080]
> > > >   2: (gsignal()+0x10b) [0x7f6809890eab]
> > > >   3: (abort()+0x123) [0x7f680987b5b9]
> > > >   4: (ceph::__ceph_abort(char const*, int, char const*,
> > > > std::__cxx11::basic_string<char, std::char_traits<char>,
> > > > std::allocator<char> > const&)+0x1b0) [0x55b35506c69f]
> > > >   5: (BlueStore::_txc_add_transaction(BlueStore::TransContext*,
> > > > ceph::os::Transaction*)+0xd28) [0x55b355690f18]
> > > >   6: (BlueStore::queue_transactions(boost::intrusive_ptr<ObjectStore::CollectionImpl>&,
> > > > std::vector<ceph::os::Transaction,
> > > > std::allocator<ceph::os::Transaction> >&,
> > > > boost::intrusive_ptr<TrackedOp>, ThreadPool::TPHandle*)+0x40f)
> > > > [0x55b3556ad19f]
> > > >   7: (non-virtual thunk to
> > > > PrimaryLogPG::queue_transactions(std::vector<ceph::os::Transaction,
> > > > std::allocator<ceph::os::Transaction> >&,
> > > > boost::intrusive_ptr<OpRequest>)+0x54) [0x55b3553964b4]
> > > >   8: (ReplicatedBackend::submit_transaction(hobject_t const&,
> > > > object_stat_sum_t const&, eversion_t const&,
> > > > std::unique_ptr<PGTransaction, std::default_delete<PGTransaction> >&&,
> > > > eversion_t const&, eversion_t const&, std::vector<pg_log_entry_t,
> > > > std::allocator<pg_log_entry_t> > const&,
> > > > std::optional<pg_hit_set_history_t>&, Context*, unsigned long,
> > > > osd_reqid_t, boost::intrusive_ptr<OpRequest>)+0xac6) [0x55b3554f9db6]
> > > >   9: (PrimaryLogPG::issue_repop(PrimaryLogPG::RepGather*,
> > > > PrimaryLogPG::OpContext*)+0xc06) [0x55b3552f8e46]
> > > >   10: (PrimaryLogPG::execute_ctx(PrimaryLogPG::OpContext*)+0x113c)
> > > > [0x55b35534b64c]
> > > >   11: (PrimaryLogPG::do_op(boost::intrusive_ptr<OpRequest>&)+0x34a4)
> > > > [0x55b35534f344]
> > > >   12: (PrimaryLogPG::do_request(boost::intrusive_ptr<OpRequest>&,
> > > > ThreadPool::TPHandle&)+0xde1) [0x55b355357011]
> > > >   13: (OSD::dequeue_op(boost::intrusive_ptr<PG>,
> > > > boost::intrusive_ptr<OpRequest>, ThreadPool::TPHandle&)+0x359)
> > > > [0x55b3551f5ea9]
> > > >   14: (PGOpItem::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
> > > > ThreadPool::TPHandle&)+0x62) [0x55b3554320a2]
> > > >   15: (OSD::ShardedOpWQ::_process(unsigned int,
> > > > ceph::heartbeat_handle_d*)+0x949) [0x55b355211069]
> > > >   16: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
> > > > [0x55b3557d43d4]
> > > >   17: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x55b3557d64a0]
> > > >   18: (()+0x7594) [0x7f680abb1594]
> > > >   19: (clone()+0x3f) [0x7f6809953f4f]
> > > >   NOTE: a copy of the executable, or `objdump -rdS <executable>` is
> > > > needed to interpret this.
> > > >
> > > > --- logging levels ---
> > > >     0/ 5 none
> > > >     0/ 1 lockdep
> > > >     0/ 1 context
> > > >     1/ 1 crush
> > > >     1/ 5 mds
> > > >     1/ 5 mds_balancer
> > > >     1/ 5 mds_locker
> > > >     1/ 5 mds_log
> > > >     1/ 5 mds_log_expire
> > > >     1/ 5 mds_migrator
> > > >     0/ 1 buffer
> > > >     0/ 1 timer
> > > >     0/ 1 filer
> > > >     0/ 1 striper
> > > >    20/20 objecter
> > > >     0/ 5 rados
> > > >     0/ 5 rbd
> > > >     0/ 5 rbd_mirror
> > > >     0/ 5 rbd_replay
> > > >     0/ 5 journaler
> > > >     0/ 5 objectcacher
> > > >     0/ 5 immutable_obj_cache
> > > >     0/ 5 client
> > > >    25/25 osd
> > > >     0/ 5 optracker
> > > >    20/20 objclass
> > > >    20/20 filestore
> > > >    20/20 journal
> > > >     1/ 1 ms
> > > >     1/ 5 mon
> > > >    20/20 monc
> > > >     1/ 5 paxos
> > > >     0/ 5 tp
> > > >     1/ 5 auth
> > > >     1/ 5 crypto
> > > >     1/ 1 finisher
> > > >    10/10 reserver
> > > >     1/ 5 heartbeatmap
> > > >     1/ 5 perfcounter
> > > >     1/ 5 rgw
> > > >     1/ 5 rgw_sync
> > > >     1/10 civetweb
> > > >     1/ 5 javaclient
> > > >     1/ 5 asok
> > > >     1/ 1 throttle
> > > >     0/ 0 refs
> > > >     1/ 5 compressor
> > > >    20/20 bluestore
> > > >    20/20 bluefs
> > > >    20/20 bdev
> > > >     1/ 5 kstore
> > > >    20/20 rocksdb
> > > >     4/ 5 leveldb
> > > >     4/ 5 memdb
> > > >     1/ 5 kinetic
> > > >     1/ 5 fuse
> > > >     1/ 5 mgr
> > > >    20/20 mgrc
> > > >     1/ 5 dpdk
> > > >     1/ 5 eventtrace
> > > >     1/ 5 prioritycache
> > > >    -2/-2 (syslog threshold)
> > > >    -1/-1 (stderr threshold)
> > > >    max_recent     10000
> > > >    max_new         1000
> > > >    log_file /lv2tb/ceph-noob/build/out/osd.0.log
> > > > --- end dump of recent events ---
> > > >
> > > >
> >
> >
> >
> > --
> >
> > Matt Benjamin
> > Red Hat, Inc.
> > 315 West Huron Street, Suite 140A
> > Ann Arbor, Michigan 48103
> >
> > http://www.redhat.com/en/technologies/storage
> >
> > tel.  734-821-5101
> > fax.  734-769-8938
> > cel.  734-216-5309
> 
> 
> 
> -- 
> 
> Matt Benjamin
> Red Hat, Inc.
> 315 West Huron Street, Suite 140A
> Ann Arbor, Michigan 48103
> 
> http://www.redhat.com/en/technologies/storage
> 
> tel.  734-821-5101
> fax.  734-769-8938
> cel.  734-216-5309
> 
> 
