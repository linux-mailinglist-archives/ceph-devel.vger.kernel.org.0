Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C7C19DE62
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgDCTMe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Apr 2020 15:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgDCTMd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 15:12:33 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7269820719;
        Fri,  3 Apr 2020 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585941152;
        bh=t0O3jl7lAXvw+9N2JWtwAXa6QWnP6W4U0pIo3Ws8X5Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uH1TNf/3jQZNBC1wQohSFDtOhglrtPcpp60w5N1aMvLpEY2NYoNh/QTCSVbDpoKT+
         F8kXhp8UCVRPPISI/QTtQExSAVQcwvn3VdOsTmp7V88Vwc8p5QMIRgZHwsCvzgLCCv
         vv/TZpRE6SmiejiKmGPcR0XuJGviBK89onH2YiDU=
Message-ID: <d78905efb00f9501e053f0acded14fc4cbc3eacf.camel@kernel.org>
Subject: Re: [PATCH] ceph: unify i_dirty_item and i_flushing_item handling
 when auth caps change
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Date:   Fri, 03 Apr 2020 15:12:31 -0400
In-Reply-To: <20200403144751.23977-1-jlayton@kernel.org>
References: <20200403144751.23977-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-04-03 at 10:47 -0400, Jeff Layton wrote:
> Suggested-by: "Yan, Zheng" <zyan@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 47 +++++++++++++++++++++++++----------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index eb190e4e203c..b3460d52a305 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3700,6 +3700,27 @@ static bool handle_cap_trunc(struct inode *inode,
>  	return queue_trunc;
>  }
>  
> +/**
> + * transplant_auth_cap - move inode to appropriate lists when auth caps change
> + * @ci: inode to be moved
> + * @session: new auth caps session
> + */
> +static void transplant_auth_ses(struct ceph_inode_info *ci,
> +				struct ceph_mds_session *session)
> +{
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	if (list_empty(&ci->i_dirty_item) && list_empty(&ci->i_flushing_item))
> +		return;
> +
> +	spin_lock(&session->s_mdsc->cap_dirty_lock);
> +	if (!list_empty(&ci->i_dirty_item))
> +		list_move(&ci->i_dirty_item, &session->s_cap_dirty);
> +	if (!list_empty(&ci->i_flushing_item))
> +		list_move_tail(&ci->i_flushing_item, &session->s_cap_flushing);
> +	spin_unlock(&session->s_mdsc->cap_dirty_lock);
> +}
> +
>  /*
>   * Handle EXPORT from MDS.  Cap is being migrated _from_ this mds to a
>   * different one.  If we are the most recent migration we've seen (as
> @@ -3771,22 +3792,9 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  			tcap->issue_seq = t_seq - 1;
>  			tcap->issued |= issued;
>  			tcap->implemented |= issued;
> -			if (cap == ci->i_auth_cap)
> +			if (cap == ci->i_auth_cap) {
>  				ci->i_auth_cap = tcap;
> -
> -			if (!list_empty(&ci->i_dirty_item)) {
> -				spin_lock(&mdsc->cap_dirty_lock);
> -				list_move(&ci->i_dirty_item,
> -					  &tcap->session->s_cap_dirty);
> -				spin_unlock(&mdsc->cap_dirty_lock);
> -			}
> -
> -			if (!list_empty(&ci->i_cap_flush_list) &&
> -			    ci->i_auth_cap == tcap) {
> -				spin_lock(&mdsc->cap_dirty_lock);
> -				list_move_tail(&ci->i_flushing_item,
> -					       &tcap->session->s_cap_flushing);
> -				spin_unlock(&mdsc->cap_dirty_lock);
> +				transplant_auth_ses(ci, tcap->session);
>  			}
>  		}
>  		__ceph_remove_cap(cap, false);
> @@ -3798,13 +3806,8 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
>  			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
>  
> -		if (!list_empty(&ci->i_cap_flush_list) &&
> -		    ci->i_auth_cap == tcap) {
> -			spin_lock(&mdsc->cap_dirty_lock);
> -			list_move_tail(&ci->i_flushing_item,
> -				       &tcap->session->s_cap_flushing);
> -			spin_unlock(&mdsc->cap_dirty_lock);
> -		}
> +		if (ci->i_auth_cap == tcap)
> +			transplant_auth_ses(ci, tcap->session);
>  
>  		__ceph_remove_cap(cap, false);
>  		goto out_unlock;

If this looks ok, I think I'll fold it into "ceph: convert
mdsc->cap_dirty to a per-session list".

-- 
Jeff Layton <jlayton@kernel.org>

