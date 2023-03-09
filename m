Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80DF6B1942
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 03:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCICjO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 21:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCICjM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 21:39:12 -0500
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F69253D98
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 18:39:10 -0800 (PST)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 577F561852;
        Thu,  9 Mar 2023 13:39:08 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id MhIWmEGuFWbf; Thu,  9 Mar 2023 13:39:08 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 0FB506180E;
        Thu,  9 Mar 2023 13:39:08 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id B3039680560; Thu,  9 Mar 2023 13:39:07 +1100 (AEDT)
Date:   Thu, 9 Mar 2023 13:39:07 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     Anthony D'Atri <aad@dreamsnake.net>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: Upgrade 16.2.9 to 16.2.11 stopped due to #57627
Message-ID: <ZAlGyylVaONzLes1@onthe.net.au>
References: <ZAgb8KZ5NWEkAWWF@onthe.net.au>
 <6372A70B-F3F5-41BA-A18D-8A27F1541D50@dreamsnake.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6372A70B-F3F5-41BA-A18D-8A27F1541D50@dreamsnake.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[[
   possibly stuff of general interest here so adding ceph-devel back to CC
]]

On Wed, Mar 08, 2023 at 07:49:01AM -0500, Anthony D'Atri wrote:
>> On Mar 8, 2023, at 12:24 AM, Chris Dunlop <chris@onthe.net.au> wrote:
>>
>> b2$ lsblk -P -p -o 'NAME' | wc -l
>> 924
>
> I’m curious how you have that many devices.
>
> Something like a 90-bay toploader + dmcrypt + shared WAL+DB?

The actual box has 105 bays, head unit + jbod x 2, with currently 87 
physical devices - see below for more details on what this box is doing.

The "lsblk" line above is what's run by:

src/ceph-volume/ceph_volume/util/disk.py:lsblk_all()

[[ aside...
   I think the general recommendation is that where a command has short and 
   long versions of the same option, the short option is nice for 
   interactive use but it's better to use the long option for programming, 
   i.e. it would be better to have disk.py call lsblk like:

   lsblk --pairs --paths --output 'NAME'
]]

But it's significantly overcounting, e.g. I can't see that lsblk_all() is 
"unique-ifying" the output as it should:

b2$ lsblk -P -p -o 'NAME' | sort -u | wc -l
393

The lsblk "merge" option might be appropriate for this:

b2$ diff <(lsblk -P -p -o 'NAME' | sort -u) <(lsblk -M -P -p -o 'NAME' | sort) || echo same
same

Perhaps there's more filtering that can / should be done at the lsblk 
level to further reduce the device count but I don't know exactly what 
ceph is looking for here so can't suggest what might work.

To further expand on this box...

Just to get in ahead of the obvious comments: yes, this box is more than a 
little frankenstein and the functions it performs can and should be 
separated out. But "for historical reasons" this is where we are 
currently, so...

The box is running 21 osds, some with separate WAL+DB. It's also running a 
bunch of other stuff, e.g. there are:

- 8 MD devices comprised of 55 of the physical devices which make up 
   - a 300T XFS filesystem for bulk storage
   - some smaller XFS FSs (e.g. root)
   - some mirrored SSDs for WAL+DB
   - an SSD LV writecache on raid6 (5 devices)
- 56 mapped rbds, each with LV writecache

Overall, the 393 unique lsblk entries are made up of:

84	physical (e.g. /dev/sdx)
47	partition (e.g. /dev/sdx1)
8	md (e.g. /dev/mdx)
56	rbds (e.g. /dev/rbdx)
198	mapper (e.g. /dev/mapper/xxxx)

The mapper stuff is obviously a significant part of my issue. E.g. for a 
single mapped rbd with an LV writecache on a 5-device MD raid6 (and there 
are currently 56 of these mapped rbds!), "lsblk" shows these entries: 

b2$ lsblk
NAME                           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
...
sdbp                            68:48   0   3.5T  0 disk
└─md10                           9:10   0  10.5T  0 raid6
   ├─aaaaa-fast--bbbbbbbb_cvol  253:46   0     1G  0 lvm
   │ └─aaaaa-bbbbbbbb           253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...
sdbt                            68:112  0   3.5T  0 disk
└─md10                           9:10   0  10.5T  0 raid6
   ├─aaaaa-fast-bbbbbbbbb_cvol  253:46   0     1G  0 lvm
   │ └─aaaaa-bbbbbbbb           253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...
sdce                            69:32   0   3.5T  0 disk
└─md10                           9:10   0  10.5T  0 raid6
   ├─aaaaa-fast-bbbbbbbbb_cvol  253:46   0     1G  0 lvm
   │ └─aaaaa-bbbbbbbb           253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...
sdci                            69:96   0   3.5T  0 disk
└─md10                           9:10   0  10.5T  0 raid6
   ├─aaaaa-fast-bbbbbbbbb_cvol  253:46   0     1G  0 lvm
   │ └─aaaaa-bbbbbbbb           253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...
sdcw                            70:64   0   3.5T  0 disk
└─md10                           9:10   0  10.5T  0 raid6
   ├─aaaaa-fast-bbbbbbbbb_cvol  253:46   0     1G  0 lvm
   │ └─aaaaa-bbbbbbbb           253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...
rbd33                          252:528  0     1T  0 disk
└─aaaaa-bbbbbbbb_wcorig        253:47   0  1024G  0 lvm
   └─aaaaa-bbbbbbbb             253:48   0  1024G  0 lvm   /aaaaa/bbbbbbbb
...

So lsblk_all() sees:

b2$ lsblk -M -P -p -o 'NAME' | grep bbbbbbbb
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-bbbbbbbb_wcorig"
NAME="/dev/mapper/aaaaa-bbbbbbbb"

Alternatively:

b2$ lsblk -M -P -p -o 'NAME' | grep bbbbbbbb
NAME="/dev/mapper/aaaaa-fast--bbbbbbbb_cvol"
NAME="/dev/mapper/aaaaa-bbbbbbbb"
NAME="/dev/mapper/aaaaa-bbbbbbbb_wcorig"


Cheers,

Chris
