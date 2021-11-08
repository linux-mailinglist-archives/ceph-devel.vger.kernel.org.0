Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF86A447BC2
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 09:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhKHI1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 03:27:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235830AbhKHI1j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 03:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636359894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZsQaQuUIae1FYhSCYkljk7PBHLTf2yf932kIWuaftuU=;
        b=Jl81c4Y2xCtV9y5SlhHCeiNLmBI57ssKtnFRlAVl6T3sPYKA1HLRBgqG4/btNZueWn5pw7
        JmmU/fGDA/WpEwp5KV+X5fo+RS4z+PhlYbQTwP2tJQO0ApvYiTZci1VOMFz200DXBqhBIn
        CTBjo49gp55lkPAh9kQtqEa01vJLS8Q=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-4BmlBV11PLC7B7jD3L5SXw-1; Mon, 08 Nov 2021 03:24:53 -0500
X-MC-Unique: 4BmlBV11PLC7B7jD3L5SXw-1
Received: by mail-pf1-f200.google.com with SMTP id h21-20020a056a001a5500b0049fc7bcb45aso1887528pfv.11
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:24:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZsQaQuUIae1FYhSCYkljk7PBHLTf2yf932kIWuaftuU=;
        b=y+JhEzsFPG+VG4AdoMCtCi32Lzz3WL1INrBBhGhrsDeqBeBW5I1BfHarTHLPMUxYm8
         1+Ppr8AS1l4kA6uNYwaadsP0yL2tOY87xAWsdmMtPik85CY/LJDGrR0IABlizeJKqv0O
         hPYtEXs/OzJy9jC4j1W0yhOqz4L+ZsaWkxahGKNu69Ubgfm4u/3uL4SOJuGWGlm+b5jv
         2+AhuWWifaVwV59j7lkVWRz1GjP8s3h/WeSYZQ+GSa5SHNiUJnHb06Yc2kriD8rsjm6m
         mSFoE1KDIniRNrhKVLrv2smexXGEnNPVXLwSQwYTiqZcYcnqITF8VKbp9fHqTPYmx2Q3
         xjyg==
X-Gm-Message-State: AOAM530g9Cg8jIhuXAd801eDLc8h5pMHUM8RdIaCGyiAahfo2O9oAOO6
        Bps2K1mR7ZC37YBZT4pXgdoadhRG0rQ6pEF0U87wc0iqeNqKwVJBRSItZuSIjch/fIz9eVblo5x
        JXsK/IbxMZKgnNm66LwhccsWbBu4AYiNxpHiNdYCiY61mar6yjwquvJ2Iw+s2f76YJeo0pGg=
X-Received: by 2002:a17:902:778a:b0:13f:672c:103a with SMTP id o10-20020a170902778a00b0013f672c103amr69904564pll.55.1636359891235;
        Mon, 08 Nov 2021 00:24:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYJ1sdzndGI+YvV4S95JNAw/A4aFErDgSa5nLRCBPTbZiGsa+A4rqFzihYCFwHro10d7mz1w==
X-Received: by 2002:a17:902:778a:b0:13f:672c:103a with SMTP id o10-20020a170902778a00b0013f672c103amr69904528pll.55.1636359890853;
        Mon, 08 Nov 2021 00:24:50 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u32sm3987185pfg.220.2021.11.08.00.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 00:24:50 -0800 (PST)
Subject: Re: [PATCH v7 0/9] ceph: size handling for the fscrypt
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105142215.345566-1-xiubli@redhat.com>
 <946e4c63292ae901e9a0925cc678609ba9e2ba9c.camel@kernel.org>
 <3ea75e3a6ab79ea090d6ea301633716846992db2.camel@kernel.org>
 <e0fcee87-68bd-8c33-b920-867fd0ef8fa9@redhat.com>
 <98d31e0fac7d2bfb8b81b252c1b75aea40e759dc.camel@kernel.org>
 <d31b2241f72115896bc38a7ed84beecdff409afa.camel@kernel.org>
 <1dd5e6bf-1f53-8edc-7e66-aebf1eb72330@redhat.com>
 <92781961-3c7f-38df-519f-643d884bb04c@redhat.com>
Message-ID: <ae29c908-96c8-c1fa-3c98-082c7bee999a@redhat.com>
Date:   Mon, 8 Nov 2021 16:24:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <92781961-3c7f-38df-519f-643d884bb04c@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/8/21 2:04 PM, Xiubo Li wrote:
>
> On 11/8/21 11:22 AM, Xiubo Li wrote:
> ...
>>>>
>>>>      $ sudo ./check -g quick -E ./ceph.exclude
>>>>
>>>> ...and ceph.exclude has:
>>>>
>>>> ceph/001
>>>> generic/003
>>>> generic/531
>>>> generic/538
>>>>
>>>> ...most of the exclusions are because they take a long time to run.
>>> Oh and I should say...most of the failures I've seen with this patchset
>>> are intermittent. I suspect there is some race condition we haven't
>>> addressed yet.
>>
>> The "generic/075" failed:
>>
>> [root@lxbceph1 xfstests]# ./check generic/075
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+
>>
>> generic/075     [failed, exit status 1] - output mismatch (see 
>> /mnt/kcephfs/xfstests/results//generic/075.out.bad)
>>     --- tests/generic/075.out    2021-11-08 08:38:19.756822587 +0800
>>     +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08 
>> 09:19:14.570013209 +0800
>>     @@ -4,15 +4,4 @@
>>      -----------------------------------------------
>>      fsx.0 : -d -N numops -S 0
>>      -----------------------------------------------
>>     -
>>     ------------------------------------------------
>>     -fsx.1 : -d -N numops -S 0 -x
>>     ------------------------------------------------
>>     ...
>>     (Run 'diff -u tests/generic/075.out 
>> /mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the 
>> entire diff)
>> Ran: generic/075
>> Failures: generic/075
>> Failed 1 of 1 tests
>>
>>
>> From '075.0.fsxlog':
>>
>>
>>  84 122 trunc       from 0x40000 to 0x3ffd3
>>  85 123 mapread     0x2794d thru    0x2cb8c (0x5240 bytes)
>>  86 124 read        0x37b86 thru    0x3dc7b (0x60f6 bytes)
>>  87 READ BAD DATA: offset = 0x37b86, size = 0x60f6, fname = 075.0
>>  88 OFFSET  GOOD    BAD     RANGE
>>  89 0x38fc0 0x79b2  0x0000  0x00000
>>  90 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>>  91 0x38fc1 0xb279  0x0000  0x00001
>>  92 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>>  93 0x38fc2 0x791e  0x0000  0x00002
>>  94 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>>  95 0x38fc3 0x1e79  0x0000  0x00003
>>  96 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>>  97 0x38fc4 0x79e0  0x0000  0x00004
>>  98 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>>  99 0x38fc5 0xe079  0x0000  0x00005
>> 100 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 101 0x38fc6 0x790b  0x0000  0x00006
>> 102 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 103 0x38fc7 0x0b79  0x0000  0x00007
>> 104 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 105 0x38fc8 0x7966  0x0000  0x00008
>> 106 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 107 0x38fc9 0x6679  0x0000  0x00009
>> 108 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 109 0x38fca 0x79ff  0x0000  0x0000a
>> 110 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 111 0x38fcb 0xff79  0x0000  0x0000b
>> 112 operation# (mod 256) for the bad data unknown, check HOLE and 
>> EXTEND ops
>> 113 0x38fcc 0x7996  0x0000  0x0000c
>> ...
>>
>>
>> I have dumped the '075.0.full', it's the same with the '075.out.bad'.
>>
>> Checked the diff '075.0.good' and '075.0.bad', it shows that from the 
>> file offset 0x038fc0~i_size the contents are all zero in the 
>> '075.0.bad'. The '075.0.good is not.
>>
>> From the '/proc/kmsg' output:
>>
>> 18715 <7>[61484.334994] ceph:  fill_fscrypt_truncate size 262144 -> 
>> 262099 got cap refs on Fr, issued pAsxLsXsxFsxcrwb
>> 18716 <7>[61484.335010] ceph:  writepages_start 000000003e6c8932 
>> (mode=ALL)
>> 18717 <7>[61484.335021] ceph:   head snapc 000000003195bf7d has 8 
>> dirty pages
>> 18718 <7>[61484.335030] ceph:   oldest snapc is 000000003195bf7d seq 
>> 1 (0 snaps)
>> 18719 <7>[61484.335041] ceph:   not cyclic, 0 to 2251799813685247
>> 18720 <7>[61484.335054] ceph:  pagevec_lookup_range_tag got 8
>> 18721 <7>[61484.335063] ceph:  ? 000000007350de9f idx 56
>> 18722 <7>[61484.335139] ceph:  000000003e6c8932 will write page 
>> 000000007350de9f idx 56
>> 18723 <7>[61484.335151] ceph:  ? 00000000db5774fb idx 57
>> 18724 <7>[61484.335162] ceph:  000000003e6c8932 will write page 
>> 00000000db5774fb idx 57
>> 18725 <7>[61484.335173] ceph:  ? 000000008bc9ea57 idx 58
>> 18726 <7>[61484.335183] ceph:  000000003e6c8932 will write page 
>> 000000008bc9ea57 idx 58
>> 18727 <7>[61484.335194] ceph:  ? 00000000be4c1d25 idx 59
>> 18728 <7>[61484.335204] ceph:  000000003e6c8932 will write page 
>> 00000000be4c1d25 idx 59
>> 18729 <7>[61484.335215] ceph:  ? 0000000051d6fed1 idx 60
>> 18730 <7>[61484.335225] ceph:  000000003e6c8932 will write page 
>> 0000000051d6fed1 idx 60
>> 18731 <7>[61484.335237] ceph:  ? 00000000f40c8a7a idx 61
>> 18732 <7>[61484.335254] ceph:  000000003e6c8932 will write page 
>> 00000000f40c8a7a idx 61
>> 18733 <7>[61484.335274] ceph:  ? 00000000c7da9df6 idx 62
>> 18734 <7>[61484.335291] ceph:  000000003e6c8932 will write page 
>> 00000000c7da9df6 idx 62
>> 18735 <7>[61484.335312] ceph:  ? 00000000646abb31 idx 63
>> 18736 <7>[61484.335330] ceph:  000000003e6c8932 will write page 
>> 00000000646abb31 idx 63
>> 18737 <7>[61484.335344] ceph:  reached end pvec, trying for more
>> 18738 <7>[61484.335352] ceph:  pagevec_lookup_range_tag got 0
>> 18739 <7>[61484.336008] ceph:  writepages got pages at 229376~32768
>> 18740 <7>[61484.336136] ceph:  pagevec_release on 0 pages 
>> (0000000000000000)
>> 18741 <7>[61484.336157] ceph:  pagevec_lookup_range_tag got 0
>> 18742 <7>[61484.336172] ceph:  writepages dend - startone, rc = 0
>> 18743 <7>[61484.348123] ceph:  writepages_finish 000000003e6c8932 rc 0
>>
> Before this I can see there has one aio_write will update the file and 
> write/dirty the above 8 pages:
>
> 30766 <7>[72062.257479] ceph:  aio_write 00000000457286fe 
> 1000000b1b7.fffffffffffffffe 233408~28736 getting caps. i_size 53014
> 30767 <7>[72062.257491] ceph:  get_cap_refs 00000000457286fe need Fw 
> want Fb
> 30768 <7>[72062.257499] ceph:  __ceph_caps_issued 00000000457286fe cap 
> 0000000075fd8906 issued pAsxLsXsxFscb
> 30769 <7>[72062.257507] ceph:  get_cap_refs 00000000457286fe have 
> pAsxLsXsxFscb need Fw
> ...
>
> 30795 <7>[72062.267240] ceph:  aio_write 00000000457286fe 
> 1000000b1b7.fffffffffffffffe 233408~28736 got cap refs on Fwb
> 30796 <7>[72062.267248] ceph:  __unregister_request 00000000cce16c34 
> tid 24
> 30797 <7>[72062.267254] ceph:  got safe reply 24, mds0
> 30798 <7>[72062.267272] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 000000007350de9f 233408~64 (64)
> 30799 <7>[72062.267287] ceph:  set_size 00000000457286fe 53014 -> 233472
> 30800 <7>[72062.267297] ceph:  00000000457286fe set_page_dirty 
> 00000000d20754ba idx 56 head 0/0 -> 1/1 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30801 <7>[72062.267322] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 00000000db5774fb 233472~4096 (4096)
> 30802 <7>[72062.267335] ceph:  set_size 00000000457286fe 233472 -> 237568
> 30803 <7>[72062.267344] ceph:  00000000457286fe set_page_dirty 
> 00000000cf1abc39 idx 57 head 1/1 -> 2/2 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30804 <7>[72062.267380] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 000000008bc9ea57 237568~4096 (4096)
> 30805 <7>[72062.267393] ceph:  set_size 00000000457286fe 237568 -> 241664
> 30806 <7>[72062.267401] ceph:  00000000457286fe set_page_dirty 
> 00000000b55a5d0e idx 58 head 2/2 -> 3/3 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30807 <7>[72062.267417] ceph:  put_cap_refs 00000000457286fe had p
> 30808 <7>[72062.267423] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 00000000be4c1d25 241664~4096 (4096)
> 30809 <7>[72062.267435] ceph:  set_size 00000000457286fe 241664 -> 245760
> 30810 <7>[72062.267444] ceph:  00000000457286fe set_page_dirty 
> 00000000810c0300 idx 59 head 3/3 -> 4/4 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30811 <7>[72062.267473] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 0000000051d6fed1 245760~4096 (4096)
> 30812 <7>[72062.267492] ceph:  set_size 00000000457286fe 245760 -> 249856
> 30813 <7>[72062.267506] ceph:  00000000457286fe set_page_dirty 
> 00000000b113b082 idx 60 head 4/4 -> 5/5 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30814 <7>[72062.267542] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 00000000f40c8a7a 249856~4096 (4096)
> 30815 <7>[72062.267563] ceph:  set_size 00000000457286fe 249856 -> 253952
> 30816 <7>[72062.267577] ceph:  00000000457286fe set_page_dirty 
> 00000000e52c4518 idx 61 head 5/5 -> 6/6 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30817 <7>[72062.267610] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 00000000c7da9df6 253952~4096 (4096)
> 30818 <7>[72062.267626] ceph:  set_size 00000000457286fe 253952 -> 258048
> 30819 <7>[72062.267635] ceph:  00000000457286fe set_page_dirty 
> 00000000b81992fe idx 62 head 6/6 -> 7/7 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30820 <7>[72062.267660] ceph:  write_end file 00000000b0595dbb inode 
> 00000000457286fe page 00000000646abb31 258048~4096 (4096)
> 30821 <7>[72062.267672] ceph:  set_size 00000000457286fe 258048 -> 262144
> 30822 <7>[72062.267680] ceph:  00000000457286fe set_page_dirty 
> 00000000111e20f4 idx 63 head 7/7 -> 8/8 snapc 00000000f69ffd89 seq 1 
> (0 snaps)
> 30823 <7>[72062.267697] ceph:  __mark_dirty_caps 00000000457286fe Fw 
> dirty - -> Fw
>
> But still not sure why those 8 dirty pages still writing 0 to the files.
>
>
Please ignore the above issue, I was using the old branch in ceph mds code.

BRs

Thanks

>
>> ...
>> 18760 <7>[61485.386715] ceph:  sync_read on inode 000000003e6c8932 
>> 258048~4096
>> 18761 <7>[61485.386784] ceph:  client4220 send metrics to mds0
>> 18762 <7>[61485.389512] ceph:  sync_read 258048~4096 got 4096 i_size 
>> 262144
>> 18763 <7>[61485.389569] ceph:  sync_read result 4096 retry_op 2
>> 18764 <7>[61485.389581] ceph:  put_cap_refs 000000003e6c8932 had Fr last
>>
>>
>> I see in fill_fscrypt_truncate() just before reading the last block 
>> it has already trigerred and successfully flushed the dirty pages to 
>> the OSD, but it seems those 8 pages' contents are zero.
>>
>> Is that possibly those 8 pages are not dirtied yet when we are 
>> flushing it in fill_fscrypt_truncate() ?
>>
>> Thanks
>>
>> BRs
>>
>>
>>
>>
>>
>>
>>> Thanks,

