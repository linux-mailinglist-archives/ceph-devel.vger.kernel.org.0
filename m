Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD722158DE5
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgBKMEG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 07:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgBKMEG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 07:04:06 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292052051A;
        Tue, 11 Feb 2020 12:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581422645;
        bh=QOpgO/cVz1+S3NFUCT3h2zj/Ed/Q54MfwlUJh60ZPdY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=DAj8xfq9/YZEMZ0Yds4ebfxKMlpCBproykOoWB1ynSBLPyhnBN7vDZy5X9eW+750m
         uEflOMqXl7FFj7uNlN3HXrpyZguTEDPJ6xv4Qg/j63MfupuatNfzm81+ByNFq3TJgb
         zK4r/BhJ8t5NZsk404vSQDM8L9N3cPYPCMBFLvXA=
Message-ID: <70302bc11d208458832164f9853a2e4dfcba2c13.camel@kernel.org>
Subject: Re: [PATCH] ceph: check if file lock exists before sending unlock
 request
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Tue, 11 Feb 2020 07:04:03 -0500
In-Reply-To: <20200211085901.16256-1-zyan@redhat.com>
References: <20200211085901.16256-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-02-11 at 16:59 +0800, Yan, Zheng wrote:
> When a process exits, kernel closes its files. locks_remove_file()
> is called to remove file locks on these files. locks_remove_file()
> tries unlocking files locks even there is no file locks.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/locks.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 544e9e85b120..78be861259eb 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -255,9 +255,21 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
>  	else
>  		lock_cmd = CEPH_LOCK_UNLOCK;
>  
> +	if (op == CEPH_MDS_OP_SETFILELOCK && F_UNLCK == fl->fl_type) {
> +		unsigned int orig_flags = fl->fl_flags;
> +		fl->fl_flags |= FL_EXISTS;
> +		err = posix_lock_file(file, fl, NULL);
> +		fl->fl_flags = orig_flags;
> +		if (err == -ENOENT) {
> +			if (!(orig_flags & FL_EXISTS))
> +				err = 0;
> +			return err;
> +		}

Maybe move the above logic into a helper function since this is copied
to the section below? The helper would need to use locks_lock_file_wait
instead of posix_lock_file, but that should be ok.

> +	}
> +
>  	err = ceph_lock_message(CEPH_LOCK_FCNTL, op, inode, lock_cmd, wait, fl);
>  	if (!err) {
> -		if (op == CEPH_MDS_OP_SETFILELOCK) {
> +		if (op == CEPH_MDS_OP_SETFILELOCK && F_UNLCK != fl->fl_type) {
>  			dout("mds locked, locking locally\n");
>  			err = posix_lock_file(file, fl, NULL);
>  			if (err) {
> @@ -311,9 +323,21 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
>  	else
>  		lock_cmd = CEPH_LOCK_UNLOCK;
>  
> +	if (F_UNLCK == fl->fl_type) {
> +		unsigned int orig_flags = fl->fl_flags;
> +		fl->fl_flags |= FL_EXISTS;
> +		err = locks_lock_file_wait(file, fl);
> +		fl->fl_flags = orig_flags;
> +		if (err == -ENOENT) {
> +			if (!(orig_flags & FL_EXISTS))
> +				err = 0;
> +			return err;
> +		}
> +	}
> +
>  	err = ceph_lock_message(CEPH_LOCK_FLOCK, CEPH_MDS_OP_SETFILELOCK,
>  				inode, lock_cmd, wait, fl);
> -	if (!err) {
> +	if (!err && F_UNLCK != fl->fl_type) {
>  		err = locks_lock_file_wait(file, fl);
>  		if (err) {
>  			ceph_lock_message(CEPH_LOCK_FLOCK,

-- 
Jeff Layton <jlayton@kernel.org>

