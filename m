Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8A24B7764
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 21:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbiBORFf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 12:05:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiBORFd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 12:05:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B52117C80
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 09:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5360160C52
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 17:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC5C340EB;
        Tue, 15 Feb 2022 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644944722;
        bh=HmNELKf85jXdITl3T97lI4mxo5MewdpDBDB3dPaFiKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hSFOml4dbUrjqHesT10zjoBTr+dtk3/j8CZ4cXHi/CAk9skjdPNH8X88d34w+QDkl
         763B1gSp3VqsVDDzLUxwdIcQVp2kU6IgNxUoMF9YkicNsCSpunsxvozLfkJbeHYRzG
         eZKP8iTMOyb5a+98DHlSzicoYfYJ2a+vMhSbU6uC16Vn+gVzQshE7Ex74GLaF1tE0Q
         8gymwGNS7V3X8iWu3dDBA6iCT2yv3vfpj6qjNiedj5ATEXMSnKbIho8Vn0b+K4khbc
         gnzA0xw6pAl/pK+Uy4BIvKQomwLza7+pzaq0cvMmeeMXNDAV79nExEqVPXdII46Y9I
         65MokKDHTbe7w==
Message-ID: <13786a0450214e715a01337989660a52f869230c.camel@kernel.org>
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is
 no new snapshot
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 15 Feb 2022 12:05:21 -0500
In-Reply-To: <20220215122316.7625-4-xiubli@redhat.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
         <20220215122316.7625-4-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> No need to update snapshot context when any of the following two
> cases happens:
> 1: if my context seq matches realm's seq and realm has no parent.
> 2: if my context seq equals or is larger than my parent's, this
>    works because we rebuild_snap_realms() works _downward_ in
>    hierarchy after each update.
> 
> This fix will avoid those inodes which accidently calling
> ceph_queue_cap_snap() and make no sense, for exmaple:
> 
> There have 6 directories like:
> 
> /dir_X1/dir_X2/dir_X3/
> /dir_Y1/dir_Y2/dir_Y3/
> 
> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
> make a root snapshot under /.snap/root_snap. And every time when
> we make snapshots under /dir_Y1/..., the kclient will always try
> to rebuild the snap context for snap_X2 realm and finally will
> always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
> no sense.
> 
> That's because the snap_X2's seq is 2 and root_snap's seq is 3.
> So when creating a new snapshot under /dir_Y1/... the new seq
> will be 4, and then the mds will send kclient a snapshot backtrace
> in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
> it will always rebuild the from the last realm, that's the root_snap.
> So later when rebuilding the snap context it will always rebuild
> the snap_X2 realm and then try to queue cap snaps for all the inodes
> related in snap_X2 realm, and we are seeing the logs like:
> 
> "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
> 
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index d075d3ce5f6d..1f24a5de81e7 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>  		num += parent->cached_context->num_snaps;
>  	}
>  
> -	/* do i actually need to update?  not if my context seq
> -	   matches realm seq, and my parents' does to.  (this works
> -	   because we rebuild_snap_realms() works _downward_ in
> -	   hierarchy after each update.) */
> +	/* do i actually need to update? No need when any of the following
> +	 * two cases:
> +	 * #1: if my context seq matches realm's seq and realm has no parent.
> +	 * #2: if my context seq equals or is larger than my parent's, this
> +	 *     works because we rebuild_snap_realms() works _downward_ in
> +	 *     hierarchy after each update.
> +	 */
>  	if (realm->cached_context &&
> -	    realm->cached_context->seq == realm->seq &&
> -	    (!parent ||
> -	     realm->cached_context->seq >= parent->cached_context->seq)) {
> +	    ((realm->cached_context->seq == realm->seq && !parent) ||
> +	     (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
>  		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
>  		     " (unchanged)\n",
>  		     realm->ino, realm, realm->cached_context,

I've never had a good feel for the snaprealm handling code, so I'll
leave it to others that do to comment on whether your logic makes sense.

Either way, I don't think this patch depends on the earlier two, does
it? The comment is a nice addition though.

Acked-by: Jeff Layton <jlayton@kernel.org>
