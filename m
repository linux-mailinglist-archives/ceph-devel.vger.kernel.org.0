Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A554AB5AA
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 08:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiBGHJA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 02:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbiBGGyq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 01:54:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAD8CC043181
        for <ceph-devel@vger.kernel.org>; Sun,  6 Feb 2022 22:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644216884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dz04Z6cvCHmf0GzMe5TEpbLfdT99sbZuxyLFKkt78xs=;
        b=Z96v+0eYBGH6fFONqRb6MTHqB/JxGZmCr8uJTqyGI6g/933jaDGPAHbXhVZSFF8urwDKsi
        JEPbUMWqvjm0N8xvbZ9Cfh7bVCQh/DxHOsE6ar8n3URdb1c24VQhrKz9sQD5QZ/22Jw3cY
        LqITA6MbLJtT3vUir9gniO72UAqcGLw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-KfrrefzDOD62rbH6DKjNsA-1; Mon, 07 Feb 2022 01:54:42 -0500
X-MC-Unique: KfrrefzDOD62rbH6DKjNsA-1
Received: by mail-pj1-f71.google.com with SMTP id h16-20020a17090ac39000b001b8d02b2efaso410323pjt.5
        for <ceph-devel@vger.kernel.org>; Sun, 06 Feb 2022 22:54:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dz04Z6cvCHmf0GzMe5TEpbLfdT99sbZuxyLFKkt78xs=;
        b=g/bW5j69QOoLUCFYP/EaRrfMVw2uGJkY1Zg5AEEkX6LYlSopurfr0qmoJcDxqxHcim
         FKKHU2MXuVvxGsGFSTRoI+Nwy1swb85htGCNtI2Wq3WtzV8mposuEd8sVNB2lo2U3noh
         bErKt/wJ18ywtsHixTqEmtJGQLDN/pcCK6EJeQeAc9sbHQ3DvlB1fuXIU3eLH3lTjEaV
         1kssPHEWrzJh9fAhvj8YQAHHhLKuEZgZIkxvAr5msbZQw4LWz+/0ddu3ntNombpTwUTJ
         0KQGqOUKKhXU1rR+Nc4+lrW+XRwsV86+ZYSSEK1J1vHdBBJ7Preo1AMZGwSsHMlndeB7
         4vHg==
X-Gm-Message-State: AOAM533E7sZvR/bMSXH00uqjAnyCutWugnNYT5p7U8raKK/+2B8VAIj4
        J5j/IjW8nBkZHaSB3HySABbk+QawJC6Af2ICJeuwsTlIAtdNWdKhIXbbZh3k79rW3P+5M7bZSd3
        /VNKhD+Xa0zSonS498IUkEw==
X-Received: by 2002:a17:902:ef47:: with SMTP id e7mr11864713plx.73.1644216880801;
        Sun, 06 Feb 2022 22:54:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWTrbtsWYBO6sD0EOTfqR08wS34a3kqf0buIA8unoFX6LBWlBbJ80H8+3bvX2H1t0TDKmOWw==
X-Received: by 2002:a17:902:ef47:: with SMTP id e7mr11864701plx.73.1644216880556;
        Sun, 06 Feb 2022 22:54:40 -0800 (PST)
Received: from [10.72.12.64] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l8sm10967983pfc.187.2022.02.06.22.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 22:54:39 -0800 (PST)
Subject: Re: [PATCH] ceph: wait for async create reply before sending any cap
 messages
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
References: <20220205151705.36309-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <60e4e14e-687b-7f8a-8dc9-548bd41619a4@redhat.com>
Date:   Mon, 7 Feb 2022 14:54:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220205151705.36309-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/5/22 11:17 PM, Jeff Layton wrote:
> If we haven't received a reply to an async create request, then we don't
> want to send any cap messages to the MDS for that inode yet.
>
> Just have ceph_check_caps  and __kick_flushing_caps return without doing
> anything, and have ceph_write_inode wait for the reply if we were asked
> to wait on the inode writeback.
>
> URL: https://tracker.ceph.com/issues/54107
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index e668cdb9c99e..f29e2dbcf8df 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1916,6 +1916,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>   		ceph_get_mds_session(session);
>   
>   	spin_lock(&ci->i_ceph_lock);
> +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> +		/* Don't send messages until we get async create reply */
> +		spin_unlock(&ci->i_ceph_lock);
> +		ceph_put_mds_session(session);
> +		return;
> +	}
> +
>   	if (ci->i_ceph_flags & CEPH_I_FLUSH)
>   		flags |= CHECK_CAPS_FLUSH;
>   retry:
> @@ -2410,6 +2417,9 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
>   	dout("write_inode %p wait=%d\n", inode, wait);
>   	ceph_fscache_unpin_writeback(inode, wbc);
>   	if (wait) {
> +		err = ceph_wait_on_async_create(inode);
> +		if (err)
> +			return err;
>   		dirty = try_flush_caps(inode, &flush_tid);
>   		if (dirty)
>   			err = wait_event_interruptible(ci->i_cap_wq,
> @@ -2440,6 +2450,10 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>   	u64 first_tid = 0;
>   	u64 last_snap_flush = 0;
>   
> +	/* Don't do anything until create reply comes in */
> +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
> +		return;
> +
>   	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
>   
>   	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {

Is it also possible in case that just after the async unlinking request 
is submit and a flush cap request is fired ? Then in MDS side the inode 
could be removed from the cache and then the flush cap request comes.



