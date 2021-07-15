Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6123CA030
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jul 2021 16:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhGOOFh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jul 2021 10:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGOOFg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 15 Jul 2021 10:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F5EE6128D;
        Thu, 15 Jul 2021 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626357763;
        bh=grQW3UgWfXU4yxwPEIzF0tsiYGHqaSRZYJBDNFj47i4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h7p/Z2Fh0durFJqN2B8OLm4ac4IMDfIhaepdrfM8ah8taH71CAdxgLR4xH6EaMHJ1
         cX4bAF5rv16Vzi75kKwQiEC1U66a37cFRuCGHyeRDFrauYUYtQOJOWSCfPKzaxtUeB
         M8xDD7PvXYXlOacZ7O/2V1sRP8m7Hf4uhQJD3/dZtK5xnC+kjUFg6EDH1rMv+FvRGH
         qXvOY2sOsjad/4/a58uy/9XzduON8s4l3EbZ4txEtXhkde/TU+3DcbMjV1ZamaGkyl
         Qj3poUfZSwovsz0XHFsINscwC/c1BCYvzFa8YrpHuD3MNRyLN/FHceDuVeGQ1DrEtR
         Cu1uuZgpiQPRA==
Message-ID: <98f3852d84645b88963f987bb3373bb56ddd8d3e.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't WARN if we're still opening a session to an
 MDS
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Jul 2021 10:02:41 -0400
In-Reply-To: <20210715134039.10466-1-lhenriques@suse.de>
References: <20210715134039.10466-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-07-15 at 14:40 +0100, Luis Henriques wrote:
> If MDSs aren't available while mounting a filesystem, the session state will
> transition from SESSION_OPENING to SESSION_CLOSING.  And in that scenario
> check_session_state() will be called from delayed_work() and trigger this
> WARN.
> 
> Avoid this by only WARNing after a session has already been established
> (i.e., the s_ttl will be different from 0).
> 
> Fixes: 62575e270f66 ("ceph: check session state after bumping session->s_seq")
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e5af591d3bd4..86f09b1110a2 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4468,7 +4468,7 @@ bool check_session_state(struct ceph_mds_session *s)
>  		break;
>  	case CEPH_MDS_SESSION_CLOSING:
>  		/* Should never reach this when we're unmounting */
> -		WARN_ON_ONCE(true);
> +		WARN_ON_ONCE(s->s_ttl);
>  		fallthrough;
>  	case CEPH_MDS_SESSION_NEW:
>  	case CEPH_MDS_SESSION_RESTARTING:

Mea culpa -- I've been meaning to fix that up. I'll plan to merge this
later today.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

