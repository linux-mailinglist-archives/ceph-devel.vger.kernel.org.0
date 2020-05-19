Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5466F1D9467
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgESKc6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 06:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgESKc6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 May 2020 06:32:58 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 281F0206BE;
        Tue, 19 May 2020 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589884377;
        bh=Sz3NWQVCvErlN0KG9s3oNfFh9TODvLg02ncE3/8Xexo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0qDdhJET96SLwW8UIT0ZyZa7u3uQg8aAlsr4fHIzN2JCfnX4F2MgZiXQGrwMHMVzy
         CLr1/N2zrh33/ssJzJRVPXhftetT0ryTUVUv5BD/gA5Ovq9AfT0AcJwW9grQbFB5hc
         j2TSyYJTnNd1097VcdLKriKvqOhk55eFHeSDII1k=
Message-ID: <a9793df5b119b81b995b903505006076811227ed.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: don't return -ESTALE if there's still an open
 file
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 May 2020 06:32:55 -0400
In-Reply-To: <20200518174726.GA84496@suse.com>
References: <20200518174726.GA84496@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-05-18 at 18:47 +0100, Luis Henriques wrote:
> Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> a file handle to dentry"), this fixes another corner case with
> name_to_handle_at/open_by_handle_at.  The issue has been detected by
> xfstest generic/467, when doing:
> 
>  - name_to_handle_at("/cephfs/myfile")
>  - open("/cephfs/myfile")
>  - unlink("/cephfs/myfile")
>  - sync; sync;
>  - drop caches
>  - open_by_handle_at()
> 
> The call to open_by_handle_at should not fail because the file hasn't been
> deleted yet (only unlinked) and we do have a valid handle to it.  -ESTALE
> shall be returned only if i_nlink is 0 *and* i_count is 1.
> 
> This patch also makes sure we have LINK caps before checking i_nlink.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi!
> 
> (and sorry for the delay in my reply!)
> 
> So, from the discussion thread and some IRC chat with Jeff, I'm sending
> v2.  What changed?  Everything! :-)
> 
> - Use i_count instead of __ceph_is_file_opened to check for open files
> - Add call to ceph_do_getattr to make sure we have LINK caps before
>   accessing i_nlink
> 
> Cheers,
> --
> Luis
> 
>  fs/ceph/export.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 79dc06881e78..e088843a7734 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -172,9 +172,16 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
>  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  {
>  	struct inode *inode = __lookup_inode(sb, ino);
> +	int err;
> +
>  	if (IS_ERR(inode))
>  		return ERR_CAST(inode);
> -	if (inode->i_nlink == 0) {
> +	/* We need LINK caps to reliably check i_nlink */
> +	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
> +	if (err)
> +		return ERR_PTR(err);
> +	/* -ESTALE if inode as been unlinked and no file is open */
> +	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
>  		iput(inode);
>  		return ERR_PTR(-ESTALE);
>  	}
> 

Looks good. Merged into testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

