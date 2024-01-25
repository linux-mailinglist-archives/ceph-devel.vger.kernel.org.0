Return-Path: <ceph-devel+bounces-657-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7F383B6DF
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 02:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B4C1B2364B
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 01:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1E31388;
	Thu, 25 Jan 2024 01:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdUpozGX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64FA6FB2
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jan 2024 01:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706147587; cv=none; b=racVN9ZFlPq7xr38L6NBUKkxEM6G+GXE8Jf386P/Or+I/6fkI+lCJs6UOS/OWUJxXRkwMpjQgUVI2K/ibFBzbFyLlL/SKFhmP2N5CCkh/Gz8VK3eWyg62AMQRwqLVYlTrvdUTLpmlwptPD+5x+DKgdzVjVcAj6kVVwNxLf5ypAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706147587; c=relaxed/simple;
	bh=Or1SKE2pR7Isqu7JaC9KAlaV6QsEeIhX4E9G7bgO2Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skYyotWIGoTxDxyvnDhi0qHnPbfo1lWsA2lNF6qqCyj5xJPhd3ZglKAZZJU9q9h4j8KTycy9uH60dpSmbLiPyEer05NVzQNOv459MDxWwlIdtt3iXNcUDXhH+oQVpqjNQihPFGfsXA1cRJwb9alqyDvDt9iJyZr/UC2UyoD0HU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdUpozGX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A49C433C7;
	Thu, 25 Jan 2024 01:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706147587;
	bh=Or1SKE2pR7Isqu7JaC9KAlaV6QsEeIhX4E9G7bgO2Gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZdUpozGXR2rVFh+eVItoBaaLviISCO7zh0557TN5DIEJnZgfZId9IDF7SwrLoBPJZ
	 EU5EfV4zqKkISwe7DSnHWESLug0nS+gh266dF5DQNGTKqh1Ug8MqVAq0VgvU4lqpsa
	 Q8dWhDHTLdVrS1J/zGYCgfnjuMho5XjLkkIIEljYtqJSRF3Oy8rY1JG0osYuQmhuJD
	 nSlz2psjArLYvSxBtoKRKAJwemyQJVDx/hmzebEoIuov0CiRd9f1mqcQ7CKwTJvZlr
	 TnO4S3Ss7ICj+mKm9We6rk6iJ47vf/EQlv8OGG3FxuTsuLLjwXi/FYtGXSLWqE9xqz
	 gsrUewCuvi5mQ==
Date: Wed, 24 Jan 2024 17:53:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
	vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH] ceph: always set the initial i_blkbits to
 CEPH_FSCRYPT_BLOCK_SHIFT
Message-ID: <20240125015305.GG1088@sol.localdomain>
References: <20240118080404.783677-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118080404.783677-1-xiubli@redhat.com>

On Thu, Jan 18, 2024 at 04:04:04PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The fscrypt code will use i_blkbits to setup the 'ci_data_unit_bits'
> when allocating the new inode, but ceph will initiate i_blkbits
> ater when filling the inode, which is too late. Since the
> 'ci_data_unit_bits' will only be used by the fscrypt framework so
> initiating i_blkbits with CEPH_FSCRYPT_BLOCK_SHIFT is safe.
> 
> Fixes: commit 5b1188847180 ("fscrypt: support crypto data unit size
>        less than filesystem block size")

The Fixes line should be one line, and the word "commit" should not be there

> URL: https://tracker.ceph.com/issues/64035
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 62af452cdba4..d96d97b31f68 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -79,6 +79,8 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
>  	if (!inode)
>  		return ERR_PTR(-ENOMEM);
>  
> +	inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
> +
>  	if (!S_ISLNK(*mode)) {
>  		err = ceph_pre_init_acls(dir, mode, as_ctx);
>  		if (err < 0)

Looks good, you can add:

    Reviewed-by: Eric Biggers <ebiggers@google.com>

Sorry for the trouble; I need to start running xfstests on CephFS!

In the future please also Cc the fscrypt mailing list on things like this.

Maybe you'd like to also send a patch that updates the comment for
fscrypt_prepare_new_inode() to clarify that i_blkbits needs to be set first?

- Eric

