Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6664B7BFD
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 01:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbiBPAg0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 19:36:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiBPAgZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 19:36:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A200827B33
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644971773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOM1I4AQvS5CPZi0DwCYMJ1p4P5QCYej5a5pbnhO6Jg=;
        b=N5OW5CcbatBa5mZVjY6MvRzhQZeuaW4w80FaQyHTX8Zhxx2utU3yGzT55hpeDfwhWbzzoU
        d/leWqmaleQRLmEpXUyu/4j2M0NJar7INyD31AEaZTCKrCuHyJARRd69D7Rnld0gADDoMS
        fcFcdybeN514vGjlnvJJpS2VeS+Ssqo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-E5LZ5hCKMj2ACIegtygUQQ-1; Tue, 15 Feb 2022 19:36:12 -0500
X-MC-Unique: E5LZ5hCKMj2ACIegtygUQQ-1
Received: by mail-pf1-f198.google.com with SMTP id a22-20020aa79716000000b004e16e3cc5fcso447499pfg.11
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:36:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mOM1I4AQvS5CPZi0DwCYMJ1p4P5QCYej5a5pbnhO6Jg=;
        b=4IXLZYme2wIswWx8csX5MG98R0MW2FG85eGemaujcTPSWO676HLPuzbMCEpH+T+Woi
         iR6Q5CqHR5yzPYmAHN309KjBjWLCLDfihImkIgYaK2uCzjNH4in0OmPl57RXO1cD26Pq
         Onb1ppKcnski/sjG7+0YUa1Ugs1fT3fjwmVlUo2he8mScwKZ9+NIPpJA3C4pmSKMPT8I
         cjufXyLvtymhsXvlBeo01b35giCu/2Lb/i3UZNIUNORsjQwithQobsiHbbDMRYFVePfb
         OqKoQBwzAYh04nXaBjcSFJUksHhleL0shyCKGgV88uQeH/pFxf9PeaU/Aos20TxCYh9U
         fUsQ==
X-Gm-Message-State: AOAM531AoGJPoHKwb0BbFb6u/cOsfyw1N9bx3ljSw6gVAWS/7B5GtGxo
        akZCqG3mgynj5Zog534SpAO5GMb3TzlGAZFWAA5evP1rDfg3clQB2Pede2px4cO10uB9khH46QH
        Pygai/Angx6AV8+rTGtRh53SyCjKyIv8HECQASDxU1+BlJjvvG9TKUE377V9sYq/r5HPFtMY=
X-Received: by 2002:a17:90b:4c8e:b0:1b9:d23f:bf62 with SMTP id my14-20020a17090b4c8e00b001b9d23fbf62mr7352625pjb.160.1644971770674;
        Tue, 15 Feb 2022 16:36:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNCLHv4u12L+ap4Rk7ZZz0V0X7YlWUDbeC+0M/Z0dUUoFep1xgXg5cdfesNohQ5rr2RklBTA==
X-Received: by 2002:a17:90b:4c8e:b0:1b9:d23f:bf62 with SMTP id my14-20020a17090b4c8e00b001b9d23fbf62mr7352590pjb.160.1644971770324;
        Tue, 15 Feb 2022 16:36:10 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ob12sm11121034pjb.5.2022.02.15.16.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 16:36:09 -0800 (PST)
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is no
 new snapshot
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220215122316.7625-1-xiubli@redhat.com>
 <20220215122316.7625-4-xiubli@redhat.com>
 <73043655720d093ae7ab1f4eb25456a5792cece4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <caa86c6f-3283-588e-0ad6-624216de986d@redhat.com>
Date:   Wed, 16 Feb 2022 08:36:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <73043655720d093ae7ab1f4eb25456a5792cece4.camel@kernel.org>
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


On 2/16/22 2:35 AM, Jeff Layton wrote:
> On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> No need to update snapshot context when any of the following two
>> cases happens:
>> 1: if my context seq matches realm's seq and realm has no parent.
>> 2: if my context seq equals or is larger than my parent's, this
>>     works because we rebuild_snap_realms() works _downward_ in
>>     hierarchy after each update.
>>
>> This fix will avoid those inodes which accidently calling
>> ceph_queue_cap_snap() and make no sense, for exmaple:
>>
>> There have 6 directories like:
>>
>> /dir_X1/dir_X2/dir_X3/
>> /dir_Y1/dir_Y2/dir_Y3/
>>
>> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
>> make a root snapshot under /.snap/root_snap. And every time when
>> we make snapshots under /dir_Y1/..., the kclient will always try
>> to rebuild the snap context for snap_X2 realm and finally will
>> always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
>> no sense.
>>
>> That's because the snap_X2's seq is 2 and root_snap's seq is 3.
>> So when creating a new snapshot under /dir_Y1/... the new seq
>> will be 4, and then the mds will send kclient a snapshot backtrace
>> in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
>> it will always rebuild the from the last realm, that's the root_snap.
>> So later when rebuilding the snap context it will always rebuild
>> the snap_X2 realm and then try to queue cap snaps for all the inodes
>> related in snap_X2 realm, and we are seeing the logs like:
>>
>> "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>>
>> URL: https://tracker.ceph.com/issues/44100
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index d075d3ce5f6d..1f24a5de81e7 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>>   		num += parent->cached_context->num_snaps;
>>   	}
>>   
>> -	/* do i actually need to update?  not if my context seq
>> -	   matches realm seq, and my parents' does to.  (this works
>> -	   because we rebuild_snap_realms() works _downward_ in
>> -	   hierarchy after each update.) */
>> +	/* do i actually need to update? No need when any of the following
>> +	 * two cases:
>> +	 * #1: if my context seq matches realm's seq and realm has no parent.
>> +	 * #2: if my context seq equals or is larger than my parent's, this
>> +	 *     works because we rebuild_snap_realms() works _downward_ in
>> +	 *     hierarchy after each update.
>> +	 */
> This may be, but that downward building is done via unbounded recursion
> in rebuild_snap_realms().
>
> I'm ok with taking this patch in the short term, but I would really like
> to see steps made to eliminate recursion from this code altogether. A
> sufficiently deep hierarchy could blow out the stack. How could we
> redesign this code to avoid it?

Yeah, the recursion really a potential issue here, let me figure out one 
method to eliminate it later in the following patches, there has some 
other code also may need to improve, and I am still going through the 
code, not very clear yet. But not related to the perfermance issue this 
patch is trying to fix.

-- Xiubo

>
>>   	if (realm->cached_context &&
>> -	    realm->cached_context->seq == realm->seq &&
>> -	    (!parent ||
>> -	     realm->cached_context->seq >= parent->cached_context->seq)) {
>> +	    ((realm->cached_context->seq == realm->seq && !parent) ||
>> +	     (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
>>   		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
>>   		     " (unchanged)\n",
>>   		     realm->ino, realm, realm->cached_context,

