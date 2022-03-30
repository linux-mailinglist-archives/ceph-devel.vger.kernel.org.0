Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A447D4ECD0E
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350719AbiC3TPI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 15:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbiC3TPB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 15:15:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A894B220F0
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 12:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6C13CE1F0C
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 19:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD4DC340EC;
        Wed, 30 Mar 2022 19:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648667592;
        bh=VQQV4Ur/m1b9CH++qSosAsvLQTpN/s9JNOhFcc0vHE8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GLGIb5ZJ3kOtfLPdwcF8aaxLiCl61XHU7PJHYyS5T2r4XdxGhg61kK9B/aU/qG/Ps
         G6LUYMpsALW9g2B1B5zB0UsCDjB0ySIVsS+45wBmd2TqNuov90IYp1moa606sY/A+C
         zcwxPhXGrBGsL56ZJEO196RK3wnzqbzmFxKNEhxCyYPEkHs+CCjQUYxVVB+z1cbJn7
         SPWO6MuH1k/IwtB4VUtjslcUhco+rimNPume/oajEy/dtTQXWVGGf/YyI4EadvzX/P
         hhhuyr3KkjV/K0aOQOeggIRowN7yVOIOGovgrrznYt0yZkXMbnp4sgodlSGQ0Oi+I0
         LqO9rVskfa6mw==
Message-ID: <7cb4898491f262fd1ecf411f055a00927ebc13b4.camel@kernel.org>
Subject: Re: [PATCH] ceph: discard r_new_inode if open O_CREAT opened
 existing inode
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com,
        =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Date:   Wed, 30 Mar 2022 15:13:09 -0400
In-Reply-To: <20220330190457.73279-1-jlayton@kernel.org>
References: <20220330190457.73279-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-30 at 15:04 -0400, Jeff Layton wrote:
> When we do an unchecked create, we optimistically pre-create an inode
> and populate it, including its fscrypt context. It's possible though
> that we'll end up opening an existing inode, in which case the
> precreated inode will have a crypto context that doesn't match the
> existing data.
> 
> If we're issuing an O_CREAT open and find an existing inode, just
> discard the precreated inode and create a new one to ensure the context
> is properly set.
> 
> Cc: Luís Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 840a60b812fc..b03128fdbb07 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  	/* Must find target inode outside of mutexes to avoid deadlocks */
>  	rinfo = &req->r_reply_info;
>  	if ((err >= 0) && rinfo->head->is_target) {
> -		struct inode *in;
> +		struct inode *in = xchg(&req->r_new_inode, NULL);
>  		struct ceph_vino tvino = {
>  			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
>  			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
>  		};
>  
> -		in = ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, NULL));
> +		/* If we ended up opening an existing inode, discard r_new_inode */
> +		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
> +			iput(in);
> +			in = NULL;
> +		}
> +
> +		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
>  		if (IS_ERR(in)) {
>  			err = PTR_ERR(in);
>  			mutex_lock(&session->s_mutex);

Forgot to mention that this one is for the fscrypt pile. This patch
fixes generic/595 for me.
-- 
Jeff Layton <jlayton@kernel.org>
