Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FF84E2A80
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Mar 2022 15:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347398AbiCUOZL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Mar 2022 10:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352779AbiCUOW6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Mar 2022 10:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4D11AECA7
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 07:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21BC1612F2
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 14:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3344EC340EE;
        Mon, 21 Mar 2022 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647872238;
        bh=W4r5OC2Pe6NjdZNlJNgcmzDBerGspoMJU2y6+1BWvas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gIy7V6+748RH7bcte6bdKHBCrGBSOdLd0aeyKP1y8G+IkHXaqE3GuVhVEdaxox79y
         TezUbuAQZ+8K9/zNdXdlIIwa9IhHUr8xxvsxIE/bDo+LgoX7mJw9+jiP0rMJwUZS1W
         4V9oz7ynrdMMaNKNB/aByntldKJC0RpGmI48bq3AZtdA7T5NzJ85fTmXe/aFh6y3YB
         lGpXCuwY41jVXQ7MFE7vtYjdJYoM+qoYYQeUvUA20XnuPMOr0AFa9oYhbreTLLXzEG
         IwD8ZVPqCZKtlZ2e5ns35MxY9jNs/zHMoPp6ZWB6NpsWNoP1xJb0B/jk07f9lrj8MN
         OhBBkTDLQB5vA==
Message-ID: <6c9920d568f225623a9fb6ae456eb5e061abe428.camel@kernel.org>
Subject: Re: [PATCH v3 4/5] libceph: add sparse read support to OSD client
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 21 Mar 2022 10:17:16 -0400
In-Reply-To: <20220318135013.43934-5-jlayton@kernel.org>
References: <20220318135013.43934-1-jlayton@kernel.org>
         <20220318135013.43934-5-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-03-18 at 09:50 -0400, Jeff Layton wrote:
> Add a new sparse_read operation for the OSD client, driven by its own
> state machine. The messenger can repeatedly call the sparse_read
> operation, and it will pass back the necessary info to set up to read
> the next extent of data, while zero-filling the sparse regions.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/osd_client.h |  32 +++++
>  net/ceph/osd_client.c           | 238 +++++++++++++++++++++++++++++++-
>  2 files changed, 266 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 00a5b53a6763..2c5f9eb7d888 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -40,6 +40,36 @@ struct ceph_sparse_extent {
>  	u64	len;
>  } __attribute__((packed));
>  
> +/* Sparse read state machine state values */
> +enum ceph_sparse_read_state {
> +	CEPH_SPARSE_READ_HDR	= 0,
> +	CEPH_SPARSE_READ_EXTENTS,
> +	CEPH_SPARSE_READ_DATA_LEN,
> +	CEPH_SPARSE_READ_DATA,
> +};
> +
> +/*
> + * A SPARSE_READ reply is a 32-bit count of extents, followed by an array of
> + * 64-bit offset/length pairs, and then all of the actual file data
> + * concatenated after it (sans holes).
> + *
> + * Unfortunately, we don't know how long the extent array is until we've
> + * started reading the data section of the reply. The caller should send down
> + * a destination buffer for the array, but we'll alloc one if it's too small
> + * or if the caller doesn't.
> + */
> +struct ceph_sparse_read {
> +	enum ceph_sparse_read_state	sr_state;	/* state machine state */
> +	u64				sr_req_off;	/* orig request offset */
> +	u64				sr_req_len;	/* orig request length */
> +	u64				sr_pos;		/* current pos in buffer */
> +	int				sr_index;	/* current extent index */
> +	__le32				sr_datalen;	/* length of actual data */
> +	u32				sr_count;	/* extent count in reply */
> +	int				sr_ext_len;	/* length of extent array */
> +	struct ceph_sparse_extent	*sr_extent;	/* extent array */
> +};
> +
>  /*
>   * A given osd we're communicating with.
>   *
> @@ -48,6 +78,7 @@ struct ceph_sparse_extent {
>   */
>  struct ceph_osd {
>  	refcount_t o_ref;
> +	int o_sparse_op_idx;
>  	struct ceph_osd_client *o_osdc;
>  	int o_osd;
>  	int o_incarnation;
> @@ -63,6 +94,7 @@ struct ceph_osd {
>  	unsigned long lru_ttl;
>  	struct list_head o_keepalive_item;
>  	struct mutex lock;
> +	struct ceph_sparse_read	o_sparse_read;
>  };
>  
>  #define CEPH_OSD_SLAB_OPS	2
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9fec258e1f8d..3694696c8a31 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -376,6 +376,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
>  
>  	switch (op->op) {
>  	case CEPH_OSD_OP_READ:
> +	case CEPH_OSD_OP_SPARSE_READ:
>  	case CEPH_OSD_OP_WRITE:
>  	case CEPH_OSD_OP_WRITEFULL:
>  		kfree(op->extent.sparse_ext);
> @@ -707,6 +708,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
>  		/* reply */
>  		case CEPH_OSD_OP_STAT:
>  		case CEPH_OSD_OP_READ:
> +		case CEPH_OSD_OP_SPARSE_READ:
>  		case CEPH_OSD_OP_LIST_WATCHERS:
>  			*num_reply_data_items += 1;
>  			break;
> @@ -776,7 +778,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
>  	       opcode != CEPH_OSD_OP_WRITEFULL && opcode != CEPH_OSD_OP_ZERO &&
> -	       opcode != CEPH_OSD_OP_TRUNCATE);
> +	       opcode != CEPH_OSD_OP_TRUNCATE && opcode != CEPH_OSD_OP_SPARSE_READ);
>  
>  	op->extent.offset = offset;
>  	op->extent.length = length;
> @@ -985,6 +987,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
>  	case CEPH_OSD_OP_STAT:
>  		break;
>  	case CEPH_OSD_OP_READ:
> +	case CEPH_OSD_OP_SPARSE_READ:
>  	case CEPH_OSD_OP_WRITE:
>  	case CEPH_OSD_OP_WRITEFULL:
>  	case CEPH_OSD_OP_ZERO:
> @@ -1081,7 +1084,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
>  	       opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
> -	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
> +	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE &&
> +	       opcode != CEPH_OSD_OP_SPARSE_READ);
>  
>  	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
>  					GFP_NOFS);
> @@ -1222,6 +1226,13 @@ static void osd_init(struct ceph_osd *osd)
>  	mutex_init(&osd->lock);
>  }
>  
> +static void ceph_init_sparse_read(struct ceph_sparse_read *sr)
> +{
> +	kfree(sr->sr_extent);
> +	memset(sr, '\0', sizeof(*sr));
> +	sr->sr_state = CEPH_SPARSE_READ_HDR;
> +}
> +
>  static void osd_cleanup(struct ceph_osd *osd)
>  {
>  	WARN_ON(!RB_EMPTY_NODE(&osd->o_node));
> @@ -1232,6 +1243,8 @@ static void osd_cleanup(struct ceph_osd *osd)
>  	WARN_ON(!list_empty(&osd->o_osd_lru));
>  	WARN_ON(!list_empty(&osd->o_keepalive_item));
>  
> +	ceph_init_sparse_read(&osd->o_sparse_read);
> +
>  	if (osd->o_auth.authorizer) {
>  		WARN_ON(osd_homeless(osd));
>  		ceph_auth_destroy_authorizer(osd->o_auth.authorizer);
> @@ -1251,6 +1264,9 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
>  	osd_init(osd);
>  	osd->o_osdc = osdc;
>  	osd->o_osd = onum;
> +	osd->o_sparse_op_idx = -1;
> +
> +	ceph_init_sparse_read(&osd->o_sparse_read);
>  
>  	ceph_con_init(&osd->o_con, osd, &osd_con_ops, &osdc->client->msgr);
>  
> @@ -2055,6 +2071,7 @@ static void setup_request_data(struct ceph_osd_request *req)
>  					       &op->raw_data_in);
>  			break;
>  		case CEPH_OSD_OP_READ:
> +		case CEPH_OSD_OP_SPARSE_READ:
>  			ceph_osdc_msg_data_add(reply_msg,
>  					       &op->extent.osd_data);
>  			break;
> @@ -2470,8 +2487,10 @@ static void finish_request(struct ceph_osd_request *req)
>  
>  	req->r_end_latency = ktime_get();
>  
> -	if (req->r_osd)
> +	if (req->r_osd) {
> +		ceph_init_sparse_read(&req->r_osd->o_sparse_read);
>  		unlink_request(req->r_osd, req);
> +	}
>  	atomic_dec(&osdc->num_requests);
>  
>  	/*
> @@ -5416,6 +5435,24 @@ static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  	ceph_msg_put(msg);
>  }
>  
> +/* How much sparse data was requested? */
> +static u64 sparse_data_requested(struct ceph_osd_request *req)
> +{
> +	u64 len = 0;
> +
> +	if (req->r_flags & CEPH_OSD_FLAG_READ) {
> +		int i;
> +
> +		for (i = 0; i < req->r_num_ops; ++i) {
> +			struct ceph_osd_req_op *op = &req->r_ops[i];
> +
> +			if (op->op == CEPH_OSD_OP_SPARSE_READ)
> +				len += op->extent.length;
> +		}
> +	}
> +	return len;
> +}
> +
>  /*
>   * Lookup and return message for incoming reply.  Don't try to do
>   * anything about a larger than preallocated data portion of the
> @@ -5432,6 +5469,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  	int front_len = le32_to_cpu(hdr->front_len);
>  	int data_len = le32_to_cpu(hdr->data_len);
>  	u64 tid = le64_to_cpu(hdr->tid);
> +	u64 srlen;
>  
>  	down_read(&osdc->lock);
>  	if (!osd_registered(osd)) {
> @@ -5464,7 +5502,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  		req->r_reply = m;
>  	}
>  
> -	if (data_len > req->r_reply->data_length) {
> +	srlen = sparse_data_requested(req);
> +	if (!srlen && (data_len > req->r_reply->data_length)) {
>  		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
>  			__func__, osd->o_osd, req->r_tid, data_len,
>  			req->r_reply->data_length);
> @@ -5474,6 +5513,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  	}
>  
>  	m = ceph_msg_get(req->r_reply);
> +	m->sparse_read = (bool)srlen;
> +
>  	dout("get_reply tid %lld %p\n", tid, m);
>  
>  out_unlock_session:
> @@ -5706,9 +5747,198 @@ static int osd_check_message_signature(struct ceph_msg *msg)
>  	return ceph_auth_check_message_signature(auth, msg);
>  }
>  
> +static void advance_cursor(struct ceph_msg_data_cursor *cursor, size_t len, bool zero)
> +{
> +	while (len) {
> +		struct page *page;
> +		size_t poff, plen;
> +		bool last = false;
> +
> +		page = ceph_msg_data_next(cursor, &poff, &plen, &last);
> +		if (plen > len)
> +			plen = len;
> +		if (zero)
> +			zero_user_segment(page, poff, poff + plen);
> +		len -= plen;
> +		ceph_msg_data_advance(cursor, plen);
> +	}
> +}
> +
> +static int prep_next_sparse_read(struct ceph_connection *con,
> +				 struct ceph_msg_data_cursor *cursor)
> +{
> +	struct ceph_osd *o = con->private;
> +	struct ceph_sparse_read *sr = &o->o_sparse_read;
> +	struct ceph_osd_request *req;
> +	struct ceph_osd_req_op *op;
> +
> +	spin_lock(&o->o_requests_lock);
> +	req = lookup_request(&o->o_requests, le64_to_cpu(con->in_msg->hdr.tid));
> +	if (!req) {
> +		spin_unlock(&o->o_requests_lock);
> +		return -EBADR;
> +	}
> +
> +	if (o->o_sparse_op_idx < 0) {
> +		u64 srlen = sparse_data_requested(req);
> +
> +		dout("%s: [%d] starting new sparse read req. srlen=0x%llx\n",
> +			__func__, o->o_osd, srlen);
> +		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
> +	} else {
> +		op = &req->r_ops[o->o_sparse_op_idx];
> +
> +		WARN_ON_ONCE(op->extent.sparse_ext);
> +
> +		/* hand back buffer we took earlier */
> +		op->extent.sparse_ext = sr->sr_extent;
> +		sr->sr_extent = NULL;
> +		op->extent.sparse_ext_len = sr->sr_count;
> +		sr->sr_ext_len = 0;
> +		dout("%s: [%d] completed extent array len %d cursor->resid %zd\n",
> +			__func__, o->o_osd, op->extent.sparse_ext_len,
> +			cursor->resid);
> +		/*
> +		 * FIXME: Need to advance to the next data item here, in the
> +		 * event that there are multiple sparse read requests. Is this
> +		 * the right way to do that?
> +		 */
> +		if (cursor->resid)
> +			advance_cursor(cursor, cursor->resid, false);

As I suspected, the above is wrong. I was hoping that cursor->resid
would hold the residual data in the current data item, and it does when
the read is shorter than requested. When it's not though, then this ends
up advancing too far.

It's not a problem with this patchset alone since nothing in here issues
requests with multiple sparse reads, but in the current fscrypt set, it
does and this falls over.

I have a fix in my tree I'm testing now, and it seems to be OK. I'll
post a revised patchset in the near future (along with the var name
change that Xiubo requested).

> +	}
> +
> +	ceph_init_sparse_read(sr);
> +
> +	/* find next op in this request (if any) */
> +	while (++o->o_sparse_op_idx < req->r_num_ops) {
> +		op = &req->r_ops[o->o_sparse_op_idx];
> +		if (op->op == CEPH_OSD_OP_SPARSE_READ)
> +			goto found;
> +	}
> +
> +	/* reset for next sparse read request */
> +	spin_unlock(&o->o_requests_lock);
> +	o->o_sparse_op_idx = -1;
> +	return 0;
> +found:
> +	sr->sr_req_off = op->extent.offset;
> +	sr->sr_req_len = op->extent.length;
> +	sr->sr_pos = sr->sr_req_off;
> +	dout("%s: [%d] new sparse read op at idx %d 0x%llx~0x%llx\n", __func__,
> +		o->o_osd, o->o_sparse_op_idx, sr->sr_req_off, sr->sr_req_len);
> +
> +	/* hand off request's sparse extent map buffer */
> +	sr->sr_ext_len = op->extent.sparse_ext_len;
> +	op->extent.sparse_ext_len = 0;
> +	sr->sr_extent = op->extent.sparse_ext;
> +	op->extent.sparse_ext = NULL;
> +
> +	spin_unlock(&o->o_requests_lock);
> +	return 1;
> +}
> +
> +#ifdef __BIG_ENDIAN
> +static inline void convert_extent_map(struct ceph_sparse_read *sr)
> +{
> +	int i;
> +
> +	for (i = 0; i < sr->sr_count; i++) {
> +		struct ceph_sparse_extent *ext = sr->sr_extent[i];
> +
> +		ext->off = le64_to_cpu((__force __le32)ext->off);
> +		ext->len = le64_to_cpu((__force __le32)ext->len);
> +	}
> +}
> +#else
> +static inline void convert_extent_map(struct ceph_sparse_read *sr)
> +{
> +}
> +#endif
> +
> +static int osd_sparse_read(struct ceph_connection *con,
> +			   struct ceph_msg_data_cursor *cursor,
> +			   u64 *plen, char **pbuf)
> +{
> +	struct ceph_osd *o = con->private;
> +	struct ceph_sparse_read *sr = &o->o_sparse_read;
> +	u32 count = sr->sr_count;
> +	u64 eoff, elen;
> +	int ret;
> +
> +	switch (sr->sr_state) {
> +	case CEPH_SPARSE_READ_HDR:
> +next_op:
> +		ret = prep_next_sparse_read(con, cursor);
> +		if (ret <= 0)
> +			return ret;
> +
> +		/* number of extents */
> +		*plen = sizeof(sr->sr_count);
> +		*pbuf = (char *)&sr->sr_count;
> +		sr->sr_state = CEPH_SPARSE_READ_EXTENTS;
> +		break;
> +	case CEPH_SPARSE_READ_EXTENTS:
> +		/* Convert sr_count to host-endian */
> +		count = le32_to_cpu((__force __le32)sr->sr_count);
> +		sr->sr_count = count;
> +		dout("[%d] got %u extents\n", o->o_osd, count);
> +
> +		if (count > 0) {
> +			if (!sr->sr_extent || count > sr->sr_ext_len) {
> +				/* no extent array provided, or too short */
> +				kfree(sr->sr_extent);
> +				sr->sr_extent = kmalloc_array(count, sizeof(*sr->sr_extent),
> +							   GFP_NOIO);
> +				if (!sr->sr_extent)
> +					return -ENOMEM;
> +				sr->sr_ext_len = count;
> +			}
> +			*plen = count * sizeof(*sr->sr_extent);
> +			*pbuf = (char *)sr->sr_extent;
> +			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
> +			break;
> +		}
> +		/* No extents? Fall through to reading data len */
> +		fallthrough;
> +	case CEPH_SPARSE_READ_DATA_LEN:
> +		convert_extent_map(sr);
> +		*plen = sizeof(sr->sr_datalen);
> +		*pbuf = (char *)&sr->sr_datalen;
> +		sr->sr_state = CEPH_SPARSE_READ_DATA;
> +		break;
> +	case CEPH_SPARSE_READ_DATA:
> +		if (sr->sr_index >= count) {
> +			sr->sr_state = CEPH_SPARSE_READ_HDR;
> +			goto next_op;
> +		}
> +
> +		eoff = sr->sr_extent[sr->sr_index].off;
> +		elen = sr->sr_extent[sr->sr_index].len;
> +
> +		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
> +		     o->o_osd, sr->sr_index, eoff, elen);
> +
> +		/* zero out anything from sr_pos to start of extent */
> +		if (sr->sr_pos < eoff)
> +			advance_cursor(cursor, eoff - sr->sr_pos, true);
> +
> +		/* Set position to end of extent */
> +		sr->sr_pos = eoff + elen;
> +
> +		/* send back the new length */
> +		*plen = elen;
> +
> +		/* Bump the array index */
> +		++sr->sr_index;
> +		break;
> +	}
> +	return 1;
> +}
> +
>  static const struct ceph_connection_operations osd_con_ops = {
>  	.get = osd_get_con,
>  	.put = osd_put_con,
> +	.sparse_read = osd_sparse_read,
>  	.alloc_msg = osd_alloc_msg,
>  	.dispatch = osd_dispatch,
>  	.fault = osd_fault,

-- 
Jeff Layton <jlayton@kernel.org>
