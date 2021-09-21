Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A547341392A
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 19:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhIURwt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 13:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhIURwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 Sep 2021 13:52:47 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A58C061574
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 10:51:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q26so41638114wrc.7
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AsuqXeNSKmrICL2DP3howwpk3Ow1Bhccyn3uimmRHWg=;
        b=Qpr4HTYn2I3mkjIMoisSYPXRhdugNrFtIiv+HAcsA2V3PziEEG5GmBq1Nc3B4htys6
         VllevFFV1Z5GXbynuKJNb92CaPEceADZc98G0y6HRpksBrcs+30jKTroEEDCynaQTKJ0
         W5sStjUUJj+oMiu1hLtIU303h1VWVeShkALeZGDInJX+fS+SZrJAh0VjSOCWdaEj+yFY
         fQVQzEI4wqhssGeQE+7ix+Y9WLeZhT6bbbqn6eWObcW4Hd3gWX2lEUGS4vYJIb4BIr9v
         vxw6pPBweAH4sNy1IzUBE4KHQI3bw4irJC3nH1AeSY3M5Qsxh/j+42Qpwa5CAT03fZfV
         q6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AsuqXeNSKmrICL2DP3howwpk3Ow1Bhccyn3uimmRHWg=;
        b=bW+q8txRjAu4W5cB1dYx+1H8w2RXISoCmKJpkFhOurRbhXzMXCkE91gU1+8ucR7eOg
         EQC5q8wgAguRPM/sGYdF3ifyhheDChq/WRwEv/PBINgEabFwDxkhKOdo+EUUQH1IbXcS
         2M5wYduLMlPoEzrg9EzWkHrYkfQrvYp0PVf8ENnyIjsFl3P96pBu1jujA8CAcgAwzn79
         Ij00uL1w/xsyDBSMiM6i98y5N9zBxfkoHmtkSerIePqSTOV/evsQHF7bGiIkJs+bpvcO
         cMYAgL8WlpHg8gey8rEIV+NNMDQvHQiF69E6o6Eliqd7QrdX2Zg+cD50qenV6AXj3Rcg
         7loQ==
X-Gm-Message-State: AOAM530cCOV3lGgQaWZnYXzjedFQujhwZfQHTSuSBdl3ANyAbs1Ikdt9
        2yEvBAl79xJswtMPbeT8q5thMg9jk2fIHJlvvcNj1aMn
X-Google-Smtp-Source: ABdhPJzBsYXYGLAsEeLqHCNxKg982uI7ORJ7Cc2q/yfnX34CZ4LxzZ8jofMNxHAZig9LB/uqaOIQouHB3px9kFjy5BQ=
X-Received: by 2002:a1c:7e55:: with SMTP id z82mr6117664wmc.95.1632246676971;
 Tue, 21 Sep 2021 10:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAE-AtHqdhMKYytpDYp4c+JMdDofEGai3yeQNXkB4v6kya1aSfA@mail.gmail.com>
 <CAE_BDMJ+wiEemTeoMn0HQgRTvfbm5oh2sTzU2+GE8hkZcrqQgA@mail.gmail.com> <CAE-AtHq+6HAiijrM3mVV53qy3_jsAYRV89HjjAkEfc9=j5QmSw@mail.gmail.com>
In-Reply-To: <CAE-AtHq+6HAiijrM3mVV53qy3_jsAYRV89HjjAkEfc9=j5QmSw@mail.gmail.com>
From:   Christian Wuerdig <christian.wuerdig@gmail.com>
Date:   Wed, 22 Sep 2021 05:51:04 +1200
Message-ID: <CAE_BDM+aVANDJC91Zo=vUhshZgq8Dkg=sq3oF=Q2WnN8a1ErCA@mail.gmail.com>
Subject: Re: [ceph-users] RocksDB options for HDD, SSD, NVME Mixed productions
To:     mhnx <morphinwithyou@gmail.com>
Cc:     Ceph Users <ceph-users@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 22 Sept 2021 at 00:54, mhnx <morphinwithyou@gmail.com> wrote:
>
> Thanks for the explanation. Then the first thing I did wrong I didn't add=
 levels to reach total space. I didn't know that and I've set :
> max_bytes_for_level_base=3D536870912 and max_bytes_for_level_multiplier=
=3D10
> 536870912*10*10=3D50Gb
>
> I have space on Nvme's. I think I can resize the partitions.
> 1- Set osd down
> 2- Migrate partition to next blocks to be able resize the partition
> 3- Resize DB partition block size to 60GiB * 19HDD =3D
> 4- Sed osd up
>
> Also the other option is:
> 1- Remove Nvme from raid1
> 2- Migrate half of the partitions on New empty Nvme.
> 3- Resize the partitions
> 4- Resize the rest partitions or re-create the Nvme to get rid of degrade=
d Nvme pool.
>
> It's a lot of hard work and also you said "You need to re-create OSD's fo=
r new RocksDB options' killed my dreams.
> Are you sure about this? Why OSD restart have no effect on RocksDB option=
s?
> Do I really need to re-create all 190 HDD's ? Just wow. It will take deca=
des to be done.


No - I'm not 100% sure about this (never tinkered with the settings)
but it would fit the observations (namely that the 512MB level base
which you set doesn't seem to apply). Haven't found any explicit
documentation but in principle RocksDB should support changing these
params on-the-fly but not sure how to get ceph to apply them. Somebody
else would have to chime in to confirm.
Also keep in mind that even with 60GB partition you will still get
spillover since you seem to have around 120-130GB meta data per OSD so
moving to 160GB partitions would seem to be better.

>
>
>
>
>
>
> Christian Wuerdig <christian.wuerdig@gmail.com>, 21 Eyl 2021 Sal, 10:15 t=
arihinde =C5=9Funu yazd=C4=B1:
>>
>> It's been discussed a few times on the list but RocksDB levels essential=
ly grow by a factor of 10 (max_bytes_for_level_multiplier) by default and y=
ou need (level-1)*10 space for the next level on your drive to avoid spill =
over
>> So the sequence (by default) is 256MB -> 2.56GB -> 25.6GB -> 256GB GB an=
d since 50GB < 286 (sum of all levels) you get spill-over going from L2 to =
L3. See also https://docs.ceph.com/en/latest/rados/configuration/bluestore-=
config-ref/#sizing
>>
>> Interestingly your level base seems to be 512MB instead of the default 2=
56MB - did you change that? In your case the sequence I would have expected=
 is 0.5 -> 5 -> 50 - and you should have already seen spillover at 5GB (sin=
ce you only have 50GB partitions but you need 55.5GB at least)
>> Not sure what's up with that. I think you need to re-create OSDs after c=
hanging these RocksDB params
>>
>> Overall since Pacific this no longer holds entirely true since RocksDB s=
harding was added (https://docs.ceph.com/en/latest/rados/configuration/blue=
store-config-ref/#bluestore-rocksdb-sharding) - it was broken in 16.2.4 but=
 looks like it's fixed in 16.2.6
>>
>> Upgrade to Pacific
>> Get rid of the NVME raid
>> Make 160GB DB partitions
>> Activate RocksDB sharding
>> Don't worry about RocksDB params
>>
>> If you don't feel like upgrading to Pacific any time soon but want to ma=
ke more efficient use of the NVME and don't mind going out on a limp I'd st=
ill do 2+3 plus study https://github-wiki-see.page/m/facebook/rocksdb/wiki/=
Leveled-Compaction carefully and make adjustments based on that.
>> With 160GB partitions a multiplier of 7 might work well with a base size=
 of 350MB 0.35 -> 2.45 -> 17.15 -> 120.05 (total 140GB out of 160GB)
>>
>> You could also try to switch to a 9x multiplier and re-create one of the=
 OSDs to see how it pans out prior to dissolving the raid1 setup (given you=
r settings that should result in 0.5 -> 4.5 -> 40.5 GB usage)
>>
>> On Tue, 21 Sept 2021 at 13:19, mhnx <morphinwithyou@gmail.com> wrote:
>>>
>>> Hello everyone!
>>> I want to understand the concept and tune my rocksDB options on nautilu=
s
>>> 14.2.16.
>>>
>>>      osd.178 spilled over 102 GiB metadata from 'db' device (24 GiB use=
d of
>>> 50 GiB) to slow device
>>>      osd.180 spilled over 91 GiB metadata from 'db' device (33 GiB used=
 of
>>> 50 GiB) to slow device
>>>
>>> The problem is, I have the spill over warnings like the rest of the
>>> community.
>>> I tuned RocksDB Options with the settings below but the problem still
>>> exists and I wonder if I did anything wrong. I still have the Spill Ove=
rs
>>> and also some times index SSD's are getting down due to compaction prob=
lems
>>> and can not start them until I do offline compaction.
>>>
>>> Let me tell you about my hardware right?
>>> Every server in my system has:
>>> HDD -   19 x TOSHIBA  MG08SCA16TEY   16.0TB for EC pool.
>>> SSD -    3 x SAMSUNG  MZILS960HEHP/007 GXL0 960GB
>>> NVME - 2 x PM1725b 1.6TB
>>>
>>> I'm using Raid 1 Nvme for Bluestore DB. I dont have WAL.
>>> 19*50GB =3D 950GB total usage on NVME. (I was thinking use the rest but
>>> regret it now)
>>>
>>> So! Finally let's check my RocksDB Options:
>>> [osd]
>>> bluefs_buffered_io =3D true
>>> bluestore_rocksdb_options =3D
>>> compression=3DkNoCompression,max_write_buffer_number=3D32,min_write_buf=
fer_number_to_merge=3D2,recycle_log_file_num=3D32,compaction_style=3DkCompa=
ctionStyleLevel,write_buffer_size=3D67108864,target_file_size_base=3D671088=
64,max_background_compactions=3D31,level0_file_num_compaction_trigger=3D8,l=
evel0_slowdown_writes_trigger=3D32,level0_stop_writes_trigger=3D64,flusher_=
threads=3D8,compaction_readahead_size=3D2MB,compaction_threads=3D16,
>>> *max_bytes_for_level_base=3D536870912*,
>>> *max_bytes_for_level_multiplier=3D10*
>>>
>>> *"ceph osd df tree"  *to see ssd and hdd usage, omap and meta.
>>>
>>> > ID  CLASS WEIGHT     REWEIGHT SIZE    RAW USE DATA    OMAP    META
>>> > AVAIL   %USE  VAR  PGS STATUS TYPE NAME
>>> > -28        280.04810        - 280 TiB 169 TiB 166 TiB 688 GiB 2.4 TiB=
 111
>>> > TiB 60.40 1.00   -            host MHNX1
>>> > 178   hdd   14.60149  1.00000  15 TiB 8.6 TiB 8.5 TiB  44 KiB 126 GiB=
 6.0
>>> > TiB 59.21 0.98 174     up         osd.178
>>> > 179   ssd    0.87329  1.00000 894 GiB 415 GiB  89 GiB 321 GiB 5.4 GiB=
 479
>>> > GiB 46.46 0.77 104     up         osd.179
>>>
>>>
>>> I know the size of NVME is not suitable for 16TB HDD's. I should have m=
ore
>>> but the expense is cutting us pieces. Because of that I think I'll see =
the
>>> spill overs no matter what I do. But maybe I will make it better
>>> with your help!
>>>
>>> *My questions are:*
>>> 1- What is the meaning of (33 GiB used of 50 GiB)
>>> 2- Why it's not 50GiB / 50GiB ?
>>> 3- Do I have 17GiB unused area on the DB partition?
>>> 4- Is there anything wrong with my Rocksdb options?
>>> 5- How can I be sure and find the good Rocksdb Options for Ceph?
>>> 6- How can I measure the change and test it?
>>> 7- Do I need different RocksDB options for HDD's and SSD's ?
>>> 8- If I stop using Nvme Raid1 to gain x2 size and resize the DB's  to
>>> 160GiB. Is it worth to take Nvme faulty? Because I will lose 10HDD at t=
he
>>> same time but I have 10 Node and that's only %5 of the EC data . I use =
m=3D8
>>> k=3D2.
>>>
>>> P.S: There are so many people asking and searching around this. I hope =
it
>>> will work this time.
>>> _______________________________________________
>>> ceph-users mailing list -- ceph-users@ceph.io
>>> To unsubscribe send an email to ceph-users-leave@ceph.io
