Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B1B413A05
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 20:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhIUSWp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 14:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhIUSWa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 Sep 2021 14:22:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4422AC061794
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 11:20:52 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t7so8711100wrw.13
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YNTEyAxVHiDFUKizPl8H8VzMOqpdlMwRe8WZ752JHSM=;
        b=KlkJx6zZnqLeCJD2DABAAywqByWbeFE0Bi+iy463uxfci+MGKZdH4UwEtXNKKvzpne
         6iKln7okFuZW+w6hOz13r4KeoOBWuF4xNjI7YHzmcJPyOJcEBrF6y41OkOOpGoUi9rvA
         EqB9yIH4aW9iBNshpOX6UODud3gsTXGCEr6Tuav2avu5/0LWivoLfivlVys3b9EVHUy5
         koMLIk/FJmrYSHpUojPB3ZvLu1usLxtUEL1bUkhXNmwR29HNTfJdv6YKOj2KhVfIRWJr
         ty7yRr6yF/Wr51wpsZV998QGjXynnad8+z5YDq9ukyaLIK1bnuDQ7cxiFpAjWN2TAYlQ
         d81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YNTEyAxVHiDFUKizPl8H8VzMOqpdlMwRe8WZ752JHSM=;
        b=6m0yrUN1MvJimoIgBcqq0cK7U9PaVkgXbr1pL2eAeuzDVu0Mer8N+20+I43z3zoQ0v
         N7lTc/0qoFlBr44nV+900geqtHPdGc/74W8RS2gwuLI0j94G8AjKi1HK+YCpdWei4gRP
         wTjPaEvYguE/kLiWAAIAJMPwOSzDjvRbCw7vpfb1KrBn4fnaLixt52yg05qAvuU5igK/
         6YXqnyC7h0NTCWSLFbrsLLNLnyyxzmBUAxgJjxYXBjrzoBDHJvp+1TRhWnlr1tthZeT8
         oCEmu+nDrCvuluvJ1GE1+BWMY1/3bGhrls/hy33ZXTVneH2ZmJIQwSz57p8LN1lSbLo6
         0wsA==
X-Gm-Message-State: AOAM532S+UNKmRGtePIaIT3DQTUzs/dHBxe+10UFvRT+T2KFqQSKoyAj
        gIbdWoZcMitMny58z9vGQQJaQrqUTPD0inD9haQ8lUl4
X-Google-Smtp-Source: ABdhPJyfsEy64m0HBZefbgjnbdaUL5rtNoWDV7Z1MOmtOx79BOkdxkKYh3sxfYVAK/NCc0t3lxVaknnCSeRaESF6byk=
X-Received: by 2002:a5d:5281:: with SMTP id c1mr18285181wrv.92.1632248450839;
 Tue, 21 Sep 2021 11:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <D7D3F091-929F-4A02-99D8-ABB9C3995C38@agoda.com>
In-Reply-To: <D7D3F091-929F-4A02-99D8-ABB9C3995C38@agoda.com>
From:   Christian Wuerdig <christian.wuerdig@gmail.com>
Date:   Wed, 22 Sep 2021 06:20:38 +1200
Message-ID: <CAE_BDM+Xh-VZMjLwumwQbBin4sm7928oQTSGktM1O-RG7hn=yw@mail.gmail.com>
Subject: Re: [ceph-users] Re: RocksDB options for HDD, SSD, NVME Mixed productions
To:     "Szabo, Istvan (Agoda)" <Istvan.Szabo@agoda.com>
Cc:     mhnx <morphinwithyou@gmail.com>, Ceph Users <ceph-users@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 22 Sept 2021 at 05:54, Szabo, Istvan (Agoda)
<Istvan.Szabo@agoda.com> wrote:
>
> =EF=BB=BFSorry to steal it, so if I have 500GB and 700GB mixed wal+rocksd=
b on nvme the number should be the level base 5000000000 and 7000000000? Or=
 needs to be power of 2?

Generally the sum of all levels (up to the max of your metadata) needs
to fit into the db partition for each OSD. If you have a 500 or 700 GB
WAL+DB partition per OSD then the default settings should carry you to
L3 (~333GB required free space). Do you have more than 300GB metadata
per OSD?
All examples I've ever seen show the level base size at a power of 2
but I don't know if there are any side effects not doing that
5/7GB level base is an order of magnitude higher than the default and
it's unclear what performance effect this has.

I would not advise tinkering with the defaults unless you have a lot
of time and energy to burn on testing and are willing to accept
potential future performance issues on upgrade because you run a setup
that nobody ever tests for.

What's the size of your OSDs, how much db space per OSD do you
actually have and what do the spillover warnings say?


> Istvan Szabo
> Senior Infrastructure Engineer
> ---------------------------------------------------
> Agoda Services Co., Ltd.
> e: istvan.szabo@agoda.com
> ---------------------------------------------------
>
> On 2021. Sep 21., at 9:19, Christian Wuerdig <christian.wuerdig@gmail.com=
> wrote:
>
> =EF=BB=BFEmail received from the internet. If in doubt, don't click any l=
ink nor open any attachment !
> ________________________________
>
> It's been discussed a few times on the list but RocksDB levels essentiall=
y
> grow by a factor of 10 (max_bytes_for_level_multiplier) by default and yo=
u
> need (level-1)*10 space for the next level on your drive to avoid spill o=
ver
> So the sequence (by default) is 256MB -> 2.56GB -> 25.6GB -> 256GB GB and
> since 50GB < 286 (sum of all levels) you get spill-over going from L2 to
> L3. See also
> https://docs.ceph.com/en/latest/rados/configuration/bluestore-config-ref/=
#sizing
>
> Interestingly your level base seems to be 512MB instead of the default
> 256MB - did you change that? In your case the sequence I would have
> expected is 0.5 -> 5 -> 50 - and you should have already seen spillover a=
t
> 5GB (since you only have 50GB partitions but you need 55.5GB at least)
> Not sure what's up with that. I think you need to re-create OSDs after
> changing these RocksDB params
>
> Overall since Pacific this no longer holds entirely true since RocksDB
> sharding was added (
> https://docs.ceph.com/en/latest/rados/configuration/bluestore-config-ref/=
#bluestore-rocksdb-sharding)
> - it was broken in 16.2.4 but looks like it's fixed in 16.2.6
>
>   1. Upgrade to Pacific
>   2. Get rid of the NVME raid
>   3. Make 160GB DB partitions
>   4. Activate RocksDB sharding
>   5. Don't worry about RocksDB params
>
> If you don't feel like upgrading to Pacific any time soon but want to mak=
e
> more efficient use of the NVME and don't mind going out on a limp I'd sti=
ll
> do 2+3 plus study
> https://github-wiki-see.page/m/facebook/rocksdb/wiki/Leveled-Compaction
> carefully and make adjustments based on that.
> With 160GB partitions a multiplier of 7 might work well with a base size =
of
> 350MB 0.35 -> 2.45 -> 17.15 -> 120.05 (total 140GB out of 160GB)
>
> You could also try to switch to a 9x multiplier and re-create one of the
> OSDs to see how it pans out prior to dissolving the raid1 setup (given yo=
ur
> settings that should result in 0.5 -> 4.5 -> 40.5 GB usage)
>
> On Tue, 21 Sept 2021 at 13:19, mhnx <morphinwithyou@gmail.com> wrote:
>
> Hello everyone!
>
> I want to understand the concept and tune my rocksDB options on nautilus
>
> 14.2.16.
>
>
>     osd.178 spilled over 102 GiB metadata from 'db' device (24 GiB used o=
f
>
> 50 GiB) to slow device
>
>     osd.180 spilled over 91 GiB metadata from 'db' device (33 GiB used of
>
> 50 GiB) to slow device
>
>
> The problem is, I have the spill over warnings like the rest of the
>
> community.
>
> I tuned RocksDB Options with the settings below but the problem still
>
> exists and I wonder if I did anything wrong. I still have the Spill Overs
>
> and also some times index SSD's are getting down due to compaction proble=
ms
>
> and can not start them until I do offline compaction.
>
>
> Let me tell you about my hardware right?
>
> Every server in my system has:
>
> HDD -   19 x TOSHIBA  MG08SCA16TEY   16.0TB for EC pool.
>
> SSD -    3 x SAMSUNG  MZILS960HEHP/007 GXL0 960GB
>
> NVME - 2 x PM1725b 1.6TB
>
>
> I'm using Raid 1 Nvme for Bluestore DB. I dont have WAL.
>
> 19*50GB =3D 950GB total usage on NVME. (I was thinking use the rest but
>
> regret it now)
>
>
> So! Finally let's check my RocksDB Options:
>
> [osd]
>
> bluefs_buffered_io =3D true
>
> bluestore_rocksdb_options =3D
>
>
> compression=3DkNoCompression,max_write_buffer_number=3D32,min_write_buffe=
r_number_to_merge=3D2,recycle_log_file_num=3D32,compaction_style=3DkCompact=
ionStyleLevel,write_buffer_size=3D67108864,target_file_size_base=3D67108864=
,max_background_compactions=3D31,level0_file_num_compaction_trigger=3D8,lev=
el0_slowdown_writes_trigger=3D32,level0_stop_writes_trigger=3D64,flusher_th=
reads=3D8,compaction_readahead_size=3D2MB,compaction_threads=3D16,
>
> *max_bytes_for_level_base=3D536870912*,
>
> *max_bytes_for_level_multiplier=3D10*
>
>
> *"ceph osd df tree"  *to see ssd and hdd usage, omap and meta.
>
>
> ID  CLASS WEIGHT     REWEIGHT SIZE    RAW USE DATA    OMAP    META
>
> AVAIL   %USE  VAR  PGS STATUS TYPE NAME
>
> -28        280.04810        - 280 TiB 169 TiB 166 TiB 688 GiB 2.4 TiB 111
>
> TiB 60.40 1.00   -            host MHNX1
>
> 178   hdd   14.60149  1.00000  15 TiB 8.6 TiB 8.5 TiB  44 KiB 126 GiB 6.0
>
> TiB 59.21 0.98 174     up         osd.178
>
> 179   ssd    0.87329  1.00000 894 GiB 415 GiB  89 GiB 321 GiB 5.4 GiB 479
>
> GiB 46.46 0.77 104     up         osd.179
>
>
>
> I know the size of NVME is not suitable for 16TB HDD's. I should have mor=
e
>
> but the expense is cutting us pieces. Because of that I think I'll see th=
e
>
> spill overs no matter what I do. But maybe I will make it better
>
> with your help!
>
>
> *My questions are:*
>
> 1- What is the meaning of (33 GiB used of 50 GiB)
>
> 2- Why it's not 50GiB / 50GiB ?
>
> 3- Do I have 17GiB unused area on the DB partition?
>
> 4- Is there anything wrong with my Rocksdb options?
>
> 5- How can I be sure and find the good Rocksdb Options for Ceph?
>
> 6- How can I measure the change and test it?
>
> 7- Do I need different RocksDB options for HDD's and SSD's ?
>
> 8- If I stop using Nvme Raid1 to gain x2 size and resize the DB's  to
>
> 160GiB. Is it worth to take Nvme faulty? Because I will lose 10HDD at the
>
> same time but I have 10 Node and that's only %5 of the EC data . I use m=
=3D8
>
> k=3D2.
>
>
> P.S: There are so many people asking and searching around this. I hope it
>
> will work this time.
>
> _______________________________________________
>
> ceph-users mailing list -- ceph-users@ceph.io
>
> To unsubscribe send an email to ceph-users-leave@ceph.io
>
>
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
