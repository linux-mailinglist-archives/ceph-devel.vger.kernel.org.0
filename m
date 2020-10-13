Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41528CE5F
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Oct 2020 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgJMMbs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Oct 2020 08:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgJMMbr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 08:31:47 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFCEB223BD;
        Tue, 13 Oct 2020 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602592307;
        bh=WIhDd3xJbLPBasBN4gKJkUKEHhBnazx3bUl9IvZ433M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MGwmjMYcdUlHwDYWtVqqsKuywNmh0vxQevAfzLQ76SGuqKkoWFwmZl6BgoIXvZxmY
         brnaqxb+wOkG+bWFgZhHeOaokghoWS0A4cLwXQjHz3SsYy41B8s10KKrMqBbqDmTdU
         9QhLLGcnkm3btwjmdSjEItF6oCtYgqIh2bnGbtkc=
Message-ID: <6240402b3e530f3ffa8fba3cedd0113325c821fa.camel@kernel.org>
Subject: Re: [PATCH] ceph: add 'noshare' mount option support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 13 Oct 2020 08:31:45 -0400
In-Reply-To: <20201013103112.12132-1-xiubli@redhat.com>
References: <20201013103112.12132-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-10-13 at 18:31 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will disable different mount points to share superblocks.
> 

Why? What problem does this solve? Don't make us dig through random
tracker bugs to determine this, please. :)

Also, the subject mentions a "noshare" mount option, but the code below
will be expecting sharesb/nosharesb.

> URL: https://tracker.ceph.com/issues/46883
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 12 ++++++++++++
>  fs/ceph/super.h |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 2f530a111b3a..6f283e4d62ee 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -159,6 +159,7 @@ enum {
>  	Opt_quotadf,
>  	Opt_copyfrom,
>  	Opt_wsync,
> +	Opt_sharesb,
>  };
>  
>  enum ceph_recover_session_mode {
> @@ -199,6 +200,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>  	fsparam_string	("source",			Opt_source),
>  	fsparam_u32	("wsize",			Opt_wsize),
>  	fsparam_flag_no	("wsync",			Opt_wsync),
> +	fsparam_flag_no	("sharesb",			Opt_sharesb),
>  	{}
>  };
>  
> @@ -455,6 +457,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  		else
>  			fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
>  		break;
> +	case Opt_sharesb:
> +		if (!result.negated)
> +			fsopt->flags &= ~CEPH_MOUNT_OPT_NO_SHARE_SB;
> +		else
> +			fsopt->flags |= CEPH_MOUNT_OPT_NO_SHARE_SB;
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -1007,6 +1015,10 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>  
>  	dout("ceph_compare_super %p\n", sb);
>  
> +	if (fsopt->flags & CEPH_MOUNT_OPT_NO_SHARE_SB ||
> +	    other->mount_options->flags & CEPH_MOUNT_OPT_NO_SHARE_SB)
> +		return 0;
> +
>  	if (compare_mount_options(fsopt, opt, other)) {
>  		dout("monitor(s)/mount options don't match\n");
>  		return 0;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f097237a5ad3..e877c21196e5 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -44,6 +44,7 @@
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
>  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> +#define CEPH_MOUNT_OPT_NO_SHARE_SB     (1<<16) /* disable sharing the same superblock */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
>  	(CEPH_MOUNT_OPT_DCACHE |		\

-- 
Jeff Layton <jlayton@kernel.org>

