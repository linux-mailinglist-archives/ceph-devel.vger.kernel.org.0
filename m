Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6826A013C
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfH1MFB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 08:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfH1MFA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 08:05:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3792173E;
        Wed, 28 Aug 2019 12:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566993899;
        bh=a9yoDi7IwlbPtOkcHhnpvZ7CKEa8wVvd63kTQR3A0g4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZHKikdWRxpeysCV+8dbQO+5fE0up5MnHcwhAhNyqT9e4xiKtnt/WPMBErkgHiY+fq
         iy0Q9fUwIqB9fki/Gz4x522qGpyMeFVxkB40llYrw0yT+HbGZIU222zuLD8SCPjClM
         x6mtTiB5VobBEpU6Ye1xRKwmtG7d5brdtUfvdpAQ=
Message-ID: <c568f3b8453a55516dd13bfd617edb778a6f7b1c.camel@kernel.org>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening
 state
From:   Jeff Layton <jlayton@kernel.org>
To:     chenerqi@gmail.com, ceph-devel@vger.kernel.org
Cc:     "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 28 Aug 2019 08:04:58 -0400
In-Reply-To: <20190828094855.49918-1-chenerqi@gmail.com>
References: <20190828094855.49918-1-chenerqi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-08-28 at 17:48 +0800, chenerqi@gmail.com wrote:
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
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..eee4b63 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4044,7 +4044,7 @@ static void delayed_work(struct work_struct *work)
>  				pr_info("mds%d hung\n", s->s_mds);
>  			}
>  		}
> -		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> +		if (s->s_state < CEPH_MDS_SESSION_OPENING) {
>  			/* this mds is failed or recovering, just wait */
>  			ceph_put_mds_session(s);
>  			continue;

Just for my own edification:

OPENING == we've sent (or are sending) the session open request
OPEN == we've gotten the reply from the MDS and it was successful

So in this case, the client got blacklisted after sending the request
but before the reply? Ok.

So this should make it send a keepalive (or cap) message, at which point
the client discovers the connection is closed and then goes to reconnect
the session. This sounds sane to me, but I wonder if this would be
better expressed as:

    if (s->s_state == CEPH_MDS_SESSION_NEW)

It always seems odd to me that we rely on the numerical values in this
enum. That said, we do that all over the code, so I'm inclined to just
merge this as-is (assuming Zheng concurs).

-- 
Jeff Layton <jlayton@kernel.org>

