Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2BB2CA2B
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 17:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfE1PRe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 11:17:34 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43416 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1PRe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 11:17:34 -0400
Received: by mail-yw1-f66.google.com with SMTP id t5so8037397ywf.10
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 08:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c9r0JhaU2OvWLDa+5xajbzuMsY5DmsA6OBoqhjdPAtk=;
        b=GteiCtLLoTeE67eNhibc4NPlDsIMbsKNHC+9bb61A24FGevYhjm7iq+HZpUhcI7HJK
         BvbXGp7GeBkkN6qt7vnirGleix1XNxSlSyNd++OpKofauanlmGyMx06UnpsLmhmcfvjO
         i0Uwvmo/dqQMiSkMAG4CM+zD6MG5K7OdsaNcefreK8sMxKjwl1y5EUSIb4j8c1yQguDI
         XeU3sCeTuGEfTj5xdaGRaEFklr4hbzRyLEyCl3wa7Q9k41g8wG+QU3W/fDQmX5xvFBsn
         p6/xMzgi8DBtmJc4EWfwZhDbj7Be2DdU4ied6VJ/UPAMh/Hw1rhVkm7V6nAxwqRyZbgP
         mVKw==
X-Gm-Message-State: APjAAAWAX95/p/lt+f2vCsM8vRxYJtUjo7clvj8NxEigOhvSzL6onQeC
        uEzacM9WzO1UHPk7DGVHD5PmM2x/MPY=
X-Google-Smtp-Source: APXvYqzbrn79CX3EwQi9U7y/Ha/93Uvk063sKyTGjDfCdTczdC1TQeHQjkgywlPw47Yr7ek4f3a+aw==
X-Received: by 2002:a81:a483:: with SMTP id b125mr26148310ywh.79.1559056653668;
        Tue, 28 May 2019 08:17:33 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id j188sm3832666ywj.18.2019.05.28.08.17.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 08:17:33 -0700 (PDT)
Message-ID: <3e8213e52d3b241711692c200df2883548ed48ce.camel@redhat.com>
Subject: Re: [PATCH 7/8] ceph: ensure d_name/d_parent stability in
 ceph_mdsc_lease_send_msg()
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 11:17:32 -0400
In-Reply-To: <20190523081345.20410-7-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-7-zyan@redhat.com>
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
>  fs/ceph/dir.c        |  7 +++----
>  fs/ceph/mds_client.c | 24 +++++++++++++-----------
>  fs/ceph/mds_client.h |  1 -
>  3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 1271024a3797..72efad28857c 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1433,8 +1433,7 @@ static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
>  	return false;
>  }
>  
> -static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags,
> -				 struct inode *dir)
> +static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
>  {
>  	struct ceph_dentry_info *di;
>  	struct ceph_mds_session *session = NULL;
> @@ -1466,7 +1465,7 @@ static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags,
>  	spin_unlock(&dentry->d_lock);
>  
>  	if (session) {
> -		ceph_mdsc_lease_send_msg(session, dir, dentry,
> +		ceph_mdsc_lease_send_msg(session, dentry,
>  					 CEPH_MDS_LEASE_RENEW, seq);
>  		ceph_put_mds_session(session);
>  	}
> @@ -1566,7 +1565,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  		   ceph_snap(d_inode(dentry)) == CEPH_SNAPDIR) {
>  		valid = 1;
>  	} else {
> -		valid = dentry_lease_is_valid(dentry, flags, dir);
> +		valid = dentry_lease_is_valid(dentry, flags);
>  		if (valid == -ECHILD)
>  			return valid;
>  		if (valid || dir_lease_is_valid(dir, dentry)) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 870754e9d572..98c500dbec3f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3941,31 +3941,33 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>  }
>  
>  void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
> -			      struct inode *inode,
>  			      struct dentry *dentry, char action,
>  			      u32 seq)
>  {
>  	struct ceph_msg *msg;
>  	struct ceph_mds_lease *lease;
> -	int len = sizeof(*lease) + sizeof(u32);
> -	int dnamelen = 0;
> +	struct inode *dir;
> +	int len = sizeof(*lease) + sizeof(u32) + NAME_MAX;
>  
> -	dout("lease_send_msg inode %p dentry %p %s to mds%d\n",
> -	     inode, dentry, ceph_lease_op_name(action), session->s_mds);
> -	dnamelen = dentry->d_name.len;
> -	len += dnamelen;
> +	dout("lease_send_msg identry %p %s to mds%d\n",
> +	     dentry, ceph_lease_op_name(action), session->s_mds);
>  
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_LEASE, len, GFP_NOFS, false);
>  	if (!msg)
>  		return;
>  	lease = msg->front.iov_base;
>  	lease->action = action;
> -	lease->ino = cpu_to_le64(ceph_vino(inode).ino);
> -	lease->first = lease->last = cpu_to_le64(ceph_vino(inode).snap);
>  	lease->seq = cpu_to_le32(seq);
> -	put_unaligned_le32(dnamelen, lease + 1);
> -	memcpy((void *)(lease + 1) + 4, dentry->d_name.name, dnamelen);
>  
> +	spin_lock(&dentry->d_lock);
> +	dir = d_inode(dentry->d_parent);
> +	lease->ino = cpu_to_le64(ceph_inode(dir)->i_vino.ino);
> +	lease->first = lease->last = cpu_to_le64(ceph_inode(dir)->i_vino.snap);
> +
> +	put_unaligned_le32(dentry->d_name.len, lease + 1);
> +	memcpy((void *)(lease + 1) + 4,
> +	       dentry->d_name.name, dentry->d_name.len);
> +	spin_unlock(&dentry->d_lock);
>  	/*
>  	 * if this is a preemptive lease RELEASE, no need to
>  	 * flush request stream, since the actual request will
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 9c28b86abcf4..330769ecb601 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -505,7 +505,6 @@ extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *base,
>  
>  extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
>  extern void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
> -				     struct inode *inode,
>  				     struct dentry *dentry, char action,
>  				     u32 seq);
>  

Reviewed-by: Jeff Layton <jlayton@redhat.com>

