Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6D9513430
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 14:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346671AbiD1Mxc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 08:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346669AbiD1Mx3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 08:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 292024DF6D
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651150213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Auok7Yr1LQaz4SPmkZw4as7aJgMfI/uFshX+gxJhdZU=;
        b=K1d95BligIW3VnDUHBGBdrEPSnum8qgbHSa+A+wWkSZ9AXVq7PcOyNJZd0o3Tqq9yLeiSr
        miPjZiV0Hs/bWwIn6YXWadHKywIJBmvtNrJ22LaJYyZAs/VzFJW2mZu6WVcwwy9TLITyja
        jPR75SpuaFRi1EJD08PlNbUx98R38FU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-rUnzY4E6P--xaNxWrYeOZw-1; Thu, 28 Apr 2022 08:50:12 -0400
X-MC-Unique: rUnzY4E6P--xaNxWrYeOZw-1
Received: by mail-pg1-f199.google.com with SMTP id z18-20020a631912000000b003a392265b64so2391438pgl.2
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Auok7Yr1LQaz4SPmkZw4as7aJgMfI/uFshX+gxJhdZU=;
        b=0r0KuzPWYxNVgGIW7OnBDZrmDwgwpK2bYlZyeWojm986ZS45+Ecx/NMV4YONi0/+Bf
         tvAMmn6a9XoZ06mB2EcdEvuH8jmKuEdD+5jCkkViI2t7Fs3kS0XQgvcWyhW+v29EVzvT
         79vj0NXzQvUcHFlrbh1pUg6myzbXw09v03V0cirjnp8Jj3N+gEK43joowGg22avgf4jz
         kjihDYJHyVHCnLcSNkKluLCId86GUCBeT7seqcmAaS+uRHuuOOfT8DVJK6KvOZEykcwV
         MJti7QtfV4l1jHdgzRwqWsoC8Sc7ju3P/dLYEh/7l8mjS1FrUbFO72/Tm8xwvZOqbSYZ
         2PJA==
X-Gm-Message-State: AOAM531pB2NgaKyZEShEAdR6nPpfK7NATHH4jfOHWEG4zxgvvtethNYm
        OScUH635Ij8Nv0wcHTwK1GNdG+KI/o6g4mj5V3wMgSHtoZeJ0U/7kdPT/HtHdeFcIR0TahznRXm
        2VEwqgRO9fr5X9wJK6RYbeNr1mYS/WeiAhQqJKVDhU2PP/uSoNEAb195VoYZ/3+viazfsfSI=
X-Received: by 2002:a05:6a00:212c:b0:50d:a337:7437 with SMTP id n12-20020a056a00212c00b0050da3377437mr1228124pfj.70.1651150210607;
        Thu, 28 Apr 2022 05:50:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJych0V9BFmnmWIqOZ9xALPV28bZhLlKM+Xp8RRDVPn6PJvSRH0QW+HPKVdWLWHHWLOX/JQWnQ==
X-Received: by 2002:a05:6a00:212c:b0:50d:a337:7437 with SMTP id n12-20020a056a00212c00b0050da3377437mr1228097pfj.70.1651150210159;
        Thu, 28 Apr 2022 05:50:10 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d21-20020a056a0010d500b004fd9ee64134sm22788103pfu.74.2022.04.28.05.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 05:50:09 -0700 (PDT)
Subject: Re: [PATCH] ceph: try to queue a writeback if revoking fails
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220428124852.80682-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <addbb89f-4f06-40d5-3980-9addc9295d96@redhat.com>
Date:   Thu, 28 Apr 2022 20:49:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220428124852.80682-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Please ignore this, just forgot to add the v2 tag.

-- Xiubo

On 4/28/22 8:48 PM, Xiubo Li wrote:
> If the pagecaches writeback just finished and the i_wrbuffer_ref
> reaches zero it will try to trigger ceph_check_caps(). But if just
> before ceph_check_caps() the i_wrbuffer_ref could be increased
> again by mmap/cache write, then the Fwb revoke will fail.
>
> We need to try to queue a writeback in this case instead of
> triggering the writeback by BDI's delayed work per 5 seconds.
>
> URL: https://tracker.ceph.com/issues/55377
> URL: https://tracker.ceph.com/issues/46904
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 906c95d2a4ed..22dae29be64d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1912,6 +1912,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>   	struct rb_node *p;
>   	bool queue_invalidate = false;
>   	bool tried_invalidate = false;
> +	bool queue_writeback = false;
>   
>   	if (session)
>   		ceph_get_mds_session(session);
> @@ -2064,10 +2065,27 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>   		}
>   
>   		/* completed revocation? going down and there are no caps? */
> -		if (revoking && (revoking & cap_used) == 0) {
> -			dout("completed revocation of %s\n",
> -			     ceph_cap_string(cap->implemented & ~cap->issued));
> -			goto ack;
> +		if (revoking) {
> +			if ((revoking & cap_used) == 0) {
> +				dout("completed revocation of %s\n",
> +				      ceph_cap_string(cap->implemented & ~cap->issued));
> +				goto ack;
> +			}
> +
> +			/*
> +			 * If the "i_wrbuffer_ref" was increased by mmap or generic
> +			 * cache write just before the ceph_check_caps() is called,
> +			 * the Fb capability revoking will fail this time. Then we
> +			 * must wait for the BDI's delayed work to flush the dirty
> +			 * pages and to release the "i_wrbuffer_ref", which will cost
> +			 * at most 5 seconds. That means the MDS needs to wait at
> +			 * most 5 seconds to finished the Fb capability's revocation.
> +			 *
> +			 * Let's queue a writeback for it.
> +			 */
> +			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
> +			    (revoking & CEPH_CAP_FILE_BUFFER))
> +				queue_writeback = true;
>   		}
>   
>   		/* want more caps from mds? */
> @@ -2137,6 +2155,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>   	spin_unlock(&ci->i_ceph_lock);
>   
>   	ceph_put_mds_session(session);
> +	if (queue_writeback)
> +		ceph_queue_writeback(inode);
>   	if (queue_invalidate)
>   		ceph_queue_invalidate(inode);
>   }

