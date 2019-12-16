Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4C11FCAA
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2019 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfLPB5N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 15 Dec 2019 20:57:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726299AbfLPB5M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 15 Dec 2019 20:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576461430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1/5w0Y709gZ4N4turmDMQs8kFWW3o5kHJF43TwNnuQ=;
        b=RHHcfn/hn4c+dMYHPf8qjLQZHsstD3dLRAzKRb9TXBxgfCk91m8gWOzzeJ+BKVNJbydMdE
        iQBLaqeh4SMNa6EKRhGMbGQ2OKEjqqOnZIhp8WePwiATa5mAet+2P13ynwPSbee31FvWqa
        fM36JRdSlXO+EvDqYIKuCj23Zp4Pq2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-kzE6gwUIOW-7gRdf7KJhyA-1; Sun, 15 Dec 2019 20:57:05 -0500
X-MC-Unique: kzE6gwUIOW-7gRdf7KJhyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8856800D54;
        Mon, 16 Dec 2019 01:57:04 +0000 (UTC)
Received: from [10.72.12.99] (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F8A460BF7;
        Mon, 16 Dec 2019 01:57:03 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, ukernel@gmail.com
References: <20191212173159.35013-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0a58cb14-1648-6c7e-6e6d-7f6c093f7563@redhat.com>
Date:   Mon, 16 Dec 2019 09:57:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191212173159.35013-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/13 1:31, Jeff Layton wrote:
> I believe it's possible that we could end up with racing calls to
> __ceph_remove_cap for the same cap. If that happens, the cap->ci
> pointer will be zereoed out and we can hit a NULL pointer dereference.
>
> Once we acquire the s_cap_lock, check for the ci pointer being NULL,
> and just return without doing anything if it is.
>
> URL: https://tracker.ceph.com/issues/43272
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
>
> This is the only scenario that made sense to me in light of Ilya's
> analysis on the tracker above. I could be off here though -- the locking
> around this code is horrifically complex, and I could be missing what
> should guard against this scenario.

Checked the downstream 3.10.0-862.14.4 code, it seems that when doing 
trim_caps_cb() and at the same time if the inode is being destroyed we 
could hit this.

All the __ceph_remove_cap() calls will be protected by the 
"ci->i_ceph_lock" lock, only except when destroying the inode.

And the upstream seems have no this problem now.

BRs


> Thoughts?
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9d09bb53c1ab..7e39ee8eff60 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
>   void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>   {
>   	struct ceph_mds_session *session = cap->session;
> -	struct ceph_inode_info *ci = cap->ci;
> -	struct ceph_mds_client *mdsc =
> -		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +	struct ceph_inode_info *ci;
> +	struct ceph_mds_client *mdsc;
>   	int removed = 0;
>   
> +	spin_lock(&session->s_cap_lock);
> +	ci = cap->ci;
> +	if (!ci) {
> +		/*
> +		 * Did we race with a competing __ceph_remove_cap call? If
> +		 * ci is zeroed out, then just unlock and don't do anything.
> +		 * Assume that it's on its way out anyway.
> +		 */
> +		spin_unlock(&session->s_cap_lock);
> +		return;
> +	}
> +
>   	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>   
>   	/* remove from inode's cap rbtree, and clear auth cap */
> @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>   	if (ci->i_auth_cap == cap)
>   		ci->i_auth_cap = NULL;
>   
> -	/* remove from session list */
> -	spin_lock(&session->s_cap_lock);
>   	if (session->s_cap_iterator == cap) {
>   		/* not yet, we are iterating over this very cap */
>   		dout("__ceph_remove_cap  delaying %p removal from session %p\n",
>   		     cap, cap->session);
>   	} else {
> +		/* remove from session list */
>   		list_del_init(&cap->session_caps);
>   		session->s_nr_caps--;
>   		cap->session = NULL;
> @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>   	}
>   	/* protect backpointer with s_cap_lock: see iterate_session_caps */
>   	cap->ci = NULL;
> +	mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>   
>   	/*
>   	 * s_cap_reconnect is protected by s_cap_lock. no one changes


