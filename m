Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F33F432D4E
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 07:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhJSFjC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 01:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhJSFjB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 01:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634621808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1UhRR9o7nZXmjjRDsqDRTXcfGFKtBUQ/aEdls9m5oIQ=;
        b=BtsyXzaFh65k9/lszCnbGstetaPdtUKkwUg28aLMDjth8TKx19SZAN/7zw2GiLG+o1RC3a
        YHHWKAsYSyMjw5/6lV1KacNHIW4wys12mifpcxnhMlOqLGOh17eNCk+pgU0yMkHW8bbmCp
        0LrBh4BafB6/5U8+iymBL9lPFjlbpI0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-qNIq7YDdOh2jhgFQNuSEEQ-1; Tue, 19 Oct 2021 01:36:47 -0400
X-MC-Unique: qNIq7YDdOh2jhgFQNuSEEQ-1
Received: by mail-pj1-f70.google.com with SMTP id oo5-20020a17090b1c8500b0019e585e8f6fso901939pjb.9
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 22:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1UhRR9o7nZXmjjRDsqDRTXcfGFKtBUQ/aEdls9m5oIQ=;
        b=KXmLROVecJjDNG02LIJHvkI2NNYxRSKspzGvnYzwOaGqLpNg2imurAiz7AUsEGW2hM
         IIw/zblglv2gLXkVMkPsK9u/tMahdJtm9C7IaDQfry+CHIZAW2p4OgdptYjflw+2Ngla
         PvaFUs7fEIHoMHTD1OGHB5DxXWvFjHgHAOGfGJ38Rx+vyQzsI+1DKMunhcjCxFbK9RCg
         ZBRm9ndhdlQQHuLuJhznqELsYgzI/UxMmFns91e7h7g3uEBCWqduNT+BjpVUbdwfEuV3
         wbkeSHJkl8QdjefR9ytkFeazLaaWCeUV0F9S8TDdu76ybqbpdP3CoMspLsSvWmUItGWv
         w54Q==
X-Gm-Message-State: AOAM5339hRZJj6WiL75AJ0gFygrG8LsWys9+ZezKe8ZM2hbgt2WGASsj
        sa5O/LujytBjbBZqnozCI20gmv4Mosy91k7zx0Sl7wWgDrR3KSLrd0RvpmerQ+supg1F+d89Z5K
        iruIYUPf7jrfRKDWcf7BTHQ==
X-Received: by 2002:aa7:90d2:0:b0:44c:e078:d6fb with SMTP id k18-20020aa790d2000000b0044ce078d6fbmr32776552pfk.7.1634621806122;
        Mon, 18 Oct 2021 22:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8KY0xFoNbD+ySvwra0nJ8fSqUVdI0vwYPDnrbNRM9AJccNjaIRIA8Y4dfjqHUN1SkvnqdYw==
X-Received: by 2002:aa7:90d2:0:b0:44c:e078:d6fb with SMTP id k18-20020aa790d2000000b0044ce078d6fbmr32776531pfk.7.1634621805736;
        Mon, 18 Oct 2021 22:36:45 -0700 (PDT)
Received: from [10.72.12.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w185sm14584519pfb.38.2021.10.18.22.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 22:36:45 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix handling of "meta" errors on ceph
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>
References: <20211007185907.122326-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <138a6f46-0942-4acf-1a6b-872420b801bd@redhat.com>
Date:   Tue, 19 Oct 2021 13:36:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211007185907.122326-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/8/21 2:59 AM, Jeff Layton wrote:
> Currently, we check the wb_err too early for directories, before all of
> the unsafe child requests have been waited on. In order to fix that we
> need to check the mapping->wb_err later nearer to the end of ceph_fsync.
>
> We also have an overly-complex method for tracking errors after
> blocklisting. The errors recorded in cleanup_session_requests go to a
> completely separate field in the inode, but we end up reporting them the
> same way we would for any other error (in fsync).
>
> There's no real benefit to tracking these errors in two different
> places, since the only reporting mechanism for them is in fsync, and
> we'd need to advance them both every time.
>
> Given that, we can just remove i_meta_err, and convert the places that
> used it to instead just use mapping->wb_err instead. That also fixes
> the original problem by ensuring that we do a check_and_advance of the
> wb_err at the end of the fsync op.
>
> URL: https://tracker.ceph.com/issues/52864
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c       | 14 ++++----------
>   fs/ceph/file.c       |  1 -
>   fs/ceph/inode.c      |  2 --
>   fs/ceph/mds_client.c | 15 ++++-----------
>   fs/ceph/super.h      |  3 ---
>   5 files changed, 8 insertions(+), 27 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index cdeb5b2d7920..21268d2c6e56 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2331,7 +2331,6 @@ static int unsafe_request_wait(struct inode *inode)
>   
>   int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>   {
> -	struct ceph_file_info *fi = file->private_data;
>   	struct inode *inode = file->f_mapping->host;
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	u64 flush_tid;
> @@ -2366,14 +2365,9 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>   	if (err < 0)
>   		ret = err;
>   
> -	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
> -		spin_lock(&file->f_lock);
> -		err = errseq_check_and_advance(&ci->i_meta_err,
> -					       &fi->meta_err);
> -		spin_unlock(&file->f_lock);
> -		if (err < 0)
> -			ret = err;
> -	}
> +	err = file_check_and_advance_wb_err(file);
> +	if (err < 0)
> +		ret = err;
>   out:
>   	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
>   	return ret;
> @@ -4663,7 +4657,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
>   		spin_unlock(&mdsc->cap_dirty_lock);
>   
>   		if (dirty_dropped) {
> -			errseq_set(&ci->i_meta_err, -EIO);
> +			mapping_set_error(inode->i_mapping, -EIO);
>   
>   			if (ci->i_wrbuffer_ref_head == 0 &&
>   			    ci->i_wr_ref == 0 &&
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d20785285d26..91173d3aa161 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -233,7 +233,6 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>   
>   	spin_lock_init(&fi->rw_contexts_lock);
>   	INIT_LIST_HEAD(&fi->rw_contexts);
> -	fi->meta_err = errseq_sample(&ci->i_meta_err);
>   	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>   
>   	return 0;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 23b5a0867e3a..00c73242c4bf 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -542,8 +542,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>   
>   	ceph_fscache_inode_init(ci);
>   
> -	ci->i_meta_err = 0;
> -
>   	return &ci->vfs_inode;
>   }
>   
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 279462482416..598425ccd020 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1493,7 +1493,6 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>   {
>   	struct ceph_mds_request *req;
>   	struct rb_node *p;
> -	struct ceph_inode_info *ci;
>   
>   	dout("cleanup_session_requests mds%d\n", session->s_mds);
>   	mutex_lock(&mdsc->mutex);
> @@ -1502,16 +1501,10 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>   				       struct ceph_mds_request, r_unsafe_item);
>   		pr_warn_ratelimited(" dropping unsafe request %llu\n",
>   				    req->r_tid);
> -		if (req->r_target_inode) {
> -			/* dropping unsafe change of inode's attributes */
> -			ci = ceph_inode(req->r_target_inode);
> -			errseq_set(&ci->i_meta_err, -EIO);
> -		}
> -		if (req->r_unsafe_dir) {
> -			/* dropping unsafe directory operation */
> -			ci = ceph_inode(req->r_unsafe_dir);
> -			errseq_set(&ci->i_meta_err, -EIO);
> -		}
> +		if (req->r_target_inode)
> +			mapping_set_error(req->r_target_inode->i_mapping, -EIO);
> +		if (req->r_unsafe_dir)
> +			mapping_set_error(req->r_unsafe_dir->i_mapping, -EIO);
>   		__unregister_request(mdsc, req);
>   	}
>   	/* zero r_attempts, so kick_requests() will re-send requests */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8aa39bab2d72..d730e508159f 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -435,8 +435,6 @@ struct ceph_inode_info {
>   #ifdef CONFIG_CEPH_FSCACHE
>   	struct fscache_cookie *fscache;
>   #endif
> -	errseq_t i_meta_err;
> -
>   	struct inode vfs_inode; /* at end */
>   };
>   
> @@ -781,7 +779,6 @@ struct ceph_file_info {
>   	spinlock_t rw_contexts_lock;
>   	struct list_head rw_contexts;
>   
> -	errseq_t meta_err;
>   	u32 filp_gen;
>   	atomic_t num_locks;
>   };

Reviewed-by: Xiubo Li <xiubli@redhat.com>




