Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349A4AD6EC
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 12:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfIIKfL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 06:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbfIIKfL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 06:35:11 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 350922086D;
        Mon,  9 Sep 2019 10:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568025309;
        bh=hRx9yb4pD46+5kN87jkPGzlRP7O/0R+F2wikb+6HcWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jo3pPW6/RwscCHhtxZZAfHBiK1LMxpjeeFw824tkKRa1EpEkK6JJk1P6a/zpCgo7V
         Zhew8jObYvP56NaHXYqlPdIerExsgvVaAQeVQIgl+JH1K8eakg6ddaT8xtVC5JBOdc
         jCjZxey8Rs6VwIE4kIHHJnstokJ5zHg+B2Tz9qIA=
Message-ID: <3f838e42a50575595c7310386cf698aca8f89607.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: allow object copies across different
 filesystems in the same cluster
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 09 Sep 2019 06:35:07 -0400
In-Reply-To: <20190909102834.16246-1-lhenriques@suse.com>
References: <87k1ahojri.fsf@suse.com>
         <20190909102834.16246-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-09-09 at 11:28 +0100, Luis Henriques wrote:
> OSDs are able to perform object copies across different pools.  Thus,
> there's no need to prevent copy_file_range from doing remote copies if the
> source and destination superblocks are different.  Only return -EXDEV if
> they have different fsid (the cluster ID).
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> Hi,
> 
> Here's the patch changelog since initial submittion:
> 
> - Dropped have_fsid checks on client structs
> - Use %pU to print the fsid instead of raw hex strings (%*ph)
> - Fixed 'To:' field in email so that this time the patch hits vger
> 
> Cheers,
> --
> Luis
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 685a03cc4b77..4a624a1dd0bb 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	struct ceph_inode_info *src_ci = ceph_inode(src_inode);
>  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>  	struct ceph_cap_flush *prealloc_cf;
> +	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>  	struct ceph_object_locator src_oloc, dst_oloc;
>  	struct ceph_object_id src_oid, dst_oid;
>  	loff_t endoff = 0, size;
> @@ -1915,8 +1916,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  
>  	if (src_inode == dst_inode)
>  		return -EINVAL;
> -	if (src_inode->i_sb != dst_inode->i_sb)
> -		return -EXDEV;
> +	if (src_inode->i_sb != dst_inode->i_sb) {
> +		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> +
> +		if (ceph_fsid_compare(&src_fsc->client->fsid,
> +				      &dst_fsc->client->fsid)) {
> +			dout("Copying object across different clusters:");
> +			dout("  src fsid: %pU dst fsid: %pU\n",
> +			     &src_fsc->client->fsid, &dst_fsc->client->fsid);
> +			return -EXDEV;
> +		}
> +	}

Just to be clear: what happens here if I mount two entirely separate
clusters, and their OSDs don't have any access to one another? Will this
fail at some later point with an error that we can catch so that we can
fall back?


>  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>  		return -EROFS;
>  
> @@ -1928,7 +1938,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	 * efficient).
>  	 */
>  
> -	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
> +	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
>  		return -EOPNOTSUPP;
>  
>  	if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
> @@ -2044,7 +2054,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  				dst_ci->i_vino.ino, dst_objnum);
>  		/* Do an object remote copy */
>  		err = ceph_osdc_copy_from(
> -			&ceph_inode_to_client(src_inode)->client->osdc,
> +			&src_fsc->client->osdc,
>  			src_ci->i_vino.snap, 0,
>  			&src_oid, &src_oloc,
>  			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |

-- 
Jeff Layton <jlayton@kernel.org>

