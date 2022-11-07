Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA461F160
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Nov 2022 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKGK7n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Nov 2022 05:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiKGK7R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Nov 2022 05:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E1D19281
        for <ceph-devel@vger.kernel.org>; Mon,  7 Nov 2022 02:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667818698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Z1EOSRlp4jl1RjYNN5yP+/AS3LSGqO1qinKUvHFCoI=;
        b=IV0NDrqb2ESpQw8rdUa/MtwMrwMwsH74jwrOVzSzqqK3yc6JE0jxL4mIOwtyO3LcmRXqJ8
        HpDN/vK2nvZJeqV9j2/lMQHKFteUfUG8JhBXM2swLr33lkUw+nhMUuzzXWuxS4kKnp5+xc
        oIMs59igQ6z5vryeKz4v1u3d4ldOvoA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-90HsDVe0Pl6U3ivzdYcgOQ-1; Mon, 07 Nov 2022 05:58:17 -0500
X-MC-Unique: 90HsDVe0Pl6U3ivzdYcgOQ-1
Received: by mail-pj1-f71.google.com with SMTP id b1-20020a17090a10c100b0020da29fa5e5so5079980pje.2
        for <ceph-devel@vger.kernel.org>; Mon, 07 Nov 2022 02:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Z1EOSRlp4jl1RjYNN5yP+/AS3LSGqO1qinKUvHFCoI=;
        b=VRUaoGxes5tk5kziCwLMuE+b8nHbE40EdrlfwmyGFrkx2mK9FSDUvjR2SOulWJUpBP
         aw3FGGAlntyCxV9J9groL7Avsy28mH48LRnlQ+AoS7ofaOghU3WfBjwt+Ia3t2bLth8B
         JzZe4oxNZD6coiWa+m8nnX6sTqU7oRG+LYpigFWVHR9hrWNx9/F5+vTTwcIRTCeJYdWa
         il02nEcjo52XisnHJ2n2LhwBz4Z20waCC4NEpv9JMJtGgv7Dlt+N6VzzsCAwIzc/Dkya
         RM7KZ3fVqOI4lSwKOjR/lQ0MANB6mLV537BbLcYf3yahQQngadQ7V5Uw0jccopPR2mCT
         aToQ==
X-Gm-Message-State: ACrzQf3dZWqBEC6CFjXrYon3yZ/p53j98Za22Sv9b+bTYntZXqptsCqR
        MRq77eOl69LxnccMolY00KBsZNXzYqOEYwc+n6YyMWA9IyxFIxtV0ZbwpJhZgoA5zwFv0q7ETl+
        4YsvltFBkN6ium6QVLzeIkg==
X-Received: by 2002:a17:903:3011:b0:186:892d:1c4c with SMTP id o17-20020a170903301100b00186892d1c4cmr49539984pla.152.1667818696466;
        Mon, 07 Nov 2022 02:58:16 -0800 (PST)
X-Google-Smtp-Source: AMsMyM50ACHM/kWKhh/M0rblZrC1wMVJmyDC87RVuVplMs9xi/OAuunuiRT5QPaTi5sruG7XrdKi5g==
X-Received: by 2002:a17:903:3011:b0:186:892d:1c4c with SMTP id o17-20020a170903301100b00186892d1c4cmr49539969pla.152.1667818696215;
        Mon, 07 Nov 2022 02:58:16 -0800 (PST)
Received: from [10.72.12.88] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y28-20020aa79afc000000b005627ddbc7a4sm4200352pfp.191.2022.11.07.02.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 02:58:15 -0800 (PST)
Subject: Re: [PATCH] ceph: avoid putting the realm twice when docoding snaps
 fails
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, stable@vger.kernel.org
References: <20221107071759.32000-1-xiubli@redhat.com>
 <Y2jgZ52dV+TzWhlQ@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b9366f31-01b6-a5f7-ea11-5e0f88934f58@redhat.com>
Date:   Mon, 7 Nov 2022 18:58:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y2jgZ52dV+TzWhlQ@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 07/11/2022 18:39, Luís Henriques wrote:
> On Mon, Nov 07, 2022 at 03:17:59PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When decoding the snaps fails it maybe leaving the 'first_realm'
>> and 'realm' pointing to the same snaprealm memory. And then it'll
>> put it twice and could cause random use-after-free, BUG_ON, etc
>> issues.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..baf17df05107 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>   	if (realm_to_rebuild && p >= e)
>>   		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>>   
>> -	if (!first_realm)
>> +	if (!first_realm) {
>>   		first_realm = realm;
>> -	else
>> +		realm = NULL;
>> +	} else {
>>   		ceph_put_snap_realm(mdsc, realm);
>> +	}
>>   
>>   	if (p < e)
>>   		goto more;
>> -- 
>> 2.31.1
>>
> This patch looks correct to me.  But I wonder if there's a deeper problem
> there (probably not on the kernel client).  Because the other question is:
> why are we failing to decode the snaps?  But I guess this fix is worth it
> anyway.

Yeah, good question.

At the same time the MDS also crashed [1][2] just before the kernel 
crash was triggered seconds later. And the metadata in cephfs was 
corrupted due to some reasons.

[1] https://tracker.ceph.com/issues/56140

[2] https://tracker.ceph.com/issues/54546

Thanks!

- Xiubo

> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>
>
> Cheers,
> --
> Luís
>

