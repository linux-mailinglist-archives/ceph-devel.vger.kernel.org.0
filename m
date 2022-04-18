Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFCD504A88
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 03:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiDRBjj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 17 Apr 2022 21:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiDRBjh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 17 Apr 2022 21:39:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A0D9B87C
        for <ceph-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650245819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHXJOKSGSrzLMTK2bxdeDicxXaMoFVlLaGwy4EoLQCs=;
        b=fjDcYrQ0vcUw6pSWhkWsOSNsURDHq5FmD2VxPuqiGxSQqUic3SRHGccOz6nigLzn+Bzkph
        ObrcrS3Wj1ZzB9uITHx4Pg2wDXdqVlRhytvWuWrFuVAQZNJV/TMQdnLPJ3EowD/UjcJ2dH
        1Wc+YCTSULvTXe0zMlfM34GsH1FumHw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-HV6dNTRkN0yN6WBbioK3RQ-1; Sun, 17 Apr 2022 21:36:58 -0400
X-MC-Unique: HV6dNTRkN0yN6WBbioK3RQ-1
Received: by mail-pj1-f71.google.com with SMTP id r12-20020a17090a690c00b001cb9bce2284so7539724pjj.8
        for <ceph-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:36:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jHXJOKSGSrzLMTK2bxdeDicxXaMoFVlLaGwy4EoLQCs=;
        b=ysrGbGXAMxca1htEULUzcIfgGXi/0m0nB5GdKkf6LmBJGMuK1JsLXJIf2uaAEC4ihy
         VRCoEKUXNEsgaZqRJZomPiwnhA2XpehOqIe5ONyyvuCqeyLUPxRrDhW2JvxMI9R8fjJm
         M4e64gpg6zNNZnZ/Mxj2qQ8SBmNXUIDwxxsov1j/GveA3S/7/Ene6LLlYTrM+81C+eLl
         aX8TgF/KyWJQS+Rg6UXyv4jhDxgGPlfi5Wt+ahFZNqq3jVwoyGI3pP1Kn2mOzcVXB4Uf
         lCYlbrU66W6u9kRia/2+/L/eQDQXapHscsVF8JxvSlMaczItVY6YAlMwxsGw9T+J49cc
         QRbg==
X-Gm-Message-State: AOAM533pZGIPFhvXefhmZrab+wn0ullS5+m2TAXgIg1Qwuhjg6+916Lf
        f1Rdfhnn13VJn9H8Ptcg1by46vpSch19/d57yz8PzpPu7W7zbM502HigeRl62mvcOUysSvKENM3
        XS0CIWGkME9PnW5aL88MHF2n4yTh+gOB1CdV4qbwXas2Zkxyf4RevlvE8lawLZyeH+YcM1+0=
X-Received: by 2002:a17:902:7c94:b0:14d:77d2:a72e with SMTP id y20-20020a1709027c9400b0014d77d2a72emr8959990pll.153.1650245816270;
        Sun, 17 Apr 2022 18:36:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfdRhNzYy2cNBpunJ/zi6DhBCmw3PVFc5MjSPLQnDId93yVq70LfsXeec4DpLq44I8gGYtJQ==
X-Received: by 2002:a17:902:7c94:b0:14d:77d2:a72e with SMTP id y20-20020a1709027c9400b0014d77d2a72emr8959971pll.153.1650245815893;
        Sun, 17 Apr 2022 18:36:55 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d139-20020a621d91000000b00505aa0d10desm10137068pfd.0.2022.04.17.18.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 18:36:54 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix possible NULL pointer dereference for
 req->r_session
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220414054324.374694-1-xiubli@redhat.com>
 <1767a8c4889fb5f7d27c99928b47d7af73a9a64e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3755b6fc-7081-24cd-e340-bb4de9c2cc67@redhat.com>
Date:   Mon, 18 Apr 2022 09:36:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1767a8c4889fb5f7d27c99928b47d7af73a9a64e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/15/22 8:05 PM, Jeff Layton wrote:
> On Thu, 2022-04-14 at 13:43 +0800, Xiubo Li wrote:
>> The request will be inserted into the ci->i_unsafe_dirops before
>> assigning the req->r_session, so it's possible that we will hit
>> NULL pointer dereference bug here.
>>
>> URL: https://tracker.ceph.com/issues/55327
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 69af17df59be..6a9bf58478c8 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2333,7 +2333,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   			list_for_each_entry(req, &ci->i_unsafe_dirops,
>>   					    r_unsafe_dir_item) {
>>   				s = req->r_session;
>> -				if (unlikely(s->s_mds >= max_sessions)) {
>> +				if (unlikely(s && s->s_mds >= max_sessions)) {
>>   					spin_unlock(&ci->i_unsafe_lock);
>>   					for (i = 0; i < max_sessions; i++) {
>>   						s = sessions[i];
>> @@ -2343,7 +2343,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   					kfree(sessions);
>>   					goto retry;
>>   				}
>> -				if (!sessions[s->s_mds]) {
>> +				if (s && !sessions[s->s_mds]) {
>>   					s = ceph_get_mds_session(s);
>>   					sessions[s->s_mds] = s;
>>   				}
>> @@ -2353,7 +2353,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   			list_for_each_entry(req, &ci->i_unsafe_iops,
>>   					    r_unsafe_target_item) {
>>   				s = req->r_session;
>> -				if (unlikely(s->s_mds >= max_sessions)) {
>> +				if (unlikely(s && s->s_mds >= max_sessions)) {
>>   					spin_unlock(&ci->i_unsafe_lock);
>>   					for (i = 0; i < max_sessions; i++) {
>>   						s = sessions[i];
>> @@ -2363,7 +2363,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   					kfree(sessions);
>>   					goto retry;
>>   				}
>> -				if (!sessions[s->s_mds]) {
>> +				if (s && !sessions[s->s_mds]) {
>>   					s = ceph_get_mds_session(s);
>>   					sessions[s->s_mds] = s;
>>   				}
> Good catch. I think it'd be cleaner to just do this in each loop though,
> to keep the if conditions simpler:
>
>      s = req->r_session;
>      if (!s)
> 	    continue;

Sure, will send the second version.

-- Xiubo

> The bug and fix look real though.

