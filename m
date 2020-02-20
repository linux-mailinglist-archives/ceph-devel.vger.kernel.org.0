Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A016689E
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 21:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgBTUlR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 15:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBTUlR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 15:41:17 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA51A206EF;
        Thu, 20 Feb 2020 20:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582231276;
        bh=+FxN4LSrTpLPQ+BNOXbeHelQDANhytSaVcyEj0REqJQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aMf4pr44Fpuim07oaWGoniGQRxXw7tU+iE9mbHulidNSc68+JHvIAOfx4fp2YRZEC
         Gtbzo4Ptu9lCOV7WVDWlLI/pUUSR8zWg9oXLPFurqZqlwvxj3aIPwEicxyWgcC2aIi
         kMjq4KWpgPEtzUlQABDtsv0JoE91xifhAANHJ8HU=
Message-ID: <9282539b8efcaccdd8d19197edb289828803d39c.camel@kernel.org>
Subject: Re: [PATCH] ceph: re-org copy_file_range and fix error handling
 paths
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 20 Feb 2020 15:41:14 -0500
In-Reply-To: <20200217123649.12316-1-lhenriques@suse.com>
References: <20200217123649.12316-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-17 at 12:36 +0000, Luis Henriques wrote:
> This patch re-organizes copy_file_range, trying to fix a few issues in
> error handling.  Here's the summary:
> 
> - Abort copy if initial do_splice_direct() returns fewer bytes than
>   requested.
> 
> - Move the 'size' initialization (with i_size_read()) further down in the
>   code, after the initial call to do_splice_direct().  This avoids issues
>   with a possibly stale value if a manual copy is done.
> 
> - Move the object copy loop into a separate function.  This makes it
>   easier to handle errors (e.g, dirtying caps and updating the MDS
>   metadata if only some objects have been copied before an error has
>   occurred).
> 
> - Added calls to ceph_oloc_destroy() to avoid leaking memory with src_oloc
>   and dst_oloc
> 
> - After the object copy loop, the new file size to be reported to the MDS
>   (if there's file size change) is now the actual file size, and not the
>   size after an eventual extra manual copy.
> 
> - Added a few dout() to show the number of bytes copied in the two manual
>   copies and in the object copy loop.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi!
> 
> Initially I was going to have this patch split in a series, but then I
> decided not to do that as this big patch allows (IMO) to better see the
> whole picture.  But please let me know if you think otherwise and I can
> split it in a few smaller patches.
> 
> I tried to cover all the issues that have been pointed out by Ilya, but I
> may have missed something or, more likely, introduced new bugs ;-)
> 
> Cheers,
> --
> Luis
> 

Sorry for the delay in review!

>  fs/ceph/file.c | 169 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 96 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index c3b8e8e0bf17..4d90a275f9a5 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1931,6 +1931,71 @@ static int is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
>  	return 0;
>  }
>  
> +static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off,
> +				    struct ceph_inode_info *dst_ci, u64 *dst_off,
> +				    struct ceph_fs_client *fsc,
> +				    size_t len, unsigned int flags)
> +{
> +	struct ceph_object_locator src_oloc, dst_oloc;
> +	struct ceph_object_id src_oid, dst_oid;
> +	size_t bytes = 0;
> +	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
> +	u32 src_objlen, dst_objlen;
> +	u32 object_size = src_ci->i_layout.object_size;
> +	int ret;
> +
> +	src_oloc.pool = src_ci->i_layout.pool_id;
> +	src_oloc.pool_ns = ceph_try_get_string(src_ci->i_layout.pool_ns);
> +	dst_oloc.pool = dst_ci->i_layout.pool_id;
> +	dst_oloc.pool_ns = ceph_try_get_string(dst_ci->i_layout.pool_ns);
> +
> +	while (len >= object_size) {
> +		ceph_calc_file_object_mapping(&src_ci->i_layout, *src_off,
> +					      object_size, &src_objnum,
> +					      &src_objoff, &src_objlen);
> +		ceph_calc_file_object_mapping(&dst_ci->i_layout, *dst_off,
> +					      object_size, &dst_objnum,
> +					      &dst_objoff, &dst_objlen);
> +		ceph_oid_init(&src_oid);
> +		ceph_oid_printf(&src_oid, "%llx.%08llx",
> +				src_ci->i_vino.ino, src_objnum);
> +		ceph_oid_init(&dst_oid);
> +		ceph_oid_printf(&dst_oid, "%llx.%08llx",
> +				dst_ci->i_vino.ino, dst_objnum);
> +		/* Do an object remote copy */
> +		ret = ceph_osdc_copy_from(&fsc->client->osdc,
> +					  src_ci->i_vino.snap, 0,
> +					  &src_oid, &src_oloc,
> +					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> +					  CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> +					  &dst_oid, &dst_oloc,
> +					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> +					  CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> +					  dst_ci->i_truncate_seq,
> +					  dst_ci->i_truncate_size,
> +					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> +		if (ret) {
> +			if (ret == -EOPNOTSUPP) {
> +				fsc->have_copy_from2 = false;
> +				pr_notice("OSDs don't support copy-from2; disabling copy offload\n");
> +			}
> +			dout("ceph_osdc_copy_from returned %d\n", ret);
> +			if (!bytes)
> +				bytes = ret;
> +			goto out;
> +		}
> +		len -= object_size;
> +		bytes += object_size;
> +		*src_off += object_size;
> +		*dst_off += object_size;
> +	}
> +
> +out:
> +	ceph_oloc_destroy(&src_oloc);
> +	ceph_oloc_destroy(&dst_oloc);
> +	return bytes;
> +}
> +
>  static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  				      struct file *dst_file, loff_t dst_off,
>  				      size_t len, unsigned int flags)
> @@ -1941,14 +2006,11 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>  	struct ceph_cap_flush *prealloc_cf;
>  	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> -	struct ceph_object_locator src_oloc, dst_oloc;
> -	struct ceph_object_id src_oid, dst_oid;
> -	loff_t endoff = 0, size;
> -	ssize_t ret = -EIO;
> +	loff_t size;
> +	ssize_t ret = -EIO, bytes;
>  	u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
> -	u32 src_objlen, dst_objlen, object_size;
> +	u32 src_objlen, dst_objlen;
>  	int src_got = 0, dst_got = 0, err, dirty;
> -	bool do_final_copy = false;
>  
>  	if (src_inode->i_sb != dst_inode->i_sb) {
>  		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> @@ -2026,22 +2088,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	if (ret < 0)
>  		goto out_caps;
>  
> -	size = i_size_read(dst_inode);
> -	endoff = dst_off + len;
> -
>  	/* Drop dst file cached pages */
>  	ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
>  					    dst_off >> PAGE_SHIFT,
> -					    endoff >> PAGE_SHIFT);
> +					    (dst_off + len) >> PAGE_SHIFT);
>  	if (ret < 0) {
>  		dout("Failed to invalidate inode pages (%zd)\n", ret);
>  		ret = 0; /* XXX */
>  	}
> -	src_oloc.pool = src_ci->i_layout.pool_id;
> -	src_oloc.pool_ns = ceph_try_get_string(src_ci->i_layout.pool_ns);
> -	dst_oloc.pool = dst_ci->i_layout.pool_id;
> -	dst_oloc.pool_ns = ceph_try_get_string(dst_ci->i_layout.pool_ns);
> -
>  	ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
>  				      src_ci->i_layout.object_size,
>  				      &src_objnum, &src_objoff, &src_objlen);
> @@ -2060,6 +2114,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	 * starting at the src_off
>  	 */
>  	if (src_objoff) {
> +		dout("Initial partial copy of %u bytes\n", src_objlen);
> +
>  		/*
>  		 * we need to temporarily drop all caps as we'll be calling
>  		 * {read,write}_iter, which will get caps again.
> @@ -2067,8 +2123,9 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  		put_rd_wr_caps(src_ci, src_got, dst_ci, dst_got);
>  		ret = do_splice_direct(src_file, &src_off, dst_file,
>  				       &dst_off, src_objlen, flags);
> -		if (ret < 0) {
> -			dout("do_splice_direct returned %d\n", err);
> +		/* Abort on short copies or on error */
> +		if (ret < src_objlen) {
> +			dout("Failed partial copy (%zd)\n", ret);
>  			goto out;
>  		}
>  		len -= ret;
> @@ -2081,62 +2138,29 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  		if (err < 0)
>  			goto out_caps;
>  	}
> -	object_size = src_ci->i_layout.object_size;
> -	while (len >= object_size) {
> -		ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
> -					      object_size, &src_objnum,
> -					      &src_objoff, &src_objlen);
> -		ceph_calc_file_object_mapping(&dst_ci->i_layout, dst_off,
> -					      object_size, &dst_objnum,
> -					      &dst_objoff, &dst_objlen);
> -		ceph_oid_init(&src_oid);
> -		ceph_oid_printf(&src_oid, "%llx.%08llx",
> -				src_ci->i_vino.ino, src_objnum);
> -		ceph_oid_init(&dst_oid);
> -		ceph_oid_printf(&dst_oid, "%llx.%08llx",
> -				dst_ci->i_vino.ino, dst_objnum);
> -		/* Do an object remote copy */
> -		err = ceph_osdc_copy_from(
> -			&src_fsc->client->osdc,
> -			src_ci->i_vino.snap, 0,
> -			&src_oid, &src_oloc,
> -			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> -			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> -			&dst_oid, &dst_oloc,
> -			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> -			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> -			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> -			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> -		if (err) {
> -			if (err == -EOPNOTSUPP) {
> -				src_fsc->have_copy_from2 = false;
> -				pr_notice("OSDs don't support copy-from2; disabling copy offload\n");
> -			}
> -			dout("ceph_osdc_copy_from returned %d\n", err);
> -			if (!ret)
> -				ret = err;
> -			goto out_caps;
> -		}
> -		len -= object_size;
> -		src_off += object_size;
> -		dst_off += object_size;
> -		ret += object_size;
> -	}
>  
> -	if (len)
> -		/* We still need one final local copy */
> -		do_final_copy = true;
> +	size = i_size_read(dst_inode);
> +	bytes = ceph_do_objects_copy(src_ci, &src_off, dst_ci, &dst_off,
> +				     src_fsc, len, flags);
> +	if (bytes <= 0) {
> +		if (!ret)
> +			ret = bytes;
> +		goto out_caps;
> +	}

Suppose we did the front part with do_splice_direct (ret > 0), but then
ceph_do_objects_copy fails (bytes < 0). We "goto out_caps" but then...

[...]

> @@ -2152,15 +2176,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  out_caps:
>  	put_rd_wr_caps(src_ci, src_got, dst_ci, dst_got);
>  
> -	if (do_final_copy) {
> -		err = do_splice_direct(src_file, &src_off, dst_file,
> -				       &dst_off, len, flags);
> -		if (err < 0) {
> -			dout("do_splice_direct returned %d\n", err);
> -			goto out;
> -		}
> -		len -= err;
> -		ret += err;
> +	if (len && (ret >= 0)) {

...len is still positive and we do_splice_direct again (probably at the
wrong offset?), instead of just returning a short copy. I think we
probably want to just stop any copying if it fails at any point along
the way, right?

> +		dout("Final partial copy of %zu bytes\n", len);
> +		bytes = do_splice_direct(src_file, &src_off, dst_file,
> +					 &dst_off, len, flags);
> +		if (bytes > 0)
> +			ret += bytes;
> +		else
> +			dout("Failed partial copy (%zd)\n", bytes);
>  	}
>  
>  out:

-- 
Jeff Layton <jlayton@kernel.org>

