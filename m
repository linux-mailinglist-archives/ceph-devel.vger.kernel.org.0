Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FF817DF07
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 12:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCILvl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 07:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCILvl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 07:51:41 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C6B2051A;
        Mon,  9 Mar 2020 11:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583754700;
        bh=cRPhnh/Qv+Br+tgb6dnvHXKbCxbV8yc46hTfucrzQjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=svQmzJgV37YZIrOQe9lHQZ6z5WeqFPT8L/Air+ME4+dQ6BYRazrIjXlYSIdZPq9uV
         ryN0YZWVpCo7IPZUNKH/Ir7OzJ0lSYH3MkCjwH499AXNJUsCZrPTyeXJwYCthOBGRP
         beXpo8IYLXTF8ACqMl1QWHxabnzVV6vwWKNED86E=
Message-ID: <16b9a2a5bfbd8802ce2f2c435aba7331cd1adb35.camel@kernel.org>
Subject: Re: [PATCH v9 2/5] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 09 Mar 2020 07:51:38 -0400
In-Reply-To: <1583739430-4928-3-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
         <1583739430-4928-3-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-09 at 03:37 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will fulfill the cap hit/mis metric stuff per-superblock,
> it will count the hit/mis counters based each inode, and if one
> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
> 
> item          total           miss            hit
> -------------------------------------------------
> caps          295             107             4119
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/acl.c        |  2 +-
>  fs/ceph/caps.c       | 19 +++++++++++++++++++
>  fs/ceph/debugfs.c    | 16 ++++++++++++++++
>  fs/ceph/dir.c        |  5 +++--
>  fs/ceph/inode.c      |  4 ++--
>  fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>  fs/ceph/metric.h     | 13 +++++++++++++
>  fs/ceph/super.h      |  8 +++++---
>  fs/ceph/xattr.c      |  4 ++--
>  9 files changed, 83 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 26be652..e046574 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
> +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
>  		set_cached_acl(inode, type, acl);
>  	else
>  		forget_cached_acl(inode, type);
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 342a32c..efaeb67 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -912,6 +912,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  	return 0;
>  }
>  
> +int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
> +				   int touch)
> +{
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +	int r;
> +
> +	r = __ceph_caps_issued_mask(ci, mask, touch);
> +	if (r)
> +		ceph_update_cap_hit(&fsc->mdsc->metric);
> +	else
> +		ceph_update_cap_mis(&fsc->mdsc->metric);
> +	return r;
> +}
> +
>  /*
>   * Return true if mask caps are currently being revoked by an MDS.
>   */
> @@ -2680,6 +2694,11 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  	if (snap_rwsem_locked)
>  		up_read(&mdsc->snap_rwsem);
>  
> +	if (!ret)
> +		ceph_update_cap_mis(&mdsc->metric);

Should a negative error code here also mean a miss?

> +	else if (ret == 1)
> +		ceph_update_cap_hit(&mdsc->metric);
> +
>  	dout("get_cap_refs %p ret %d got %s\n", inode,
>  	     ret, ceph_cap_string(*got));
>  	return ret;

-- 
Jeff Layton <jlayton@kernel.org>

