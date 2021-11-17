Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F08454F1C
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 22:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbhKQVNo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 16:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhKQVNH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 16:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C43361BCF;
        Wed, 17 Nov 2021 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637183408;
        bh=IFXtblsiRXPO13gaaJTkl/1UxjvXqGRu0AMSX9xM3vA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XM08958AwaGuj1VizUCYgo76i6PFoKwnYtaVxmddmMtJOTpHRdeYUQk2JGpX2aDn3
         h5a105XJ0a43R9STW5BEiSNqL8ykK4OXs46cpYgArCzeVJk+SksoRaK9T36/t/wpZq
         qOS7cgB9gguXBJ6dWnXbprTHslLiSIs+AZm9MIXbtL5y16hQBRlfhjYTf5dEbiS9OP
         lysCiC/6cUrLKwU5KZJzFPLedzt4+ehUPGHHVB//SES0ad1Mq/q5RQA/dKXDy/cz89
         OqV+NebjRuFTpm5NjDm96H7+i2rU+ayJBnIb3sAFDKhOJmJk7RZinpqNiXdZ0zxqMn
         9qNWgIvjiqKkg==
Message-ID: <e1e4365e92281675aad8cd9617e9111d7903564f.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size
 doesn't change
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 17 Nov 2021 16:10:07 -0500
In-Reply-To: <20211116092002.99439-1-xiubli@redhat.com>
References: <20211116092002.99439-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In case truncating a file to a smaller sizeA, the sizeA will be kept
> in truncate_size. And if truncate the file to a bigger sizeB, the
> MDS will only increase the truncate_seq, but still using the sizeA as
> the truncate_size.
> 
> So when filling the inode it will truncate the pagecache by using
> truncate_sizeA again, which makes no sense and will trim the inocent
> pages.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 1b4ce453d397..b4f784684e64 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>  			 * don't hold those caps, then we need to check whether
>  			 * the file is either opened or mmaped
>  			 */
> -			if ((issued & (CEPH_CAP_FILE_CACHE|
> +			if (ci->i_truncate_size != truncate_size &&
> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>  				       CEPH_CAP_FILE_BUFFER)) ||
>  			    mapping_mapped(inode->i_mapping) ||
> -			    __ceph_is_file_opened(ci)) {
> +			    __ceph_is_file_opened(ci))) {
>  				ci->i_truncate_pending++;
>  				queue_trunc = 1;
>  			}


This patch causes xfstest generic/129 to hang at umount time, when
applied on top of the testing branch, and run (w/o fscrypt being
enabled). The call stack looks like this:

        [<0>] wb_wait_for_completion+0xc3/0x120
        [<0>] __writeback_inodes_sb_nr+0x151/0x190
        [<0>] sync_filesystem+0x59/0x100
        [<0>] generic_shutdown_super+0x44/0x1d0
        [<0>] kill_anon_super+0x1e/0x40
        [<0>] ceph_kill_sb+0x5f/0xc0 [ceph]
        [<0>] deactivate_locked_super+0x5d/0xd0
        [<0>] cleanup_mnt+0x1f4/0x260
        [<0>] task_work_run+0x8b/0xc0
        [<0>] exit_to_user_mode_prepare+0x267/0x270
        [<0>] syscall_exit_to_user_mode+0x16/0x50
        [<0>] do_syscall_64+0x48/0x90
        [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
         

I suspect this is causing dirty data to get stuck in the cache somehow,
but I haven't tracked down the cause in detail.
-- 
Jeff Layton <jlayton@kernel.org>
