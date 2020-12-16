Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152902DC878
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 22:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgLPVpf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 16:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgLPVpe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 16:45:34 -0500
Message-ID: <d7dffb1d8f4c6b558f67ca4f60fa50942aea8ed5.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608155093;
        bh=RhMzfDT0+o4eyFY+AqkAd/r5sUqSfLpZtL5IkzILeJU=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=b9mpJ7JVnlQTw+Dxd37LUSNYTQ/v7QwlYtTymghL5WcpNJfbBzzyBbxvukjValujk
         6Ktg+SNcbkLfkKsWSsTK0t91SEVNvH1uVMSpMvMdrP+18RptpMssIY8dT3kv8MTFEj
         kKeQFn2mc8FkhZOBQuZW54KuBrRm8b7QdjgE30AlJrYKHPD3lWXSW7d7VQRbDEmkV1
         bJEWWxYZxC8lYK5dj1lVy8SEPWy4bE7me+9HEM/KYmTfBkMJLXh6gxKM2wz+cdLIFd
         um1Lc0mwp0Te2xG34rq+zqTvwB289LjPZfzjMDDxpCQ+0ZqxVxc5tAytVcyaehrtGM
         qWor3jO89FtAg==
Subject: Re: [PATCH] ceph: reencode gid_list when reconnecting
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 16 Dec 2020 16:44:51 -0500
In-Reply-To: <20201216213804.30419-1-idryomov@gmail.com>
References: <20201216213804.30419-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-12-16 at 22:38 +0100, Ilya Dryomov wrote:
> On reconnect, cap and dentry releases are dropped and the fields
> that follow must be reencoded into the freed space.  Currently these
> are timestamp and gid_list, but gid_list isn't reencoded.  This
> results in
> 
>   failed to decode message of type 24 v4: End of buffer
> 
> errors on the MDS.
> 
> While at it, make a change to encode gid_list unconditionally,
> without regard to what head/which version was used as a result
> of checking whether CEPH_FEATURE_FS_BTIME is supported or not.
> 
> URL: https://tracker.ceph.com/issues/48618
> Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head structure")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/mds_client.c | 53 ++++++++++++++++++--------------------------
>  1 file changed, 22 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 98c15ff2e599..840587037b59 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2475,6 +2475,22 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
>  	return r;
>  }
>  
> 
> +static void encode_timestamp_and_gids(void **p,
> +				      const struct ceph_mds_request *req)
> +{
> +	struct ceph_timespec ts;
> +	int i;
> +
> +	ceph_encode_timespec64(&ts, &req->r_stamp);
> +	ceph_encode_copy(p, &ts, sizeof(ts));
> +
> +	/* gid_list */
> +	ceph_encode_32(p, req->r_cred->group_info->ngroups);
> +	for (i = 0; i < req->r_cred->group_info->ngroups; i++)
> +		ceph_encode_64(p, from_kgid(&init_user_ns,
> +					    req->r_cred->group_info->gid[i]));
> +}
> +
>  /*
>   * called under mdsc->mutex
>   */
> @@ -2491,7 +2507,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  	u64 ino1 = 0, ino2 = 0;
>  	int pathlen1 = 0, pathlen2 = 0;
>  	bool freepath1 = false, freepath2 = false;
> -	int len, i;
> +	int len;
>  	u16 releases;
>  	void *p, *end;
>  	int ret;
> @@ -2517,17 +2533,10 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  		goto out_free1;
>  	}
>  
> 
> -	if (legacy) {
> -		/* Old style */
> -		len = sizeof(*head);
> -	} else {
> -		/* New style: add gid_list and any later fields */
> -		len = sizeof(struct ceph_mds_request_head) + sizeof(u32) +
> -		      (sizeof(u64) * req->r_cred->group_info->ngroups);
> -	}
> -
> +	len = legacy ? sizeof(*head) : sizeof(struct ceph_mds_request_head);
>  	len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
>  		sizeof(struct ceph_timespec);
> +	len += sizeof(u32) + (sizeof(u64) * req->r_cred->group_info->ngroups);
>  
> 
>  	/* calculate (max) length for cap releases */
>  	len += sizeof(struct ceph_mds_request_release) *
> @@ -2548,7 +2557,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  	msg->hdr.tid = cpu_to_le64(req->r_tid);
>  
> 
>  	/*
> -	 * The old ceph_mds_request_header didn't contain a version field, and
> +	 * The old ceph_mds_request_head didn't contain a version field, and
>  	 * one was added when we moved the message version from 3->4.
>  	 */
>  	if (legacy) {
> @@ -2609,20 +2618,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  
> 
>  	head->num_releases = cpu_to_le16(releases);
>  
> 
> -	/* time stamp */
> -	{
> -		struct ceph_timespec ts;
> -		ceph_encode_timespec64(&ts, &req->r_stamp);
> -		ceph_encode_copy(&p, &ts, sizeof(ts));
> -	}
> -
> -	/* gid list */
> -	if (!legacy) {
> -		ceph_encode_32(&p, req->r_cred->group_info->ngroups);
> -		for (i = 0; i < req->r_cred->group_info->ngroups; i++)
> -			ceph_encode_64(&p, from_kgid(&init_user_ns,
> -				       req->r_cred->group_info->gid[i]));
> -	}
> +	encode_timestamp_and_gids(&p, req);
>  
> 
>  	if (WARN_ON_ONCE(p > end)) {
>  		ceph_msg_put(msg);
> @@ -2730,13 +2726,8 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  		/* remove cap/dentry releases from message */
>  		rhead->num_releases = 0;
>  
> 
> -		/* time stamp */
>  		p = msg->front.iov_base + req->r_request_release_offset;
> -		{
> -			struct ceph_timespec ts;
> -			ceph_encode_timespec64(&ts, &req->r_stamp);
> -			ceph_encode_copy(&p, &ts, sizeof(ts));
> -		}
> +		encode_timestamp_and_gids(&p, req);
>  
> 
>  		msg->front.iov_len = p - msg->front.iov_base;
>  		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);

Reviewed-by: Jeff Layton <jlayton@kernel.org>

