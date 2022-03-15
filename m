Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921C24D9E73
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 16:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349493AbiCOPRd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 11:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiCOPRc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 11:17:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96584EA0D
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 08:16:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qa43so41795379ejc.12
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uLHjIHPDsvPabzrMMzOe+60O8socyx0/gjZTs8xCOWg=;
        b=RxhzMP2iahH6adEyuExPgWfEWaeMZWqYxzED/5yKp/m3z3OQ/mJuAJa97Tn97xeRGd
         zrnkAV/DM5clH7dFKiJzkaJR+LbK4tiK5m1tuR/s1PFmcUH8kMcsbxSz4EGjxT3j8yrK
         2geNtOqcxjofgB8QY9ImxHwceHjAvopSm1i2DRR+jy1RDou465pJqn//BDf3ElC/bXbp
         nzNZvJPg3ZdadQEmV4duPQO2vOnbr1+qkqsOH7yUhykXrmZ+SdtgX1amh6fyYvm6Z2/d
         fhDx8f2cwYvGJFgsicmy5Bd0g1/Zh3rUOsMLtA7ZEznZE2EIdVuvvBw6jybP7TqtDTU2
         OUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uLHjIHPDsvPabzrMMzOe+60O8socyx0/gjZTs8xCOWg=;
        b=VIy1v1YSYRyaWe35Grxb+D6Hm1IKPyrgJgn0/lkVItHpeXvT0U6JM1AgZ2STiWIbtV
         2O2IR8stJcL8Hx/WDRq2s/zujVinl+ZTFzOn8Oe8y0Jwh/Xik6Di9iPw2W11ZlXrrVdl
         ekRhyL1lqTgmB66RyQ9tRFQO5yixoPX9ifqAf3AfPsZfNPWicgrWcdY8+Bglx2dZzgCQ
         8ANbNQgr8p8mldMVtC1X3Gfx4unG4QZu59PJLTizm2IDvp3RRaUem5mPWiLg9tZgty9q
         uZOlc3+BAv1uL9lxYwV+hArMtV0Ke/JAK4b0lApKMKOYUKuD9CkbYmYYZHez+RUnjV23
         QR+A==
X-Gm-Message-State: AOAM5336dsGINlyyLaeQqJivta+XCv5iBGp/HyZmxK0/Vl2Uo/xHmsLT
        iUVLpvEf6mTv6ChKbYB8Jj66qS3Dx0dIDA==
X-Google-Smtp-Source: ABdhPJyyT98Dp9Yha1vm+8t4lGEkt0053dr4b9NxiSYtViILNDFL2g/ItNXD3ZCq9Fs4x+2nLROPgA==
X-Received: by 2002:a17:907:8692:b0:6da:866c:6355 with SMTP id qa18-20020a170907869200b006da866c6355mr23692265ejc.174.1647357376324;
        Tue, 15 Mar 2022 08:16:16 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:f2b6:6987:9238:41ca? (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9547490edt.92.2022.03.15.08.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 08:16:15 -0700 (PDT)
Message-ID: <1be78ec5-ec3b-19c1-3934-b64126d222c9@gmail.com>
Date:   Tue, 15 Mar 2022 16:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] ceph: get snap_rwsem read lock in handle_cap_export for
 ceph_add_cap
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>
References: <20220314200717.52033-1-dossche.niels@gmail.com>
 <1ce10b6639b34759a701602d9172aec59e23c03b.camel@kernel.org>
 <1128c0fd550cef3566e1921e28837b31748eb2bd.camel@kernel.org>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <1128c0fd550cef3566e1921e28837b31748eb2bd.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/15/22 16:10, Jeff Layton wrote:
> On Tue, 2022-03-15 at 08:26 -0400, Jeff Layton wrote:
>> On Mon, 2022-03-14 at 21:07 +0100, Niels Dossche wrote:
>>> ceph_add_cap says in its function documentation that the caller should
>>> hold the read lock on the session snap_rwsem. Furthermore, not only
>>> ceph_add_cap needs that lock, when it calls to ceph_lookup_snap_realm it
>>> eventually calls ceph_get_snap_realm which states via lockdep that
>>> snap_rwsem needs to be held. handle_cap_export calls ceph_add_cap
>>> without that mdsc->snap_rwsem held. Thus, since ceph_get_snap_realm
>>> and ceph_add_cap both need the lock, the common place to acquire that
>>> lock is inside handle_cap_export.
>>>
>>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>>> ---
>>>  fs/ceph/caps.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index b472cd066d1c..0dd60db285b1 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -3903,8 +3903,10 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>>  		/* add placeholder for the export tagert */
>>>  		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
>>>  		tcap = new_cap;
>>> +		down_read(&mdsc->snap_rwsem);
>>>  		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
>>>  			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
>>> +		up_read(&mdsc->snap_rwsem);
>>>  
>>>  		if (!list_empty(&ci->i_cap_flush_list) &&
>>>  		    ci->i_auth_cap == tcap) {
>>
>> Looks good. The other ceph_add_cap callsites already hold this.
>>
>> Merged into ceph testing branch.
>>
> 
> 
> Oops, spoke too soon. This patch calls down_read (a potentially sleeping
> function) while holding the i_ceph_lock spinlock. I think you'll need to
> take the rwsem earlier in the function, before taking the spinlock.
> 
> Dropped from testing branch for now...

Ah my bad. I notice that handle_cap_export is actually called with the i_ceph_lock spinlock.
I can send a v2 which acquires the down_read lock just before the i_ceph_lock spinlock is taken (i.e. just under the retry label).
Does that work for you? If so, I'll send a v2.
Thanks!
