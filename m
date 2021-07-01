Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F083B8BD4
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 03:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhGABxC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 21:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238443AbhGABxC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625104231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnhx+e9pBdxvihlZYnH9/JGV5kPnOGjPpRkqJmd4ZAE=;
        b=PabIP9gYlClG16b/XdXxNUrowbqVDjczAEkS3Pb7paqf9GkF4q2Kt6nrCN81E6cXmWZUSh
        wyrdjTECmKO/huoG+bWiDSChXnBVw74jz6trwvCpes6J0rg5XesfAdrFNneFqS+6cSHAi1
        7Gu3lLDgHbXCH9jQKC49m+SOrusxW+A=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-azRrXgtFM5-L7zSp7AbbGA-1; Wed, 30 Jun 2021 21:50:30 -0400
X-MC-Unique: azRrXgtFM5-L7zSp7AbbGA-1
Received: by mail-pf1-f200.google.com with SMTP id s15-20020a056a0008cfb0290306b50a28ecso2954175pfu.10
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 18:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tnhx+e9pBdxvihlZYnH9/JGV5kPnOGjPpRkqJmd4ZAE=;
        b=DP5MgLhSgsX0UPr3YI24EZw42WwtSP/vDzh87Tuh9FWJZMCz3iyDHwoDaEUlIZoTot
         hOJsOB7eCTxuzaCu8sxslhX60RdBB6hR3XBhlD9IsIs+9SCtLRgbDiWzwiNszjkZjj9O
         W2xotXaIciVwSFOSJJ8X3WdwlXDh8WfzAwyGgI5m/22qXAvFRlFsTn/oyaxmmUv7D2pZ
         XjUCeJEzgKlwQuqzLtaE+haJOM6yfsz9Q0nfGTqXqgpHWMoViuyS3wOVNo6V00kHbfmm
         aV58tlYrzuZUuNVxdf/cNN9H2JasLAccQDlotD9FsMhJqRKsrlzJgIkjlhyVY+qAG3/v
         ZiWg==
X-Gm-Message-State: AOAM531ugItfu3Qz1XQpWTQYULoI/B0zELIdFW8Rykt5ZhpqoZSau6EW
        j55qPoskRTS1KhJ6Iu5ufTyLWcJQ1Kp5sG9lfcnojMm1Pt3Mrg5wCFD12xce+Bb4+njjCEgwhva
        AwQkyD1GU07X+16h7mgZLr/rtT3yJ7e6bnFXj3YQBf5KvNHzGvPzBl/hoBkd4Q7fhb49HCnU=
X-Received: by 2002:a17:902:b7c5:b029:128:e537:52f7 with SMTP id v5-20020a170902b7c5b0290128e53752f7mr15423953plz.59.1625104229537;
        Wed, 30 Jun 2021 18:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMIWOIbwj4Jx01f5SgYcRJ77vlElz+6JZKljPTLw8a5Ne0cmiW47TVpWBDY1wO0SmRgGjf7Q==
X-Received: by 2002:a17:902:b7c5:b029:128:e537:52f7 with SMTP id v5-20020a170902b7c5b0290128e53752f7mr15423934plz.59.1625104229174;
        Wed, 30 Jun 2021 18:50:29 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm22356687pfp.137.2021.06.30.18.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 18:50:28 -0700 (PDT)
Subject: Re: [PATCH 1/5] ceph: export ceph_create_session_msg
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-2-xiubli@redhat.com>
 <88c1bdbf8235b35671a84f0b0d5feca855017940.camel@kernel.org>
 <8cc0a19a-2c67-f807-5085-46455727e8ab@redhat.com>
 <CAOi1vP-+K1OVA5_Fq6pdC1z0Pp4jLfGB_P+AOzJO9i7oL2uvcg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e558085c-d0a8-3ea5-2e66-1a7fe02a2446@redhat.com>
Date:   Thu, 1 Jul 2021 09:50:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-+K1OVA5_Fq6pdC1z0Pp4jLfGB_P+AOzJO9i7oL2uvcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/21 8:17 PM, Ilya Dryomov wrote:
> On Tue, Jun 29, 2021 at 3:27 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/29/21 9:12 PM, Jeff Layton wrote:
>>> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>> nit: the subject of this patch is not quite right. You aren't exporting
>>> it here, just making it a global symbol (within ceph.ko).
>>>
>> Yeah, will fix it.
>>
>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 15 ++++++++-------
>>>>    fs/ceph/mds_client.h |  1 +
>>>>    2 files changed, 9 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 2d7dcd295bb9..e49d3e230712 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -1150,7 +1150,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>>>>    /*
>>>>     * session messages
>>>>     */
>>>> -static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>>>> +struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
>>>>    {
>>>>       struct ceph_msg *msg;
>>>>       struct ceph_mds_session_head *h;
>>>> @@ -1158,7 +1158,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>>>>       msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
>>>>                          false);
>>>>       if (!msg) {
>>>> -            pr_err("create_session_msg ENOMEM creating msg\n");
>>>> +            pr_err("ceph_create_session_msg ENOMEM creating msg\n");
>>> instead of hardcoding the function names in these error messages, use
>>> __func__ instead? That makes it easier to keep up with code changes.
>>>
>>>        pr_err("%s ENOMEM creating msg\n", __func__);
>> Sure, will fix this too.
> I think this can be just "ENOMEM creating session msg" without the
> function name to avoid repetition.

Will fix it by using:

pr_err("ENOMEM creating session %s msg", ceph_session_op_name(op));

Thanks.

>
> Thanks,
>
>                  Ilya
>

