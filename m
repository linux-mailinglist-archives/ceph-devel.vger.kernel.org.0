Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45913ED3A5
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhHPMGI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 08:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhHPMGE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 08:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC1461BF9;
        Mon, 16 Aug 2021 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629115532;
        bh=XSc2ALpZc0B8aNHhMR951uwVDlx5CrZP3jgI1weDNhY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WnCeUJfKPukzJwFkcIQVeHb3iFnl9NiwUpEPdbx8XRlTowWJLhvcAviv5dNNHpRyW
         1QYRHaZw1ys6r5eSqbSkqVU++9CYdEXnBdcI929GKSLUzXI9+u1GeUr+nv7xKtSFRU
         csjep9AjKQcPk1OacTsBkh/5ckoM2u7bANhDi7Z03EyIQP6T11TfrWjZcUp2R27D4O
         6SjmJSaaCd7QwZH9oyfFhkzLbZUA8O+GWdzEIX5xEIroKDx8GcmTFNgC1DcesJ23MF
         UV3/toJ7FJ6ana2u6Hw4oR5IMcQA2+tVHR3dNwupCYym2lwOY/D/Zpo589yweOR+gA
         U73Nezl/yeQ8Q==
Message-ID: <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
Subject: Re: [PATCH] ceph: try to reconnect to the export targets
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 16 Aug 2021 08:05:31 -0400
In-Reply-To: <20210812041042.132984-1-xiubli@redhat.com>
References: <20210812041042.132984-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-12 at 12:10 +0800, xiubli@redhat.com wrote:
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
>  fs/ceph/mds_client.c | 58 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 14e44de05812..7dfe7a804320 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4182,13 +4182,24 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
> +	if (export_targets && m_info) {
> +		for (i = 0; i < m_info->num_export_targets; i++) {
> +			BUG_ON(m_info->export_targets[i] >= newmap->possible_max_rank);

In general, we shouldn't BUG() in response to bad info sent by the MDS.
It would probably be better to check these values in
ceph_mdsmap_decode() and return an error there if it doesn't look right.
That way we can just toss out the new map instead of crashing.

> +			export_targets[m_info->export_targets[i]] = 1;
> +		}
> +	}
> +
>  	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		if (!mdsc->sessions[i])
>  			continue;
> @@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>  		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>  			mutex_unlock(&mdsc->mutex);
> +			if (export_targets)
> +				export_targets[i] = 0;
>  			send_mds_reconnect(mdsc, s);
>  			mutex_lock(&mdsc->mutex);
>  		}
> @@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		}
>  	}
>  
> +	for (i = 0; i < newmap->possible_max_rank; i++) {

The condition on this loop is slightly different from the one below it,
and I'm not sure why. Should this also be checking this?

    i < newmap->possible_max_rank && i < mdsc->max_sessions

...do we need to look at export targets where i >= mdsc->max_sessions ?

> +		if (!export_targets)
> +			break;
> +
> +		/*
> +		 * Only open and reconnect sessions that don't
> +		 * exist yet.
> +		 */
> +		if (!export_targets[i] || __have_session(mdsc, i))
> +			continue;
> +
> +		/*
> +		 * In case the export MDS is crashed just after
> +		 * the EImportStart journal is flushed, so when
> +		 * a standby MDS takes over it and is replaying
> +		 * the EImportStart journal the new MDS daemon
> +		 * will wait the client to reconnect it, but the
> +		 * client may never register/open the sessions
> +		 * yet.
> +		 *
> +		 * It will try to reconnect that MDS daemons if
> +		 * the MDSes are in the export targets and is the
> +		 * RECONNECT state.
> +		 */
> +		newstate = ceph_mdsmap_get_state(newmap, i);
> +		if (newstate != CEPH_MDS_STATE_RECONNECT)
> +			continue;
> +		s = __open_export_target_session(mdsc, i);
> +		if (IS_ERR(s)) {
> +			err = PTR_ERR(s);
> +			pr_err("failed to open export target session, err %d\n",
> +			       err);
> +			continue;
> +		}
> +		dout("send reconnect to target mds.%d\n", i);
> +		mutex_unlock(&mdsc->mutex);
> +		send_mds_reconnect(mdsc, s);
> +		mutex_lock(&mdsc->mutex);
> +		ceph_put_mds_session(s);

Suppose we end up in this part of the code, and we have to drop the
mdsc->mutex like this. What ensures that an earlier session in the array
won't end up going back into CEPH_MDS_STATE_RECONNECT before we can get
into the loop below? This looks racy.

> +	}
> +
>  	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		s = mdsc->sessions[i];
>  		if (!s)
> @@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  			__open_export_target_sessions(mdsc, s);
>  		}
>  	}
> +
> +	kfree(export_targets);
>  }
>  
>  

-- 
Jeff Layton <jlayton@kernel.org>

