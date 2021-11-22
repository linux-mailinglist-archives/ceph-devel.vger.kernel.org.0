Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36CE459411
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Nov 2021 18:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhKVRmP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Nov 2021 12:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhKVRmO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 12:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24C7C60524;
        Mon, 22 Nov 2021 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637602747;
        bh=OKvrL4n/OgHtigPMUDOHWznYAqh6RZMP/efGeJRGAU0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n7FSEQPLi2+WSCcoGYa0Iecw6YOJUOSuVG8Dlx5lat69pP9qv7PKXXClfPv701DCa
         XLh1a/gTfLzYYpsuQz4C5cYK2VujobQ7z5nxrCC/kc6QIMzKQwogvKTzNmKrsQUABj
         VdiTu1j//oOx9lYffuhdDdZbLAGyCT/66R3xhyihwQURcwOG2prfBfNPK9D0eNLUqa
         s2Xy3z6BXKRfalIzmVj5r8KVZXclZ90r61LdtVwB6p8STSS637xTsdLCon+COuc7z+
         3f8PpMmNGAVwCiKtcCWVzcDk0TJ0fVeXxShTsnngMGOkmCE6KBdnrbUazjzZiSWGbc
         VmXDxiH77mdWA==
Message-ID: <9ad536c494ab2663e0087d739f7ebdc49786401b.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix duplicate increment of opened_inodes metric
From:   Jeff Layton <jlayton@kernel.org>
To:     Hu Weiwen <sehuww@mail.scut.edu.cn>, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Date:   Mon, 22 Nov 2021 12:39:06 -0500
In-Reply-To: <20211122142212.1621-1-sehuww@mail.scut.edu.cn>
References: <20211122142212.1621-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-22 at 22:22 +0800, Hu Weiwen wrote:
> opened_inodes is incremented twice when the same inode is opened twice
> with O_RDONLY and O_WRONLY respectively.
> 
> To reproduce, run this python script, then check the metrics:
> 
> import os
> for _ in range(10000):
>     fd_r = os.open('a', os.O_RDONLY)
>     fd_w = os.open('a', os.O_WRONLY)
>     os.close(fd_r)
>     os.close(fd_w)
> 
> Fixes: 1dd8d4708136 ("ceph: metrics for opened files, pinned caps and opened inodes")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>  fs/ceph/caps.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b9460b6fb76f..c447fa2e2d1f 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4350,7 +4350,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>  {
>  	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
>  	int bits = (fmode << 1) | 1;
> -	bool is_opened = false;
> +	bool already_opened = false;
>  	int i;
>  
>  	if (count == 1)
> @@ -4358,19 +4358,19 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> -		if (bits & (1 << i))
> -			ci->i_nr_by_mode[i] += count;
> -
>  		/*
> -		 * If any of the mode ref is larger than 1,
> +		 * If any of the mode ref is larger than 0,
>  		 * that means it has been already opened by
>  		 * others. Just skip checking the PIN ref.
>  		 */
> -		if (i && ci->i_nr_by_mode[i] > 1)
> -			is_opened = true;
> +		if (i && ci->i_nr_by_mode[i])
> +			already_opened = true;
> +
> +		if (bits & (1 << i))
> +			ci->i_nr_by_mode[i] += count;
>  	}
>  
> -	if (!is_opened)
> +	if (!already_opened)
>  		percpu_counter_inc(&mdsc->metric.opened_inodes);
>  	spin_unlock(&ci->i_ceph_lock);
>  }

Thanks for the patch. I think it's correct, but I'd like Xiubo to
confirm before we merge this.
-- 
Jeff Layton <jlayton@kernel.org>
