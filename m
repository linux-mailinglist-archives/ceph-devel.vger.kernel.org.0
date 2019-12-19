Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB38125915
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 02:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLSBJ5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Dec 2019 20:09:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbfLSBJ5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 Dec 2019 20:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576717796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeGg0fmfnAz+oXw9ER30KnHvzRKConmAMg+uEsru2BU=;
        b=IHTjJpJ/LpnJ4oybvXxEkIXoS75i4q2njSn/GNK3NuzpOBm/ibxV9YiKVQb8s5TM1R2oy2
        1EM5p4tzK+NA7pWnqsABlcqwO+e327DrydmC74tz/+qoxsZTIyEXA4WkXAo26Y+dvGNkrK
        xtiQMA9Wph4DwDcfEa6aXsFxtSPX7/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-St6lB4YkO3C2c8RudedOYw-1; Wed, 18 Dec 2019 20:09:55 -0500
X-MC-Unique: St6lB4YkO3C2c8RudedOYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A9C2DB20;
        Thu, 19 Dec 2019 01:09:54 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A2AC620BE;
        Thu, 19 Dec 2019 01:09:49 +0000 (UTC)
Subject: Re: [PATCH] ceph: rename get_session and switch to use
 ceph_get_mds_session
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191218120041.8263-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9d008422-aafa-c523-6eee-fdcb92ab2d43@redhat.com>
Date:   Thu, 19 Dec 2019 09:09:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191218120041.8263-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This has some conflicts with the upstream code and posted a V2 to fix it.

Thanks.

On 2019/12/18 20:00, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Just in case the session's refcount reach 0 and is releasing, and
> if we get the session without checking it, we may encounter kernel
> crash.
>
> Rename get_session to ceph_get_mds_session and make it global.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c       |  4 ++--
>   fs/ceph/mds_client.c | 16 ++++++++--------
>   fs/ceph/mds_client.h |  9 ++-------
>   3 files changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5c89a915409b..5a828298456a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented, int mask)
>   		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued));
>   
>   		if (mask >= 0) {
> -			s = get_session(cap->session);
> +			s = ceph_get_mds_session(cap->session);
>   			if (cap == ci->i_auth_cap)
>   				r = revoking;
>   			if (mask & (cap->issued & ~r))
> @@ -907,7 +907,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch,
>   		if (!__cap_is_valid(cap))
>   			continue;
>   
> -		s = get_session(cap->session);
> +		s = ceph_get_mds_session(cap->session);
>   		if ((cap->issued & mask) == mask) {
>   			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
>   			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 99de89a3a0d3..619b08cba677 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -538,7 +538,7 @@ const char *ceph_session_state_name(int s)
>   	}
>   }
>   
> -static struct ceph_mds_session *get_session(struct ceph_mds_session *s)
> +struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s)
>   {
>   	if (refcount_inc_not_zero(&s->s_ref)) {
>   		dout("mdsc get_session %p %d -> %d\n", s,
> @@ -571,7 +571,7 @@ struct ceph_mds_session *__ceph_lookup_mds_session(struct ceph_mds_client *mdsc,
>   {
>   	if (mds >= mdsc->max_sessions || !mdsc->sessions[mds])
>   		return NULL;
> -	return get_session(mdsc->sessions[mds]);
> +	return ceph_get_mds_session(mdsc->sessions[mds]);
>   }
>   
>   static bool __have_session(struct ceph_mds_client *mdsc, int mds)
> @@ -2004,7 +2004,7 @@ void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
>   	if (mdsc->stopping)
>   		return;
>   
> -	get_session(session);
> +	ceph_get_mds_session(session);
>   	if (queue_work(mdsc->fsc->cap_wq,
>   		       &session->s_cap_release_work)) {
>   		dout("cap release work queued\n");
> @@ -2619,7 +2619,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>   			goto finish;
>   		}
>   	}
> -	req->r_session = get_session(session);
> +	req->r_session = ceph_get_mds_session(session);
>   
>   	dout("do_request mds%d session %p state %s\n", mds, session,
>   	     ceph_session_state_name(session->s_state));
> @@ -3143,7 +3143,7 @@ static void handle_session(struct ceph_mds_session *session,
>   
>   	mutex_lock(&mdsc->mutex);
>   	if (op == CEPH_SESSION_CLOSE) {
> -		get_session(session);
> +		ceph_get_mds_session(session);
>   		__unregister_session(mdsc, session);
>   	}
>   	/* FIXME: this ttl calculation is generous */
> @@ -3818,7 +3818,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>   
>   		if (i >= newmap->m_num_mds) {
>   			/* force close session for stopped mds */
> -			get_session(s);
> +			ceph_get_mds_session(s);
>   			__unregister_session(mdsc, s);
>   			__wake_requests(mdsc, &s->s_waiting);
>   			mutex_unlock(&mdsc->mutex);
> @@ -4460,7 +4460,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>   	mutex_lock(&mdsc->mutex);
>   	for (i = 0; i < mdsc->max_sessions; i++) {
>   		if (mdsc->sessions[i]) {
> -			session = get_session(mdsc->sessions[i]);
> +			session = ceph_get_mds_session(mdsc->sessions[i]);
>   			__unregister_session(mdsc, session);
>   			mutex_unlock(&mdsc->mutex);
>   			mutex_lock(&session->s_mutex);
> @@ -4693,7 +4693,7 @@ static struct ceph_connection *con_get(struct ceph_connection *con)
>   {
>   	struct ceph_mds_session *s = con->private;
>   
> -	if (get_session(s)) {
> +	if (ceph_get_mds_session(s)) {
>   		dout("mdsc con_get %p ok (%d)\n", s, refcount_read(&s->s_ref));
>   		return con;
>   	}
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 40676c2392cf..37e8798e7408 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -457,15 +457,10 @@ extern const char *ceph_mds_op_name(int op);
>   extern struct ceph_mds_session *
>   __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
>   
> -static inline struct ceph_mds_session *
> -ceph_get_mds_session(struct ceph_mds_session *s)
> -{
> -	refcount_inc(&s->s_ref);
> -	return s;
> -}
> -
>   extern const char *ceph_session_state_name(int s);
>   
> +extern struct ceph_mds_session *
> +ceph_get_mds_session(struct ceph_mds_session *s);
>   extern void ceph_put_mds_session(struct ceph_mds_session *s);
>   
>   extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,


