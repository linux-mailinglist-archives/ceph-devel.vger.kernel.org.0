Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE33F4BDC
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhHWNuC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 09:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhHWNuB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 09:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E47613A8;
        Mon, 23 Aug 2021 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629726558;
        bh=RBQi+NykciDtTdZixRtMU8T9bNAMp4mCBpheGjMXIzw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lECLtUSKn5prEZphNysnxoUPftwUTn/0gnayfJOc8RpU341/SVhSiiGsOFv99Txg8
         18moHgaHZQKIiQHkHxF7Ylckvwl5Q3yo3tMSpoHIl+nvl1GfEh/EPN4gglrr3cMc+m
         fP5p8NkLFsYDlQUl8JKRWW+/iY8aKSYQFUWQMhmgJl0Ua/sTJFwQPKbJxLLXRkx5CS
         9RE6NbtBwgDuRR8eHIDkQOHONCbwiW/4C47jnVhpNyOQ/hAIDXueDwtK6cpLYidCqG
         z7MUuDtd7u5MbWae9q54VTYEZ16NU4M7CE9CByroroaxcmn13yHAArUbCJVzeAIfvN
         ep9/jpYkPa6dw==
Message-ID: <7bf49c80528b31f6350d7f3ee2a5a69da42aaa69.camel@kernel.org>
Subject: Re: [PATCH 2/3] ceph: don't WARN if we're force umounting
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 23 Aug 2021 09:49:17 -0400
In-Reply-To: <20210818080603.195722-3-xiubli@redhat.com>
References: <20210818080603.195722-1-xiubli@redhat.com>
         <20210818080603.195722-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Force umount will try to close the sessions by setting the session
> state to _CLOSING, so in ceph_kill_sb after that it will warn on it.
> 
> URL: https://tracker.ceph.com/issues/52295
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a632e1c7cef2..0302af53e079 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4558,6 +4558,8 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>  
>  bool check_session_state(struct ceph_mds_session *s)
>  {
> +	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
> +
>  	switch (s->s_state) {
>  	case CEPH_MDS_SESSION_OPEN:
>  		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
> @@ -4566,8 +4568,11 @@ bool check_session_state(struct ceph_mds_session *s)
>  		}
>  		break;
>  	case CEPH_MDS_SESSION_CLOSING:
> -		/* Should never reach this when we're unmounting */
> -		WARN_ON_ONCE(s->s_ttl);
> +		/*
> +		 * Should never reach this when none force unmounting
> +		 */
> +		if (READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN)
> +			WARN_ON_ONCE(s->s_ttl);

How about something like this instead?

    WARN_ON_ONCE(s->s_ttl && READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);


>  		fallthrough;
>  	case CEPH_MDS_SESSION_NEW:
>  	case CEPH_MDS_SESSION_RESTARTING:

-- 
Jeff Layton <jlayton@kernel.org>

