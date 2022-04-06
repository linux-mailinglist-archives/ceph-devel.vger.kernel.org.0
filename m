Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0B14F5773
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Apr 2022 10:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiDFHFu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Apr 2022 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiDFGZU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Apr 2022 02:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B32F64A51CF
        for <ceph-devel@vger.kernel.org>; Tue,  5 Apr 2022 22:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649222682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=huf2PKqN+sIoLvexLuqlbsgpQJkarDnuScbIKuVkilk=;
        b=Rhn4qTtML6bPwFh++s6QBJnOOGNrUKEFoq75dm++v4qxQ6hBPv4TaTU2oJCipvnHOMLc1o
        KoQCsSym9sa5YbEizWuCUR7d4ommWCeBQ2FT+fs0smeV2g+ggQSmrUi3HJGp4gOP2AJpU0
        /hXebR8tjcnCqfkQmhBeRbSwAu+QMlw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-MgZPSMmnMiKVhMLiPDucCQ-1; Wed, 06 Apr 2022 01:24:41 -0400
X-MC-Unique: MgZPSMmnMiKVhMLiPDucCQ-1
Received: by mail-pj1-f69.google.com with SMTP id d7-20020a17090ad98700b001c6834c71ffso1012350pjv.1
        for <ceph-devel@vger.kernel.org>; Tue, 05 Apr 2022 22:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=huf2PKqN+sIoLvexLuqlbsgpQJkarDnuScbIKuVkilk=;
        b=1Fb2h3qZXYDlWvHJFNWQC8yvUcuW0NX/pyyu21ydoPkpLLYIRcjYiw4r9J7KHJTVJn
         cl5qSct0fVvWKVmI+/KkUg074XCSRpNgP0lAfnj13oIvz1V1EFen1atb/Y6M28VD2z4g
         qCNosbNtRDhBIxWNpIbk5t4rmMroAdrMfqeqiJbfcNLiw+dFxD/wCvc79G/EdaTNIHoI
         XwQmZTTlGZwNsz0/xFo4kvanq399Bg7s3YqzldTzpQz2aeWXEveDzShpdgkb9fkuWpB3
         iBJk55ItuqOcMdQhlX/gNBMwn9Z79XjtWSOMDRi9y3uUDDyT6KPgtI0G79ffM4XL+xJg
         7Jqw==
X-Gm-Message-State: AOAM533ObgaWHNmN2NCr7wEFZyYPAsulliWPaAYD3DA7ed5IKKehUgI2
        IJ2xdQFOIoqh8J7OVgTZv0RlZ0co2zI/8YFkn5pL3Lt5SlWbP47ybUCIE1Bx8tcI+5lLEIctuhB
        YQg8ozkXvudRmrgjD8FpQqg==
X-Received: by 2002:a63:6a88:0:b0:398:54fb:85ba with SMTP id f130-20020a636a88000000b0039854fb85bamr5779111pgc.88.1649222680315;
        Tue, 05 Apr 2022 22:24:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5kMQCqiOjFSx0LMWpJ63fH2khDgzJ4KLeeovNhYeXBYYMYVTDzKjet77CSVAFFBQaXEsTfA==
X-Received: by 2002:a63:6a88:0:b0:398:54fb:85ba with SMTP id f130-20020a636a88000000b0039854fb85bamr5779095pgc.88.1649222680048;
        Tue, 05 Apr 2022 22:24:40 -0700 (PDT)
Received: from [10.72.13.31] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w22-20020a17090aea1600b001ca91b7542esm3873061pjy.51.2022.04.05.22.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 22:24:39 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: invalidate pages when doing DIO in encrypted
 inodes
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220401133243.1075-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5146f7a8-94c1-a7aa-db2d-d3ae98c5b83a@redhat.com>
Date:   Wed, 6 Apr 2022 13:24:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220401133243.1075-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/1/22 9:32 PM, Luís Henriques wrote:
> When doing DIO on an encrypted node, we need to invalidate the page cache in
> the range being written to, otherwise the cache will include invalid data.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/file.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> Changes since v1:
> - Replaced truncate_inode_pages_range() by invalidate_inode_pages2_range
> - Call fscache_invalidate with FSCACHE_INVAL_DIO_WRITE if we're doing DIO
>
> Note: I'm not really sure this last change is required, it doesn't really
> affect generic/647 result, but seems to be the most correct.
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5072570c2203..b2743c342305 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1605,7 +1605,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   	if (ret < 0)
>   		return ret;
>   
> -	ceph_fscache_invalidate(inode, false);
> +	ceph_fscache_invalidate(inode, (iocb->ki_flags & IOCB_DIRECT));
>   	ret = invalidate_inode_pages2_range(inode->i_mapping,
>   					    pos >> PAGE_SHIFT,
>   					    (pos + count - 1) >> PAGE_SHIFT);
> @@ -1895,6 +1895,15 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   		req->r_inode = inode;
>   		req->r_mtime = mtime;
>   
> +		if (IS_ENCRYPTED(inode) && (iocb->ki_flags & IOCB_DIRECT)) {
> +			ret = invalidate_inode_pages2_range(
> +				inode->i_mapping,
> +				write_pos >> PAGE_SHIFT,
> +				(write_pos + write_len - 1) >> PAGE_SHIFT);
> +			if (ret < 0)
> +				dout("invalidate_inode_pages2_range returned %d\n", ret);
> +		}

Shouldn't we fail it if the 'invalidate_inode_pages2_range()' fails here ?

-- Xiubo

> +
>   		/* Set up the assertion */
>   		if (rmw) {
>   			/*
>

