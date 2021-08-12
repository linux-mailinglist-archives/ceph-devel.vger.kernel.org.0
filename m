Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0607E3E9CB7
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Aug 2021 04:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhHLCwF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 22:52:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbhHLCwF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 22:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628736700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jIGQn8YtQQwlLVZWHAlJQlP4CRJ0N2utgutAm64Fks=;
        b=HQmku06T4r5o7PGs5fHvZi+923IW90WEAJ2jAk/vme+HgCFnIvTy2DXS0MPmdGlTt+18/n
        JrJGBkU7iAH56xJaNGCdX3+vgoWM2exmistSzK3KFZUWNIEFEmfGScl8V15B+H+xkMAGvo
        SWMiBFytJIDQGBtYS/RNUY7GKLFfVWQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-i8lwvZ7cOLCoB69DCqG_fw-1; Wed, 11 Aug 2021 22:51:39 -0400
X-MC-Unique: i8lwvZ7cOLCoB69DCqG_fw-1
Received: by mail-pj1-f70.google.com with SMTP id h21-20020a17090adb95b029017797967ffbso3925725pjv.5
        for <ceph-devel@vger.kernel.org>; Wed, 11 Aug 2021 19:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7jIGQn8YtQQwlLVZWHAlJQlP4CRJ0N2utgutAm64Fks=;
        b=kXdSxDe2qu3lsPD70h3POchmefdSmgkVt7cXgTQAoP+Hsqyoz18RUxRw5GiiaeNyCZ
         yNKmNm71dwRS9G4XwHbRbXt1ee9GoDLdnglwfAF9lekMAlq+3emy8IcQ+ICfsGtAwHff
         FoNqYyH7mogk5zyAHr3UuPTs0DpD/DS5ZbLHvWxJwW57nBqkqI89fy/ESKAXMhKD2svT
         Pehehy93GkA++Z4RKmKdgT5jpr2ubO/tCGuTC5zKAB8pX2Ptl5wzGQOAJYrEsPSD8IiQ
         xlvz9Cy4HcVxuY79wjg1HgN51aCa5M9OoFiy6e+zEmJNANZ9/Pa1yHb4y9hAs5DgPTsq
         Az3Q==
X-Gm-Message-State: AOAM532svOsnRyjvrL4d6HqbXCnuQHrDjkUC1QqDn6oDphqBXNUE64s2
        FnDOznbTtpiKOJKBTiDFbnFCV2mbzZrP0SOHDxUasCGUvJYVCx9NvaQNrxgg8n/PrQ7feNApMBX
        P8Vk6/2CqEL2AnAwnL5L+5A==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr14258934pjq.88.1628736697955;
        Wed, 11 Aug 2021 19:51:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznTBknUwU//dk5plj8RAGahBAxciJii8WJp6ZS19Pme+9ec/lEbVNyr6G37tojTw3RASD5ng==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr14258913pjq.88.1628736697656;
        Wed, 11 Aug 2021 19:51:37 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v5sm8390371pjs.45.2021.08.11.19.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 19:51:37 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: request Fw caps before updating the mtime in
 ceph_write_iter
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de,
        =?UTF-8?B?Sm96ZWYgS292w6HEjQ==?= <kovac@firma.zoznam.sk>
References: <20210811173738.29574-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4f3aea6d-b6ea-fdbd-3196-41a6ad00422d@redhat.com>
Date:   Thu, 12 Aug 2021 10:51:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210811173738.29574-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/12/21 1:37 AM, Jeff Layton wrote:
> The current code will update the mtime and then try to get caps to
> handle the write. If we end up having to request caps from the MDS, then
> the mtime in the cap grant will clobber the updated mtime and it'll be
> lost.
>
> This is most noticable when two clients are alternately writing to the
> same file. Fw caps are continually being granted and revoked, and the
> mtime ends up stuck because the updated mtimes are always being
> overwritten with the old one.
>
> Fix this by changing the order of operations in ceph_write_iter. Get the
> caps much earlier, and only update the times afterward. Also, make sure
> we check the NEARFULL conditions before making any changes to the inode.
>
> URL: https://tracker.ceph.com/issues/46574
> Reported-by: Jozef Kováč <kovac@firma.zoznam.sk>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 35 ++++++++++++++++++-----------------
>   1 file changed, 18 insertions(+), 17 deletions(-)
>
> v2: fix error handling -- make sure we release i_rwsem on error exit
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d1755ac1d964..da856bd5eaa5 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1722,22 +1722,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		goto out;
>   	}
>   
> -	err = file_remove_privs(file);
> -	if (err)
> -		goto out;
> -
> -	err = file_update_time(file);
> -	if (err)
> -		goto out;
> -
> -	inode_inc_iversion_raw(inode);
> -
> -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> -		err = ceph_uninline_data(file, NULL);
> -		if (err < 0)
> -			goto out;
> -	}
> -
>   	down_read(&osdc->lock);
>   	map_flags = osdc->osdmap->flags;
>   	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
> @@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		goto out;
>   	}
>   
> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> +		err = ceph_uninline_data(file, NULL);
> +		if (err < 0)
> +			goto out;
> +	}
> +
>   	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
>   	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
>   	if (fi->fmode & CEPH_FILE_MODE_LAZY)
> @@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	if (err < 0)
>   		goto out;
>   
> +	err = file_remove_privs(file);
> +	if (err)
> +		goto out_caps;
> +
> +	err = file_update_time(file);
> +	if (err)
> +		goto out_caps;
> +
> +	inode_inc_iversion_raw(inode);
> +
>   	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
>   	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
>   
> @@ -1822,7 +1822,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
>   			ceph_check_caps(ci, 0, NULL);
>   	}
> -
>   	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
>   	     inode, ceph_vinop(inode), pos, (unsigned)count,
>   	     ceph_cap_string(got));
> @@ -1842,6 +1841,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	}
>   
>   	goto out_unlocked;
> +out_caps:
> +	ceph_put_cap_refs(ci, got);
>   out:
>   	if (direct_lock)
>   		ceph_end_io_direct(inode);

The fuse client is already correctly doing this.

LGTM

Reviewed-by: Xiubo Li <xiubli@redhat.com>




