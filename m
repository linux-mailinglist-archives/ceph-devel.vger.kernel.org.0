Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C753F6F85
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 08:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhHYGdo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 02:33:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237102AbhHYGdo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 02:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629873177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0DWLBxTtM4lOOFalLK3LTPkJn+QEHLzsRUaOMwYcuU=;
        b=Lrs5nDhNsXJNOvAEY/st151mLjw9RxSrBpoo/7honcx625tQREHU3eY7uRPXWZK/xXFrte
        vN1WF14lCkhYfQqm+9n6C0OfifzQ40gTmWraT3v7THMQYOOdtrdcYzUPqROjcqbs1Bh5XV
        M4hxvcK7RszwenXUwZYS9d7RYKiHqik=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-V5IC8BgGM1i9BMMZmDpZtw-1; Wed, 25 Aug 2021 02:32:56 -0400
X-MC-Unique: V5IC8BgGM1i9BMMZmDpZtw-1
Received: by mail-pj1-f71.google.com with SMTP id 11-20020a17090a198b00b001822e08fc1bso4673136pji.0
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 23:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q0DWLBxTtM4lOOFalLK3LTPkJn+QEHLzsRUaOMwYcuU=;
        b=rldEqSlImOdXnFWk5IcopmjcivhEIcpmTzeryeetMmR7nVshKNmUsbnEo5pzm/eskD
         7jHPboEpfOVGExvSwKv6v1QnG+z5M5wgjbsn1ITyavi7xWNMstFF5dVGLrK4axAVrG/v
         axUYTNxEFN6JPzkcr3UNbfk9ZGjerL1Vs9coFYWrc0ZF7Xfmf8o9zlXndt/hWks7Og5Y
         Keoq6+FUHcDjJD8uMxc9iWFSS9Wpf1yN3COxUnTbDp7kds23HeHTsPUR7yn3fg2uEuGg
         81LZb1CiIoZZFgPFPugsUa52fKcglyRVXMOq7jvN++3JnKm2lIT6i4rOFyo2qsX3hB6t
         n5Hw==
X-Gm-Message-State: AOAM532APd+d9fxoi7RsetGhT01YFHJRETdxMonbQZjWWybWP/0C50nV
        5w1igwkW/4lbPb82LMXozHk8CAkV3CO7/B3YDU/tJWUFIwRwEKLqMXO2kFa1YTPg0pboU7SQnku
        GlBdlePCMmEKd3BdpBYq1KoAwfKrTla2CtsYDouY8hYfiM915nMZP8mZR7I2uAGRFbCcS38g=
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr8971518pjo.231.1629873174805;
        Tue, 24 Aug 2021 23:32:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyYTbd1SRB/ynA3bGIUZmOb+T7ciGO269ipWYgKsoMY3mRaM93r5An74Und63IiAxXupAtoA==
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr8971494pjo.231.1629873174553;
        Tue, 24 Aug 2021 23:32:54 -0700 (PDT)
Received: from [10.72.12.116] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm4463776pjd.3.2021.08.24.23.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 23:32:54 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] ceph: remove the capsnaps when removing the caps
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210825051355.5820-1-xiubli@redhat.com>
 <20210825051355.5820-2-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3932b0b5-50cc-3d1e-c508-80ee655a2c38@redhat.com>
Date:   Wed, 25 Aug 2021 14:32:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825051355.5820-2-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There still has one bug, I am looking at it.

Thanks


On 8/25/21 1:13 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> The capsnaps will ihold the inodes when queuing to flush, so when
> force umounting it will close the sessions first and if the MDSes
> respond very fast and the session connections are closed just
> before killing the superblock, which will flush the msgr queue,
> then the flush capsnap callback won't ever be called, which will
> lead the memory leak bug for the ceph_inode_info.
>
> URL: https://tracker.ceph.com/issues/52295
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c       | 56 +++++++++++++++++++++++++++++++-------------
>   fs/ceph/mds_client.c | 25 +++++++++++++++++++-
>   fs/ceph/super.h      |  6 +++++
>   3 files changed, 70 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ddd86106e6d0..557c610289fb 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3658,6 +3658,43 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>   		iput(inode);
>   }
>   
> +void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
> +			   bool *wake_ci, bool *wake_mdsc)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	bool ret;
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
> +
> +	list_del_init(&capsnap->ci_item);
> +	ret = __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
> +	if (wake_ci)
> +		*wake_ci = ret;
> +
> +	spin_lock(&mdsc->cap_dirty_lock);
> +	if (list_empty(&ci->i_cap_flush_list))
> +		list_del_init(&ci->i_flushing_item);
> +
> +	ret = __detach_cap_flush_from_mdsc(mdsc, &capsnap->cap_flush);
> +	if (wake_mdsc)
> +		*wake_mdsc = ret;
> +	spin_unlock(&mdsc->cap_dirty_lock);
> +}
> +
> +void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
> +			 bool *wake_ci, bool *wake_mdsc)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	WARN_ON_ONCE(capsnap->dirty_pages || capsnap->writing);
> +	__ceph_remove_capsnap(inode, capsnap, wake_ci, wake_mdsc);
> +}
> +
>   /*
>    * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
>    * throw away our cap_snap.
> @@ -3695,23 +3732,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
>   			     capsnap, capsnap->follows);
>   		}
>   	}
> -	if (flushed) {
> -		WARN_ON(capsnap->dirty_pages || capsnap->writing);
> -		dout(" removing %p cap_snap %p follows %lld\n",
> -		     inode, capsnap, follows);
> -		list_del(&capsnap->ci_item);
> -		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
> -
> -		spin_lock(&mdsc->cap_dirty_lock);
> -
> -		if (list_empty(&ci->i_cap_flush_list))
> -			list_del_init(&ci->i_flushing_item);
> -
> -		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
> -							  &capsnap->cap_flush);
> -		spin_unlock(&mdsc->cap_dirty_lock);
> -	}
> +	if (flushed)
> +		ceph_remove_capsnap(inode, capsnap, &wake_ci, &wake_mdsc);
>   	spin_unlock(&ci->i_ceph_lock);
> +
>   	if (flushed) {
>   		ceph_put_snap_context(capsnap->context);
>   		ceph_put_cap_snap(capsnap);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index df3a735f7837..df10f9b33660 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1604,10 +1604,32 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>   	return ret;
>   }
>   
> +static void remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_cap_snap *capsnap;
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
> +
> +	while (!list_empty(&ci->i_cap_snaps)) {
> +		capsnap = list_first_entry(&ci->i_cap_snaps,
> +					   struct ceph_cap_snap, ci_item);
> +		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
> +		ceph_put_snap_context(capsnap->context);
> +		ceph_put_cap_snap(capsnap);
> +		iput(inode);
> +	}
> +	wake_up_all(&ci->i_cap_wq);
> +	wake_up_all(&mdsc->cap_flushing_wq);
> +}
> +
>   static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>   				  void *arg)
>   {
>   	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	LIST_HEAD(to_remove);
>   	bool dirty_dropped = false;
> @@ -1619,7 +1641,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>   	__ceph_remove_cap(cap, false);
>   	if (!ci->i_auth_cap) {
>   		struct ceph_cap_flush *cf;
> -		struct ceph_mds_client *mdsc = fsc->mdsc;
>   
>   		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
>   			if (inode->i_data.nrpages > 0)
> @@ -1684,6 +1705,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>   			ci->i_prealloc_cap_flush = NULL;
>   		}
>   	}
> +	if (!list_empty(&ci->i_cap_snaps))
> +		remove_capsnaps(mdsc, inode);
>   	spin_unlock(&ci->i_ceph_lock);
>   	while (!list_empty(&to_remove)) {
>   		struct ceph_cap_flush *cf;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8f4f2747be65..445d13d760d1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1169,6 +1169,12 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
>   					    int had);
>   extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>   				       struct ceph_snap_context *snapc);
> +extern void __ceph_remove_capsnap(struct inode *inode,
> +				  struct ceph_cap_snap *capsnap,
> +				  bool *wake_ci, bool *wake_mdsc);
> +extern void ceph_remove_capsnap(struct inode *inode,
> +				struct ceph_cap_snap *capsnap,
> +				bool *wake_ci, bool *wake_mdsc);
>   extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>   			     struct ceph_mds_session **psession);
>   extern bool __ceph_should_report_size(struct ceph_inode_info *ci);

