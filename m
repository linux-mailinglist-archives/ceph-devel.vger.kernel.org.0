Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD05D135B60
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgAIOay (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 09:30:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:60052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgAIOay (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 09:30:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7159AFEC;
        Thu,  9 Jan 2020 14:30:51 +0000 (UTC)
Date:   Thu, 9 Jan 2020 14:30:50 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in
 copy_file_range
Message-ID: <20200109143011.GA14582@brahms>
References: <20200108100353.23770-1-lhenriques@suse.com>
 <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 09, 2020 at 08:06:17AM -0500, Jeff Layton wrote:
> On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> > Instead of using the 'copy-from' operation, switch copy_file_range to the
> > new 'copy-from2' operation, which allows to send the truncate_seq and
> > truncate_size parameters.
> > 
> > If an OSD does not support the 'copy-from2' operation it will return
> > -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> > remote object copies for this fs client and will always use the generic
> > VFS copy_file_range.
> > 
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> > Hi Jeff,
> > 
> > This is a follow-up to the discussion in [1].  Since PR [2] has been
> > merged, it's now time to change the kernel client to use the new
> > 'copy-from2'.  And that's what this patch does.
> > 
> > [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.com/
> > [2] https://github.com/ceph/ceph/pull/31728
> > 
> >  fs/ceph/file.c                  | 13 ++++++++++++-
> >  fs/ceph/super.c                 |  1 +
> >  fs/ceph/super.h                 |  3 +++
> >  include/linux/ceph/osd_client.h |  1 +
> >  include/linux/ceph/rados.h      |  2 ++
> >  net/ceph/osd_client.c           | 18 ++++++++++++------
> >  6 files changed, 31 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 11929d2bb594..1e6cdf2dfe90 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >  	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* Do the OSDs support the 'copy-from2' operation? */
> > +	if (!src_fsc->have_copy_from2)
> > +		return -EOPNOTSUPP;
> > +
> >  	/*
> >  	 * Striped file layouts require that we copy partial objects, but the
> >  	 * OSD copy-from operation only supports full-object copies.  Limit
> > @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >  			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> >  			&dst_oid, &dst_oloc,
> >  			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> > -			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > +			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > +			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > +			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> >  		if (err) {
> > +			if (err == -EOPNOTSUPP) {
> > +				src_fsc->have_copy_from2 = false;
> > +				pr_notice("OSDs don't support 'copy-from2'; "
> > +					  "disabling copy_file_range\n");
> > +			}
> >  			dout("ceph_osdc_copy_from returned %d\n", err);
> >  			if (!ret)
> >  				ret = err;
> 
> The patch itself looks fine to me. I'll not merge yet, since you sent it
> as an RFC, but I don't have any objection to it at first glance.

I was going to drop the RFC, but then at the last minute decided to leave.

>                                                                    The
> only other comment I'd make is that you should probably split this into
> two patches -- one for the libceph changes and one for cephfs.

Hmm... TBH I didn't thought about that, but since the libceph patch would
be changing its API (ceph_osdc_copy_from would have 2 extra parameters), I
don't think that's a good idea.  Bisection would be broken between these 2
patches.

> 
> On a related note, I wonder if we'd get better performance out of large
> copy_file_range calls here if you were to move the wait for all of these
> osd requests after issuing them all in parallel?
> 
> Currently we're doing:
> 
> copy_from
> wait
> copy_from
> wait
> 
> ...but figure that the second copy_from might very well be between osds
> that are not involved in the first copy. There's no reason to do them
> sequentially. It'd be better to issue all of the OSD requests first, and
> then wait on all of the replies in turn:
> 
> copy_from
> copy_from
> copy_from
> ...
> wait
> wait
> wait

Ah!  It looks like you've been looking into my TODO list :-)

In fact I was discussing copy_file_range performance with some colleagues
just before the EOY break and one of the things I had decided to
experiment was to parallelize the 'copy-from' requests.  I haven't looked
yet at the details, but I expect to be looking into that soon(ish).

Thanks for your review and suggestion.

Cheers,
--
Luís

> 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 29a795f975df..b62c487a53af 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -637,6 +637,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >  	fsc->sb = NULL;
> >  	fsc->mount_state = CEPH_MOUNT_MOUNTING;
> >  	fsc->filp_gen = 1;
> > +	fsc->have_copy_from2 = true;
> >  
> >  	atomic_long_set(&fsc->writeback_count, 0);
> >  
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 3bf1a01cd536..b2f86bed5c2c 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -106,6 +106,9 @@ struct ceph_fs_client {
> >  	unsigned long last_auto_reconnect;
> >  	bool blacklisted;
> >  
> > +	/* Do the OSDs support the 'copy-from2' Op? */
> > +	bool have_copy_from2;
> > +
> >  	u32 filp_gen;
> >  	loff_t max_file_size;
> >  
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index eaffbdddf89a..5a62dbd3f4c2 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >  			struct ceph_object_id *dst_oid,
> >  			struct ceph_object_locator *dst_oloc,
> >  			u32 dst_fadvise_flags,
> > +			u32 truncate_seq, u64 truncate_size,
> >  			u8 copy_from_flags);
> >  
> >  /* watch/notify */
> > diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
> > index 3eb0e55665b4..59bdfd470100 100644
> > --- a/include/linux/ceph/rados.h
> > +++ b/include/linux/ceph/rados.h
> > @@ -256,6 +256,7 @@ extern const char *ceph_osd_state_name(int s);
> >  									    \
> >  	/* tiering */							    \
> >  	f(COPY_FROM,	__CEPH_OSD_OP(WR, DATA, 26),	"copy-from")	    \
> > +	f(COPY_FROM2,	__CEPH_OSD_OP(WR, DATA, 45),	"copy-from2")	    \
> >  	f(COPY_GET_CLASSIC, __CEPH_OSD_OP(RD, DATA, 27), "copy-get-classic") \
> >  	f(UNDIRTY,	__CEPH_OSD_OP(WR, DATA, 28),	"undirty")	    \
> >  	f(ISDIRTY,	__CEPH_OSD_OP(RD, DATA, 29),	"isdirty")	    \
> > @@ -446,6 +447,7 @@ enum {
> >  	CEPH_OSD_COPY_FROM_FLAG_MAP_SNAP_CLONE = 8, /* map snap direct to
> >  						     * cloneid */
> >  	CEPH_OSD_COPY_FROM_FLAG_RWORDERED = 16,     /* order with write */
> > +	CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ = 32,  /* send truncate_{seq,size} */
> >  };
> >  
> >  enum {
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index ba45b074a362..b68b376d8c2f 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -402,7 +402,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
> >  	case CEPH_OSD_OP_LIST_WATCHERS:
> >  		ceph_osd_data_release(&op->list_watchers.response_data);
> >  		break;
> > -	case CEPH_OSD_OP_COPY_FROM:
> > +	case CEPH_OSD_OP_COPY_FROM2:
> >  		ceph_osd_data_release(&op->copy_from.osd_data);
> >  		break;
> >  	default:
> > @@ -697,7 +697,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
> >  		case CEPH_OSD_OP_SETXATTR:
> >  		case CEPH_OSD_OP_CMPXATTR:
> >  		case CEPH_OSD_OP_NOTIFY_ACK:
> > -		case CEPH_OSD_OP_COPY_FROM:
> > +		case CEPH_OSD_OP_COPY_FROM2:
> >  			*num_request_data_items += 1;
> >  			break;
> >  
> > @@ -1029,7 +1029,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
> >  	case CEPH_OSD_OP_CREATE:
> >  	case CEPH_OSD_OP_DELETE:
> >  		break;
> > -	case CEPH_OSD_OP_COPY_FROM:
> > +	case CEPH_OSD_OP_COPY_FROM2:
> >  		dst->copy_from.snapid = cpu_to_le64(src->copy_from.snapid);
> >  		dst->copy_from.src_version =
> >  			cpu_to_le64(src->copy_from.src_version);
> > @@ -1966,7 +1966,7 @@ static void setup_request_data(struct ceph_osd_request *req)
> >  			ceph_osdc_msg_data_add(request_msg,
> >  					       &op->notify_ack.request_data);
> >  			break;
> > -		case CEPH_OSD_OP_COPY_FROM:
> > +		case CEPH_OSD_OP_COPY_FROM2:
> >  			ceph_osdc_msg_data_add(request_msg,
> >  					       &op->copy_from.osd_data);
> >  			break;
> > @@ -5315,6 +5315,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >  				     struct ceph_object_locator *src_oloc,
> >  				     u32 src_fadvise_flags,
> >  				     u32 dst_fadvise_flags,
> > +				     u32 truncate_seq, u64 truncate_size,
> >  				     u8 copy_from_flags)
> >  {
> >  	struct ceph_osd_req_op *op;
> > @@ -5325,7 +5326,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >  	if (IS_ERR(pages))
> >  		return PTR_ERR(pages);
> >  
> > -	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM, dst_fadvise_flags);
> > +	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> > +			      dst_fadvise_flags);
> >  	op->copy_from.snapid = src_snapid;
> >  	op->copy_from.src_version = src_version;
> >  	op->copy_from.flags = copy_from_flags;
> > @@ -5335,6 +5337,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >  	end = p + PAGE_SIZE;
> >  	ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
> >  	encode_oloc(&p, end, src_oloc);
> > +	ceph_encode_32(&p, truncate_seq);
> > +	ceph_encode_64(&p, truncate_size);
> >  	op->indata_len = PAGE_SIZE - (end - p);
> >  
> >  	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
> > @@ -5350,6 +5354,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >  			struct ceph_object_id *dst_oid,
> >  			struct ceph_object_locator *dst_oloc,
> >  			u32 dst_fadvise_flags,
> > +			u32 truncate_seq, u64 truncate_size,
> >  			u8 copy_from_flags)
> >  {
> >  	struct ceph_osd_request *req;
> > @@ -5366,7 +5371,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >  
> >  	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
> >  					src_oloc, src_fadvise_flags,
> > -					dst_fadvise_flags, copy_from_flags);
> > +					dst_fadvise_flags, truncate_seq,
> > +					truncate_size, copy_from_flags);
> >  	if (ret)
> >  		goto out;
> >  
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
