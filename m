Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1191513DD7C
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 15:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAPOdK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 09:33:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgAPOdK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jan 2020 09:33:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579185188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZ9seONj/nQspf+pYsdWOHLelo26/tGl/Ezt37tcB3g=;
        b=DY6/oIPYIvJ1aGSVxEuXB2Ui4wOYQvQJuwa5ER9lQFQMVBwjEFM+lQodMzab1MLdx5/XI/
        Te+goiA6X9qwaCoPvfzRS+/iOWnbKy8/rOAjumafn3Ko792mhby/aECqZnpU90lehQZzvI
        52SzNnYCYaVVDgcSULL0hezP5umD5Jg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-CbY7VHx4P_mYdir8AT2R8g-1; Thu, 16 Jan 2020 09:33:05 -0500
X-MC-Unique: CbY7VHx4P_mYdir8AT2R8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C039C1005510;
        Thu, 16 Jan 2020 14:33:03 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 986B689D02;
        Thu, 16 Jan 2020 14:32:58 +0000 (UTC)
Subject: Re: [RFC PATCH v2 05/10] ceph: decode interval_sets for delegated
 inos
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        xiubli@redhat.com
References: <20200115205912.38688-1-jlayton@kernel.org>
 <20200115205912.38688-6-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <228e39e4-fb0f-cdb4-0bba-c9166cdc3e93@redhat.com>
Date:   Thu, 16 Jan 2020 22:32:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115205912.38688-6-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/16/20 4:59 AM, Jeff Layton wrote:
> Starting in Octopus, the MDS will hand out caps that allow the client
> to do asynchronous file creates under certain conditions. As part of
> that, the MDS will delegate ranges of inode numbers to the client.
> 
> Add the infrastructure to decode these ranges, and stuff them into an
> xarray for later consumption by the async creation code.
> 
> Because the xarray code currently only handles unsigned long indexes,
> and those are 32-bits on 32-bit arches, we only enable the decoding when
> running on a 64-bit arch.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 109 +++++++++++++++++++++++++++++++++++++++----
>   fs/ceph/mds_client.h |   7 ++-
>   2 files changed, 106 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 8263f75badfc..19bd71eb5733 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -415,21 +415,110 @@ static int parse_reply_info_filelock(void **p, void *end,
>   	return -EIO;
>   }
>   
> +
> +#if BITS_PER_LONG == 64
> +
> +#define DELEGATED_INO_AVAILABLE		xa_mk_value(1)
> +
> +static int ceph_parse_deleg_inos(void **p, void *end,
> +				 struct ceph_mds_session *s)
> +{
> +	u32 sets;
> +
> +	ceph_decode_32_safe(p, end, sets, bad);
> +	dout("got %u sets of delegated inodes\n", sets);
> +	while (sets--) {
> +		u64 start, len, ino;
> +
> +		ceph_decode_64_safe(p, end, start, bad);
> +		ceph_decode_64_safe(p, end, len, bad);
> +		while (len--) {
> +			int err = xa_insert(&s->s_delegated_inos, ino = start++,
> +					    DELEGATED_INO_AVAILABLE,
> +					    GFP_KERNEL);
> +			if (!err) {
> +				dout("added delegated inode 0x%llx\n",
> +				     start - 1);
> +			} else if (err == -EBUSY) {
> +				pr_warn("ceph: MDS delegated inode 0x%llx more than once.\n",
> +					start - 1);
> +			} else {
> +				return err;
> +			}
> +		}
> +	}
> +	return 0;
> +bad:
> +	return -EIO;
> +}
> +
> +unsigned long ceph_get_deleg_ino(struct ceph_mds_session *s)
> +{
> +	unsigned long ino;
> +	void *val;
> +
> +	xa_for_each(&s->s_delegated_inos, ino, val) {
> +		val = xa_erase(&s->s_delegated_inos, ino);
> +		if (val == DELEGATED_INO_AVAILABLE)
> +			return ino;
> +	}
> +	return 0;

do we need to protect s_delegated_inos? ceph_get_deleg_ino() and 
ceph_parse_deleg_inos() can be executed at the same time. multiple 
thread may call ceph_parse_deleg_inos() at the same time.

> +}
> +#else /* BITS_PER_LONG == 64 */
> +/*
> + * FIXME: xarrays can't handle 64-bit indexes on a 32-bit arch. For now, just
> + * ignore delegated_inos on 32 bit arch. Maybe eventually add xarrays for top
> + * and bottom words?
> + */
> +static int ceph_parse_deleg_inos(void **p, void *end,
> +				 struct ceph_mds_session *s)
> +{
> +	u32 sets;
> +
> +	ceph_decode_32_safe(p, end, sets, bad);
> +	if (sets)
> +		ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
> +	return 0;
> +bad:
> +	return -EIO;
> +}
> +
> +unsigned long ceph_get_deleg_ino(struct ceph_mds_session *s)
> +{
> +	return 0;
> +}
> +#endif /* BITS_PER_LONG == 64 */
> +
>   /*
>    * parse create results
>    */
>   static int parse_reply_info_create(void **p, void *end,
>   				  struct ceph_mds_reply_info_parsed *info,
> -				  u64 features)
> +				  u64 features, struct ceph_mds_session *s)
>   {
> +	int ret;
> +
>   	if (features == (u64)-1 ||
>   	    (features & CEPH_FEATURE_REPLY_CREATE_INODE)) {
> -		/* Malformed reply? */
>   		if (*p == end) {
> +			/* Malformed reply? */
>   			info->has_create_ino = false;
> -		} else {
> +		} else if (test_bit(CEPHFS_FEATURE_DELEG_INO, &s->s_features)) {
> +			u8 struct_v, struct_compat;
> +			u32 len;
> +
>   			info->has_create_ino = true;
> +			ceph_decode_8_safe(p, end, struct_v, bad);
> +			ceph_decode_8_safe(p, end, struct_compat, bad);
> +			ceph_decode_32_safe(p, end, len, bad);
> +			ceph_decode_64_safe(p, end, info->ino, bad);
> +			ret = ceph_parse_deleg_inos(p, end, s);
> +			if (ret)
> +				return ret;
> +		} else {
> +			/* legacy */
>   			ceph_decode_64_safe(p, end, info->ino, bad);
> +			info->has_create_ino = true;
>   		}
>   	} else {
>   		if (*p != end)
> @@ -448,7 +537,7 @@ static int parse_reply_info_create(void **p, void *end,
>    */
>   static int parse_reply_info_extra(void **p, void *end,
>   				  struct ceph_mds_reply_info_parsed *info,
> -				  u64 features)
> +				  u64 features, struct ceph_mds_session *s)
>   {
>   	u32 op = le32_to_cpu(info->head->op);
>   
> @@ -457,7 +546,7 @@ static int parse_reply_info_extra(void **p, void *end,
>   	else if (op == CEPH_MDS_OP_READDIR || op == CEPH_MDS_OP_LSSNAP)
>   		return parse_reply_info_readdir(p, end, info, features);
>   	else if (op == CEPH_MDS_OP_CREATE)
> -		return parse_reply_info_create(p, end, info, features);
> +		return parse_reply_info_create(p, end, info, features, s);
>   	else
>   		return -EIO;
>   }
> @@ -465,7 +554,7 @@ static int parse_reply_info_extra(void **p, void *end,
>   /*
>    * parse entire mds reply
>    */
> -static int parse_reply_info(struct ceph_msg *msg,
> +static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>   			    struct ceph_mds_reply_info_parsed *info,
>   			    u64 features)
>   {
> @@ -490,7 +579,7 @@ static int parse_reply_info(struct ceph_msg *msg,
>   	ceph_decode_32_safe(&p, end, len, bad);
>   	if (len > 0) {
>   		ceph_decode_need(&p, end, len, bad);
> -		err = parse_reply_info_extra(&p, p+len, info, features);
> +		err = parse_reply_info_extra(&p, p+len, info, features, s);
>   		if (err < 0)
>   			goto out_bad;
>   	}
> @@ -558,6 +647,7 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
>   	if (refcount_dec_and_test(&s->s_ref)) {
>   		if (s->s_auth.authorizer)
>   			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
> +		xa_destroy(&s->s_delegated_inos);
>   		kfree(s);
>   	}
>   }
> @@ -645,6 +735,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>   	refcount_set(&s->s_ref, 1);
>   	INIT_LIST_HEAD(&s->s_waiting);
>   	INIT_LIST_HEAD(&s->s_unsafe);
> +	xa_init(&s->s_delegated_inos);
>   	s->s_num_cap_releases = 0;
>   	s->s_cap_reconnect = 0;
>   	s->s_cap_iterator = NULL;
> @@ -2947,9 +3038,9 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>   	dout("handle_reply tid %lld result %d\n", tid, result);
>   	rinfo = &req->r_reply_info;
>   	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
> -		err = parse_reply_info(msg, rinfo, (u64)-1);
> +		err = parse_reply_info(session, msg, rinfo, (u64)-1);
>   	else
> -		err = parse_reply_info(msg, rinfo, session->s_con.peer_features);
> +		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
>   	mutex_unlock(&mdsc->mutex);
>   
>   	mutex_lock(&session->s_mutex);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 27a7446e10d3..30fb60ba2580 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -23,8 +23,9 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_RECLAIM_CLIENT,
>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>   	CEPHFS_FEATURE_MULTI_RECONNECT,
> +	CEPHFS_FEATURE_DELEG_INO,
>   
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MULTI_RECONNECT,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
>   };
>   
>   /*
> @@ -37,6 +38,7 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_REPLY_ENCODING,		\
>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> +	CEPHFS_FEATURE_DELEG_INO,		\
>   						\
>   	CEPHFS_FEATURE_MAX,			\
>   }
> @@ -201,6 +203,7 @@ struct ceph_mds_session {
>   
>   	struct list_head  s_waiting;  /* waiting requests */
>   	struct list_head  s_unsafe;   /* unsafe requests */
> +	struct xarray	  s_delegated_inos;
>   };
>   
>   /*
> @@ -537,4 +540,6 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
>   extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>   			  struct ceph_mds_session *session,
>   			  int max_caps);
> +
> +extern unsigned long ceph_get_deleg_ino(struct ceph_mds_session *session);
>   #endif
> 

