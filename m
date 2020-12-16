Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F98F2DC2A4
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 16:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLPPCp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 10:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPPCo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 10:02:44 -0500
Message-ID: <4de984790af91031ced683457b438ec9f6fc66e8.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608130923;
        bh=X/Z5Acbl6QLbk1h5Or1nUsdL/iRAD0TAbVMWOLNgwZM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XGlesP4omla8P5qVn2cjQS9+oMQvVRQRE3Y0Nm6S/wCzCd0+ognSiG/2VBbCphaom
         audeB9iKVn5AgYbCOTx0hg7OESVusXFQFmeYy7MR/K5cab2pUrkTpXBTOIC49xT846
         gy3Ac9ZSG13KQqcEDHDQttqhpuxD9Mp7rySxYKl/38Fzgfhnc/EpcbdlEPmj0VrBwN
         A9JyjMKXohpg0Nq9QqXNYR5ARtE2mXYpsZdXwTReryxdowiZujgw3KebS6mtwrhfXI
         JgZcITSE92E5blGks3dlXn8uZRC2eY4ARRRZ47JMBPIXZEt+iCIeJDpc0hgNPItqjB
         KCGWRFjzbzFew==
Subject: Re: [PATCH 4/4] ceph: implement updated ceph_mds_request_head
 structure
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Date:   Wed, 16 Dec 2020 10:02:01 -0500
In-Reply-To: <20201209185354.29097-5-jlayton@kernel.org>
References: <20201209185354.29097-1-jlayton@kernel.org>
         <20201209185354.29097-5-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-12-09 at 13:53 -0500, Jeff Layton wrote:
> When we added the btime feature in mainline ceph, we had to extend
> struct ceph_mds_request_args so that it could be set. Implement the same
> in the kernel client.
> 
> Rename ceph_mds_request_head with a _old extension, and a union
> ceph_mds_request_args_ext to allow for the extended size of the new
> header format.
> 
> Add the appropriate code to handle both formats in struct
> create_request_message and key the behavior on whether the peer supports
> CEPH_FEATURE_FS_BTIME.
> 
> The gid_list field in the payload is now populated from the saved
> credential. For now, we don't add any support for setting the btime via
> setattr, but this does enable us to add that in the future.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c         | 72 +++++++++++++++++++++++++++++-------
>  include/linux/ceph/ceph_fs.h | 32 +++++++++++++++-
>  2 files changed, 90 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f76ae9e7d4c1..e9db2d1e0020 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2478,21 +2478,24 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
>  /*
>   * called under mdsc->mutex
>   */
> -static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> +static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  					       struct ceph_mds_request *req,
> -					       int mds, bool drop_cap_releases)
> +					       bool drop_cap_releases)
>  {
> +	int mds = session->s_mds;
> +	struct ceph_mds_client *mdsc = session->s_mdsc;
>  	struct ceph_msg *msg;
> -	struct ceph_mds_request_head *head;
> +	struct ceph_mds_request_head_old *head;
>  	const char *path1 = NULL;
>  	const char *path2 = NULL;
>  	u64 ino1 = 0, ino2 = 0;
>  	int pathlen1 = 0, pathlen2 = 0;
>  	bool freepath1 = false, freepath2 = false;
> -	int len;
> +	int len, i;
>  	u16 releases;
>  	void *p, *end;
>  	int ret;
> +	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
>  
> 
>  	ret = set_request_path_attr(req->r_inode, req->r_dentry,
>  			      req->r_parent, req->r_path1, req->r_ino1.ino,
> @@ -2514,14 +2517,23 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>  		goto out_free1;
>  	}
>  
> 
> -	len = sizeof(*head) +
> -		pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
> +	if (legacy) {
> +		/* Old style */
> +		len = sizeof(*head);
> +	} else {
> +		/* New style: add gid_list and any later fields */
> +		len = sizeof(struct ceph_mds_request_head) +
> +		      sizeof(u32) + (sizeof(u64) * req->r_cred->group_info->ngroups);
> +	}
> +
> +	len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
>  		sizeof(struct ceph_timespec);
>  
> 
>  	/* calculate (max) length for cap releases */
>  	len += sizeof(struct ceph_mds_request_release) *
>  		(!!req->r_inode_drop + !!req->r_dentry_drop +
>  		 !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
> +
>  	if (req->r_dentry_drop)
>  		len += pathlen1;
>  	if (req->r_old_dentry_drop)
> @@ -2533,11 +2545,25 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>  		goto out_free2;
>  	}
>  
> 
> -	msg->hdr.version = cpu_to_le16(3);
>  	msg->hdr.tid = cpu_to_le64(req->r_tid);
>  
> 
> -	head = msg->front.iov_base;
> -	p = msg->front.iov_base + sizeof(*head);
> +	/*
> +	 * The old ceph_mds_request_header didn't contain a version field, and
> +	 * one was added when we moved the message version from 3->4.
> +	 */
> +	if (legacy) {
> +		msg->hdr.version = cpu_to_le16(3);
> +		head = msg->front.iov_base;
> +		p = msg->front.iov_base + sizeof(*head);
> +	} else {
> +		struct ceph_mds_request_head *new_head = msg->front.iov_base;
> +
> +		msg->hdr.version = cpu_to_le16(4);
> +		new_head->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
> +		head = (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
> +		p = msg->front.iov_base + sizeof(*new_head);
> +	}
> +
>  	end = msg->front.iov_base + msg->front.iov_len;
>  
> 
>  	head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
> @@ -2588,6 +2614,14 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>  		ceph_encode_copy(&p, &ts, sizeof(ts));
>  	}
>  
> 
> +	/* gid list */
> +	if (!legacy) {
> +		ceph_encode_32(&p, req->r_cred->group_info->ngroups);
> +		for (i = 0; i < req->r_cred->group_info->ngroups; i++)
> +			ceph_encode_64(&p, from_kgid(&init_user_ns,
> +				       req->r_cred->group_info->gid[i]));
> +	}
> +
>  	if (WARN_ON_ONCE(p > end)) {
>  		ceph_msg_put(msg);
>  		msg = ERR_PTR(-ERANGE);
> @@ -2631,6 +2665,17 @@ static void complete_request(struct ceph_mds_client *mdsc,
>  	complete_all(&req->r_completion);
>  }
>  
> 
> +static struct ceph_mds_request_head_old *find_old_request_head(void *p, u64 features)
> +{
> +	bool legacy = !(features & CEPH_FEATURE_FS_BTIME);
> +	struct ceph_mds_request_head *new_head;
> +
> +	if (legacy)
> +		return (struct ceph_mds_request_head_old *)p;
> +	new_head = (struct ceph_mds_request_head *)p;
> +	return (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
> +}
> +
>  /*
>   * called under mdsc->mutex
>   */
> @@ -2640,7 +2685,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  {
>  	int mds = session->s_mds;
>  	struct ceph_mds_client *mdsc = session->s_mdsc;
> -	struct ceph_mds_request_head *rhead;
> +	struct ceph_mds_request_head_old *rhead;
>  	struct ceph_msg *msg;
>  	int flags = 0;
>  
> 
> @@ -2659,6 +2704,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  
> 
>  	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
>  		void *p;
> +
>  		/*
>  		 * Replay.  Do not regenerate message (and rebuild
>  		 * paths, etc.); just use the original message.
> @@ -2666,7 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  		 * d_move mangles the src name.
>  		 */
>  		msg = req->r_request;
> -		rhead = msg->front.iov_base;
> +		rhead = find_old_request_head(msg->front.iov_base, session->s_con.peer_features);
>  
> 
>  		flags = le32_to_cpu(rhead->flags);
>  		flags |= CEPH_MDS_FLAG_REPLAY;
> @@ -2697,14 +2743,14 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  		ceph_msg_put(req->r_request);
>  		req->r_request = NULL;
>  	}
> -	msg = create_request_message(mdsc, req, mds, drop_cap_releases);
> +	msg = create_request_message(session, req, drop_cap_releases);
>  	if (IS_ERR(msg)) {
>  		req->r_err = PTR_ERR(msg);
>  		return PTR_ERR(msg);
>  	}
>  	req->r_request = msg;
>  
> 
> -	rhead = msg->front.iov_base;
> +	rhead = find_old_request_head(msg->front.iov_base, session->s_con.peer_features);
>  	rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
>  	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
>  		flags |= CEPH_MDS_FLAG_REPLAY;
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index c0f1b921ec69..d44d98033d58 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -446,11 +446,25 @@ union ceph_mds_request_args {
>  	} __attribute__ ((packed)) lookupino;
>  } __attribute__ ((packed));
>  
> 
> +union ceph_mds_request_args_ext {
> +	union ceph_mds_request_args old;
> +	struct {
> +		__le32 mode;
> +		__le32 uid;
> +		__le32 gid;
> +		struct ceph_timespec mtime;
> +		struct ceph_timespec atime;
> +		__le64 size, old_size;       /* old_size needed by truncate */
> +		__le32 mask;                 /* CEPH_SETATTR_* */
> +		struct ceph_timespec btime;
> +	} __attribute__ ((packed)) setattr_ext;
> +};
> +
>  #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
>  #define CEPH_MDS_FLAG_WANT_DENTRY	2 /* want dentry in reply */
>  #define CEPH_MDS_FLAG_ASYNC		4 /* request is asynchronous */
>  
> 
> -struct ceph_mds_request_head {
> +struct ceph_mds_request_head_old {
>  	__le64 oldest_client_tid;
>  	__le32 mdsmap_epoch;           /* on client */
>  	__le32 flags;                  /* CEPH_MDS_FLAG_* */
> @@ -463,6 +477,22 @@ struct ceph_mds_request_head {
>  	union ceph_mds_request_args args;
>  } __attribute__ ((packed));
>  
> 
> +#define CEPH_MDS_REQUEST_HEAD_VERSION  1
> +
> +struct ceph_mds_request_head {
> +	__le16 version;                /* struct version */
> +	__le64 oldest_client_tid;
> +	__le32 mdsmap_epoch;           /* on client */
> +	__le32 flags;                  /* CEPH_MDS_FLAG_* */
> +	__u8 num_retry, num_fwd;       /* count retry, fwd attempts */
> +	__le16 num_releases;           /* # include cap/lease release records */
> +	__le32 op;                     /* mds op code */
> +	__le32 caller_uid, caller_gid;
> +	__le64 ino;                    /* use this ino for openc, mkdir, mknod,
> +					  etc. (if replaying) */
> +	union ceph_mds_request_args_ext args;
> +} __attribute__ ((packed));
> +
>  /* cap/lease release record */
>  struct ceph_mds_request_release {
>  	__le64 ino, cap_id;            /* ino and unique cap id */

Patrick has hit some errors that look like this:

    failed to decode message of type 24 v4: End of buffer

I've not been able to reproduce it yet, but for now, I'm going to back
this patch out of the testing branch to validate that it is the problem.

See: https://tracker.ceph.com/issues/48618
-- 
Jeff Layton <jlayton@kernel.org>

