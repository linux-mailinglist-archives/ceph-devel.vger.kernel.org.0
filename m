Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9EAEB38
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 15:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbfIJNNy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 09:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfIJNNy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:13:54 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584F821019;
        Tue, 10 Sep 2019 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568121233;
        bh=V55o4gBVCahB5PgSe9ehccNx4OWXfyZj4WirmnMmEmA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=IB1akXYb6siFwnL4eRbet7uvezNWcS52bCZoI8kOXplq207t9UhIz3YHv8uHTY2Jk
         7Yh/lNcugltDTy3tzgP/SvV7368fHEQZQR05qHBpwKpftErisJowRK1llycaSAPmQj
         JXzFL+DbU8whZd2IRKNxAAtX7w8wQzNdcSO81+CA=
Message-ID: <5f0d307b37615756d0f284da5e2a505ab7436198.camel@kernel.org>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening
 state
From:   Jeff Layton <jlayton@kernel.org>
To:     chenerqi@gmail.com, ceph-devel@vger.kernel.org
Date:   Tue, 10 Sep 2019 09:13:52 -0400
In-Reply-To: <20190910130912.46277-1-chenerqi@gmail.com>
References: <20190910130912.46277-1-chenerqi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-09-10 at 21:09 +0800, chenerqi@gmail.com wrote:
> From: chenerqi <chenerqi@gmail.com>
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
> index 937e887..8f382b5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3581,7 +3581,9 @@ static void delayed_work(struct work_struct *work)
>  				pr_info("mds%d hung\n", s->s_mds);
>  			}
>  		}
> -		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> +		if (s->s_state == CEPH_MDS_SESSION_NEW ||
> +		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> +		    s->s_state == CEPH_MDS_SESSION_REJECTED) {
>  			/* this mds is failed or recovering, just wait */
>  			ceph_put_mds_session(s);
>  			continue;

This has already been merged into the testing branch and should make
v5.4. Was there a reason you decided to resend it?
-- 
Jeff Layton <jlayton@kernel.org>

