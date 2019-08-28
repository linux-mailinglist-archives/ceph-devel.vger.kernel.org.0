Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB22BA041B
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfH1OEU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 10:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfH1OET (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 10:04:19 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEC52080F;
        Wed, 28 Aug 2019 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567001058;
        bh=nTA0Mhc3f63XWszB6RLxEhVJe8t/AOi22YeOsdOKJyY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=CIed2oIilZa7/JGZlaT74HBZHvf3xUVtQ7ctBSCEWFQneoaM1BT2EVVSLMQGZ7A4F
         RjZkQ1rgDEqUneQVC9V6r3QEOEMU0sIh14LlgyTEC6yTl3rcXQeRIlKoSP+z3zCqFq
         zvPE7As2Or9Z7+4a61EXXrCaoJa9YBtyn5L5n57Q=
Message-ID: <398eae89e986dc9847c76421cc6d866ab2f1c4bb.camel@kernel.org>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening
 state
From:   Jeff Layton <jlayton@kernel.org>
To:     chenerqi@gmail.com, ceph-devel@vger.kernel.org
Date:   Wed, 28 Aug 2019 10:04:17 -0400
In-Reply-To: <20190828132245.53155-1-chenerqi@gmail.com>
References: <20190828132245.53155-1-chenerqi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-08-28 at 21:22 +0800, chenerqi@gmail.com wrote:
> From: Erqi Chen <chenerqi@gmail.com>
> 
> If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
> mds won't send session msg to client, and delayed_work skip
> CEPH_MDS_SESSION_OPENING state session, the session hang forever.
> ceph_con_keepalive reconnct connection for CEPH_MDS_SESSION_OPENING
> session to avoid session hang.
> 
> Fixes: https://tracker.ceph.com/issues/41551
> Signed-off-by: Erqi Chen chenerqi@gmail.com
> ---
>  fs/ceph/mds_client.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..3d589c0 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4044,7 +4044,9 @@ static void delayed_work(struct work_struct *work)
>  				pr_info("mds%d hung\n", s->s_mds);
>  			}
>  		}
> -		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> +		if (s->s_state == CEPH_MDS_SESSION_NEW ||
> +		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> +		    s->s_state == CEPH_MDS_SESSION_REJECTED)
>  			/* this mds is failed or recovering, just wait */
>  			ceph_put_mds_session(s);
>  			continue;

This "if" is missing an opening curly brace. I fixed that up and cleaned
up the changelog. I'll merge this into ceph/testing after doing some
tests with it today.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

