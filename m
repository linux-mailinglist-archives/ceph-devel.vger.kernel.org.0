Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883521359B3
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgAINGU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgAINGU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:06:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410202075D;
        Thu,  9 Jan 2020 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578575179;
        bh=axH7W09l6kKa4CCzyrgUSdbPBpjdOOgfOa0kYkBco1s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=piBmbB3XvGE7xFhpP7YKf7dTSbgEatKhe+mCitJOlYu3Y8DHi4jv80wypBkIoKHnZ
         fFxHd7SwD3zccmmB6W3ML6ral8RZY4m7BMpyWHRqGlMW7g+KfwvYNjnJOCMwszMFdh
         ZqfoPznuaFfjJItsjmIzH81zMpXEDrjtQCoRDtik=
Message-ID: <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in
 copy_file_range
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 09 Jan 2020 08:06:17 -0500
In-Reply-To: <20200108100353.23770-1-lhenriques@suse.com>
References: <20200108100353.23770-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> Instead of using the 'copy-from' operation, switch copy_file_range to the
> new 'copy-from2' operation, which allows to send the truncate_seq and
> truncate_size parameters.
> 
> If an OSD does not support the 'copy-from2' operation it will return
> -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> remote object copies for this fs client and will always use the generic
> VFS copy_file_range.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi Jeff,
> 
> This is a follow-up to the discussion in [1].  Since PR [2] has been
> merged, it's now time to change the kernel client to use the new
> 'copy-from2'.  And that's what this patch does.
> 
> [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.com/
> [2] https://github.com/ceph/ceph/pull/31728
> 
>  fs/ceph/file.c                  | 13 ++++++++++++-
>  fs/ceph/super.c                 |  1 +
>  fs/ceph/super.h                 |  3 +++
>  include/linux/ceph/osd_client.h |  1 +
>  include/linux/ceph/rados.h      |  2 ++
>  net/ceph/osd_client.c           | 18 ++++++++++++------
>  6 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 11929d2bb594..1e6cdf2dfe90 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
>  		return -EOPNOTSUPP;
>  
> +	/* Do the OSDs support the 'copy-from2' operation? */
> +	if (!src_fsc->have_copy_from2)
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * Striped file layouts require that we copy partial objects, but the
>  	 * OSD copy-from operation only supports full-object copies.  Limit
> @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
>  			&dst_oid, &dst_oloc,
>  			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> -			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> +			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> +			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> +			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
>  		if (err) {
> +			if (err == -EOPNOTSUPP) {
> +				src_fsc->have_copy_from2 = false;
> +				pr_notice("OSDs don't support 'copy-from2'; "
> +					  "disabling copy_file_range\n");
> +			}
>  			dout("ceph_osdc_copy_from returned %d\n", err);
>  			if (!ret)
>  				ret = err;

The patch itself looks fine to me. I'll not merge yet, since you sent it
as an RFC, but I don't have any objection to it at first glance. The
only other comment I'd make is that you should probably split this into
two patches -- one for the libceph changes and one for cephfs.

On a related note, I wonder if we'd get better performance out of large
copy_file_range calls here if you were to move the wait for all of these
osd requests after issuing them all in parallel?

Currently we're doing:

copy_from
wait
copy_from
wait

...but figure that the second copy_from might very well be between osds
that are not involved in the first copy. There's no reason to do them
sequentially. It'd be better to issue all of the OSD requests first, and
then wait on all of the replies in turn:

copy_from
copy_from
copy_from
...
wait
wait
wait

> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 29a795f975df..b62c487a53af 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -637,6 +637,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	fsc->sb = NULL;
>  	fsc->mount_state = CEPH_MOUNT_MOUNTING;
>  	fsc->filp_gen = 1;
> +	fsc->have_copy_from2 = true;
>  
>  	atomic_long_set(&fsc->writeback_count, 0);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3bf1a01cd536..b2f86bed5c2c 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -106,6 +106,9 @@ struct ceph_fs_client {
>  	unsigned long last_auto_reconnect;
>  	bool blacklisted;
>  
> +	/* Do the OSDs support the 'copy-from2' Op? */
> +	bool have_copy_from2;
> +
>  	u32 filp_gen;
>  	loff_t max_file_size;
>  
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index eaffbdddf89a..5a62dbd3f4c2 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  			struct ceph_object_id *dst_oid,
>  			struct ceph_object_locator *dst_oloc,
>  			u32 dst_fadvise_flags,
> +			u32 truncate_seq, u64 truncate_size,
>  			u8 copy_from_flags);
>  
>  /* watch/notify */
> diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
> index 3eb0e55665b4..59bdfd470100 100644
> --- a/include/linux/ceph/rados.h
> +++ b/include/linux/ceph/rados.h
> @@ -256,6 +256,7 @@ extern const char *ceph_osd_state_name(int s);
>  									    \
>  	/* tiering */							    \
>  	f(COPY_FROM,	__CEPH_OSD_OP(WR, DATA, 26),	"copy-from")	    \
> +	f(COPY_FROM2,	__CEPH_OSD_OP(WR, DATA, 45),	"copy-from2")	    \
>  	f(COPY_GET_CLASSIC, __CEPH_OSD_OP(RD, DATA, 27), "copy-get-classic") \
>  	f(UNDIRTY,	__CEPH_OSD_OP(WR, DATA, 28),	"undirty")	    \
>  	f(ISDIRTY,	__CEPH_OSD_OP(RD, DATA, 29),	"isdirty")	    \
> @@ -446,6 +447,7 @@ enum {
>  	CEPH_OSD_COPY_FROM_FLAG_MAP_SNAP_CLONE = 8, /* map snap direct to
>  						     * cloneid */
>  	CEPH_OSD_COPY_FROM_FLAG_RWORDERED = 16,     /* order with write */
> +	CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ = 32,  /* send truncate_{seq,size} */
>  };
>  
>  enum {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index ba45b074a362..b68b376d8c2f 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -402,7 +402,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
>  	case CEPH_OSD_OP_LIST_WATCHERS:
>  		ceph_osd_data_release(&op->list_watchers.response_data);
>  		break;
> -	case CEPH_OSD_OP_COPY_FROM:
> +	case CEPH_OSD_OP_COPY_FROM2:
>  		ceph_osd_data_release(&op->copy_from.osd_data);
>  		break;
>  	default:
> @@ -697,7 +697,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
>  		case CEPH_OSD_OP_SETXATTR:
>  		case CEPH_OSD_OP_CMPXATTR:
>  		case CEPH_OSD_OP_NOTIFY_ACK:
> -		case CEPH_OSD_OP_COPY_FROM:
> +		case CEPH_OSD_OP_COPY_FROM2:
>  			*num_request_data_items += 1;
>  			break;
>  
> @@ -1029,7 +1029,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
>  	case CEPH_OSD_OP_CREATE:
>  	case CEPH_OSD_OP_DELETE:
>  		break;
> -	case CEPH_OSD_OP_COPY_FROM:
> +	case CEPH_OSD_OP_COPY_FROM2:
>  		dst->copy_from.snapid = cpu_to_le64(src->copy_from.snapid);
>  		dst->copy_from.src_version =
>  			cpu_to_le64(src->copy_from.src_version);
> @@ -1966,7 +1966,7 @@ static void setup_request_data(struct ceph_osd_request *req)
>  			ceph_osdc_msg_data_add(request_msg,
>  					       &op->notify_ack.request_data);
>  			break;
> -		case CEPH_OSD_OP_COPY_FROM:
> +		case CEPH_OSD_OP_COPY_FROM2:
>  			ceph_osdc_msg_data_add(request_msg,
>  					       &op->copy_from.osd_data);
>  			break;
> @@ -5315,6 +5315,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  				     struct ceph_object_locator *src_oloc,
>  				     u32 src_fadvise_flags,
>  				     u32 dst_fadvise_flags,
> +				     u32 truncate_seq, u64 truncate_size,
>  				     u8 copy_from_flags)
>  {
>  	struct ceph_osd_req_op *op;
> @@ -5325,7 +5326,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  	if (IS_ERR(pages))
>  		return PTR_ERR(pages);
>  
> -	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM, dst_fadvise_flags);
> +	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> +			      dst_fadvise_flags);
>  	op->copy_from.snapid = src_snapid;
>  	op->copy_from.src_version = src_version;
>  	op->copy_from.flags = copy_from_flags;
> @@ -5335,6 +5337,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  	end = p + PAGE_SIZE;
>  	ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
>  	encode_oloc(&p, end, src_oloc);
> +	ceph_encode_32(&p, truncate_seq);
> +	ceph_encode_64(&p, truncate_size);
>  	op->indata_len = PAGE_SIZE - (end - p);
>  
>  	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
> @@ -5350,6 +5354,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  			struct ceph_object_id *dst_oid,
>  			struct ceph_object_locator *dst_oloc,
>  			u32 dst_fadvise_flags,
> +			u32 truncate_seq, u64 truncate_size,
>  			u8 copy_from_flags)
>  {
>  	struct ceph_osd_request *req;
> @@ -5366,7 +5371,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  
>  	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
>  					src_oloc, src_fadvise_flags,
> -					dst_fadvise_flags, copy_from_flags);
> +					dst_fadvise_flags, truncate_seq,
> +					truncate_size, copy_from_flags);
>  	if (ret)
>  		goto out;
>  
-- 
Jeff Layton <jlayton@kernel.org>

