Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A472500B7
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHXPQC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 11:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgHXPN2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 11:13:28 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B441206B5;
        Mon, 24 Aug 2020 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598281975;
        bh=yO9W1Kc0RdGpWZmeTxsnbWWXCS+9065Inn/90nZH8S4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P1OE/CS8PxQYqFGUCpqEisH8/zh3qJNGTtpsU6Euxa2780rFG9iiDIZTS4AEfRC3K
         YGgqyg0WSsIs23QtW1LkKT8x5UwfFYQL8Jj5v1E2yxogukGObENk0h/D7bpKUjbIFN
         djdqwoEw4kxSS40Z2aXyYUvOrxzcq0URhp+ObUhg=
Message-ID: <9b6b670245ae0ca8eab16263c01f6a6d1bd94e4b.camel@kernel.org>
Subject: Re: [PATCH] ceph: add column 'mds' to show caps in more user
 friendly
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 24 Aug 2020 11:12:54 -0400
In-Reply-To: <20200824030058.37786-1-gmayyyha@gmail.com>
References: <20200824030058.37786-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-24 at 11:00 +0800, Yanhu Cao wrote:
> In multi-mds, the 'caps' debugfs file will have duplicate ino,
> add the 'mds' column to indicate which mds session the cap belongs to.
> 
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/debugfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 97539b497e4c..47f8971a9c52 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -202,7 +202,8 @@ static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>  {
>  	struct seq_file *s = p;
>  
> -	seq_printf(s, "0x%-17lx%-17s%-17s\n", inode->i_ino,
> +	seq_printf(s, "0x%-17lx%-3d%-17s%-17s\n", inode->i_ino,
> +		   cap->session->s_mds,
>  		   ceph_cap_string(cap->issued),
>  		   ceph_cap_string(cap->implemented));
>  	return 0;
> @@ -222,8 +223,8 @@ static int caps_show(struct seq_file *s, void *p)
>  		   "reserved\t%d\n"
>  		   "min\t\t%d\n\n",
>  		   total, avail, used, reserved, min);
> -	seq_printf(s, "ino                issued           implemented\n");
> -	seq_printf(s, "-----------------------------------------------\n");
> +	seq_printf(s, "ino              mds  issued           implemented\n");
> +	seq_printf(s, "--------------------------------------------------\n");
>  
>  	mutex_lock(&mdsc->mutex);
>  	for (i = 0; i < mdsc->max_sessions; i++) {

Looks good. Merged.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

