Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D80148A19
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFQRaI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 13:30:08 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36902 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRaI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jun 2019 13:30:08 -0400
Received: by mail-yw1-f65.google.com with SMTP id 186so5408870ywo.4
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 10:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/pXZdU/QR8fqk1756UgKaTiG/FZxzEwT8m3P8Uv+GuU=;
        b=MFCvY23dH2nEKGhH9sD9tOD+gNOWhXpdyo3gqaIVRd1rY9NfqQo8gKwhDeRhacLIIH
         cPYJJyDvODntOOO88U6qnGEr9wR5XwPietdTMA3+hhwQ6IqWsMNiPMe1QmXWodyD+3KY
         SA+M6dYrKhH5zZ6diIxC1qrI2ipJWrrk8ZjIYUBq6wr0RxDwJzSYuDkFLO+gcCYguuNO
         S7WFQsc83TH1lTGgzhhgmLfZxUR4cN3zNSCXEe/j9x7nu6FRlbOb3QQt/yk8EOhMjg2B
         qV1A2W1Oit7ckskNQiM1/39PloljWYqIb4/ygFeee0GybAW+B5Tu7lOlGm1FVURbnfLN
         jJ0Q==
X-Gm-Message-State: APjAAAXa9ToTiK2va/0h4ye7xXBf0CpE7Puk337qPnJ5GcCKSP6jXPbp
        iNwuUCnADqQUmDBv+U7dyXBO7w==
X-Google-Smtp-Source: APXvYqxLkQdGaGMAUoilMYARWQmydLg7JkhQ8TSd/kYaSQgSsbbX9prcbhqla+oWQZxOxJBoOQnxFg==
X-Received: by 2002:a81:22c1:: with SMTP id i184mr60305632ywi.292.1560792605585;
        Mon, 17 Jun 2019 10:30:05 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-8C7.dyn6.twc.com. [2606:a000:1100:37d::8c7])
        by smtp.gmail.com with ESMTPSA id x85sm3901651ywx.63.2019.06.17.10.30.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:30:04 -0700 (PDT)
Message-ID: <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Mon, 17 Jun 2019 13:30:04 -0400
In-Reply-To: <20190617125529.6230-5-zyan@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-5-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> When remounting aborted mount, also reset client's entity addr.
> 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> from blacklist.
> 

Why do I need to umount here? Once the filesystem is unmounted, then the
'-o remount' becomes superfluous, no? In fact, I get an error back when
I try to remount an unmounted filesystem:

    $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
    mount: /mnt/cephfs: mount point not mounted or bad option.

My client isn't blacklisted above, so I guess you're counting on the
umount returning without having actually unmounted the filesystem?

I think this ought to not need a umount first. From a UI standpoint,
just doing a "mount -o remount" ought to be sufficient to clear this.

Also, how would an admin know that this is something they ought to try?
Is there a way for them to know that their client has been blacklisted?

> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/mds_client.c | 16 +++++++++++++---
>  fs/ceph/super.c      | 23 +++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 19c62cf7d5b8..188c33709d9a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		struct ceph_cap_flush *cf;
>  		struct ceph_mds_client *mdsc = fsc->mdsc;
>  
> -		if (ci->i_wrbuffer_ref > 0 &&
> -		    READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
> -			invalidate = true;
> +		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> +			if (inode->i_data.nrpages > 0)
> +				invalidate = true;
> +			if (ci->i_wrbuffer_ref > 0)
> +				mapping_set_error(&inode->i_data, -EIO);
> +		}
>  
>  		while (!list_empty(&ci->i_cap_flush_list)) {
>  			cf = list_first_entry(&ci->i_cap_flush_list,
> @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>  		session = __ceph_lookup_mds_session(mdsc, mds);
>  		if (!session)
>  			continue;
> +
> +		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
> +			__unregister_session(mdsc, session);
> +		__wake_requests(mdsc, &session->s_waiting);
>  		mutex_unlock(&mdsc->mutex);
> +
>  		mutex_lock(&session->s_mutex);
>  		__close_session(mdsc, session);
>  		if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
> @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>  		}
>  		mutex_unlock(&session->s_mutex);
>  		ceph_put_mds_session(session);
> +
>  		mutex_lock(&mdsc->mutex);
>  		kick_requests(mdsc, mds);
>  	}
> +
>  	__wake_requests(mdsc, &mdsc->waiting_for_map);
>  	mutex_unlock(&mdsc->mutex);
>  }
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 67eb9d592ab7..a6a3c065f697 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
>  
>  static int ceph_remount(struct super_block *sb, int *flags, char *data)
>  {
> -	sync_filesystem(sb);
> -	return 0;
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> +
> +	if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
> +		sync_filesystem(sb);
> +		return 0;
> +	}
> +
> +	/* Make sure all page caches get invalidated.
> +	 * see remove_session_caps_cb() */
> +	flush_workqueue(fsc->inode_wq);
> +	/* In case that we were blacklisted. This also reset
> +	 * all mon/osd connections */
> +	ceph_reset_client_addr(fsc->client);
> +
> +	ceph_osdc_clear_abort_err(&fsc->client->osdc);
> +	fsc->mount_state = 0;
> +
> +	if (!sb->s_root)
> +		return 0;
> +	return __ceph_do_getattr(d_inode(sb->s_root), NULL,
> +				 CEPH_STAT_CAP_INODE, true);
>  }
>  
>  static const struct super_operations ceph_super_ops = {

-- 
Jeff Layton <jlayton@redhat.com>

