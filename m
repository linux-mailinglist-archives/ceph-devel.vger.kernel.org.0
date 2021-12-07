Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFB646C1CC
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Dec 2021 18:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbhLGRfR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Dec 2021 12:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240016AbhLGRfR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Dec 2021 12:35:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826AFC061574
        for <ceph-devel@vger.kernel.org>; Tue,  7 Dec 2021 09:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3394BB81748
        for <ceph-devel@vger.kernel.org>; Tue,  7 Dec 2021 17:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B6C341C3;
        Tue,  7 Dec 2021 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638898303;
        bh=h3KvviYKcmjP96nJH6l5+E/22E7s2SabVzZM+mLU4ag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HFfM6TZLSdyOk3pDhT4o+FqZoVCPbed+O1Uvq4A5092LAj9RPMYbIbj/MhhGeO29o
         cx5P3S/rpDwmAyeCHs/XyKsLC1I79menl29Osc31PxOYLa3VC1UVZLDHPD3mt7iD7u
         Mmy3CWbcjWOyRUMSy6xkebPTXsRIyxB0IU7WaVWgPN+Gl3dJc/cJuyrO1ttALbYsf4
         Ti2D8VmDFrblzD8MBbFTYKZLhk6tpE+wIHPw2MvZhtEb0DpeETd3RLF4Aq07qV6DYW
         aRawJqFwf98z6kUdaWw+ATwaTawsywASN3k1EM6vrfQTAs0GsQfzMFNS+SdnKqzdLn
         gENPYdXxPHNmQ==
Message-ID: <a9c5aa357785e7a67297748e4f257d1486b69a4b.camel@kernel.org>
Subject: Re: [PATCH v6 8/9] ceph: add object version support for sync read
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 07 Dec 2021 12:31:42 -0500
In-Reply-To: <20211104055248.190987-9-xiubli@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
         <20211104055248.190987-9-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-11-04 at 13:52 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The sync read may split the read into several osdc requests, so
> for each it may in different Rados objects.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c  | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h | 18 +++++++++++++++++-
>  2 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 129f6a642f8e..cedd86a6058d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -871,7 +871,8 @@ enum {
>   * only return a short read to the caller if we hit EOF.
>   */
>  ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -			 struct iov_iter *to, int *retry_op)
> +			 struct iov_iter *to, int *retry_op,
> +			 struct ceph_object_vers *objvers)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> @@ -880,6 +881,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  	u64 off = *ki_pos;
>  	u64 len = iov_iter_count(to);
>  	u64 i_size;
> +	u32 object_count = 8;
>  
>  	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>  
> @@ -896,6 +898,15 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  	if (ret < 0)
>  		return ret;
>  
> +	if (objvers) {
> +		objvers->count = 0;
> +		objvers->objvers = kcalloc(object_count,
> +					   sizeof(struct ceph_object_ver),
> +					   GFP_KERNEL);
> +		if (!objvers->objvers)
> +			return -ENOMEM;
> +	}
> +
>  	ret = 0;
>  	while ((len = iov_iter_count(to)) > 0) {
>  		struct ceph_osd_request *req;
> @@ -938,6 +949,30 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  					 req->r_end_latency,
>  					 len, ret);
>  
> +		if (objvers) {
> +			u32 ind = objvers->count;
> +
> +			if (objvers->count >= object_count) {
> +				int ov_size;
> +
> +				object_count *= 2;
> +				ov_size = sizeof(struct ceph_object_ver);
> +				objvers->objvers = krealloc_array(objvers,
> +								  object_count,
> +								  ov_size,
> +								  GFP_KERNEL);
> +				if (!objvers->objvers) {
> +					objvers->count = 0;
> +					ret = -ENOMEM;
> +					break;
> +				}
> +			}
> +
> +			objvers->objvers[ind].offset = off;
> +			objvers->objvers[ind].length = len;
> +			objvers->objvers[ind].objver = req->r_version;
> +			objvers->count++;
> +		}
>  		ceph_osdc_put_request(req);
>  
>  		i_size = i_size_read(inode);
> @@ -995,6 +1030,11 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  	}
>  
>  	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
> +	if (ret < 0 && objvers) {
> +		objvers->count = 0;
> +		kfree(objvers->objvers);
> +		objvers->objvers = NULL;
> +	}
>  	return ret;
>  }
>  
> @@ -1008,7 +1048,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	     (unsigned)iov_iter_count(to),
>  	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>  
> -	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
>  }
>  
>  struct ceph_aio_request {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 2362d758af97..b347b12e86a9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -451,6 +451,21 @@ struct ceph_inode_info {
>  	struct inode vfs_inode; /* at end */
>  };
>  
> +/*
> + * The version of an object which contains the
> + * file range of [offset, offset + length).
> + */
> +struct ceph_object_ver {
> +	u64 offset;
> +	u64 length;
> +	u64 objver;
> +};
> +
> +struct ceph_object_vers {
> +	u32 count;
> +	struct ceph_object_ver *objvers;
> +};
> +
>  static inline struct ceph_inode_info *
>  ceph_inode(const struct inode *inode)
>  {
> @@ -1254,7 +1269,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
>  extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  			    struct file *file, unsigned flags, umode_t mode);
>  extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -				struct iov_iter *to, int *retry_op);
> +				struct iov_iter *to, int *retry_op,
> +				struct ceph_object_vers *objvers);
> 
> 


I think this patch is probably overkill. It's not clear to me what you
gain from tracking the offset and length in the object version.

Reads across multiple objects aren't expected to be atomic in cephfs. It
sucks, but RADOS can't reasonably guarantee that sort of consistency. I
don't think you need to track all of the object versions since you only
care about the last object in the read.

Instead, could we just allow __ceph_sync_read to take a pointer to a u64
instead of struct ceph_object_vers * ? Then just have it fill that out
with the version of the last object in the read.


>  extern int ceph_release(struct inode *inode, struct file *filp);
>  extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>  				  char *data, size_t len);

-- 
Jeff Layton <jlayton@kernel.org>
