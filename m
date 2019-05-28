Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1731B2C824
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 15:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfE1NwM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 09:52:12 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35414 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfE1NwM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 09:52:12 -0400
Received: by mail-yw1-f65.google.com with SMTP id k128so7928741ywf.2
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 06:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mz1qyriziB19WtkKRvH7F1JIZfmI3lkgmjL/hjQMn/E=;
        b=mE9zk/67BQucrV0w4cDpQv+HCNNsJEKx0YvS4oyQnYH6wgrZTdebXAXiEiCJMl9YEL
         3/cMI8+ZgLA4KYVmmhnB/ByHb/0al3AYzQ4P61Rsml46IUk/igkNXZLnco2I2LzVMADE
         UlAty8KVQ832vYV2RiWq6oxsWDtBYImsheRzHGG9hTIdeAPsmKGjf6vSvchL53KEgKCr
         /DIGxZMn3QF89a2KSVROclkQX/obBmJEShkEYxmLw2z/dsSao2nFyKwfBmcOFtlDAGE/
         10XCkU+QwhrwSAuSfpNEmmMnHAoOSNi8pmbKLJucQ0o1tE8fd+V/XOtseO4vFSx/2L6S
         zouA==
X-Gm-Message-State: APjAAAUE5SyNqYJQW/gd8EILtNhq8NgUmazJ7M5IO868clQzs1XRKP9F
        gAcwgLaTMjEsjcIu79+GZoGWbA==
X-Google-Smtp-Source: APXvYqy+5+zXY6OHv1SAnTM8+nipczP+kSriyjS3bAse93Cdf3ptfkF9t9WPaa5JQr4EaMXezwdQ3w==
X-Received: by 2002:a81:4f06:: with SMTP id d6mr44401642ywb.379.1559051531559;
        Tue, 28 May 2019 06:52:11 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id v128sm3627452ywf.14.2019.05.28.06.52.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 06:52:11 -0700 (PDT)
Message-ID: <827161e8854366c5017311720831fba4704d6833.camel@redhat.com>
Subject: Re: [PATCH 5/8] ceph: fix dir_lease_is_valid()
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 09:52:10 -0400
In-Reply-To: <20190523081345.20410-5-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-5-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> It should call __ceph_dentry_dir_lease_touch() under dentry->d_lock.
> Besides, ceph_dentry(dentry) can be NULL when called by LOOKUP_RCU
> d_revalidate()
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/dir.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0637149fb9f9..1271024a3797 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1512,18 +1512,26 @@ static int __dir_lease_try_check(const struct dentry *dentry)
>  static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(dir);
> -	struct ceph_dentry_info *di = ceph_dentry(dentry);
> -	int valid = 0;
> +	int valid;
> +	int shared_gen;
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	if (atomic_read(&ci->i_shared_gen) == di->lease_shared_gen)
> -		valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
> +	valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
> +	shared_gen = atomic_read(&ci->i_shared_gen);
>  	spin_unlock(&ci->i_ceph_lock);
> -	if (valid)
> -		__ceph_dentry_dir_lease_touch(di);
> -	dout("dir_lease_is_valid dir %p v%u dentry %p v%u = %d\n",
> -	     dir, (unsigned)atomic_read(&ci->i_shared_gen),
> -	     dentry, (unsigned)di->lease_shared_gen, valid);
> +	if (valid) {
> +		struct ceph_dentry_info *di;
> +		spin_lock(&dentry->d_lock);
> +		di = ceph_dentry(dentry);
> +		if (dir == d_inode(dentry->d_parent) &&
> +		    di && di->lease_shared_gen == shared_gen)
> +			__ceph_dentry_dir_lease_touch(di);
> +		else
> +			valid = 0;
> +		spin_unlock(&dentry->d_lock);
> +	}
> +	dout("dir_lease_is_valid dir %p v%u dentry %p = %d\n",
> +	     dir, (unsigned)atomic_read(&ci->i_shared_gen), dentry, valid);
>  	return valid;
>  }
>  

Reviewed-by: Jeff Layton <jlayton@redhat.com>

