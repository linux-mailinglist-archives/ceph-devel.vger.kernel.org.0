Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C342D5133A2
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346207AbiD1M3S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 08:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346205AbiD1M3R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 08:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C02945AF2
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5C1C61F8C
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 12:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9885C385A9;
        Thu, 28 Apr 2022 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651148762;
        bh=sUzLNgZXEEI5JZO7sDbsZtb5nAFLmMWNqFDmokrvQI0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CWHYf++SDAVXy8BPUQfxhX0tu9GROdS7KBx9HWry3DPKq9nqcT/99HINdr5bwkxHd
         PtAvC8d4P7+KOJPKAGABGGnvkZHbaF2QZSUZPNJnlI3rWYgx/AglmcRa1hEAPX/oJc
         YTnWYp1sGBJOeOzIhDCJNQ05azhy34dUXK1cDR676nTjiWqQJD4Y9voW9CgYoTj356
         llmcH/aLj/6lv9RQeGOLqWuBxjNf7pMFxRLgUp/6Sp1uZMlyIocLI6vtHJacVnaV4q
         yLlseAz9HJrNGZGC6eAY0jsWZ1c5zf09p0EBPa+iuUD1AniityiAAqpm/KlvlUf4we
         Sr2DZeW4dEAhA==
Message-ID: <a8e8d966822a0090c7e5ba398c7d8ab9fa5b5fe2.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked
 and not used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Apr 2022 08:26:00 -0400
In-Reply-To: <20220428121318.43125-1-xiubli@redhat.com>
References: <20220428121318.43125-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-28 at 20:13 +0800, Xiubo Li wrote:
> For example if the Frwcb caps are being revoked, but only the Fr
> caps is still being used then the kclient will skip releasing them
> all. But in next turn if the Fr caps is ready to be released the
> Fw caps maybe just being used again. So in corner case, such as
> heavy load IOs, the revocation maybe stuck for a long time.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0c0c8f5ae3b3..7eb5238941fc 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  
>  	/* The ones we currently want to retain (may be adjusted below) */
>  	retain = file_wanted | used | CEPH_CAP_PIN;
> +
> +	/*
> +	 * Do not retain the capabilities if they are under revoking
> +	 * but not used, this could help speed up the revoking.
> +	 */
> +	retain &= ~((revoking & retain) & ~used);
> +
>  	if (!mdsc->stopping && inode->i_nlink > 0) {
>  		if (file_wanted) {
>  			retain |= CEPH_CAP_ANY;       /* be greedy */

Oh wow, I thought this was being done already! Curse the complex logic
in this function.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
