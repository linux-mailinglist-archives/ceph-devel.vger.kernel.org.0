Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82602C82C
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 15:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfE1Nz5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 09:55:57 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35552 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfE1Nz4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 09:55:56 -0400
Received: by mail-yw1-f65.google.com with SMTP id k128so7933530ywf.2
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 06:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=E8lRavLAaXv7Lon1D0DEwjDHLCT7iWFJTPh3HLRmT7U=;
        b=jX56Bs0281hL1mK/2piGxfRfa+6WOwzxQvEY27o4POt4KGYuSq0q9S/Ztn28uCxY5C
         m0oHcxjBh6USI1cDjsvZwghIWfhyqEsuTxX2hLhgwrWEnRxC57Tp4w7QLETfbJx1YyJt
         3usjGarvWv2pfd8jfzlU2ppIHnI6q8PGImdUTsDDzonNsFR0xesymO7faAUcHIyowy/a
         x/qvxa69zZ7ysv17aUWwgyJzfuiO4vKkw+Ez1CAMaUyxZwRE47l0XT4WP2POzu7vlqgF
         L7RoV0S9Y1W2DboWkwXZuXYCTh/4unuhcP7VrJnRgc6+eNb3EkOOxRl6/3nrFi31Pde8
         AASQ==
X-Gm-Message-State: APjAAAX2+dra3KnAXAq9nrib8gOTmfZFnl96EkqIU7ajgYZjMxFw73i2
        YZnvZb02JdSq0akpSYrMdt/VEwlKi2s=
X-Google-Smtp-Source: APXvYqwdWF7LP1MBKI+uRu4uwy+RI/xZLwYO0bgeSgcXbA6V9NyForu6yaqR2xGiarV1nGHeO4N2lg==
X-Received: by 2002:a81:a805:: with SMTP id f5mr51442377ywh.279.1559051756392;
        Tue, 28 May 2019 06:55:56 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id e205sm3734686ywa.41.2019.05.28.06.55.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 06:55:55 -0700 (PDT)
Message-ID: <c16c31b59f33c9d881bdaacfdfeb0e629e682f94.camel@redhat.com>
Subject: Re: [PATCH 6/8] ceph: use READ_ONCE to access d_parent in RCU
 critical section
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 09:55:54 -0400
In-Reply-To: <20190523081345.20410-6-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-6-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/mds_client.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 60e8ddbdfdc5..870754e9d572 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -913,7 +913,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  		struct inode *dir;
>  
>  		rcu_read_lock();
> -		parent = req->r_dentry->d_parent;
> +		parent = READ_ONCE(req->r_dentry->d_parent);

Can we use rcu_dereference() instead?

>  		dir = req->r_parent ? : d_inode_rcu(parent);
>  
>  		if (!dir || dir->i_sb != mdsc->fsc->sb) {
> @@ -2131,8 +2131,8 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>  		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
>  			dout("build_path path+%d: %p SNAPDIR\n",
>  			     pos, temp);
> -		} else if (stop_on_nosnap && inode && dentry != temp &&
> -			   ceph_snap(inode) == CEPH_NOSNAP) {
> +		} else if (stop_on_nosnap && dentry != temp &&
> +			   inode && ceph_snap(inode) == CEPH_NOSNAP) {

^^^ Unrelated delta?

>  			spin_unlock(&temp->d_lock);
>  			pos++; /* get rid of any prepended '/' */
>  			break;
> @@ -2145,7 +2145,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>  			memcpy(path + pos, temp->d_name.name, temp->d_name.len);
>  		}
>  		spin_unlock(&temp->d_lock);
> -		temp = temp->d_parent;
> +		temp = READ_ONCE(temp->d_parent);

Better to use rcu_dereference() here.

>  
>  		/* Are we at the root? */
>  		if (IS_ROOT(temp))

-- 
Jeff Layton <jlayton@redhat.com>

