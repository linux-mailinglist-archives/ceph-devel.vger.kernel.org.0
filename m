Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF7850E391
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 16:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiDYOtk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 10:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiDYOtj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 10:49:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A72DCF
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 07:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A190F61670
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 14:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9451EC385A4;
        Mon, 25 Apr 2022 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650897994;
        bh=oXf2PWCBA7tTTLBpAEjcuU1KzH8AigZffYmobNTOzUA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sH/18AinG4eMaGqlqQmP5/HoGIeRAk7k0Nha2dhCOQsJd9MFvIHSuTLrAyk46p+AY
         IieoMQZNMpY+5J2mtmtFiEp+AJ8JJZ88bEobBspRg3V2ZbmO8pB+zCboPuU5BU0Ucy
         jZGq6v+nR+K436dcyp4Xl96/oSFvJuqCby1hWmgUZKC1DLbhcp1eoyV4lka9PQYyJR
         eJaW9IECs3OAWchL0b9SEaEvWrZ7PpVg+CGD1HeZ4R4FVc83WpqLi6VWypKjn7ECoo
         aKt7Sk+aTlL+K8C1Y7g1oTUYTjLEnwn1XgwpayVBjwcFvVfP/fA7hXV9LyIUANVv9x
         yGoBtJlLmB3kg==
Message-ID: <341b2f3a6eeecbf6a14574f60c11b5a689ac5978.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix possible deadlock when holding Fwb to get
 inline_data
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 25 Apr 2022 10:46:32 -0400
In-Reply-To: <20220425115828.6966-1-xiubli@redhat.com>
References: <20220425115828.6966-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-04-25 at 19:58 +0800, Xiubo Li wrote:
> 1, mount with wsync.
> 2, create a file with O_RDWR, and the request was sent to mds.0:
> 
>    ceph_atomic_open()-->
>      ceph_mdsc_do_request(openc)
>      finish_open(file, dentry, ceph_open)-->
>        ceph_open()-->
>          ceph_init_file()-->
>            ceph_init_file_info()-->
>              ceph_uninline_data()-->
>              {
>                ...
>                if (inline_version == 1 || /* initial version, no data */
>                    inline_version == CEPH_INLINE_NONE)
>                      goto out_unlock;
>                ...
>              }
> 
> The inline_version will be 1, which is the initial version for the
> new create file. And here the ci->i_inline_version will keep with 1,
> it's buggy.
> 
> 3, buffer write to the file immediately:
> 
>    ceph_write_iter()-->
>      ceph_get_caps(file, need=Fw, want=Fb, ...);
>      generic_perform_write()-->
>        a_ops->write_begin()-->
>          ceph_write_begin()-->
>            netfs_write_begin()-->
>              netfs_begin_read()-->
>                netfs_rreq_submit_slice()-->
>                  netfs_read_from_server()-->
>                    rreq->netfs_ops->issue_read()-->
>                      ceph_netfs_issue_read()-->
>                      {
>                        ...
>                        if (ci->i_inline_version != CEPH_INLINE_NONE &&
>                            ceph_netfs_issue_op_inline(subreq))
>                          return;
>                        ...
>                      }
>      ceph_put_cap_refs(ci, Fwb);
> 
> The ceph_netfs_issue_op_inline() will send a getattr(Fsr) request to
> mds.1.
> 
> 4, then the mds.1 will request the rd lock for CInode::filelock from
> the auth mds.0, the mds.0 will do the CInode::filelock state transation
> from excl --> sync, but it need to revoke the Fxwb caps back from the
> clients.
> 
> While the kernel client has aleady held the Fwb caps and waiting for
> the getattr(Fsr).
> 
> It's deadlock!!!!
> 
> URL: https://tracker.ceph.com/issues/55377
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 02722ac86d73..15e7b48cbc95 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1641,7 +1641,7 @@ int ceph_uninline_data(struct file *file)
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -	struct ceph_osd_request *req;
> +	struct ceph_osd_request *req = NULL;
>  	struct ceph_cap_flush *prealloc_cf;
>  	struct folio *folio = NULL;
>  	u64 inline_version = CEPH_INLINE_NONE;
> @@ -1649,10 +1649,23 @@ int ceph_uninline_data(struct file *file)
>  	int err = 0;
>  	u64 len;
>  
> +	spin_lock(&ci->i_ceph_lock);
> +	inline_version = ci->i_inline_version;
> +	spin_unlock(&ci->i_ceph_lock);
> +
> +	dout("uninline_data %p %llx.%llx inline_version %llu\n",
> +	     inode, ceph_vinop(inode), inline_version);
> +
> +	if (inline_version == CEPH_INLINE_NONE)
> +		return 0;
> +
>  	prealloc_cf = ceph_alloc_cap_flush();
>  	if (!prealloc_cf)
>  		return -ENOMEM;
>  
> +	if (inline_version == 1) /* initial version, no data */
> +		goto out_uninline;
> +
>  	folio = read_mapping_folio(inode->i_mapping, 0, file);
>  	if (IS_ERR(folio)) {
>  		err = PTR_ERR(folio);
> @@ -1661,17 +1674,6 @@ int ceph_uninline_data(struct file *file)
>  
>  	folio_lock(folio);
>  
> -	spin_lock(&ci->i_ceph_lock);
> -	inline_version = ci->i_inline_version;
> -	spin_unlock(&ci->i_ceph_lock);
> -
> -	dout("uninline_data %p %llx.%llx inline_version %llu\n",
> -	     inode, ceph_vinop(inode), inline_version);
> -
> -	if (inline_version == 1 || /* initial version, no data */
> -	    inline_version == CEPH_INLINE_NONE)
> -		goto out_unlock;
> -
>  	len = i_size_read(inode);
>  	if (len > folio_size(folio))
>  		len = folio_size(folio);
> @@ -1736,6 +1738,7 @@ int ceph_uninline_data(struct file *file)
>  	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>  				  req->r_end_latency, len, err);
>  
> +out_uninline:
>  	if (!err) {
>  		int dirty;
>  
> @@ -1754,8 +1757,10 @@ int ceph_uninline_data(struct file *file)
>  	if (err == -ECANCELED)
>  		err = 0;
>  out_unlock:
> -	folio_unlock(folio);
> -	folio_put(folio);
> +	if (folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
>  out:
>  	ceph_free_cap_flush(prealloc_cf);
>  	dout("uninline_data %p %llx.%llx inline_version %llu = %d\n",

Nice catch!

Reviewed-by: Jeff Layton <jlayton@kernel.org>
