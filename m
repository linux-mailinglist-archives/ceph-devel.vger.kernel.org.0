Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8790856D400
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Jul 2022 06:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGKEhk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Jul 2022 00:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGKEhi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Jul 2022 00:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23656140AA
        for <ceph-devel@vger.kernel.org>; Sun, 10 Jul 2022 21:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657514257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hh7tNUrh8lEUMhHIyrn/K29ka0ezYl99mr//JxODbrs=;
        b=GmjrFU4YGkJnbMfxVz3ZpaP0YEBu3Tc0fN5DbXTZHAldjYwkQKjBvAp4AqV2RLGCNE5tvC
        PwXnfnjCImvmNuP7pIieh2QtBg6eGr8l4E8yUwIVTitkGe7iAIfVHaLElET64nvcFhUbf6
        VXjk1dfChP0oYeZ5XkrJzI/wads1210=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-TL44a84-OtC6Ux6v9INlkg-1; Mon, 11 Jul 2022 00:37:32 -0400
X-MC-Unique: TL44a84-OtC6Ux6v9INlkg-1
Received: by mail-pl1-f199.google.com with SMTP id z9-20020a170903018900b0016c39b2c1ffso2568713plg.12
        for <ceph-devel@vger.kernel.org>; Sun, 10 Jul 2022 21:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hh7tNUrh8lEUMhHIyrn/K29ka0ezYl99mr//JxODbrs=;
        b=p/t0riR3wlfQ9Hj+3GZPpuWomkmMU1nP7A0R5O8MZqELaApPZ+JZPwWgnTEu8NT1oA
         4no2ue7qXrxJudxA82d9xfl2Dj69muw3mDcV++1HNdk9zcDVvRiYh+iGEAYG0r6adttq
         Y6yaK/1Jtj+Evf0/X7MikiSyeoDx0cdEvJqv072TYaR2ZRZaF7ywAl3qVdvXEZqQd7Dt
         uzMLT3TtW3n7vR8cTu7gdA/b3lrfoomAI+9lqO76GAG3K0g8U2H1X+caicZwAoxbCUBu
         uP9tKLwdzWbS24vZT7r0IKNIffS7q6qHpQEM1sWIIHtF1aerthLvoPApwRDTJ/rLXUp2
         763Q==
X-Gm-Message-State: AJIora9X/GpHxUSF7AC2A/jOc+I9/EkdII/+Ob88yUQ/KUXL58kHYeg1
        i1cvq27gWG3NFErSuN0mjYJ/tabOs3rcEvPehy21De/145aUVRYfa/UVcY274z2eVRv4SgYpsRt
        rNfE6La0c2d2EjtKah50asg==
X-Received: by 2002:a17:90b:19d2:b0:1f0:46ef:fc1b with SMTP id nm18-20020a17090b19d200b001f046effc1bmr821912pjb.182.1657514251123;
        Sun, 10 Jul 2022 21:37:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sBcg3kcIsXFdek33HyrWidMVuIyn5XeiTNPuRIxrnziOuJJ7zGZNe2E7Mqc8u1uiR4BOdI/w==
X-Received: by 2002:a17:90b:19d2:b0:1f0:46ef:fc1b with SMTP id nm18-20020a17090b19d200b001f046effc1bmr821898pjb.182.1657514250884;
        Sun, 10 Jul 2022 21:37:30 -0700 (PDT)
Received: from [10.72.14.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b0015e8d4eb26esm3535351pli.184.2022.07.10.21.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 21:37:30 -0700 (PDT)
Subject: Re: [PATCH wip-fscrypt] ceph: reset "err = 0" after
 iov_get_pages_alloc in ceph_netfs_issue_read
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com
References: <20220707140811.35155-1-jlayton@kernel.org>
 <d5e9d800-750f-2422-8ff6-fe4eb2cd10bc@redhat.com>
 <ea91438a349390dd0daf8130f8fae18564f99f2f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e018dbed-5c30-254b-3fcd-dbbee866bfce@redhat.com>
Date:   Mon, 11 Jul 2022 12:37:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ea91438a349390dd0daf8130f8fae18564f99f2f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/8/22 6:57 PM, Jeff Layton wrote:
> On Fri, 2022-07-08 at 08:27 +0800, Xiubo Li wrote:
>> On 7/7/22 10:08 PM, Jeff Layton wrote:
>>> Currently, when we call ceph_netfs_issue_read for an encrypted inode,
>>> we'll call iov_iter_get_pages_alloc and assign its result to "err".
>>> Later we'll end up inappropriately calling netfs_subreq_terminated with
>>> that value after submitting the request. Ensure we reset "err = 0;"
>>> after calling iov_iter_get_pages_alloc.
>>>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/addr.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> Probably this should get squashed into the patch that adds fscrypt
>>> support to buffered reads.
>>>
>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> index c713b5491012..64facef79883 100644
>>> --- a/fs/ceph/addr.c
>>> +++ b/fs/ceph/addr.c
>>> @@ -376,6 +376,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>>    		/* should always give us a page-aligned read */
>>>    		WARN_ON_ONCE(page_off);
>>>    		len = err;
>>> +		err = 0;
>>>    
>>>    		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
>>>    	} else {
>> Looks good. Thanks Jeff!
>>
>> Show we fold it into the previous patch ?
>>
>> -- Xiubo
>>
>>
> Yes, please do.

Folded it into:

commit 7487b08568482dd113429134a2219e203214ae0d
Author: Jeff Layton <jlayton@kernel.org>
Date:   Sun Mar 20 09:35:58 2022 -0400

     ceph: add fscrypt decryption support to ceph_netfs_issue_op

     Force the use of sparse reads when the inode is encrypted, and add the
     appropriate code to decrypt the extent map after receiving.


Thanks!



