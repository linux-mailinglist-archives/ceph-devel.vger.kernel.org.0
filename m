Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C212341703D
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Sep 2021 12:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbhIXKXb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 06:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240828AbhIXKX2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 06:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6539610CB;
        Fri, 24 Sep 2021 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632478915;
        bh=o80sxHlK86Hn8JJSD+JBBsY78gzyMTo8q1xMkdJv/w4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JRtJXV4NbB5Q+zV6kFYB9Qa7RdZGzZPC2ipR7TXko7PDcHeCBuxkuhQDYJ9Py/JzV
         7A4HpnX430s9kuEmAbqTb9yK7wvZ2aaEutrFVFaDPrLThsb6DfDBQjFbKJnZihzg/c
         nLd6FOjSieII3UbADJ4BUX4E837Swj0eiGLFhdWytmiZi66A0VoGyzKNcJR1a1JB9c
         sb+F7MQWpPjUK7kJc98SIAcbuksjk9/GjICOU9JyTapRQ/mi4lCQUz1dJ9ZAbWDI1A
         AhHmrCxfk6UiRrUiMWvLDmEjDk1msX9bbfMRzyo1nFTwN1qTLNaQDODrSFNUZ2A9FZ
         gkNh7V1SKoh8g==
Message-ID: <3c2c99300fb89820c214f0ae17151504eeb22af2.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't rely on error_string to validate
 blocklisted session.
From:   Jeff Layton <jlayton@kernel.org>
To:     khiremat@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Fri, 24 Sep 2021 06:21:53 -0400
In-Reply-To: <20210923132607.81693-1-khiremat@redhat.com>
References: <20210923132607.81693-1-khiremat@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-09-23 at 18:56 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
> 
> The "error_string" in the metadata of MClientSession is being
> parsed by kclient to validate whether the session is blocklisted.
> The "error_string" is for humans and shouldn't be relied on it.
> Hence added the flag to MClientsession to indicate the session
> is blocklisted.
> 
> URL: https://tracker.ceph.com/issues/47450
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 13 +++++++++++++
>  include/linux/ceph/ceph_fs.h |  2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 44bc780b2b0e..f3c023c17963 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3407,6 +3407,19 @@ static void handle_session(struct ceph_mds_session *session,
>  		}
>  	}
>  
> +	if (msg_version >= 5) {
> +		u32 len;
> +		u32 flags;
> +		/* version >= 4, metric_spec (struct_v, struct_cv, len, metric_flag) */
> +	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
> +		/* version >= 5, flags   */
> +                ceph_decode_32_safe(&p, end, flags, bad);
> +		if (flags & CEPH_SESSION_BLOCKLISTED) {
> +		        pr_info("mds%d session blocklisted\n", session->s_mds);

Things are likely to not work well if this flag is set. Maybe this
should be a pr_warn?

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

This looks reasonable, but incomplete.

If the msg_version >= 5, then we probably also don't need to scan for
"blacklisted" in the strings, right? In fact, it looks like we can avoid
doing most of __decode_session_metadata in that case and can just skip
over the text blob section.
-- 
Jeff Layton <jlayton@kernel.org>

