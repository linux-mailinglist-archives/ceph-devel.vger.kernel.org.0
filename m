Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC253E9BD
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiFFLtL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 07:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiFFLtK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 07:49:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D8D423281D
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 04:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654516148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8VqBPtYvjJUYWnb/CD2hKWgins7xlpes9uYmFwRv9Y=;
        b=gkYWW7wTfyQrz5WJYz655LJdLGbsiNR4qkumvQQuaQCVLIQOQ2PZU3+Vse4n13dcxATYZn
        9pT9b6porW9aea9K4tNHDUie5L4Hadd7x4BnFPl/rcw4hqcuCzUJACFjO+YJeaCHs/Y2w6
        JiB1xA+H9ErxbaBHEX3TlYgk0v8OvQ8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-p2fU53oLOMKpGPbT1nzMng-1; Mon, 06 Jun 2022 07:49:07 -0400
X-MC-Unique: p2fU53oLOMKpGPbT1nzMng-1
Received: by mail-pg1-f197.google.com with SMTP id 72-20020a63014b000000b003fce454aaf2so5171097pgb.6
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 04:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=X8VqBPtYvjJUYWnb/CD2hKWgins7xlpes9uYmFwRv9Y=;
        b=EAqCoh71n42f5dQIwYypYcxoHd6lbp+/M6oi6ZuZe9vkfWtKKgAJb2Yk3X5EtmDhV9
         Fbj1CWdk6jNTE1rC4N6w5ukNqqWLUPhVFNd9I/cf8MRLLaGAU6u8/r//iJ5zhKC8m+Ug
         k8qEz6wtLff4RP7mfza+aGI0s/ptlSJeaLBnq2zONLv4/gp3dySUhLteeunTDn6oddTG
         aUij8lEPAABkbpR+wGqnKZb9u7qVVkj5g1Le6zMieyQKS1j5HKWafhIRGoSpzM/BKt+m
         dwcQsOpzHmgNwnxkDu81nlDLvTngqZqs/wvl63E1ygahHY31pIe7p1kqkh4hh5nR+N4q
         gb3Q==
X-Gm-Message-State: AOAM532JrlFBvGaE7Q9/NtOaUsnYY/dfyMJYZ0M3CzXtoF+SPpplfA0S
        FMBh0qUmlMwmuq8qVChr7NW1e717kHWEHS1StCQ/kX5JX8bXZpZJkBjPZxnt5RJfVmhnEaR3bew
        fWlogFce2KqDQonK+7tR7gg==
X-Received: by 2002:a63:83c8:0:b0:3fd:eead:c510 with SMTP id h191-20020a6383c8000000b003fdeeadc510mr319819pge.190.1654516146271;
        Mon, 06 Jun 2022 04:49:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPnTo1ZUuoV/+0AcuEn0EWGrKatmUA+sSfFSf8zCmyxzHlKqNPTCtGx1WXU+Q2DvOcilf7lw==
X-Received: by 2002:a63:83c8:0:b0:3fd:eead:c510 with SMTP id h191-20020a6383c8000000b003fdeeadc510mr319801pge.190.1654516145994;
        Mon, 06 Jun 2022 04:49:05 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p2-20020a056a0026c200b0050dc76281e5sm6800125pfw.191.2022.06.06.04.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:49:05 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix incorrectly assigning random values to peer's
 members
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        ukernel <ukernel@gmail.com>
References: <20220606072835.302935-1-xiubli@redhat.com>
 <a60d5c710b68a7fff35113df0fac754d199db075.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dd856694-cb42-a7d3-9b0f-bdac48a91047@redhat.com>
Date:   Mon, 6 Jun 2022 19:48:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a60d5c710b68a7fff35113df0fac754d199db075.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/22 6:23 PM, Jeff Layton wrote:
> On Mon, 2022-06-06 at 15:28 +0800, Xiubo Li wrote:
>> For export the peer is empty in ceph.
>>
>> URL: https://tracker.ceph.com/issues/55857
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 15 +++++----------
>>   1 file changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0a48bf829671..8efa46ff4282 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4127,16 +4127,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   		p += flock_len;
>>   	}
>>   
>> -	if (msg_version >= 3) {
>> -		if (op == CEPH_CAP_OP_IMPORT) {
>> -			if (p + sizeof(*peer) > end)
>> -				goto bad;
>> -			peer = p;
>> -			p += sizeof(*peer);
>> -		} else if (op == CEPH_CAP_OP_EXPORT) {
>> -			/* recorded in unused fields */
>> -			peer = (void *)&h->size;
>> -		}
>> +	if (msg_version >= 3 && op == CEPH_CAP_OP_IMPORT) {
>> +		if (p + sizeof(*peer) > end)
>> +			goto bad;
>> +		peer = p;
>> +		p += sizeof(*peer);
>>   	}
>>   
>>   	if (msg_version >= 4) {
> This was added in commit 11df2dfb61 (ceph: add imported caps when
> handling cap export message). If peer should always be NULL on an
> export, I wonder what he was thinking by adding this in the first place?
> Zheng, could you take a look here?
>
> If this does turn out to be correct, then I think there is some further
> cleanup you can do here, as you should be able to drop the peer argument
> from handle_cap_export. That should also collapse some of the code down
> in that function as well since lot of the target fields end up being 0s.

Okay, will drop this. The head structs are different in ceph and kernel.

-- Xiubo


