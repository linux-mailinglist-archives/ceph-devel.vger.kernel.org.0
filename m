Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0081251B485
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 02:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiEEATx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 May 2022 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiEEATv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 May 2022 20:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D19F44AE29
        for <ceph-devel@vger.kernel.org>; Wed,  4 May 2022 17:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651709774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3JKKBKELQYr2WoefvpWOm6+D8nVbZHwAJ67RQ4mbXY=;
        b=AVTioamMumRKLoTadWBJVqQ3yvqlib472akpCxicA13gNeWWpFxSlQme3zNez5panMpQTY
        eiKAv3nBoj8q6lJjHBR8r5GP5/6IlSLbwbN9Mo1HSA/MHEkbQCqTTWKMx+HAOfRtB59ZeW
        1txmhKx+trprgiNbzDyPlM5Bh/2yQpY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-eClhhvR8PbaXug8N-Sp-MA-1; Wed, 04 May 2022 20:16:13 -0400
X-MC-Unique: eClhhvR8PbaXug8N-Sp-MA-1
Received: by mail-pj1-f70.google.com with SMTP id t15-20020a17090a3b4f00b001d67e27715dso3677819pjf.0
        for <ceph-devel@vger.kernel.org>; Wed, 04 May 2022 17:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q3JKKBKELQYr2WoefvpWOm6+D8nVbZHwAJ67RQ4mbXY=;
        b=BYYoDDgv3wifkV0rH5g9nYvVKnzUVdPQRZ+RP7ArZtIkiOyRC1ipXab5Mu6VqiAh11
         Kie6AQZVfB6m93mHnFzaUO7vc5I9AD8dt5ssnXZpYo6ofQP+Ml9YiP++RlRffbpDRRCL
         uOIyoY+FeMRwMcQ4Hh5843LPTnvMuZ8hHodtH90IVs15J75/HVjsel6pzoiQy0jLyj2K
         AD2PWVxyQvJqAGX0bkJqKH0piG5ytMTV/q7ig8i6gCxcIZc16XWXAe3JmrIWKMbyXJhc
         I4gED4ptiECc0QNRQM2AHN0gATN1OpZJ91adM477O8EquPke2E9uJMjA8gIxmk8e075x
         9Xiw==
X-Gm-Message-State: AOAM532odA0FAWsLg33zNvaHsygmXg0EuFTgid12RyRxnZgSM9cVr5Hm
        ztiFXEboUTVtGUGviFB5s7nHqNzYp27x5JAVPyYXZjo1I+f724S7v0+Piw2tX6H4N5FCwSj2orR
        qEv2RF8Etbz5GTIOs1ZLOXNBepoB5kYPLkdCJemOUWenpWPNMlVyZ0/MrY6cenuXkRVKxwKE=
X-Received: by 2002:a17:90b:4a05:b0:1dc:1a2c:8c69 with SMTP id kk5-20020a17090b4a0500b001dc1a2c8c69mr2596092pjb.9.1651709771454;
        Wed, 04 May 2022 17:16:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvAynGg3OiqeOg0za9oMPTxHuxuaHUmLK0OgfPlvr4dxNvg5WLldStALu2WjlqhCNJCQCpng==
X-Received: by 2002:a17:90b:4a05:b0:1dc:1a2c:8c69 with SMTP id kk5-20020a17090b4a0500b001dc1a2c8c69mr2596064pjb.9.1651709771118;
        Wed, 04 May 2022 17:16:11 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z24-20020a63d018000000b003c14af50629sm15241883pgf.65.2022.05.04.17.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 17:16:10 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220428121318.43125-1-xiubli@redhat.com>
 <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
 <8dff2592-03cb-0ef1-e538-ae4b0484c567@redhat.com>
 <618528f07d5a6d397a76d954c43a5ff59422d83e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <34eb33b5-65c5-d4b7-0687-b8e0ac67938b@redhat.com>
Date:   Thu, 5 May 2022 08:16:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <618528f07d5a6d397a76d954c43a5ff59422d83e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/3/22 8:49 PM, Jeff Layton wrote:
> On Fri, 2022-04-29 at 14:28 +0800, Xiubo Li wrote:
>> On 4/29/22 10:46 AM, Yan, Zheng wrote:
>>> On Thu, Apr 28, 2022 at 11:42 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> For example if the Frwcb caps are being revoked, but only the Fr
>>>> caps is still being used then the kclient will skip releasing them
>>>> all. But in next turn if the Fr caps is ready to be released the
>>>> Fw caps maybe just being used again. So in corner case, such as
>>>> heavy load IOs, the revocation maybe stuck for a long time.
>>>>
>>> This does not make sense. If Frwcb are being revoked, writer can't get
>>> Fw again. Second, Frwcb are managed by single lock at mds side.
>>> Partial releasing caps does make lock state transition possible.
>>>
>> Yeah, you are right. Checked the __ceph_caps_issued() it really has
>> removed the caps being revoked already.
>>
>> Thanks Zheng.
>>
> Based on this discussion, I'm going to drop this patch from the testing
> branch.

Sure, thanks Jeff.

Planed to drop it today.

-- Xiubo

>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c | 7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 0c0c8f5ae3b3..7eb5238941fc 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>>>
>>>>           /* The ones we currently want to retain (may be adjusted below) */
>>>>           retain = file_wanted | used | CEPH_CAP_PIN;
>>>> +
>>>> +       /*
>>>> +        * Do not retain the capabilities if they are under revoking
>>>> +        * but not used, this could help speed up the revoking.
>>>> +        */
>>>> +       retain &= ~((revoking & retain) & ~used);
>>>> +
>>>>           if (!mdsc->stopping && inode->i_nlink > 0) {
>>>>                   if (file_wanted) {
>>>>                           retain |= CEPH_CAP_ANY;       /* be greedy */
>>>> --
>>>> 2.36.0.rc1
>>>>
> Thanks,

