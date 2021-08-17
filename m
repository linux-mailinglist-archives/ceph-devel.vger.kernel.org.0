Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169363EF010
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 18:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhHQQTV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 12:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhHQQTV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 12:19:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C7A760FBF;
        Tue, 17 Aug 2021 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629217128;
        bh=T6BUWZPJNbGb8CuALS6nGvEArvcpomHIpIRF5kgIHf4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MAp9RK1ZPTZE4WxRpAORll2ebxLDxNAV6gptMnKns7JJP+8dL3UVKsAm/nwFvEugT
         cp//dOYhi3TBaQXIL6OF/RU8pxMrp/uRIt3Plo3Q0F9fLFaRvOPCu7/RPpgfJeTvQa
         dxsTCqGqHlyhLu9huyCTuPPFg7gPbyTmOEanc3rL1OWDBPST2h1cQc1VVtRmOPe6Pi
         4PwBhR+CM5dO6dK4s6yVVcoDubv6ygOptvSiE1gcUekRBQYuuAMZrBHpWTfZfmmXsF
         FvuTT3QeVaYVWxdE4sc6DmWsYduinK7/cvrf6JUUfoFq+rbiuo3Mz5cGPTe4psTuTG
         m/2b18a2Q+QrA==
Message-ID: <35529e08cdad0bca25be41658bdc4b5b1ab81d28.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: try to reconnect to the export targets
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 17 Aug 2021 12:18:46 -0400
In-Reply-To: <20210817034445.405663-1-xiubli@redhat.com>
References: <20210817034445.405663-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-17 at 11:44 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In case the export MDS is crashed just after the EImportStart journal
> is flushed, so when a standby MDS takes over it and when replaying
> the EImportStart journal the MDS will wait the client to reconnect,
> but the client may never register/open the sessions yet.
> 
> We will try to reconnect that MDSes if they're in the export targets
> and in RECONNECT state.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> - check the export target rank when decoding the mdsmap instead of
> BUG_ON
> - fix issue that the sessions have been opened during the mutex's
> unlock/lock gap
> 
> 
>  fs/ceph/mds_client.c | 63 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/mdsmap.c     | 10 ++++---
>  2 files changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e49dbeb6c06f..1e013fb09d73 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4197,13 +4197,22 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  			  struct ceph_mdsmap *newmap,
>  			  struct ceph_mdsmap *oldmap)
>  {
> -	int i;
> +	int i, err;
> +	int *export_targets;
>  	int oldstate, newstate;
>  	struct ceph_mds_session *s;
> +	struct ceph_mds_info *m_info;
>  
>  	dout("check_new_map new %u old %u\n",
>  	     newmap->m_epoch, oldmap->m_epoch);
>  
> +	m_info = newmap->m_info;
> +	export_targets = kcalloc(newmap->possible_max_rank, sizeof(int), GFP_NOFS);

This allocation could fail under low-memory conditions, particularly
since it's GFP_NOFS. One idea would be to make this function return int
so you can just return -ENOMEM if the allocation fails.

Is there a hard max to possible_max_rank? If so and it's not that big,
then another possibility would be to just declare this array on the
stack.

Also, since this is just used as a flag, making an array of bools would
reduce the size of the allocation by a factor of 4.

> +	if (export_targets && m_info) {
> +		for (i = 0; i < m_info->num_export_targets; i++)
> +			export_targets[m_info->export_targets[i]] = 1;
> +	}
> +

If you reverse the sense of the flags then you wouldn't need to
initialize the array at all (assuming you still use kcalloc).

>  	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		if (!mdsc->sessions[i])
>  			continue;
> @@ -4257,6 +4266,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>  		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>  			mutex_unlock(&mdsc->mutex);
> +			if (export_targets)
> +				export_targets[i] = 0;
>  			send_mds_reconnect(mdsc, s);
>  			mutex_lock(&mdsc->mutex);
>  		}
> @@ -4279,6 +4290,54 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		}
>  	}
>  
> +	/*
> +	 * Only open and reconnect sessions that don't exist yet.
> +	 */
> +	for (i = 0; i < newmap->possible_max_rank; i++) {
> +		if (unlikely(!export_targets))
> +			break;
> +
> +		/*
> +		 * In case the import MDS is crashed just after
> +		 * the EImportStart journal is flushed, so when
> +		 * a standby MDS takes over it and is replaying
> +		 * the EImportStart journal the new MDS daemon
> +		 * will wait the client to reconnect it, but the
> +		 * client may never register/open the session yet.
> +		 *
> +		 * Will try to reconnect that MDS daemon if the
> +		 * rank number is in the export_targets array and
> +		 * is the up:reconnect state.
> +		 */
> +		newstate = ceph_mdsmap_get_state(newmap, i);
> +		if (!export_targets[i] || newstate != CEPH_MDS_STATE_RECONNECT)
> +			continue;
> +
> +		/*
> +		 * The session maybe registered and opened by some
> +		 * requests which were choosing random MDSes during
> +		 * the mdsc->mutex's unlock/lock gap below in rare
> +		 * case. But the related MDS daemon will just queue
> +		 * that requests and be still waiting for the client's
> +		 * reconnection request in up:reconnect state.
> +		 */
> +		s = __ceph_lookup_mds_session(mdsc, i);
> +		if (likely(!s)) {
> +			s = __open_export_target_session(mdsc, i);
> +			if (IS_ERR(s)) {
> +				err = PTR_ERR(s);
> +				pr_err("failed to open export target session, err %d\n",
> +				       err);
> +				continue;
> +			}
> +		}
> +		dout("send reconnect to export target mds.%d\n", i);
> +		mutex_unlock(&mdsc->mutex);
> +		send_mds_reconnect(mdsc, s);
> +		mutex_lock(&mdsc->mutex);
> +		ceph_put_mds_session(s);

You can put the mds session before you re-take the mutex.

> +	}
> +
>  	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		s = mdsc->sessions[i];
>  		if (!s)
> @@ -4293,6 +4352,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  			__open_export_target_sessions(mdsc, s);
>  		}
>  	}
> +
> +	kfree(export_targets);
>  }
>  
>  
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 3c444b9cb17b..d995cb02d30c 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -122,6 +122,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  	int err;
>  	u8 mdsmap_v;
>  	u16 mdsmap_ev;
> +	u32 target;
>  
>  	m = kzalloc(sizeof(*m), GFP_NOFS);
>  	if (!m)
> @@ -260,9 +261,12 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  						       sizeof(u32), GFP_NOFS);
>  			if (!info->export_targets)
>  				goto nomem;
> -			for (j = 0; j < num_export_targets; j++)
> -				info->export_targets[j] =
> -				       ceph_decode_32(&pexport_targets);
> +			for (j = 0; j < num_export_targets; j++) {
> +				target = ceph_decode_32(&pexport_targets);
> +				if (target >= m->possible_max_rank)
> +					goto corrupt;
> +				info->export_targets[j] = target;
> +			}
>  		} else {
>  			info->export_targets = NULL;
>  		}

-- 
Jeff Layton <jlayton@kernel.org>

