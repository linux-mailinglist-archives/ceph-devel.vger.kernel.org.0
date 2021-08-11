Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4453E93C1
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhHKOhb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 10:37:31 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58244 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhHKOha (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Aug 2021 10:37:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E3EB221A8;
        Wed, 11 Aug 2021 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628692626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VJ9FwzPl6LjiyU9HMmGoePtQc8/l9vB1VNujMGB0xCM=;
        b=KRFsfihblE+FaaqQOD6F3xBRayr/CUWBiCe/zmd69uDu1fr4qMKtcbfaLCR+J7jooRUoyo
        QOMqBh7xn2iuVZDMOCvN7+fkJ/I7IXxpKnqYgYVV4Eye5lqnlNdLOCvCXnwaHb9Fl/wnpp
        wmX5HP45yg4LYfu3nzdj0rIgZRTS+s8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628692626;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VJ9FwzPl6LjiyU9HMmGoePtQc8/l9vB1VNujMGB0xCM=;
        b=xJo1LkGdi4EDA9QqwkhAH84BZdNZL+VFxoIuTR00pFIRHtMbAjJWh+PkRDo+fgksvHGoBC
        Pceygn7spHrkF3AA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C061913969;
        Wed, 11 Aug 2021 14:37:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id coD8K5HgE2FHTgAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Wed, 11 Aug 2021 14:37:05 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 6bc7c716;
        Wed, 11 Aug 2021 14:37:05 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: remove dead code in ceph_sync_write
References: <20210811111927.8417-1-jlayton@kernel.org>
Date:   Wed, 11 Aug 2021 15:37:04 +0100
In-Reply-To: <20210811111927.8417-1-jlayton@kernel.org> (Jeff Layton's message
        of "Wed, 11 Aug 2021 07:19:27 -0400")
Message-ID: <87o8a4qc8f.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> We've already checked these flags near the top of the function and
> bailed out if either were set.

The flags being checked at the top of the function are CEPH_OSDMAP_FULL
and CEPH_POOL_FLAG_FULL; here we're checking the *_NEARFULL flags.
Right?  (I had to look a few times to make sure my eyes were not lying.)

Cheers,
-- 
Luis


>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d1755ac1d964..f55ca2c4c7de 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1834,12 +1834,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		goto retry_snap;
>  	}
>  
> -	if (written >= 0) {
> -		if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
> -		    (pool_flags & CEPH_POOL_FLAG_NEARFULL))
> -			iocb->ki_flags |= IOCB_DSYNC;
> +	if (written >= 0)
>  		written = generic_write_sync(iocb, written);
> -	}
>  
>  	goto out_unlocked;
>  out:
> -- 
>
> 2.31.1
>
