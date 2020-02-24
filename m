Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814E316B3A9
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 23:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgBXWSC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 17:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWSC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 17:18:02 -0500
Received: from vulkan (unknown [4.28.11.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D3EC218AC;
        Mon, 24 Feb 2020 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582582681;
        bh=4FWjl5C1KtmEvHRWYt5e+SAiR6u9on5oEFGfTlMkvOQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fK/ly4gF+i2bm2kwroreD8iO2w3XU5IzPFH/OY5IsvVMuunMAK26LvTV6jLcszMw+
         L7PQRj7wEMOob2aZwyaoCK5GX/LgMtblY2WQuMS2AnrK00Y11sVxlZIRc3xdKzwpwa
         ZF0wnXbbMiwt4CriMSDHnt7wmCRSzLt65PwyNuvc=
Message-ID: <57fe13b3f31a85120c0bea9adb0318c543e11cae.camel@kernel.org>
Subject: Re: [PATCH] ceph: return ETIMEDOUT errno to userland when request
 timed out
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 24 Feb 2020 14:18:00 -0800
In-Reply-To: <20200224032311.26107-1-xiubli@redhat.com>
References: <20200224032311.26107-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-02-23 at 22:23 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The ETIMEOUT errno will be cleaner and be more user-friendly.
> 
> URL: https://tracker.ceph.com/issues/44215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 3e792eca6af7..a1649eb3a3fd 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2578,7 +2578,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  	if (req->r_timeout &&
>  	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
>  		dout("do_request timed out\n");
> -		err = -EIO;
> +		err = -ETIMEDOUT;
>  		goto finish;
>  	}
>  	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> @@ -2752,7 +2752,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
>  		if (timeleft > 0)
>  			err = 0;
>  		else if (!timeleft)
> -			err = -EIO;  /* timed out */
> +			err = -ETIMEDOUT;  /* timed out */
>  		else
>  			err = timeleft;  /* killed */
>  	}


Thanks. Merged into ceph-client/testing.
-- 
Jeff Layton <jlayton@kernel.org>

