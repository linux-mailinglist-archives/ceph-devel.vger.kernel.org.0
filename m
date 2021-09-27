Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE64198B3
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Sep 2021 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhI0QQg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 12:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhI0QQg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 12:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E0B60F9B;
        Mon, 27 Sep 2021 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632759298;
        bh=ehEEyjeiOSVjq56hTyueijmMxuSx9FYBYZ1k3J27zB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dg9LuwTOKtrmKxRipX9H7UJstikDbmu3FXhnsc6vV/BWIhAwXxF0vuokCgXNo8ptt
         lTVjnksPBxFuBGciQNXXLsFpxMJyEiNCRlhVsp63hNCaspE8Koy5oUSc2nuN4EpDP8
         sPM2WzXfnh6k8Hhq6oRuUCko+2r8iuQ5vz8YLjyVOuyom+Ub7SzCDsVdybIRNYLdJb
         eOqBYT4J4UStfIHMH6iujuEku2l/7wZTRydLxe9qOubo6mobMoirmWSm9D5ygxYeq/
         CLskNC0ZwvIHuXdDzNv2ZJcfa4HAVmSs4aDdLgxe3ea/Gf7wN8uIqHH88PMqrOES8B
         JvzMYj7qXfzlw==
Message-ID: <ac394a47a2a6bb7ee55a4fad3fdc279b73164196.camel@kernel.org>
Subject: Re: [PATCH v1] ceph: don't rely on error_string to validate
 blocklisted session.
From:   Jeff Layton <jlayton@kernel.org>
To:     khiremat@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 27 Sep 2021 12:14:56 -0400
In-Reply-To: <20210927135227.290145-1-khiremat@redhat.com>
References: <20210927135227.290145-1-khiremat@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-09-27 at 19:22 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
> 

This looks good. For future reference, I'd have probably marked this as
[PATCH v2]. One minor style nit below, but you don't need to resend for
that. I'll fix it up when I merge it if you're OK with it.

> The "error_string" in the metadata of MClientSession is being
> parsed by kclient to validate whether the session is blocklisted.
> The "error_string" is for humans and shouldn't be relied on it.
> Hence added the flag to MClientsession to indicate the session
> is blocklisted.
> 
> URL: https://tracker.ceph.com/issues/47450
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 24 +++++++++++++++++++++---
>  include/linux/ceph/ceph_fs.h |  2 ++
>  2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 44bc780b2b0e..cc1137468b29 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3396,9 +3396,15 @@ static void handle_session(struct ceph_mds_session *session,
>  
>  	if (msg_version >= 3) {
>  		u32 len;
> -		/* version >= 2, metadata */
> -		if (__decode_session_metadata(&p, end, &blocklisted) < 0)
> -			goto bad;
> +		/* version >= 2 and < 5, decode metadata, skip otherwise
> +		 * as it's handled via flags.
> +		 */
> +		if (msg_version >= 5) {
> +			ceph_decode_skip_map(&p, end, string, string, bad);
> +		} else {
> +			if (__decode_session_metadata(&p, end, &blocklisted) < 0)

We can use an "else if" here and remove a level of indentation. Also,
the braces aren't necessary since both just cover a single-line
statements.

> +				goto bad;
> +		}
>  		/* version >= 3, feature bits */
>  		ceph_decode_32_safe(&p, end, len, bad);
>  		if (len) {
> @@ -3407,6 +3413,18 @@ static void handle_session(struct ceph_mds_session *session,
>  		}
>  	}
>  
> +	if (msg_version >= 5) {
> +		u32 flags;
> +		/* version >= 4, struct_v, struct_cv, len, metric_spec */
> +	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
> +		/* version >= 5, flags   */
> +                ceph_decode_32_safe(&p, end, flags, bad);
> +		if (flags & CEPH_SESSION_BLOCKLISTED) {
> +		        pr_warn("mds%d session blocklisted\n", session->s_mds);
> +			blocklisted = true;
> +		}
> +	}
> +
>  	mutex_lock(&mdsc->mutex);
>  	if (op == CEPH_SESSION_CLOSE) {
>  		ceph_get_mds_session(session);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index bc2699feddbe..7ad6c3d0db7d 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -302,6 +302,8 @@ enum {
>  	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
>  };
>  
> +#define CEPH_SESSION_BLOCKLISTED	(1 << 0)  /* session blocklisted */
> +
>  extern const char *ceph_session_op_name(int op);
>  
>  struct ceph_mds_session_head {


