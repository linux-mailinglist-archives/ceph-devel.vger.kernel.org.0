Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0C43AA97
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Oct 2021 05:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhJZDIj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 23:08:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhJZDIi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 23:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635217575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgZfLWj7RPfnAn/W2uAQwfMYaCeUPV0KjyENL3A9vM8=;
        b=araYu+wjuDcLJG2jgecBFjTrM8jswB3bIV/1CdIm2fhGHpE7H3PXX3Hxg+eiEFLyQsqY8b
        4qPdTRY7eXMpOVefT90QwWChwz/ucFhwPF2dvLWHMzynZQdH1D6P21WqIFRaWSHfEsyQGe
        fEpz0MkOWH/Wk+cLwuKxn5N3x8OMzMo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-P1k-VeioNQOvXx5V1rPS8w-1; Mon, 25 Oct 2021 23:06:09 -0400
X-MC-Unique: P1k-VeioNQOvXx5V1rPS8w-1
Received: by mail-pf1-f198.google.com with SMTP id w196-20020a627bcd000000b0047c07de537aso1184740pfc.6
        for <ceph-devel@vger.kernel.org>; Mon, 25 Oct 2021 20:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bgZfLWj7RPfnAn/W2uAQwfMYaCeUPV0KjyENL3A9vM8=;
        b=3dQpY3fg9eHG3gFb2oEM//v3gEy0deIHa0QV+iqOUf51VCVQTrXGZcJiG/ZPoTdQ48
         mVF4/PVCUHAqVwIuFwW1+BeupzoOsJigIGuTmEPNzWzew21lDPu9BRbmNoTvby9vE2jp
         7CSyuOC1+WYNO9KxOgB9BvjVGK+yMfdugVYKaMzAYLXZpBcRaexWq7vMhvCfjKnLa2OZ
         2STIClZ1hrB6ftAtRdxB+bfga3GeGm5ZnuXuk0zegv58TSI9n50Jk9YdA+5v9PJjHweA
         o0M/cfEsALuSYWVwcHGdrU8+B9KgS3WLrb1nuWNbM2C2uHFfLjMoEFfzbbqdygIIxCM1
         p5vA==
X-Gm-Message-State: AOAM530XbHOXfrvHPusn/tSZCYZ9DaccRMjza9qU1IzutjsvmUkbu6Hz
        DiuTJ9Rpo2fM2/bcGgRjr5k12bpcbnBFngi5s+Sg6cOIdJ2+aeIP255fNCQG/IwlCZZ4Z8ETRSe
        xAYDzpgpMnwvcK8dPx8tysg==
X-Received: by 2002:a62:7c0b:0:b0:47b:df8d:816 with SMTP id x11-20020a627c0b000000b0047bdf8d0816mr17489641pfc.11.1635217567963;
        Mon, 25 Oct 2021 20:06:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWh1eQlGkKFSiSnyZ955TOkEvRh94YZpScVe05hDhVwUuLUubdbFrXIblKI+fZosICPRUWnQ==
X-Received: by 2002:a62:7c0b:0:b0:47b:df8d:816 with SMTP id x11-20020a627c0b000000b0047bdf8d0816mr17489613pfc.11.1635217567561;
        Mon, 25 Oct 2021 20:06:07 -0700 (PDT)
Received: from [10.72.12.93] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c4sm23523143pfv.144.2021.10.25.20.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 20:06:06 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
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
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <785d1435-4a2c-95aa-0573-2de54b4e7b6b@redhat.com>
Date:   Tue, 26 Oct 2021 11:05:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/22/21 1:30 AM, Patrick Donnelly wrote:
> On Thu, Oct 21, 2021 at 12:35 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
>>> On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
>>>>> On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>> On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
>>>>>>> This counter will keep track of the number of remote object copies done on
>>>>>>> copy_file_range syscalls.  This counter will be filesystem per-client, and
>>>>>>> can be accessed from the client debugfs directory.
>>>>>>>
>>>>>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>>>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>>>> ---
>>>>>>> This is an RFC to reply to Patrick's request in [0].  Note that I'm not
>>>>>>> 100% sure about the usefulness of this patch, or if this is the best way
>>>>>>> to provide the functionality Patrick requested.  Anyway, this is just to
>>>>>>> get some feedback, hence the RFC.
>>>>>>>
>>>>>>> Cheers,
>>>>>>> --
>>>>>>> Luís
>>>>>>>
>>>>>>> [0] https://github.com/ceph/ceph/pull/42720
>>>>>>>
>>>>>> I think this would be better integrated into the stats infrastructure.
>>>>>>
>>>>>> Maybe you could add a new set of "copy" stats to struct
>>>>>> ceph_client_metric that tracks the total copy operations done, their
>>>>>> size and latency (similar to read and write ops)?
>>>>> I think it's a good idea to integrate this into "stats" but I think a
>>>>> local debugfs file for some counters is still useful. The "stats"
>>>>> module is immature at this time and I'd rather not build any qa tests
>>>>> (yet) that rely on it.
>>>>>
>>>>> Can we generalize this patch-set to a file named "op_counters" or
>>>>> similar and additionally add other OSD ops performed by the kclient?
>>>>>
>>>>
>>>> Tracking this sort of thing is the main purpose of the stats code. I'm
>>>> really not keen on adding a whole separate set of files for reporting
>>>> this.
>>> Maybe I'm confused. Is there some "file" which is already used for
>>> this type of debugging information? Or do you mean the code for
>>> sending stats to the MDS to support cephfs-top?
>>>
>>>> What's the specific problem with relying on the data in debugfs
>>>> "metrics" file?
>>> Maybe no problem? I wasn't aware of a "metrics" file.
>>>
>> Yes. For instance:
>>
>> # cat /sys/kernel/debug/ceph/*/metrics
>> item                               total
>> ------------------------------------------
>> opened files  / total inodes       0 / 4
>> pinned i_caps / total inodes       5 / 4
>> opened inodes / total inodes       0 / 4
>>
>> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
>> -----------------------------------------------------------------------------------
>> read          0           0               0               0               0
>> write         5           914013          824797          1092343         103476
>> metadata      79          12856           1572            114572          13262
>>
>> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
>> ----------------------------------------------------------------------------------------
>> read          0           0               0               0               0
>> write         5           4194304         4194304         4194304         20971520
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       11              0               29
>> caps          5               68              10702
>>
>>
>> I'm proposing that Luis add new lines for "copy" to go along with the
>> "read" and "write" ones. The "total" counter should give you a count of
>> the number of operations.
> Okay that makes more sense!
>
> Side note: I am a bit horrified by how computer-unfriendly that
> table-formatted data is.

Any suggestion to improve this ?

How about just make the "metric" file writable like a switch ? And as 
default it will show the data as above and if tools want the 
computer-friendly format, just write none-zero to it, then show raw data 
just like:

# cat /sys/kernel/debug/ceph/*/metrics
opened_files:0
pinned_i_caps:5
opened_inodes:0
total_inodes:4

read_latency:0,0,0,0,0
write_latency:5,914013,824797,1092343,103476
metadata_latency:79,12856,1572,114572,13262

read_size:0,0,0,0,0
write_size:5,4194304,4194304,4194304,20971520

d_lease:11,0,29
caps:5,68,10702


