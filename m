Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC093A9F03
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 17:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhFPP2A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 11:28:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44278 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbhFPP2A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 11:28:00 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4995921A69;
        Wed, 16 Jun 2021 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTU5jP+PeYlJxCkI6Drsd82MLlGqtDvJEel1qiyfdQc=;
        b=Y1YJogrGiVhddzLPsHc0Nln/rhXhQnCkJ2zln+UoDlmAm694/Ji/7QN88geJR1LFUmaDVD
        NL66up+WSN+M+fYaqGfRMsGIMqeYHTI7jSIA/JI6SiXjGi/dOc6180+pJYgSHbl/q5/ndZ
        iAwoY8TVMS5F3fHB+8rHJjlqJni7iP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857153;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTU5jP+PeYlJxCkI6Drsd82MLlGqtDvJEel1qiyfdQc=;
        b=j7UalBwVZlOCRT/zGWveZexXk2+g0w7K+B0a+w47awsnP3W0v9b+Vp6fWAEeg81VypQSpE
        FJKkDmwJrXchvMBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D4FD3118DD;
        Wed, 16 Jun 2021 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTU5jP+PeYlJxCkI6Drsd82MLlGqtDvJEel1qiyfdQc=;
        b=Y1YJogrGiVhddzLPsHc0Nln/rhXhQnCkJ2zln+UoDlmAm694/Ji/7QN88geJR1LFUmaDVD
        NL66up+WSN+M+fYaqGfRMsGIMqeYHTI7jSIA/JI6SiXjGi/dOc6180+pJYgSHbl/q5/ndZ
        iAwoY8TVMS5F3fHB+8rHJjlqJni7iP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857153;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTU5jP+PeYlJxCkI6Drsd82MLlGqtDvJEel1qiyfdQc=;
        b=j7UalBwVZlOCRT/zGWveZexXk2+g0w7K+B0a+w47awsnP3W0v9b+Vp6fWAEeg81VypQSpE
        FJKkDmwJrXchvMBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id BV5AMQAYymCbfAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Wed, 16 Jun 2021 15:25:52 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 46426dca;
        Wed, 16 Jun 2021 15:25:52 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:25:51 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 5/6] ceph: don't take s_mutex in ceph_flush_snaps
Message-ID: <YMoX/4WfJaIFQRFZ@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-6-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145730.21952-6-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 10:57:29AM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 8 +-------
>  fs/ceph/snap.c | 4 +---
>  2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d21b1fa36875..5864d5088e27 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1531,7 +1531,7 @@ static inline int __send_flush_snap(struct inode *inode,
>   * asynchronously back to the MDS once sync writes complete and dirty
>   * data is written out.
>   *
> - * Called under i_ceph_lock.  Takes s_mutex as needed.
> + * Called under i_ceph_lock.
>   */
>  static void __ceph_flush_snaps(struct ceph_inode_info *ci,
>  			       struct ceph_mds_session *session)
> @@ -1653,7 +1653,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>  	mds = ci->i_auth_cap->session->s_mds;
>  	if (session && session->s_mds != mds) {
>  		dout(" oops, wrong session %p mutex\n", session);
> -		mutex_unlock(&session->s_mutex);
>  		ceph_put_mds_session(session);
>  		session = NULL;
>  	}
> @@ -1662,10 +1661,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>  		mutex_lock(&mdsc->mutex);
>  		session = __ceph_lookup_mds_session(mdsc, mds);
>  		mutex_unlock(&mdsc->mutex);
> -		if (session) {
> -			dout(" inverting session/ino locks on %p\n", session);
> -			mutex_lock(&session->s_mutex);
> -		}
>  		goto retry;
>  	}
>  
> @@ -1680,7 +1675,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>  	if (psession) {
>  		*psession = session;
>  	} else if (session) {
> -		mutex_unlock(&session->s_mutex);
>  		ceph_put_mds_session(session);

nit: since ceph_put_mds_session() now checks for NULL, the 'else' doesn't
really need the condition.

>  	}
>  	/* we flushed them all; remove this inode from the queue */
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index f8cac2abab3f..afc7f4c32364 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -846,10 +846,8 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
>  	}
>  	spin_unlock(&mdsc->snap_flush_lock);
>  
> -	if (session) {
> -		mutex_unlock(&session->s_mutex);
> +	if (session)
>  		ceph_put_mds_session(session);
> -	}

Same here: the 'if (session)' can be dropped.

>  	dout("flush_snaps done\n");
>  }
>  
> -- 
> 2.31.1
> 

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--
Luís
