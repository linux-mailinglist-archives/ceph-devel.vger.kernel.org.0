Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2FB43C1DD
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 06:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbhJ0Eze (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 00:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238002AbhJ0Ezd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 00:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635310388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hMNq/owOA2RIyXlYkDseh4SPVudn754hwbkRS5+V1fg=;
        b=agny9uEymA0l2LBhVv8DNTV0H529MK4wDdTgT1DVQURXgFxO04lzbqxy/2d+vAwIO5yqyw
        IRg+YXcS3aVr8LD3PafNWmGh4DEeUXyV1ZTX7LBKPFBNWF3T+LEolI17JSCaxsE3ceN22V
        FIf8YesVqgQUfY61eDgqVsRK41fIaeE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-9EtdYOGqO_mhQmP1nZRVKw-1; Wed, 27 Oct 2021 00:53:06 -0400
X-MC-Unique: 9EtdYOGqO_mhQmP1nZRVKw-1
Received: by mail-pl1-f197.google.com with SMTP id ba4-20020a170902720400b0013a432f7556so724084plb.4
        for <ceph-devel@vger.kernel.org>; Tue, 26 Oct 2021 21:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hMNq/owOA2RIyXlYkDseh4SPVudn754hwbkRS5+V1fg=;
        b=NcNZUeujKjBkB15wDy+/GEKLn7FU3qETdeFbERFfOykE+NV8DeiHKSAm0hyBMAC16j
         WGcAtb9vlD7SUtlZKIZcbqpfCvUOdOE+p5q9RIhW8tUDVQPgs2bc0XQMXZQB3k+0eYC8
         Lq3+tWQ355Riu0lNZ2GW91o2cWnkDmxax4tBOrnqJuP4atemIVoVGbHdb6Y++Fy9oSWB
         kgI7XNW9uuXeZOW1IQOKmj3DMm1XXyWhnER8NOwlojh098wo/2TXDc1wisvdoFVujPMe
         lTdahnzrknB6Nzegf4lUWXC/r+t71ny1jTbUTaWYllzabobjF59e4EtF5taUUMFhXjBd
         HPqA==
X-Gm-Message-State: AOAM532uff1HS362HJueUjoS3nDCtA3vPMa60w5/Cu1RxXgn05RnPDF7
        c5nghzH1H2/ZW5FfOMAV2VX9lyuvIuzHkYdiNWCJxQZT7aMk9fESNorXSA/l56Pt6eb5nDvLrWg
        X+GMw5YhVwIUMOBTMl8ehSQ==
X-Received: by 2002:a62:6d86:0:b0:448:152d:83a4 with SMTP id i128-20020a626d86000000b00448152d83a4mr29995118pfc.38.1635310385129;
        Tue, 26 Oct 2021 21:53:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0/EPCoyg/+ydg2EuF4StJbrpg6jG8RPYCSYSCQ5LhCWdNQY9/f6ImsKUzIBNEZ5mXotvSdw==
X-Received: by 2002:a62:6d86:0:b0:448:152d:83a4 with SMTP id i128-20020a626d86000000b00448152d83a4mr29995083pfc.38.1635310384766;
        Tue, 26 Oct 2021 21:53:04 -0700 (PDT)
Received: from [10.72.12.93] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g11sm20724281pgn.41.2021.10.26.21.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 21:53:04 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
To:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20211020143708.14728-1-lhenriques@suse.de>
 <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
 <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
 <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
 <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
 <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
 <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
 <785d1435-4a2c-95aa-0573-2de54b4e7b6b@redhat.com>
 <604199ed389d9286e3fdab6b5acdf65c421df45d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <67fdba23-a91d-9ddb-4af5-8098b3e804b8@redhat.com>
Date:   Wed, 27 Oct 2021 12:52:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <604199ed389d9286e3fdab6b5acdf65c421df45d.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/26/21 7:40 PM, Jeff Layton wrote:
> On Tue, 2021-10-26 at 11:05 +0800, Xiubo Li wrote:
>> On 10/22/21 1:30 AM, Patrick Donnelly wrote:
>>> On Thu, Oct 21, 2021 at 12:35 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
>>>>> On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>> On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
>>>>>>> On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>>>> On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
>>>>>>>>> This counter will keep track of the number of remote object copies done on
>>>>>>>>> copy_file_range syscalls.  This counter will be filesystem per-client, and
>>>>>>>>> can be accessed from the client debugfs directory.
>>>>>>>>>
>>>>>>>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>>>>>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>>>>>> ---
>>>>>>>>> This is an RFC to reply to Patrick's request in [0].  Note that I'm not
>>>>>>>>> 100% sure about the usefulness of this patch, or if this is the best way
>>>>>>>>> to provide the functionality Patrick requested.  Anyway, this is just to
>>>>>>>>> get some feedback, hence the RFC.
>>>>>>>>>
>>>>>>>>> Cheers,
>>>>>>>>> --
>>>>>>>>> Luís
>>>>>>>>>
>>>>>>>>> [0] https://github.com/ceph/ceph/pull/42720
>>>>>>>>>
>>>>>>>> I think this would be better integrated into the stats infrastructure.
>>>>>>>>
>>>>>>>> Maybe you could add a new set of "copy" stats to struct
>>>>>>>> ceph_client_metric that tracks the total copy operations done, their
>>>>>>>> size and latency (similar to read and write ops)?
>>>>>>> I think it's a good idea to integrate this into "stats" but I think a
>>>>>>> local debugfs file for some counters is still useful. The "stats"
>>>>>>> module is immature at this time and I'd rather not build any qa tests
>>>>>>> (yet) that rely on it.
>>>>>>>
>>>>>>> Can we generalize this patch-set to a file named "op_counters" or
>>>>>>> similar and additionally add other OSD ops performed by the kclient?
>>>>>>>
>>>>>> Tracking this sort of thing is the main purpose of the stats code. I'm
>>>>>> really not keen on adding a whole separate set of files for reporting
>>>>>> this.
>>>>> Maybe I'm confused. Is there some "file" which is already used for
>>>>> this type of debugging information? Or do you mean the code for
>>>>> sending stats to the MDS to support cephfs-top?
>>>>>
>>>>>> What's the specific problem with relying on the data in debugfs
>>>>>> "metrics" file?
>>>>> Maybe no problem? I wasn't aware of a "metrics" file.
>>>>>
>>>> Yes. For instance:
>>>>
>>>> # cat /sys/kernel/debug/ceph/*/metrics
>>>> item                               total
>>>> ------------------------------------------
>>>> opened files  / total inodes       0 / 4
>>>> pinned i_caps / total inodes       5 / 4
>>>> opened inodes / total inodes       0 / 4
>>>>
>>>> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
>>>> -----------------------------------------------------------------------------------
>>>> read          0           0               0               0               0
>>>> write         5           914013          824797          1092343         103476
>>>> metadata      79          12856           1572            114572          13262
>>>>
>>>> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
>>>> ----------------------------------------------------------------------------------------
>>>> read          0           0               0               0               0
>>>> write         5           4194304         4194304         4194304         20971520
>>>>
>>>> item          total           miss            hit
>>>> -------------------------------------------------
>>>> d_lease       11              0               29
>>>> caps          5               68              10702
>>>>
>>>>
>>>> I'm proposing that Luis add new lines for "copy" to go along with the
>>>> "read" and "write" ones. The "total" counter should give you a count of
>>>> the number of operations.
>>> Okay that makes more sense!
>>>
>>> Side note: I am a bit horrified by how computer-unfriendly that
>>> table-formatted data is.
>> Any suggestion to improve this ?
>>
>> How about just make the "metric" file writable like a switch ? And as
>> default it will show the data as above and if tools want the
>> computer-friendly format, just write none-zero to it, then show raw data
>> just like:
>>
>> # cat /sys/kernel/debug/ceph/*/metrics
>> opened_files:0
>> pinned_i_caps:5
>> opened_inodes:0
>> total_inodes:4
>>
>> read_latency:0,0,0,0,0
>> write_latency:5,914013,824797,1092343,103476
>> metadata_latency:79,12856,1572,114572,13262
>>
>> read_size:0,0,0,0,0
>> write_size:5,4194304,4194304,4194304,20971520
>>
>> d_lease:11,0,29
>> caps:5,68,10702
>>
>>
> I'd rather not multiplex the output of this file based on some input.
> That would also be rather hard to do -- write() and read() are two
> different syscalls, so you'd need to track a bool (or something) across
> them somehow.
>
> Currently, I doubt there are many scripts in the field that scrape this
> info and debugfs is specifically excluded from ABI concerns. If we want
> to make it more machine-readable (which sounds like a good thing), then
> I suggest we just change the output to something like what you have
> above and not worry about preserving the "legacy" output.

Sound good to me.


