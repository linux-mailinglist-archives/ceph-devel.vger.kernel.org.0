Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E31C4F821C
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 16:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiDGOvN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 10:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344253AbiDGOvK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 10:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22AE9C4E14
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649342917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=baMngxJWnC9XQtxEuOuUvQXiLtJVlDMvYVucwl5zZ04=;
        b=Uvm0A1ie7If5tj/ph+KDgizlEva425nubwwvqsmE1L0a40NYXCIKKEdSBv7g68x5aRQd1K
        qnGncCh40Rk0Zp91eJWVCjCrNT/aPhzT4WAXKtNy2b8Jl0GuHpNXlxRT0zB7GFY96GXyd8
        U5OU7xyF/6btRmkEYGFZ/zUdVvJb6bw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-8FI7rd_DPtCvttHlkASykg-1; Thu, 07 Apr 2022 10:48:35 -0400
X-MC-Unique: 8FI7rd_DPtCvttHlkASykg-1
Received: by mail-pl1-f200.google.com with SMTP id e2-20020a17090301c200b001545acd89c9so2948872plh.3
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 07:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=baMngxJWnC9XQtxEuOuUvQXiLtJVlDMvYVucwl5zZ04=;
        b=gyTTX/djOVVcgyfMo7iXg5X5fCfsBwtifvT9FQ/EtQdCRAq4x54E5rnpQK+dT9E5u5
         DUslxTmWx4EEZNaRXmeaus9e0XeowsguO7YhKL6u5muJMi1ndvJRqC8DEV+CiwIUKnBP
         DM5c/L2XkR04q8VDsAyFW0EvY5csB5VXVxcUcm1FNTaEemnpx0DppHY9D6sZGMugUblx
         dpODiunSaNpNyCUcz2k1ONXMnmMeeBT6cFxBpkPOcZxjL+YDchy8+51MoYJgwtPdNDZ6
         qBQ7GCjBUXYtAsdEztmuUzEctFQICH/HLF+F6z8lQ7bUmqdnbO7qD9ntWoHrYdkKy+PX
         oZzA==
X-Gm-Message-State: AOAM5333zLsWCTVKc1XISV6zRnxZDK8Jg4Y2qevGEQNNcqdMtQv1Ht/T
        Vj9Kc/tTcrbjqEoN5nquJOay2whU2Tusvt1JMM3zBJZsPe8ZekKzGDjdy0Wi0eXdMZ/PlAGvOUs
        ykJ+CLIisx3xKvLWAYDwKcA==
X-Received: by 2002:a17:902:7b82:b0:156:ae4d:bab5 with SMTP id w2-20020a1709027b8200b00156ae4dbab5mr14590604pll.146.1649342914762;
        Thu, 07 Apr 2022 07:48:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUL09+N7B+SIj3fBUfzAe3zkTiNdq1T7YOUgvLUdoEPtXbfsvWrh5+nadNxaEYcKnrHaUO/g==
X-Received: by 2002:a17:902:7b82:b0:156:ae4d:bab5 with SMTP id w2-20020a1709027b8200b00156ae4dbab5mr14590583pll.146.1649342914489;
        Thu, 07 Apr 2022 07:48:34 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090aa78300b001ca7dfab2e4sm9161211pjq.25.2022.04.07.07.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 07:48:34 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: invalidate pages when doing direct/sync writes
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220407143834.7516-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <253c9edf-01c5-40a3-3a11-738f29df8142@redhat.com>
Date:   Thu, 7 Apr 2022 22:48:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220407143834.7516-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/7/22 10:38 PM, Luís Henriques wrote:
> When doing a direct/sync write, we need to invalidate the page cache in
> the range being written to.  If we don't do this, the cache will include
> invalid data as we just did a write that avoided the page cache.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/file.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> Ok, here's a new attempt.  After discussion in this thread and on IRC, I
> think this is the right fix.  generic/647 now passes with and without
> encryption.  Thanks!
>
> Changes since v2:
> - Invalidation needs to be done after a write
>
> Changes since v1:
> - Replaced truncate_inode_pages_range() by invalidate_inode_pages2_range
> - Call fscache_invalidate with FSCACHE_INVAL_DIO_WRITE if we're doing DIO
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5072570c2203..63e67eb60310 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1938,6 +1938,15 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   			break;
>   		}
>   		ceph_clear_error_write(ci);
> +		ret = invalidate_inode_pages2_range(
> +				inode->i_mapping,
> +				pos >> PAGE_SHIFT,
> +				(pos + len - 1) >> PAGE_SHIFT);
> +		if (ret < 0) {
> +			dout("invalidate_inode_pages2_range returned %d\n",
> +			     ret);
> +			ret = 0;
> +		}
>   		pos += len;
>   		written += len;
>   		dout("sync_write written %d\n", written);
>
LGTM.

Maybe it worth adding a comment to explain why we need this and where 
the mapping come from ?

Reviewed-by: Xiubo Li <xiubli@redhat.com>


