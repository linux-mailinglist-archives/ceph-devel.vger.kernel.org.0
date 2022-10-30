Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B9D612A9A
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Oct 2022 13:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJ3Mi6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Oct 2022 08:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJ3Mi5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 30 Oct 2022 08:38:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1964BE2B
        for <ceph-devel@vger.kernel.org>; Sun, 30 Oct 2022 05:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667133482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4B60fz/P8rMNitGf54Tbbilnbc37g2F5GF/ziw5C6k=;
        b=ZPoQY4mITEG6l+vIGnWdSKeI9qfXvb2Z6Mfi6KSEjXPX5JYk7OW3hw4er7QIfgVg0SQ6Tw
        faXYUfuboxBT/QU5gNn/UVpGnXa5XNjd5xnm/jgMMhLhxzbyPHQbffAcafk/j5domJGhQV
        GE6hMaIXByXAvdRn+CncDtEMQSJn5KA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-486-_mPD4PDWP6a5X70daMBjGA-1; Sun, 30 Oct 2022 08:37:59 -0400
X-MC-Unique: _mPD4PDWP6a5X70daMBjGA-1
Received: by mail-pf1-f199.google.com with SMTP id k131-20020a628489000000b0056b3e1a9629so4321526pfd.8
        for <ceph-devel@vger.kernel.org>; Sun, 30 Oct 2022 05:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4B60fz/P8rMNitGf54Tbbilnbc37g2F5GF/ziw5C6k=;
        b=ea3vxPPt5OLQolIYpZMMpJbu8Iur3YVNBYO7Kl9gPVK+Lji+ATJHSDg1dnB1iViA9R
         qXkjr/LASp3TBf4Iv2yWaK8p7899E7/7XctheC1VzzkvpZUIiP8DUO1skdDwrEl1adXX
         kSHsliYYRb3qpJS6rtNWWibbF8MNuGiSA8wPuzERARsL5uornRhgK4s02DJ+lzNII8rv
         Fx9ryV+X+ssd2FkzpKmSaXzUGFffEVismEP7bX6K1dtgbBv508fxWjF4s+Oycj7ENXPG
         uJ7nzHB2TYx+DCCvSQ48Oo+Fc5KCiROC+hFHt9GRFILBnI131kHiw9UK8hFkk9v7EcWp
         LCFQ==
X-Gm-Message-State: ACrzQf3x/S99ZSzZhcAnuDRMhU1IBZkOiehbgXMM8rQH6g3p/KZZfCmi
        JsMbI5aVGsK9w0nco5XjYgcI7b0ml9UT7nrF/TxtYmkgkaq1aQCeb1IlzVRXdrwHSaA+/V7NP4D
        Z82F1/uOeMlWZFc47OS1cLw==
X-Received: by 2002:a63:d015:0:b0:46f:b2a4:a34e with SMTP id z21-20020a63d015000000b0046fb2a4a34emr1589591pgf.594.1667133478373;
        Sun, 30 Oct 2022 05:37:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7wx6dkdTVFo+415zaVL0RwQ+2N45bWZGXiDPkCjdPgoRT47nm++TlMPHls4LYRxt/QVWGdvA==
X-Received: by 2002:a63:d015:0:b0:46f:b2a4:a34e with SMTP id z21-20020a63d015000000b0046fb2a4a34emr1589569pgf.594.1667133478077;
        Sun, 30 Oct 2022 05:37:58 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902ca0300b00186a8085382sm2675327pld.43.2022.10.30.05.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Oct 2022 05:37:57 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix mdsmap decode for v >= 17
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221027152811.7603-1-lhenriques@suse.de>
 <8b666226-ef41-13ae-c90c-aaa5f499b0a0@redhat.com> <Y1ubPgzSm7YATBRv@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2d9ab5c4-4921-ff19-c027-865ec0f415ca@redhat.com>
Date:   Sun, 30 Oct 2022 20:37:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y1ubPgzSm7YATBRv@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 28/10/2022 17:05, Luís Henriques wrote:
> On Fri, Oct 28, 2022 at 09:28:37AM +0800, Xiubo Li wrote:
>> On 27/10/2022 23:28, Luís Henriques wrote:
>>> Commit d93231a6bc8a ("ceph: prevent a client from exceeding the MDS
>>> maximum xattr size") was merged before the corresponding MDS-side changes
>>> have been merged.  With the introduction of 'bal_rank_mask' in the mdsmap,
>>> the decoding of maps with v>=17 is now incorrect.  Fix this by skipping
>>> the 'bal_rank_mask' string decoding.
>>>
>>> Fixes: d93231a6bc8a ("ceph: prevent a client from exceeding the MDS maximum xattr size")
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>> Hi!
>>>
>>> This inconsistency was introduced by ceph PR #43284; I think that, before
>>> picking this patch, we need to get PR #46357 merged to avoid new
>>> problems.
>>>
>>> Cheers,
>>> --
>>> Luís
>>>
>>>    fs/ceph/mdsmap.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>>> index 3fbabc98e1f7..fe4f1a6c3465 100644
>>> --- a/fs/ceph/mdsmap.c
>>> +++ b/fs/ceph/mdsmap.c
>>> @@ -379,6 +379,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>>>    		ceph_decode_skip_8(p, end, bad_ext);
>>>    		/* required_client_features */
>>>    		ceph_decode_skip_set(p, end, 64, bad_ext);
>>> +		/* bal_rank_mask */
>>> +		ceph_decode_skip_string(p, end, bad_ext);
>>>    		ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
>>>    	} else {
>>>    		/* This forces the usage of the (sync) SETXATTR Op */
>>>
>> Luis,
>>
>> Because the ceph PR #43284 will break kclient here and your xattr size patch
>> got merged long time ago, we should fix it in ceph. More detail please see
>> my comments in:
>>
>> https://github.com/ceph/ceph/pull/46357#issuecomment-1294290492
> OK, agreed.  I'll update this PR to try to fix it on the MDS side
> instead.  And let's try to have it merged as soon as possible to prevent
> further issues.

Sounds good!

- Xiubo


> Cheers,
> --
> Luís
>

