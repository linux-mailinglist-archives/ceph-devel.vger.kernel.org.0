Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8183A9EF4
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhFPP1h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 11:27:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39106 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbhFPP1g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 11:27:36 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9B1611FD47;
        Wed, 16 Jun 2021 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0vflPaMulYdbXMWZn5Zs39WOki/oEoyA54QoLpeZbo=;
        b=Ub0rW9RymtuAWriCKRochGDbslktief8IPDefJA2k1bnnXbDM43uQ3Lxowq5R5Mn9m5hUj
        TWFsARR2aVGiJr1iOIH6KRBGtU5Yhx6Ef4JgODkh+cscgOrMRsZXCg9aGpeUo729t6icNW
        7Jp82Xz2E3tlVEy0U5uas1lnTmK8aSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857129;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0vflPaMulYdbXMWZn5Zs39WOki/oEoyA54QoLpeZbo=;
        b=+oZZVruu4WCmCOgGO/A0ql3d3FrrF7K+5FxkZQj85NWRkyfv8KrI02k07IySp3mXkuR3EZ
        Po4oMxuscVfDWbDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 31466118DD;
        Wed, 16 Jun 2021 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0vflPaMulYdbXMWZn5Zs39WOki/oEoyA54QoLpeZbo=;
        b=Ub0rW9RymtuAWriCKRochGDbslktief8IPDefJA2k1bnnXbDM43uQ3Lxowq5R5Mn9m5hUj
        TWFsARR2aVGiJr1iOIH6KRBGtU5Yhx6Ef4JgODkh+cscgOrMRsZXCg9aGpeUo729t6icNW
        7Jp82Xz2E3tlVEy0U5uas1lnTmK8aSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857129;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0vflPaMulYdbXMWZn5Zs39WOki/oEoyA54QoLpeZbo=;
        b=+oZZVruu4WCmCOgGO/A0ql3d3FrrF7K+5FxkZQj85NWRkyfv8KrI02k07IySp3mXkuR3EZ
        Po4oMxuscVfDWbDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 6FBPCekXymBwfAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Wed, 16 Jun 2021 15:25:29 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id bc128d40;
        Wed, 16 Jun 2021 15:25:28 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:25:28 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 4/6] ceph: don't take s_mutex in try_flush_caps
Message-ID: <YMoX6DL9xeKvTgSK@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-5-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145730.21952-5-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 10:57:28AM -0400, Jeff Layton wrote:
> The s_mutex doesn't protect anything in this codepath.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 825b1e463ad3..d21b1fa36875 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2149,26 +2149,17 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  {
>  	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_mds_session *session = NULL;
>  	int flushing = 0;
>  	u64 flush_tid = 0, oldest_flush_tid = 0;
>  
> -retry:
>  	spin_lock(&ci->i_ceph_lock);
>  retry_locked:
>  	if (ci->i_dirty_caps && ci->i_auth_cap) {
>  		struct ceph_cap *cap = ci->i_auth_cap;
>  		struct cap_msg_args arg;
> +		struct ceph_mds_session *session = cap->session;
>  
> -		if (session != cap->session) {
> -			spin_unlock(&ci->i_ceph_lock);
> -			if (session)
> -				mutex_unlock(&session->s_mutex);
> -			session = cap->session;
> -			mutex_lock(&session->s_mutex);
> -			goto retry;
> -		}
> -		if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
> +		if (session->s_state < CEPH_MDS_SESSION_OPEN) {
>  			spin_unlock(&ci->i_ceph_lock);
>  			goto out;
>  		}
> @@ -2205,9 +2196,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  		spin_unlock(&ci->i_ceph_lock);
>  	}
>  out:
> -	if (session)
> -		mutex_unlock(&session->s_mutex);
> -
>  	*ptid = flush_tid;
>  	return flushing;
>  }
> -- 
> 2.31.1
> 

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--
Luís
