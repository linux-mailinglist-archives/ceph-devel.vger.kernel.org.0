Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2654AC353
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiBGP3K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443515AbiBGPNW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 10:13:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F35AC03E925
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 07:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8AC1CE1119
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 15:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1D4C004E1;
        Mon,  7 Feb 2022 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644246751;
        bh=y5eBoOQCmBnke15eTNUqktXXLsmR5tUo9jEaWpozvNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lf16VtQuPeYlQHpef3ctxawnU8esAzUWSgzFYrK2i3yJWMU7HLKzbpU2af2FZpL+e
         bgZ2F1nCIxpvl97AAcd0w79B7lqBPia7Me65hIlLcTcybju0K9I82lFOr4GiPOxezq
         lgYl1h6DAOujgKnwR3K/OEHuM2dVvhIF76yMaFK62dWQLrVY/XMU3uJ08rJSQe42AC
         tlLZ6jwJoKxjLjQQVgbN3lQLIe/E6R4dwaHgLAKXil5/Dc7ssUa6QITgkjD+nVfDmQ
         gPvIJ8izP2gPW3ZUxR0JFsc4Zee+hvMlKYSL/z2O3rnDapl03dhEcKGu4SuqM8rDJk
         +IJiS5r64/Iyg==
Message-ID: <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        Gregory Farnum <gfarnum@redhat.com>,
        ukernel <ukernel@gmail.com>
Date:   Mon, 07 Feb 2022 10:12:29 -0500
In-Reply-To: <20220207050340.872893-1-xiubli@redhat.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If MDS return ESTALE, that means the MDS has already iterated all
> the possible active MDSes including the auth MDS or the inode is
> under purging. No need to retry in auth MDS and will just return
> ESTALE directly.
> 

When you say "purging" here, do you mean that it's effectively being
cleaned up after being unlinked? Or is it just being purged from the
MDS's cache?

> Or it will cause definite loop for retrying it.
> 
> URL: https://tracker.ceph.com/issues/53504
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 29 -----------------------------
>  1 file changed, 29 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 93e5e3c4ba64..c918d2ac8272 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  
>  	result = le32_to_cpu(head->result);
>  
> -	/*
> -	 * Handle an ESTALE
> -	 * if we're not talking to the authority, send to them
> -	 * if the authority has changed while we weren't looking,
> -	 * send to new authority
> -	 * Otherwise we just have to return an ESTALE
> -	 */
> -	if (result == -ESTALE) {
> -		dout("got ESTALE on request %llu\n", req->r_tid);
> -		req->r_resend_mds = -1;
> -		if (req->r_direct_mode != USE_AUTH_MDS) {
> -			dout("not using auth, setting for that now\n");
> -			req->r_direct_mode = USE_AUTH_MDS;
> -			__do_request(mdsc, req);
> -			mutex_unlock(&mdsc->mutex);
> -			goto out;
> -		} else  {
> -			int mds = __choose_mds(mdsc, req, NULL);
> -			if (mds >= 0 && mds != req->r_session->s_mds) {
> -				dout("but auth changed, so resending\n");
> -				__do_request(mdsc, req);
> -				mutex_unlock(&mdsc->mutex);
> -				goto out;
> -			}
> -		}
> -		dout("have to return ESTALE on request %llu\n", req->r_tid);
> -	}
> -
> -
>  	if (head->safe) {
>  		set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
>  		__unregister_request(mdsc, req);


(cc'ing Greg, Sage and Zheng)

This patch sort of contradicts the original design, AFAICT, and I'm not
sure what the correct behavior should be. I could use some
clarification.

The original code (from the 2009 merge) would tolerate 2 ESTALEs before
giving up and returning that to userland. Then in 2010, Greg added this
commit:

    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f

...which would presumably make it retry indefinitely as long as the auth
MDS kept changing. Then, Zheng made this change in 2013:

    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938

...which seems to try to do the same thing, but detected the auth mds
change in a different way.

Is that where livelock detection was broken? Or was there some
corresponding change to __choose_mds that should prevent infinitely
looping on the same request?

In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
and that the server has forgotten about it. Does it mean the same thing
to the ceph MDS?

Has the behavior of the MDS changed such that these retries are no
longer necessary on an ESTALE? If so, when did this change, and does the
client need to do anything to detect what behavior it should be using?
-- 
Jeff Layton <jlayton@kernel.org>
