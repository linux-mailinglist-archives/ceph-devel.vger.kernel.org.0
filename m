Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6071C504EB3
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiDRKRt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiDRKRq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566C9B7D5
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7F03611C5
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 10:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CB5C385A1;
        Mon, 18 Apr 2022 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650276907;
        bh=yUxhIdr8Sd+bOR0hy+65rz+xjEwzouObenU8F943hYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bo81OTWyo0u+u8yYgy0AvcBBAHQV0GNPj+r2evmu8q4JHY6IsYKOp3sEmxrpvaN09
         iisBoFkCm21UUtHMS40H/sd8Vix3xDJkRxMBMpDKeunT16+lKIgIt+J58gvU7FyvoR
         K0nM8P4HQD97JK1jZZhX+mEvUsCtwmWWWU91Wwuux65d2fPV7eaQoeFQfFNS17g/vi
         QffmqqMQWTN13MUI9I4qh1IjSFqqL93bp7oMoUqYICZETRQO5UI5YleI45Kx0nuO5p
         +ZewDVmzERs/1YB9KZHEb0WIggNFQSLE/6NR8ywdWh/m8+3cSE6gtytF9HEbmGQzI/
         YRBV4NmktixWg==
Message-ID: <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 06:15:05 -0400
In-Reply-To: <20220411093405.301667-1-xiubli@redhat.com>
References: <20220411093405.301667-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-04-11 at 17:34 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> From the posix and the initial statx supporting commit comments,
> the AT_STATX_DONT_SYNC is a lightweight stat flag and the
> AT_STATX_FORCE_SYNC is a heaverweight one. And also checked all
> the other current usage about these two flags they are all doing
> the same, that is only when the AT_STATX_FORCE_SYNC is not set
> and the AT_STATX_DONT_SYNC is set will they skip sync retriving
> the attributes from storage.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 6788a1f88eb6..1ee6685def83 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2887,7 +2887,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>  		return -ESTALE;
>  
>  	/* Skip the getattr altogether if we're asked not to sync */
> -	if (!(flags & AT_STATX_DONT_SYNC)) {
> +	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {
>  		err = ceph_do_getattr(inode,
>  				statx_to_caps(request_mask, inode->i_mode),
>  				flags & AT_STATX_FORCE_SYNC);

I don't get it.

The only way I can see that this is a problem is if someone sent down a
mask with both DONT_SYNC and FORCE_SYNC set in it, and in that case I
don't see that ignoring FORCE_SYNC would be wrong...

-- 
Jeff Layton <jlayton@kernel.org>
