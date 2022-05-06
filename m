Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2292851DDA7
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 18:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443817AbiEFQgv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 12:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377106AbiEFQgu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 12:36:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E04E47043
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 09:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B82D61FE1
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 16:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D58C385A8;
        Fri,  6 May 2022 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651854785;
        bh=3FEEEhl4O7v3kEQBsr13TLNZcFHiUdsB3GHQzXsmYNQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tG8ulqZVQAtLm3sfhoFoFqHz9+ZMUPDCxjvj1xateehdZR7bSAnwpNvwSxL1ih9zK
         1O9bYMzBQzC6STrEP4OhYjBFvutLlPhuvaLVxSPsnP9R3+VrBk6yCVfppLWyB6HpqH
         sCI0U2cN7Z7KJ1PMJAPYZuEH+f7fvlt5q9oTqGJDGCPMKTNtfHiIypLcfuXLzSXIBY
         1FKaPPtO9vwFEs6UdoA1u1g7jwBOW7cBPjxN9oZJ6RU6YLL/5LKYUjksOhI3W0tit+
         LaeuXLo2IOPkQFr9JpjQyWFhrs05CjYtwWgM6JQxUn4IEe6E8LTVsVpFN6J6PxMxQs
         HvUiYUX+KaGaA==
Message-ID: <b3d35209c39b01aeb51632227f92994e5289a43c.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: always try to uninline inline data when
 opening files
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 06 May 2022 12:33:03 -0400
In-Reply-To: <20220506153843.515915-1-xiubli@redhat.com>
References: <20220506153843.515915-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-05-06 at 23:38 +0800, Xiubo Li wrote:
> This will help reduce possible deadlock while holding Fcr to use
> getattr for read case.
> 


Ok, so I guess the situation here is that if we can't uninline the file,
then we just take our chances with the deadlock possibilities? I think
we have to consider to still be a problem then.

We've been aware that the inlining code is problematic for a long time.
Maybe it's just time to rip this stuff out. Still, it'd be good to have
it in working state before we do that, in case we need to revert it for
some reason...

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

My hat's is off to you who can comprehend the LOCK_* state transitions!
I don't quite grok the problem fully, but I'll take your word for it.

The page should already be uptodate if we hold Fc, AFAICT, so this is
only a problem for the case where we can get Fr but not Fc.

Is there any way we could ensure that we send the getattr to the same
MDS that we got the Fr caps from? Presumably it can satisfy the request
without a revoking anything at that point.

I'll have to think about this a bit more.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 8c8226c0feac..5d5386c7ef01 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -241,11 +241,16 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	INIT_LIST_HEAD(&fi->rw_contexts);
>  	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>  
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
> -		ret = ceph_uninline_data(file);
> -		if (ret < 0)
> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> +		ret = ceph_pool_perm_check(inode, CEPH_CAP_FILE_WR);
> +		if (!ret) {
> +			ret = ceph_uninline_data(file);
> +			/* Ignore the error for readonly case */
> +			if (ret < 0 && (file->f_mode & FMODE_WRITE))
> +				goto error;
> +		} else if (ret != -EPERM) {
>  			goto error;
> +		}
>  	}
>  
>  	return 0;


Maybe instead of doing this, we should 
-- 
Jeff Layton <jlayton@kernel.org>
