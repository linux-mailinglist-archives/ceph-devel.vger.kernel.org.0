Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315F1359F3F
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 14:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhDIMun (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Apr 2021 08:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232615AbhDIMun (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 08:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF7B610E7;
        Fri,  9 Apr 2021 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617972629;
        bh=xOv9lDYpXnZrbDx22drj6l3V079be0RY5uWmz/x8Omo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nYQoktx1Hw++eqQAEwuE5agG02f4hIlyUxtmzq7LHVktqATWAdrBozN4IQdaGSX+D
         J8mJvIZEK9dabu84AdviUCW31LYy+n8pT19Jds6ye/WtMWpQU565T1KzJZw5SSUsZn
         Flt54zseUo4YmryLOFv2Gd+9jm/ZD2qxLI4c8Rbd3F1iMOjS56KbtR0aXDkj4SpbZf
         2CgF7LbnWRa6hnvArq6x0RLJBKEO1fK+0PhjFKcbEXbTGzTQOPk7y+hFgBPC/do319
         P1LFviTvZzR7JqFHYLDmS5O8RYimxG8wExqLLrLPnNUzK2F/fEI9+svS6s4QZqil/0
         7SD685UmArSeg==
Message-ID: <e3830bc562d86e7d82542a3ee3d6ce66c901fda0.camel@kernel.org>
Subject: Re: [v2] ceph: support getting ceph.dir.rsnaps vxattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 09 Apr 2021 08:50:28 -0400
In-Reply-To: <20200828012844.18937-1-gmayyyha@gmail.com>
References: <20200828012844.18937-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-08-28 at 09:28 +0800, Yanhu Cao wrote:
> It's easy to know how many snapshots have been created.
> 
> Link: https://tracker.ceph.com/issues/47168
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/inode.c      | 1 +
>  fs/ceph/mds_client.c | 9 ++++++++-
>  fs/ceph/mds_client.h | 1 +
>  fs/ceph/super.h      | 2 +-
>  fs/ceph/xattr.c      | 7 +++++++
>  5 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 357c937699d5..650cad4b3ecb 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -891,6 +891,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>  			ci->i_rfiles = le64_to_cpu(info->rfiles);
>  			ci->i_rsubdirs = le64_to_cpu(info->rsubdirs);
>  			ci->i_dir_pin = iinfo->dir_pin;
> +			ci->i_rsnaps = iinfo->rsnaps;
>  			ceph_decode_timespec64(&ci->i_rctime, &info->rctime);
>  		}
>  	}
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4a26862d7667..3466845c0179 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -176,6 +176,13 @@ static int parse_reply_info_in(void **p, void *end,
>  			memset(&info->snap_btime, 0, sizeof(info->snap_btime));
>  		}
>  
> +		/* snapshot count, remains zero for v<=3 */
> +		if (struct_v >= 4) {
> +			ceph_decode_64_safe(p, end, info->rsnaps, bad);
> +		} else {
> +			info->rsnaps = 0;
> +		}
> +
>  		*p = end;
>  	} else {
>  		if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
> @@ -214,7 +221,7 @@ static int parse_reply_info_in(void **p, void *end,
>  		}
>  
>  		info->dir_pin = -ENODATA;
> -		/* info->snap_btime remains zero */
> +		/* info->snap_btime and info->rsnaps remain zero */
>  	}
>  	return 0;
>  bad:
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bc9e95937d7c..76f2ed1a7cbf 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -88,6 +88,7 @@ struct ceph_mds_reply_info_in {
>  	s32 dir_pin;
>  	struct ceph_timespec btime;
>  	struct ceph_timespec snap_btime;
> +	u64 rsnaps;
>  	u64 change_attr;
>  };
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4c3c964b1c54..eb108b69da71 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -332,7 +332,7 @@ struct ceph_inode_info {
>  
>  	/* for dirs */
>  	struct timespec64 i_rctime;
> -	u64 i_rbytes, i_rfiles, i_rsubdirs;
> +	u64 i_rbytes, i_rfiles, i_rsubdirs, i_rsnaps;
>  	u64 i_files, i_subdirs;
>  
>  	/* quotas */
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 3a733ac33d9b..c7d8ecc3d04b 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -231,6 +231,12 @@ static ssize_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
>  	return ceph_fmt_xattr(val, size, "%lld", ci->i_rsubdirs);
>  }
>  
> +static ssize_t ceph_vxattrcb_dir_rsnaps(struct ceph_inode_info *ci, char *val,
> +					  size_t size)
> +{
> +	return ceph_fmt_xattr(val, size, "%lld", ci->i_rsnaps);
> +}
> +
>  static ssize_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
>  					size_t size)
>  {
> @@ -352,6 +358,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>  	XATTR_RSTAT_FIELD(dir, rentries),
>  	XATTR_RSTAT_FIELD(dir, rfiles),
>  	XATTR_RSTAT_FIELD(dir, rsubdirs),
> +	XATTR_RSTAT_FIELD(dir, rsnaps),
>  	XATTR_RSTAT_FIELD(dir, rbytes),
>  	XATTR_RSTAT_FIELD(dir, rctime),
>  	{

Sorry we missed this one Yanhu. In the future, please put [PATCH] in the
subject line in some fashion and we may spot it more easily.

This looks fine to me -- merged into ceph-client/testing branch, though
I did revise the changelog to be a bit more descriptive. Tell me if you
think it needs changes.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

