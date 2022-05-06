Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3A51CEF0
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 04:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387639AbiEFAvq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 20:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353629AbiEFAvn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 20:51:43 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A6F215A3F
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 17:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651798081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CZvc5/hUD/zDQJqRt36Il9HSqR6WgVa1XthEbVGCSPU=;
        b=ZImC2P4yGufJoPa5A0CyVKgEkt2jgtQiy4jsxVg7VVUtvstDrQh513uI2EAt3pW/2AM0Sx
        eKyKxEKV38qVIAPQw1qt7MPxC+QA9F6P8OemUuE0EBNcCs8qVL1nEoDxfPdNs6Z0tHgHye
        YAx4fxafsT4+Nh2UBbey3ERr2BAp8UI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-JbdnpaAgPwWqojpyHmd3Ew-1; Thu, 05 May 2022 20:48:00 -0400
X-MC-Unique: JbdnpaAgPwWqojpyHmd3Ew-1
Received: by mail-pg1-f198.google.com with SMTP id h128-20020a636c86000000b003c574b3422aso2821649pgc.12
        for <ceph-devel@vger.kernel.org>; Thu, 05 May 2022 17:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CZvc5/hUD/zDQJqRt36Il9HSqR6WgVa1XthEbVGCSPU=;
        b=cVrgUtjZSckyWz9DXj7zslnzNHtAg4e3Fc5hSogXnKgDIQJgCQkdNVVdYg5vKrbKHl
         QtO3AUtM4mkDovjIRZ/SM8q0uLh+1fkHRM2sCtZ8PykWmx0Z+GBlrj+k/frOp5rSy1A4
         R7DKAe3PfeOR4UhHyMaGRn0VgHWcVPRPKcgYlPzzgDW5SlO2rM/ErvPAmE5hxGvX5l8Z
         dRsf2FRDLfIRvjCz1rDfFyX38jr2fr3rc+3+K2Z45a5bp/yDdWVSMGes4gGF0LOi5HiG
         90cCPLakNiUKOzTSOGpXpFIoj/6+FrFRbPAglCf+ynWFYxVcZW1pIJ2INYQAUgXxKhcA
         v3mg==
X-Gm-Message-State: AOAM530+gpX68m+dt7HqgSpBEPgB53QWiEcLZvNo2767W/SFj/4DX2Wi
        NVU6Jk7u5STgP5VRaX5mOQJgwCRyKDInHbzWzjOZFLd1MC0cq9DGBQXAUaeXu3yT84mSNiVRI4s
        CRmt28J6ft5w3rzZgYnc6tibq9tMvhONRkWGd16IoO1lBMAEn97BwEi/kpkZ+2v2zQn68gIU=
X-Received: by 2002:a17:90a:e7cd:b0:1dc:74eb:7526 with SMTP id kb13-20020a17090ae7cd00b001dc74eb7526mr1165022pjb.144.1651798078442;
        Thu, 05 May 2022 17:47:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl1y9v1zmKvaUQo6Ws86ZE+mUy4Q/G0lgONNVJT1ZxpYgjDtX3RM3U1hQqjp9vtDvskx/XWw==
X-Received: by 2002:a17:90a:e7cd:b0:1dc:74eb:7526 with SMTP id kb13-20020a17090ae7cd00b001dc74eb7526mr1165000pjb.144.1651798078099;
        Thu, 05 May 2022 17:47:58 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r22-20020a170902be1600b0015edfccfdb5sm257200pls.50.2022.05.05.17.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 17:47:57 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix possible deadlock while holding Fcr to use
 getattr
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220422092520.18505-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7c366c95-04a3-9b4c-e533-b67840799f98@redhat.com>
Date:   Fri, 6 May 2022 08:47:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220422092520.18505-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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

Jeff,

Any suggestion for this patch ?

Maybe we should uninline the inline data whenever opening the file for 
the first time in any case always since we are planing to remove the 
inline feature in ceph, and thus we can keep it to be backward compatible ?

-- Xiubo

On 4/22/22 5:25 PM, Xiubo Li wrote:
> We can't use getattr to fetch inline data after getting Fcr caps,
> because it can cause deadlock. The solution is try uniline the
> inline data when opening the file, thanks David Howells' previous
> work on uninlining the inline data work.
>
> It was caused from one possible call path:
>    ceph_filemap_fault()-->
>       ceph_get_caps(Fcr);
>       filemap_fault()-->
>          do_sync_mmap_readahead()-->
>             page_cache_ra_order()-->
>                read_pages()-->
>                   aops->readahead()-->
>                      netfs_readahead()-->
>                         netfs_begin_read()-->
>                            netfs_rreq_submit_slice()-->
>                               netfs_read_from_server()-->
>                                  netfs_ops->issue_read()-->
>                                     ceph_netfs_issue_read()-->
>                                        ceph_netfs_issue_op_inline()-->
>                                           getattr()
>        ceph_pu_caps_ref(Fcr);
>
> This because if the Locker state is LOCK_EXEC_MIX for auth MDS, and
> the replica MDSes' lock state is LOCK_LOCK. Then the kclient could
> get 'Frwcb' caps from both auth and replica MDSes.
>
> But if the getattr is sent to any MDS, the MDS needs to do Locker
> transition to LOCK_MIX first and then to LOCK_SYNC. But when
> transfering to LOCK_MIX state the MDS Locker need to revoke the Fcb
> caps back, but the kclient already holding it and waiting the MDS
> to finish.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/addr.c | 65 ++++++--------------------------------------------
>   fs/ceph/file.c |  3 +--
>   2 files changed, 8 insertions(+), 60 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 261bc8bb2ab8..b0b9a2f4adb0 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -244,61 +244,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
>   	iput(req->r_inode);
>   }
>   
> -static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
> -{
> -	struct netfs_io_request *rreq = subreq->rreq;
> -	struct inode *inode = rreq->inode;
> -	struct ceph_mds_reply_info_parsed *rinfo;
> -	struct ceph_mds_reply_info_in *iinfo;
> -	struct ceph_mds_request *req;
> -	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
> -	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct iov_iter iter;
> -	ssize_t err = 0;
> -	size_t len;
> -	int mode;
> -
> -	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
> -	__clear_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
> -
> -	if (subreq->start >= inode->i_size)
> -		goto out;
> -
> -	/* We need to fetch the inline data. */
> -	mode = ceph_try_to_choose_auth_mds(inode, CEPH_STAT_CAP_INLINE_DATA);
> -	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
> -	if (IS_ERR(req)) {
> -		err = PTR_ERR(req);
> -		goto out;
> -	}
> -	req->r_ino1 = ci->i_vino;
> -	req->r_args.getattr.mask = cpu_to_le32(CEPH_STAT_CAP_INLINE_DATA);
> -	req->r_num_caps = 2;
> -
> -	err = ceph_mdsc_do_request(mdsc, NULL, req);
> -	if (err < 0)
> -		goto out;
> -
> -	rinfo = &req->r_reply_info;
> -	iinfo = &rinfo->targeti;
> -	if (iinfo->inline_version == CEPH_INLINE_NONE) {
> -		/* The data got uninlined */
> -		ceph_mdsc_put_request(req);
> -		return false;
> -	}
> -
> -	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
> -	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
> -	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);
> -	if (err == 0)
> -		err = -EFAULT;
> -
> -	ceph_mdsc_put_request(req);
> -out:
> -	netfs_subreq_terminated(subreq, err, false);
> -	return true;
> -}
> -
>   static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>   {
>   	struct netfs_io_request *rreq = subreq->rreq;
> @@ -313,9 +258,13 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>   	int err = 0;
>   	u64 len = subreq->len;
>   
> -	if (ci->i_inline_version != CEPH_INLINE_NONE &&
> -	    ceph_netfs_issue_op_inline(subreq))
> -		return;
> +	/*
> +	 * We have uninlined the inline data when openning the file,
> +	 * or we must send a GETATTR request to the MDS, which is
> +	 * buggy and will cause deadlock while holding the Fcr
> +	 * reference in ceph_filemap_fault().
> +	 */
> +	BUG_ON(ci->i_inline_version != CEPH_INLINE_NONE);
>   
>   	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
>   			0, 1, CEPH_OSD_OP_READ,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..a98a61ec4ada 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -241,8 +241,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>   	INIT_LIST_HEAD(&fi->rw_contexts);
>   	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>   
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>   		ret = ceph_uninline_data(file);
>   		if (ret < 0)
>   			goto error;

