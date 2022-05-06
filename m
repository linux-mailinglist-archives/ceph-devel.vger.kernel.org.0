Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A5051D70F
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 13:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346572AbiEFLyn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 07:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiEFLym (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 07:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EAD63BEA
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 04:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91ECB61F51
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 11:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716A0C385A8;
        Fri,  6 May 2022 11:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651837859;
        bh=ek9mIZn6r0T3xzYN2w2DlRdE+IW0qRyoqmQsi8t0taE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nx000YWycGIcBowDrh5scY0aSGGxCeeuCzS7Hwy/7i3l+gTVmj8DEzWjM23+v2A8o
         BeIC1G9i/THAYahUCo8mTWmccrR4T2ksUitrgeXNJafqc0R8mEbWtPq4anxGQgXwia
         CWR9+b+nxpZbe9B5LV/fjvKdNrw5xT8x9yfV3syreqiVDjlFIJ2wND19nD+bh7OdUy
         mSe+ZxGu0PsGNk42XY5dMeoVnKBlrDwxhJOeHPRhmgqGSa8Bf2CL97yNbZyW6bmjvu
         hUT7GhCAWY74fdCxbBEPsb/alh1ZPF1Z+xk90tg9rJmnS89GAHPOcrsGj9xUY8xJIv
         DZrbkcC3OuM6g==
Message-ID: <8cf47d9bd785ab474553e819604abd3008e0a24f.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix possible deadlock while holding Fcr to use
 getattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date:   Fri, 06 May 2022 07:50:57 -0400
In-Reply-To: <20220422092520.18505-1-xiubli@redhat.com>
References: <20220422092520.18505-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-04-22 at 17:25 +0800, Xiubo Li wrote:
> We can't use getattr to fetch inline data after getting Fcr caps,
> because it can cause deadlock. The solution is try uniline the
> inline data when opening the file, thanks David Howells' previous
> work on uninlining the inline data work.
> 
> It was caused from one possible call path:
>   ceph_filemap_fault()-->
>      ceph_get_caps(Fcr);
>      filemap_fault()-->
>         do_sync_mmap_readahead()-->
>            page_cache_ra_order()-->
>               read_pages()-->
>                  aops->readahead()-->
>                     netfs_readahead()-->
>                        netfs_begin_read()-->
>                           netfs_rreq_submit_slice()-->
>                              netfs_read_from_server()-->
>                                 netfs_ops->issue_read()-->
>                                    ceph_netfs_issue_read()-->
>                                       ceph_netfs_issue_op_inline()-->
>                                          getattr()
>       ceph_pu_caps_ref(Fcr);
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
>  fs/ceph/addr.c | 65 ++++++--------------------------------------------
>  fs/ceph/file.c |  3 +--
>  2 files changed, 8 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 261bc8bb2ab8..b0b9a2f4adb0 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -244,61 +244,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
>  	iput(req->r_inode);
>  }
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
>  static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>  {
>  	struct netfs_io_request *rreq = subreq->rreq;
> @@ -313,9 +258,13 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>  	int err = 0;
>  	u64 len = subreq->len;
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
>  	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
>  			0, 1, CEPH_OSD_OP_READ,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..a98a61ec4ada 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -241,8 +241,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	INIT_LIST_HEAD(&fi->rw_contexts);
>  	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>  
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>  		ret = ceph_uninline_data(file);
>  		if (ret < 0)
>  			goto error;

Will we always be able to guarantee that we can uninline the file? I
think it's possible to use RADOS pool caps to limit some clients to
read-only. That's what ceph_pool_perm_check is all about.

If we do want to go this route, then you may need to fix
ceph_pool_perm_check to check for CEPH_I_POOL_WR when opening an inlined
file for read.
-- 
Jeff Layton <jlayton@kernel.org>
