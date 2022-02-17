Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53D14B95EB
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiBQCav (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 21:30:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiBQCav (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 21:30:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90BA529E96A
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 18:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645065036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zy+fET+wyaLpfoJ1MPx16DcF70isua6sdQUP0A+OILk=;
        b=V6YimJpUR0Qf+leL5dWWEi/uUFFSAiTFMNViJmk45IhAExsb9JOg/31h2DeBIoii6BwIGV
        VmWvqn04o2c1lm3lphotQVmHRuiFkMWgULh34JlJpU/nBWNBqdZ85kX2153JjKsxN6pEOd
        /R8tXP6PvYhM90zMBjxHq3OBMln/bm0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-PZq9i_i5OnSfGyJ66cRzeQ-1; Wed, 16 Feb 2022 21:30:35 -0500
X-MC-Unique: PZq9i_i5OnSfGyJ66cRzeQ-1
Received: by mail-pf1-f200.google.com with SMTP id e18-20020aa78252000000b004df7a13daeaso2415597pfn.2
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 18:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Zy+fET+wyaLpfoJ1MPx16DcF70isua6sdQUP0A+OILk=;
        b=sOdpVLon8WOIQHTUIq6cZfxsX+W5BF+e5hCtUbma0CwJpBqOYzBrcVVC6L9XjrMaFy
         fUHAxtLLzOafax2jktV8UkfRQlOs8naiCo1YAyxV+pg3q2M1xM1igz/UUCt7ezLJZLQ2
         NtZuUqQsDAPYL9L4WmVS+mSAP7NMaUXnqHcHY4IiVciF4L2Gl3D28kJvdy+KiN7mFl1u
         zAeo8c9uY+feyMx9smU5Ow0ndKpHbESQJ2jM8jVIGp9FtaPLtBqDJCrRZkICXnCgcGW9
         7weXe+Y+YF0bHkrTC9GbEaMC8NllVu2JKJ8Uo3kcV05vd6l4ETtSQ9BjCvY1EFImhbB4
         U7yA==
X-Gm-Message-State: AOAM532d2prNHi6WgwB2fGaUZqbny7in32iwWOSq+CmWnwr7kCeHoC9m
        XUV3mheYV4YyFYRWOzAcyZ7ayuvM67br36jsuEFyum2+IOO8wTHrrBOiI8skgeprfyiIPxyiRSr
        g3JbAb5uukvpXPgb6jqYGFaLIYWlAy2ftA3QHFEKoJB1FMbrxvNNdyBUBvvppKcEc57rB14Q=
X-Received: by 2002:a63:7709:0:b0:36c:8c3c:1199 with SMTP id s9-20020a637709000000b0036c8c3c1199mr731817pgc.580.1645065034007;
        Wed, 16 Feb 2022 18:30:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHcURcLo1N1EHP7o8LHYFTuEvBd37DFo4zLyiWxngqjywywuqd+KfwGzjTaetUXf+zfiU/UA==
X-Received: by 2002:a63:7709:0:b0:36c:8c3c:1199 with SMTP id s9-20020a637709000000b0036c8c3c1199mr731791pgc.580.1645065033602;
        Wed, 16 Feb 2022 18:30:33 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d18sm1108341pfv.204.2022.02.16.18.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 18:30:33 -0800 (PST)
Subject: Re: [PATCH] ceph: eliminate the recursion when rebuilding the snap
 context
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220216054335.32015-1-xiubli@redhat.com>
 <6a0e0c749921548b050301c22ae8f1aeceeb064a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6c4b643b-16da-cbb5-2b10-092748a764d5@redhat.com>
Date:   Thu, 17 Feb 2022 10:30:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6a0e0c749921548b050301c22ae8f1aeceeb064a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/16/22 10:13 PM, Jeff Layton wrote:
> On Wed, 2022-02-16 at 13:43 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Use a list instead of recuresion to avoid possible stack overflow.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c  | 44 +++++++++++++++++++++++++++++++++++---------
>>   fs/ceph/super.h |  2 ++
>>   2 files changed, 37 insertions(+), 9 deletions(-)
>>
> Thanks Xiubo. This seems sane to me.
>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 6939307d41cb..808add7dca9e 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -319,7 +319,8 @@ static int cmpu64_rev(const void *a, const void *b)
>>    * build the snap context for a given realm.
>>    */
>>   static int build_snap_context(struct ceph_snap_realm *realm,
>> -			      struct list_head* dirty_realms)
>> +			      struct list_head *realm_queue,
>> +			      struct list_head *dirty_realms)
>>   {
>>   	struct ceph_snap_realm *parent = realm->parent;
>>   	struct ceph_snap_context *snapc;
>> @@ -333,9 +334,9 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>>   	 */
>>   	if (parent) {
>>   		if (!parent->cached_context) {
>> -			err = build_snap_context(parent, dirty_realms);
>> -			if (err)
>> -				goto fail;
>> +			/* add to the queue head */
>> +			list_add(&parent->rebuild_item, realm_queue);
>> +			return 1;
>>   		}
>>   		num += parent->cached_context->num_snaps;
>>   	}
>> @@ -418,13 +419,38 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>>   static void rebuild_snap_realms(struct ceph_snap_realm *realm,
>>   				struct list_head *dirty_realms)
>>   {
>> -	struct ceph_snap_realm *child;
>> +	LIST_HEAD(realm_queue);
>> +	int last = 0;
>>   
>> -	dout("%s %llx %p\n", __func__, realm->ino, realm);
>> -	build_snap_context(realm, dirty_realms);
>> +	list_add_tail(&realm->rebuild_item, &realm_queue);
>> +
>> +	while (!list_empty(&realm_queue)) {
>> +		struct ceph_snap_realm *_realm, *child;
>> +
>> +		/*
>> +		 * If the last building failed dues to memory
>> +		 * issue, just empty the realm_queue and return
>> +		 * to avoid infinite loop.
>> +		 */
>> +		if (last < 0) {
>> +			list_del(&_realm->rebuild_item);
>> +			continue;
>> +		}
> So if this ends up happening, then we'll just end up silently returning
> and not report anything to the console. Should we pr_warn or something
> instead?

Maybe a warning once on this case ? Or should we print all of the realm 
info in the warning logs ?

See my following comments, if we need to fix it I could add this in the 
following patches, and there have some other places need to do the same too.

> We could make rebuild_snap_realms be an int return function,
> and have it trigger the pr_err in ceph_update_snap_trace. That message
> is pretty cryptic though.
>
>
> It seems like the realm hierarchy would be FUBAR at this point. What's
> the likely effect if that happens? Are there any steps an admin could
> take to try and rescue things (maybe after freeing some memory on the
> box)?

 From doc 
https://docs.ceph.com/en/latest/dev/cephfs-snapshots/#snapshot-writeback.

As my understanding we should just make the whole kclient mount or 
related directory to be readonly and at least shouldn't allow any new 
write in this case. Or since we cannot generate CapSnaps for the inodes, 
so we cannot block fresh data writes ?

The whole kclient does nothing in this case in other places. I checked 
the libcephfs code, it juse call ceph_assert() or throws a 
std::bad_alloc exception to abort the daemon.

IMO we should fix it in kclient. Do you think this makes sense ? If so I 
can do that in a separate patch later. For this patch since it intend to 
eliminate the recursion I will keep this code as it was and there has 
some other places need to be fixed too.

-- Xiubo


>> +
>> +		_realm = list_first_entry(&realm_queue,
>> +					  struct ceph_snap_realm,
>> +					  rebuild_item);
>> +		last = build_snap_context(_realm, &realm_queue, dirty_realms);
>> +		dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
>> +		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
>>   
>> -	list_for_each_entry(child, &realm->children, child_item)
>> -		rebuild_snap_realms(child, dirty_realms);
>> +		list_for_each_entry(child, &_realm->children, child_item)
>> +			list_add_tail(&child->rebuild_item, &realm_queue);
>> +
>> +		/* last == 1 means need to build parent first */
>> +		if (last <= 0)
>> +			list_del(&_realm->rebuild_item);
>> +	}
>>   }
>>   
>>   
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index a17bd01a8957..baac800a6d11 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -885,6 +885,8 @@ struct ceph_snap_realm {
>>   
>>   	struct list_head dirty_item;     /* if realm needs new context */
>>   
>> +	struct list_head rebuild_item;   /* rebuild snap realms _downward_ in hierarchy */
>> +
>>   	/* the current set of snaps for this realm */
>>   	struct ceph_snap_context *cached_context;
>>   
> I'll plan to merge this into testing branch and do some testing with it,
> but I wouldn't mind a v2 or follow-on patch that clarifies what can be
> done if build_snap_context fails.
>
> Thanks,

