Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63328287AF9
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Oct 2020 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgJHR3V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Oct 2020 13:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgJHR3U (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 13:29:20 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C635522200;
        Thu,  8 Oct 2020 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602178160;
        bh=MsmO+wSTRfPE2pavE4oPWOcPS/7HtXjxBJET7rI1u0U=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=d93+1WNPizx8ojnM9yXNBGA9DkapCnwjeBYp7CGMNoxQm3COVSe5jDxuo5qqx3c5O
         6ATYJjWHPfSckhwS9DD8HbHNRNqCtwk0C89CBEHjNXSYrPwNo+40O9L+ETLVtffk0O
         tTixJqARucMOuIWUT4deGeJzLEX8Wnfh4jVzm2Is=
Message-ID: <a84ecb3297c19a92122846f22e38d932aedccb6b.camel@kernel.org>
Subject: Re: [PATCH] libceph: clear con->out_msg on Policy::stateful_server
 faults
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Thu, 08 Oct 2020 13:29:18 -0400
In-Reply-To: <20201008165800.9494-1-idryomov@gmail.com>
References: <20201008165800.9494-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-10-08 at 18:58 +0200, Ilya Dryomov wrote:
> con->out_msg must be cleared on Policy::stateful_server
> (!CEPH_MSG_CONNECT_LOSSY) faults.  Not doing so botches the
> reconnection attempt, because after writing the banner the
> messenger moves on to writing the data section of that message
> (either from where it got interrupted by the connection reset or
> from the beginning) instead of writing struct ceph_msg_connect.
> This results in a bizarre error message because the server
> sends CEPH_MSGR_TAG_BADPROTOVER but we think we wrote struct
> ceph_msg_connect:
> 
>   libceph: mds0 (1)172.21.15.45:6828 socket error on write
>   ceph: mds0 reconnect start
>   libceph: mds0 (1)172.21.15.45:6829 socket closed (con state OPEN)
>   libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch, my 32 != server's 32
>   libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch
> 
> AFAICT this bug goes back to the dawn of the kernel client.
> The reason it survived for so long is that only MDS sessions
> are stateful and only two MDS messages have a data section:
> CEPH_MSG_CLIENT_RECONNECT (always, but reconnecting is rare)
> and CEPH_MSG_CLIENT_REQUEST (only when xattrs are involved).
> The connection has to get reset precisely when such message
> is being sent -- in this case it was the former.
> 
> Cc: stable@vger.kernel.org
> Link: https://tracker.ceph.com/issues/47723
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/messenger.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index e9e2763a255f..c1f1f85545c3 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -2998,6 +2998,11 @@ static void con_fault(struct ceph_connection *con)
>  		ceph_msg_put(con->in_msg);
>  		con->in_msg = NULL;
>  	}
> +	if (con->out_msg) {
> +		BUG_ON(con->out_msg->con != con);
> +		ceph_msg_put(con->out_msg);
> +		con->out_msg = NULL;
> +	}
>  
>  	/* Requeue anything that hasn't been acked */
>  	list_splice_init(&con->out_sent, &con->out_queue);

Nice catch, Ilya.

It might be nice to make a common helper that both reset_connection and
con_fault can call to drop the in_msg/out_msg, but keeping this small
for a stable patch is reasonable. Maybe that can be done as part of the
msgr2 work?
 
Reviewed-by: Jeff Layton <jlayton@kernel.org>

