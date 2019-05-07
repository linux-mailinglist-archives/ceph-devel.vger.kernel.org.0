Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22D216490
	for <lists+ceph-devel@lfdr.de>; Tue,  7 May 2019 15:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfEGNa6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 May 2019 09:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGNa6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 May 2019 09:30:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9F58308FED4;
        Tue,  7 May 2019 13:30:57 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43E0E60C4D;
        Tue,  7 May 2019 13:30:53 +0000 (UTC)
Subject: Re: [PATCH] ceph: flush dirty inodes before proceeding with remount
To:     Jeff Layton <jlayton@kernel.org>, sage@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20190507132746.27493-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <aca6b52e-2d92-d487-b193-44d7e9ef98b0@redhat.com>
Date:   Tue, 7 May 2019 21:30:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507132746.27493-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 07 May 2019 13:30:57 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 5/7/19 9:27 PM, Jeff Layton wrote:
> xfstest generic/452 was triggering a "Busy inodes after umount" warning.
> ceph was allowing the mount to go read-only without first flushing out
> dirty inodes in the cache. Ensure we sync out the filesystem before
> allowing a remount to proceed.
> 
> Cc: stable@vger.kernel.org
> Fixes: http://tracker.ceph.com/issues/39571
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/super.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 6d5bb2f74612..01113c86e469 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -845,6 +845,12 @@ static void ceph_umount_begin(struct super_block *sb)
>   	return;
>   }
>   
> +static int ceph_remount(struct super_block *sb, int *flags, char *data)
> +{
> +	sync_filesystem(sb);
> +	return 0;
> +}
> +
>   static const struct super_operations ceph_super_ops = {
>   	.alloc_inode	= ceph_alloc_inode,
>   	.destroy_inode	= ceph_destroy_inode,
> @@ -852,6 +858,7 @@ static const struct super_operations ceph_super_ops = {
>   	.drop_inode	= ceph_drop_inode,
>   	.sync_fs        = ceph_sync_fs,
>   	.put_super	= ceph_put_super,
> +	.remount_fs	= ceph_remount,
>   	.show_options   = ceph_show_options,
>   	.statfs		= ceph_statfs,
>   	.umount_begin   = ceph_umount_begin,
> 

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
