Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C268A4D673A
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 18:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbiCKRJg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 12:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiCKRJg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 12:09:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5724ED3AE7
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 09:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E592A61DB1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 17:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EA8C340E9;
        Fri, 11 Mar 2022 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647018511;
        bh=0pslD3EZORaH9er1+tNoe9cFnGeBtyBpkY0+xjOF9bY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=am97PlEaIi3F95cQ033Xt7Y81K4WtcfNJ4NG8k1v9+gbJNREE/ab1O6XHOnA0oz/M
         ZfMd1QxxFxGg3Dg/8nUtkRt8afNwRfZyOQK+9tYR/NEr2OJFKzztIu9BcX2ljrygqD
         Dz+4Vc+Br+4Dq1rNNJ9C2YfECLII1RFQRy3xqln2ctElc4yUnfFzsY+ETPqZhA74u2
         TPZyABDfIcj8ktm8Ugo5BUTMO2puXI0fuy+9cPyk6jKVoITj855KScRdZg0urDgskP
         2saxQY0LlQHm/OVuu0mtXE4hXkwId8a8M1ZmuFCy4ZBrjcaARa2hJWFgUWEFyUwV0d
         tMDsHSARTJBQQ==
Message-ID: <3dd18cbe5853b2c0ac46391e2c298a8967c9ec64.camel@kernel.org>
Subject: Re: [PATCH 2/3] libceph: add sparse read support to OSD client
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Fri, 11 Mar 2022 12:08:29 -0500
In-Reply-To: <20220309123323.20593-3-jlayton@kernel.org>
References: <20220309123323.20593-1-jlayton@kernel.org>
         <20220309123323.20593-3-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-09 at 07:33 -0500, Jeff Layton wrote:
> Add a new sparse_read operation for the OSD client, driven by its own
> state machine. The messenger can repeatedly call the sparse_read
> operation, and it will pass back the necessary info to set up to read
> the next extent of data, while zeroing in the sparse regions.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/osd_client.h |  38 ++++++++
>  net/ceph/osd_client.c           | 163 ++++++++++++++++++++++++++++++--
>  2 files changed, 194 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 3431011f364d..42eb1628a66d 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -29,6 +29,43 @@ typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *);
>  
>  #define CEPH_HOMELESS_OSD	-1
>  
> +enum ceph_sparse_read_state {
> +	CEPH_SPARSE_READ_HDR	= 0,
> +	CEPH_SPARSE_READ_EXTENTS,
> +	CEPH_SPARSE_READ_DATA_LEN,
> +	CEPH_SPARSE_READ_DATA,
> +};
> +
> +/* A single extent in a SPARSE_READ reply */
> +struct ceph_sparse_extent {
> +	__le64	off;
> +	__le64	len;
> +} __attribute__((packed));
> +
> +/*
> + * A SPARSE_READ reply is a 32-bit count of extents, followed by an array of
> + * 64-bit offset/length pairs, and then all of the actual file data
> + * concatenated after it (sans holes).
> + *
> + * Unfortunately, we don't know how long the extent array is until we've
> + * started reading the data section of the reply, so for a real sparse read, we
> + * have to allocate the array after alloc_msg returns.
> + *
> + * For the common case of a single extent, we keep an embedded extent here so
> + * we can avoid the extra allocation.
> + */
> +struct ceph_sparse_read {
> +	enum ceph_sparse_read_state	sr_state;	/* state machine state */
> +	u64				sr_req_off;	/* orig request offset */
> +	u64				sr_req_len;	/* orig request length */
> +	u64				sr_pos;		/* current pos in buffer */
> +	int				sr_index;	/* current extent index */
> +	__le32				sr_datalen;	/* length of actual data */
> +	__le32				sr_count;	/* extent count */
> +	struct ceph_sparse_extent	*sr_extent;	/* extent array */
> +	struct ceph_sparse_extent	sr_emb_ext[1];	/* embedded extent */
> +};
> +
>  /* a given osd we're communicating with */
>  struct ceph_osd {
>  	refcount_t o_ref;
> @@ -46,6 +83,7 @@ struct ceph_osd {
>  	unsigned long lru_ttl;
>  	struct list_head o_keepalive_item;
>  	struct mutex lock;
> +	struct ceph_sparse_read	o_sparse_read;
>  };
>  
>  #define CEPH_OSD_SLAB_OPS	2
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 1c5815530e0d..f519b5727ee3 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -376,6 +376,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
>  
>  	switch (op->op) {
>  	case CEPH_OSD_OP_READ:
> +	case CEPH_OSD_OP_SPARSE_READ:
>  	case CEPH_OSD_OP_WRITE:
>  	case CEPH_OSD_OP_WRITEFULL:
>  		ceph_osd_data_release(&op->extent.osd_data);
> @@ -706,6 +707,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
>  		/* reply */
>  		case CEPH_OSD_OP_STAT:
>  		case CEPH_OSD_OP_READ:
> +		case CEPH_OSD_OP_SPARSE_READ:
>  		case CEPH_OSD_OP_LIST_WATCHERS:
>  			*num_reply_data_items += 1;
>  			break;
> @@ -775,7 +777,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
>  	       opcode != CEPH_OSD_OP_WRITEFULL && opcode != CEPH_OSD_OP_ZERO &&
> -	       opcode != CEPH_OSD_OP_TRUNCATE);
> +	       opcode != CEPH_OSD_OP_TRUNCATE && opcode != CEPH_OSD_OP_SPARSE_READ);
>  
>  	op->extent.offset = offset;
>  	op->extent.length = length;
> @@ -984,6 +986,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
>  	case CEPH_OSD_OP_STAT:
>  		break;
>  	case CEPH_OSD_OP_READ:
> +	case CEPH_OSD_OP_SPARSE_READ:
>  	case CEPH_OSD_OP_WRITE:
>  	case CEPH_OSD_OP_WRITEFULL:
>  	case CEPH_OSD_OP_ZERO:
> @@ -1080,7 +1083,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
>  	       opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
> -	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
> +	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE &&
> +	       opcode != CEPH_OSD_OP_SPARSE_READ);
>  
>  	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
>  					GFP_NOFS);
> @@ -2037,6 +2041,7 @@ static void setup_request_data(struct ceph_osd_request *req)
>  					       &op->raw_data_in);
>  			break;
>  		case CEPH_OSD_OP_READ:
> +		case CEPH_OSD_OP_SPARSE_READ:
>  			ceph_osdc_msg_data_add(reply_msg,
>  					       &op->extent.osd_data);
>  			break;
> @@ -2443,6 +2448,21 @@ static void submit_request(struct ceph_osd_request *req, bool wrlocked)
>  	__submit_request(req, wrlocked);
>  }
>  
> +static void ceph_init_sparse_read(struct ceph_sparse_read *sr, struct ceph_osd_req_op *op)
> +{
> +	if (sr->sr_extent != sr->sr_emb_ext)
> +		kfree(sr->sr_extent);
> +	sr->sr_state = CEPH_SPARSE_READ_HDR;
> +	sr->sr_req_off = op ? op->extent.offset : 0;
> +	sr->sr_req_len = op ? op->extent.length : 0;
> +	sr->sr_pos = sr->sr_req_off;
> +	sr->sr_index = 0;
> +	sr->sr_count = 0;
> +	sr->sr_extent = sr->sr_emb_ext;
> +	sr->sr_extent[0].off = 0;
> +	sr->sr_extent[0].len = 0;
> +}
> +

I think that this patch also needs make osd_cleanup() call
ceph_init_sparse_read as well, to ensure that we kfree the sr_extent (if
there was one and the previous call didn't complete). Fixed in my
tree...

>  static void finish_request(struct ceph_osd_request *req)
>  {
>  	struct ceph_osd_client *osdc = req->r_osdc;
> @@ -2452,8 +2472,10 @@ static void finish_request(struct ceph_osd_request *req)
>  
>  	req->r_end_latency = ktime_get();
>  
> -	if (req->r_osd)
> +	if (req->r_osd) {
> +		ceph_init_sparse_read(&req->r_osd->o_sparse_read, NULL);
>  		unlink_request(req->r_osd, req);
> +	}
>  	atomic_dec(&osdc->num_requests);
>  
>  	/*
> @@ -3655,6 +3677,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>  	struct MOSDOpReply m;
>  	u64 tid = le64_to_cpu(msg->hdr.tid);
>  	u32 data_len = 0;
> +	u32 result_len = 0;
> +	bool sparse = false;
>  	int ret;
>  	int i;
>  
> @@ -3749,21 +3773,32 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>  		req->r_ops[i].rval = m.rval[i];
>  		req->r_ops[i].outdata_len = m.outdata_len[i];
>  		data_len += m.outdata_len[i];
> +		if (req->r_ops[i].op == CEPH_OSD_OP_SPARSE_READ)
> +			sparse = true;
>  	}
> +
> +	result_len = data_len;
> +	if (sparse) {
> +		struct ceph_sparse_read *sr = &osd->o_sparse_read;
> +
> +		/* Fudge the result if this was a sparse read. */
> +		result_len = sr->sr_pos - sr->sr_req_off;
> +	}
> +
>  	if (data_len != le32_to_cpu(msg->hdr.data_len)) {
>  		pr_err("sum of lens %u != %u for tid %llu\n", data_len,
>  		       le32_to_cpu(msg->hdr.data_len), req->r_tid);
>  		goto fail_request;
>  	}
> -	dout("%s req %p tid %llu result %d data_len %u\n", __func__,
> -	     req, req->r_tid, m.result, data_len);
> +	dout("%s req %p tid %llu result %d data_len %u result_len %u\n", __func__,
> +	     req, req->r_tid, m.result, data_len, result_len);
>  
>  	/*
>  	 * Since we only ever request ONDISK, we should only ever get
>  	 * one (type of) reply back.
>  	 */
>  	WARN_ON(!(m.flags & CEPH_OSD_FLAG_ONDISK));
> -	req->r_result = m.result ?: data_len;
> +	req->r_result = m.result ?: result_len;
>  	finish_request(req);
>  	mutex_unlock(&osd->lock);
>  	up_read(&osdc->lock);
> @@ -5398,6 +5433,21 @@ static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  	ceph_msg_put(msg);
>  }
>  
> +static struct ceph_osd_req_op *
> +sparse_read_op(struct ceph_osd_request *req)
> +{
> +	int i;
> +
> +	if (!(req->r_flags & CEPH_OSD_FLAG_READ))
> +		return NULL;
> +
> +	for (i = 0; i < req->r_num_ops; ++i) {
> +		if (req->r_ops[i].op == CEPH_OSD_OP_SPARSE_READ)
> +			return &req->r_ops[i];
> +	}
> +	return NULL;
> +}
> +
>  /*
>   * Lookup and return message for incoming reply.  Don't try to do
>   * anything about a larger than preallocated data portion of the
> @@ -5414,6 +5464,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  	int front_len = le32_to_cpu(hdr->front_len);
>  	int data_len = le32_to_cpu(hdr->data_len);
>  	u64 tid = le64_to_cpu(hdr->tid);
> +	struct ceph_osd_req_op *srop;
>  
>  	down_read(&osdc->lock);
>  	if (!osd_registered(osd)) {
> @@ -5446,7 +5497,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  		req->r_reply = m;
>  	}
>  
> -	if (data_len > req->r_reply->data_length) {
> +	srop = sparse_read_op(req);
> +
> +	if (!srop && (data_len > req->r_reply->data_length)) {
>  		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
>  			__func__, osd->o_osd, req->r_tid, data_len,
>  			req->r_reply->data_length);
> @@ -5456,6 +5509,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>  	}
>  
>  	m = ceph_msg_get(req->r_reply);
> +	m->sparse_read = srop;
> +	if (srop)
> +		ceph_init_sparse_read(&osd->o_sparse_read, srop);
> +
>  	dout("get_reply tid %lld %p\n", tid, m);
>  
>  out_unlock_session:
> @@ -5688,9 +5745,101 @@ static int osd_check_message_signature(struct ceph_msg *msg)
>  	return ceph_auth_check_message_signature(auth, msg);
>  }
>  
> +static void zero_len(struct ceph_msg_data_cursor *cursor, size_t len)
> +{
> +	while (len) {
> +		struct page *page;
> +		size_t poff, plen;
> +		bool last = false;
> +
> +		page = ceph_msg_data_next(cursor, &poff, &plen, &last);
> +		if (plen > len)
> +			plen = len;
> +		zero_user_segment(page, poff, poff + plen);
> +		len -= plen;
> +		ceph_msg_data_advance(cursor, plen);
> +	}
> +}
> +
> +static int osd_sparse_read(struct ceph_connection *con,
> +			   struct ceph_msg_data_cursor *cursor,
> +			   u64 *plen, char **pbuf)
> +{
> +	struct ceph_osd *o = con->private;
> +	struct ceph_sparse_read *sr = &o->o_sparse_read;
> +	u32 count = __le32_to_cpu(sr->sr_count);
> +	u64 eoff, elen;
> +
> +	switch (sr->sr_state) {
> +	case CEPH_SPARSE_READ_HDR:
> +		dout("[%d] request to read 0x%llx~0x%llx\n", o->o_osd, sr->sr_req_off, sr->sr_req_len);
> +		/* number of extents */
> +		*plen = sizeof(sr->sr_count);
> +		*pbuf = (char *)&sr->sr_count;
> +		sr->sr_state = CEPH_SPARSE_READ_EXTENTS;
> +		break;
> +	case CEPH_SPARSE_READ_EXTENTS:
> +		dout("[%d] got %u extents\n", o->o_osd, count);
> +
> +		if (count > 0) {
> +			if (count > 1) {
> +				/* can't use the embedded extent array */
> +				sr->sr_extent = kmalloc_array(count, sizeof(*sr->sr_extent),
> +							   GFP_NOIO);
> +				if (!sr->sr_extent)
> +					return -ENOMEM;
> +			}
> +			*plen = count * sizeof(*sr->sr_extent);
> +			*pbuf = (char *)sr->sr_extent;
> +			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
> +			break;
> +		}
> +		/* No extents? Fall through to reading data len */
> +		fallthrough;
> +	case CEPH_SPARSE_READ_DATA_LEN:
> +		*plen = sizeof(sr->sr_datalen);
> +		*pbuf = (char *)&sr->sr_datalen;
> +		sr->sr_state = CEPH_SPARSE_READ_DATA;
> +		break;
> +	case CEPH_SPARSE_READ_DATA:
> +		if (sr->sr_index >= count)
> +			return 0;
> +		if (sr->sr_index == 0) {
> +			/* last extent */
> +			eoff = le64_to_cpu(sr->sr_extent[count - 1].off);
> +			elen = le64_to_cpu(sr->sr_extent[count - 1].len);
> +
> +			/* set up cursor to end of last extent */
> +			ceph_msg_data_cursor_init(cursor, con->in_msg,
> +						  eoff + elen - sr->sr_req_off);
> +		}
> +
> +		eoff = le64_to_cpu(sr->sr_extent[sr->sr_index].off);
> +		elen = le64_to_cpu(sr->sr_extent[sr->sr_index].len);
> +
> +		dout("[%d] ext %d off 0x%llx len 0x%llx\n", o->o_osd, sr->sr_index, eoff, elen);
> +
> +		/* zero out anything from sr_pos to start of extent */
> +		if (sr->sr_pos < eoff)
> +			zero_len(cursor, eoff - sr->sr_pos);
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
