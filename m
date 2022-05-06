Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBAB51DB2C
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442482AbiEFO4X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 10:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442312AbiEFO4W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 10:56:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F206972C
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 07:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E44A5B83665
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 14:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22952C385A9;
        Fri,  6 May 2022 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651848756;
        bh=KrIePu9X39bElbvU96t/WVnOL1m17NESZKDze5aKPLE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lBzxXBa4c4E3ULODlkrhWdySnha4whgGWUdL4/aH28+WLINKmrVtesQHoKzssfYOH
         flQW1menxicM1gRnilidUVzS0Vujy3WhrZ6sU0KKwBbRAG4MSc87ufVYLtUV6+7s8N
         ykEwOQqWtqQ9VJ+BUJyEl8htMMk+jnhS3VjmjzcVW0FPsQa9AeRNmpEkx5a1gYF2Il
         x85i6zbOfv7pqi2iodCeaeerJP3bEmyY+FU1cHUL2jTxTlnOaC9IDl4R2WzoEbzrgi
         2YZaN0StxgiR7dCsXd5bnhw+bl+k/TazX0RCXx4JSiqFswL976LKBRRKtMSuYkYQYG
         WNVd3F8ybPEiQ==
Message-ID: <aa0ea51647c660b50bbfd9b2087cba4f24938ee0.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: always try to uninline inline data when
 opening files
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 06 May 2022 10:52:34 -0400
In-Reply-To: <20220506143052.479799-1-xiubli@redhat.com>
References: <20220506143052.479799-1-xiubli@redhat.com>
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

On Fri, 2022-05-06 at 22:30 +0800, Xiubo Li wrote:
> This will help reduce possible deadlock while holding Fcr to use
> getattr for read case.
> 
> Usually we shouldn't use getattr to fetch inline data after getting
> Fcr caps, because it can cause deadlock. The solution is try uniline
> the inline data when opening files, thanks David Howells' previous
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
>  fs/ceph/file.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 8c8226c0feac..09327ef5a26d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -241,11 +241,12 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	INIT_LIST_HEAD(&fi->rw_contexts);
>  	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>  
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
> -		ret = ceph_uninline_data(file);
> -		if (ret < 0)
> -			goto error;
> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> +		if (!ceph_pool_perm_check(inode, CEPH_CAP_FILE_WR)) {
> +			ret = ceph_uninline_data(file);
> +			if (ret < 0)
> +				goto error;
> +		}
>  	}
>  
>  	return 0;

Note that this may be considered a regression in some cases. If a client
doesn't have write permissions to the pool at all, then previously it'd
be able to read files, but now it wouldn't.

Those are not terribly common configurations as I understand, but we
should be aware of it if we go this route.

Beyond that though, this patch ignores errors from ceph_pool_perm_check
and doesn't uninline the file if one is returned. Is that the behavior
you want here?

-- 
Jeff Layton <jlayton@kernel.org>
