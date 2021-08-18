Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531B23F03BD
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhHRMcO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhHRMcN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEE5C60EFE;
        Wed, 18 Aug 2021 12:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629289899;
        bh=WAQnCWOKQhx39dzfosvvy92n1OJgNqF9wYt5XXYvAVs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D7vSAksSE121Bj3MQhI+LuWsJuPeY1ALvUH+C0e+oOh24QZPKQbAxFZjf+njV5DWh
         88Gr3MIDfwaXi9TcBiUS6KRdz1C1fu93BbSh/d3IKV3mUMuA0xLOD8IGDHRSRLklJJ
         D6drs6hmlykXaMohu0UBAMoVTF9J+4mTbj0KNQQ3EJnzLkZQZGrPr+9XMzqwJ2tVV9
         /GJhQ/hGuw6Tlgx9fjWdlJEjRyQ9lyst0ab0zMipJW9ypbGr2pQDS0jlqPcBZHFBbo
         aTCNz8W9RSPLNf1LkpJrxL3Vkk5EezUrHC3nqyfdh0H86FxioZYbi9iuDAaAO7ZWbz
         thOQ949J0OJJg==
Message-ID: <6b99366e2fc4775aec7e1c39053580a4e1048e59.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: try to reconnect to the export targets
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 18 Aug 2021 08:31:37 -0400
In-Reply-To: <20210818013119.76694-1-xiubli@redhat.com>
References: <20210818013119.76694-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 09:31 +0800, xiubli@redhat.com wrote:
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
> V3:
> - switch to bitmap and on the stack
> - put the ceph_put_mds_session() out of the mdsc->mutex lock scope
> 
> 
>  fs/ceph/mds_client.c | 55 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/mdsmap.c     | 10 +++++---
>  2 files changed, 61 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e49dbeb6c06f..c2fca06b09a0 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -11,6 +11,7 @@
>  #include <linux/ratelimit.h>
>  #include <linux/bits.h>
>  #include <linux/ktime.h>
> +#include <linux/bitmap.h>
>  
>  #include "super.h"
>  #include "mds_client.h"
> @@ -4197,13 +4198,19 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  			  struct ceph_mdsmap *newmap,
>  			  struct ceph_mdsmap *oldmap)
>  {
> -	int i;
> +	int i, err;
>  	int oldstate, newstate;
>  	struct ceph_mds_session *s;
> +	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
>  
>  	dout("check_new_map new %u old %u\n",
>  	     newmap->m_epoch, oldmap->m_epoch);
>  
> +	if (newmap->m_info) {
> +		for (i = 0; i < newmap->m_info->num_export_targets; i++)
> +			set_bit(newmap->m_info->export_targets[i], targets);
> +	}
> +

I wasn't aware you could exceed the size of the first unsigned long in
the array with the atomic bitops handlers. Looking at the helpers
themselves though, I don't see why this wouldn't work. Ok!

>  	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		if (!mdsc->sessions[i])
>  			continue;
> @@ -4257,6 +4264,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>  		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>  			mutex_unlock(&mdsc->mutex);
> +			clear_bit(i, targets);
>  			send_mds_reconnect(mdsc, s);
>  			mutex_lock(&mdsc->mutex);
>  		}
> @@ -4279,6 +4287,51 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		}
>  	}
>  
> +	/*
> +	 * Only open and reconnect sessions that don't exist yet.
> +	 */
> +	for (i = 0; i < newmap->possible_max_rank; i++) {
> +		/*
> +		 * In case the import MDS is crashed just after
> +		 * the EImportStart journal is flushed, so when
> +		 * a standby MDS takes over it and is replaying
> +		 * the EImportStart journal the new MDS daemon
> +		 * will wait the client to reconnect it, but the
> +		 * client may never register/open the session yet.
> +		 *
> +		 * Will try to reconnect that MDS daemon if the
> +		 * rank number is in the export targets array and
> +		 * is the up:reconnect state.
> +		 */
> +		newstate = ceph_mdsmap_get_state(newmap, i);
> +		if (!test_bit(i, targets) || newstate != CEPH_MDS_STATE_RECONNECT)
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
> +		ceph_put_mds_session(s);
> +		mutex_lock(&mdsc->mutex);
> +	}
> +
>  	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		s = mdsc->sessions[i];
>  		if (!s)
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

Looks good. Merged into testing. I also reworded the changelog for
(hopefully) better clarity. Xiubo, let me know if I didn't get the
description right.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

