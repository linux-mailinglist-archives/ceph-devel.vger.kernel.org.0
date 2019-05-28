Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC472CA49
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfE1PWG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 11:22:06 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33179 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfE1PWF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 11:22:05 -0400
Received: by mail-yw1-f68.google.com with SMTP id r200so4151694ywe.0
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 08:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RLBUCTDVM1ZnICFfsctjA1DT8LPbiA+zXGsJhKD/TaA=;
        b=TxxGBkE9+eHBmSN9JBBFOiMHUTglEEigwEUIQQVCx6WCQ2Rw9YUK4jc7eq6HxFMghf
         Y8Zfkd2PU6nuIvQGUmfdTq6Y5I7U3J9eijU6Oku8EIVuhX1dYTJ2VYQfCo4q1GgRsHE6
         9To1Mj4SHyCdAtoVvabCkqlnqbw74+B7lwKo3AupUVqHGFR0CIg1duibj5HKR9Yej7H3
         WagGmcoGtpyuvWSByw20p4PesZ6/gUsoRqjZvKtms8BCCbKlo10YkWdSSaJdGJzSrNJv
         2SGNA8D+k77Y5C51DulWmz9yp2XlE16Hw/eUAQem23GDf24ZDf+qsWioMljrzmouaQdu
         6XEQ==
X-Gm-Message-State: APjAAAW6AQxpbPKteh3mWjnXSWrOj/vrnR/sro4w3ps78907nz04wHSB
        XZpbk61VGyxGCrxSwWXoHGOynEfmfzg=
X-Google-Smtp-Source: APXvYqwyeyBBUKHQDZcdQ7/1z/jz1x6dnY4y+OjNWM4sM3yiJKqvTICdaPpD2GByutadArvEzctRmw==
X-Received: by 2002:a81:8982:: with SMTP id z124mr1928133ywf.322.1559056924556;
        Tue, 28 May 2019 08:22:04 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id v144sm3639493ywv.15.2019.05.28.08.22.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 08:22:04 -0700 (PDT)
Message-ID: <561ce5fedaac8be32431221e6bc598b4ecc5ea37.camel@redhat.com>
Subject: Re: [PATCH 8/8] ceph: hold i_ceph_lock when removing caps for
 freeing inode
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 11:22:03 -0400
In-Reply-To: <20190523081345.20410-8-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-8-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> ceph_d_revalidate(, LOOKUP_RCU) may call __ceph_caps_issued_mask()
> on a freeing inode.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c  | 10 ++++++----
>  fs/ceph/inode.c |  2 +-
>  fs/ceph/super.h |  2 +-
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0176241eaea7..7754d7679122 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1263,20 +1263,22 @@ static int send_cap_msg(struct cap_msg_args *arg)
>  }
>  
>  /*
> - * Queue cap releases when an inode is dropped from our cache.  Since
> - * inode is about to be destroyed, there is no need for i_ceph_lock.
> + * Queue cap releases when an inode is dropped from our cache.
>   */
> -void __ceph_remove_caps(struct inode *inode)
> +void __ceph_remove_caps(struct ceph_inode_info *ci)
>  {
> -	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct rb_node *p;
>  
> +	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
> +	 * may call __ceph_caps_issued_mask() on a freeing inode. */
> +	spin_lock(&ci->i_ceph_lock);
>  	p = rb_first(&ci->i_caps);
>  	while (p) {
>  		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
>  		p = rb_next(p);
>  		__ceph_remove_cap(cap, true);
>  	}
> +	spin_unlock(&ci->i_ceph_lock);
>  }
>  
>  /*
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e47a25495be5..30d0cdc21035 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -534,7 +534,7 @@ void ceph_destroy_inode(struct inode *inode)
>  
>  	ceph_fscache_unregister_inode_cookie(ci);
>  
> -	__ceph_remove_caps(inode);
> +	__ceph_remove_caps(ci);
>  
>  	if (__ceph_has_any_quota(ci))
>  		ceph_adjust_quota_realms_count(inode, false);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 11aeb540b0cf..e74867743e07 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1003,7 +1003,7 @@ extern void ceph_add_cap(struct inode *inode,
>  			 unsigned cap, unsigned seq, u64 realmino, int flags,
>  			 struct ceph_cap **new_cap);
>  extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
> -extern void __ceph_remove_caps(struct inode* inode);
> +extern void __ceph_remove_caps(struct ceph_inode_info *ci);
>  extern void ceph_put_cap(struct ceph_mds_client *mdsc,
>  			 struct ceph_cap *cap);
>  extern int ceph_is_any_caps(struct inode *inode);

Reviewed-by: Jeff Layton <jlayton@redhat.com>

