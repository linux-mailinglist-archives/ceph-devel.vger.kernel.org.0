Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A323F03A7
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhHRMVc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235606AbhHRMVc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F40361051;
        Wed, 18 Aug 2021 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629289257;
        bh=r76n+lUH1cjChAlZYjOsIQBwKYMBDvkY61lTq1hdo0s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qlAFXXqJ8CIvbTD+B9Wznqp0KHrM21Hrj3U+WANCdxmAG+DZnJZhoXq7aSvK78sk4
         HkT3gAIybYnb3T/PPHBH3m7JT08xTxGwvzK+3J0bd5URxHAuFM3Nu7UYVd1cePpt0O
         AEsD2aO4TqIKGWMN3Eosys16xZtAUKjt4IK5ZnCd73sG1Mn+1OP8H90SQb61FrecfG
         DQE9IvlPgD0Vs7UUeUZJ2oh5+e/kGs+OLWMt2SzmGKcK+q2na6VJp11lfPDLYZeO//
         egd8ioK/OotRXb+P+CCF39PDHppoq+1o1hcH98Vbu4gfPXpbXOqyAP0sjw0cUY0XdV
         Xp+5F6y0eVC1Q==
Message-ID: <3e0961dec832a54bc6a59776831e5467ed231333.camel@kernel.org>
Subject: Re: [fscrypt][RFC PATCH v2] ceph: don't allow changing layout on
 encrypted files/directories
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 Aug 2021 08:20:55 -0400
In-Reply-To: <20210817140439.1442-1-lhenriques@suse.de>
References: <20210817140439.1442-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-17 at 15:04 +0100, Luis Henriques wrote:
> Encryption is currently only supported on files/directories with layouts
> where stripe_count=1.  Forbid changing layouts when encryption is involved.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Changes since v1:
> - dropped changes to ceph_sync_setxattr(), MDS shall be responsible for
>   preventing layout changes on encrypted dirs/files
> 
>  fs/ceph/ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 477ecc667aee..480d18bb2ff0 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
> +	/* encrypted directories can't have striped layout */
> +	if (ci->i_layout.stripe_count > 1)
> +		return -EINVAL;
> +
>  	ret = vet_mds_for_fscrypt(file);
>  	if (ret)
>  		return ret;

Thanks Luis. I've gone ahead and merged this into my fscrypt pile.
-- 
Jeff Layton <jlayton@kernel.org>

