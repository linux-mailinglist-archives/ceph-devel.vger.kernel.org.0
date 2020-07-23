Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9B522ACBB
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 12:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgGWKlD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 06:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgGWKlC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 06:41:02 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9644820737;
        Thu, 23 Jul 2020 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595500862;
        bh=Z220Ff8kLpyW3s2JDA0+gRObyW+mpYE8s02e1/VRY9E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ArnxqUcq+zlxED9Z+ffV5Zxq7hHEFibzgxQC+1nibcO7jn6i6lbyd/aldqGuasNyq
         P1mQFKGP+d925lgWTXDYkmNTVj/FXkdllmlUmMfyKcXq6iC0pC/7cKBV7gEnBDi2DJ
         OK15XShn1ncTU/kDV5p8vYFMaQEoNlPbAnsakR0w=
Message-ID: <11f7ff95dd153e18204a9c23731c222a09f2b196.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix use-after-free for fsc->mdsc
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Thu, 23 Jul 2020 06:41:00 -0400
In-Reply-To: <20200723073225.340115-1-xiubli@redhat.com>
References: <20200723073225.340115-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-07-23 at 15:32 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the ceph_mdsc_init() fails, it will free the mdsc already.
> 
> Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
> URL: https://tracker.ceph.com/issues/46684
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index af7221d1c610..590822fab767 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4453,7 +4453,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  		goto err_mdsc;
>  	}
>  
> -	fsc->mdsc = mdsc;
>  	init_completion(&mdsc->safe_umount_waiters);
>  	init_waitqueue_head(&mdsc->session_close_wq);
>  	INIT_LIST_HEAD(&mdsc->waiting_for_map);
> @@ -4508,6 +4507,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  
>  	strscpy(mdsc->nodename, utsname()->nodename,
>  		sizeof(mdsc->nodename));
> +
> +	fsc->mdsc = mdsc;
>  	return 0;
>  
>  err_mdsmap:

Looks good, merged into testing.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

