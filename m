Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B02159673
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgBKRqE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 12:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbgBKRqD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 12:46:03 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1390E20661;
        Tue, 11 Feb 2020 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443163;
        bh=SVdl6rDZqz1TqwJlKpjQm12NLhb4v2P+CtsnSO8TXsY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Fehe58bzTWz4Ein45HaGvrcI40N7TaYL97hS9cZqH75WP1jiT8qp92TSFNyOnuUxy
         AVYfm/IeztFIPpBf/i//HEWjJmQ6xjiKI2LsHJ4yrA2FKIlbUtsLOcIs5SDEfYNuv6
         z3K0yAfF+wbFUOw3SW0OZbzjDtyqWQZipiLeXPHE=
Message-ID: <3f4ebc76a3155d9c1629e8fccb92e6f685d592ba.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: check if file lock exists before sending
 unlock request
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Tue, 11 Feb 2020 12:46:02 -0500
In-Reply-To: <20200211145443.40988-1-zyan@redhat.com>
References: <20200211145443.40988-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-02-11 at 22:54 +0800, Yan, Zheng wrote:
> When a process exits, kernel closes its files. locks_remove_file()
> is called to remove file locks on these files. locks_remove_file()
> tries unlocking files even there is no file lock.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/locks.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 544e9e85b120..d6b9166e71e4 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -210,6 +210,21 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
>  	return 0;
>  }
>  
> +static int try_unlock_file(struct file *file, struct file_lock *fl)
> +{
> +	int err;
> +	unsigned int orig_flags = fl->fl_flags;
> +	fl->fl_flags |= FL_EXISTS;
> +	err = locks_lock_file_wait(file, fl);
> +	fl->fl_flags = orig_flags;
> +	if (err == -ENOENT) {
> +		if (!(orig_flags & FL_EXISTS))
> +			err = 0;
> +		return err;
> +	}
> +	return 1;
> +}
> +
>  /**
>   * Attempt to set an fcntl lock.
>   * For now, this just goes away to the server. Later it may be more awesome.
> @@ -255,9 +270,15 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
>  	else
>  		lock_cmd = CEPH_LOCK_UNLOCK;
>  
> +	if (op == CEPH_MDS_OP_SETFILELOCK && F_UNLCK == fl->fl_type) {
> +		err = try_unlock_file(file, fl);
> +		if (err <= 0)
> +			return err;
> +	}
> +
>  	err = ceph_lock_message(CEPH_LOCK_FCNTL, op, inode, lock_cmd, wait, fl);
>  	if (!err) {
> -		if (op == CEPH_MDS_OP_SETFILELOCK) {
> +		if (op == CEPH_MDS_OP_SETFILELOCK && F_UNLCK != fl->fl_type) {
>  			dout("mds locked, locking locally\n");
>  			err = posix_lock_file(file, fl, NULL);
>  			if (err) {
> @@ -311,9 +332,15 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
>  	else
>  		lock_cmd = CEPH_LOCK_UNLOCK;
>  
> +	if (F_UNLCK == fl->fl_type) {
> +		err = try_unlock_file(file, fl);
> +		if (err <= 0)
> +			return err;
> +	}
> +
>  	err = ceph_lock_message(CEPH_LOCK_FLOCK, CEPH_MDS_OP_SETFILELOCK,
>  				inode, lock_cmd, wait, fl);
> -	if (!err) {
> +	if (!err && F_UNLCK != fl->fl_type) {
>  		err = locks_lock_file_wait(file, fl);
>  		if (err) {
>  			ceph_lock_message(CEPH_LOCK_FLOCK,

Looks good. Merged into testing branch.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

