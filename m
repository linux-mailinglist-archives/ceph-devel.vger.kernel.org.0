Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7387B346A7D
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Mar 2021 21:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhCWUyw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Mar 2021 16:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233354AbhCWUy2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 16:54:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 699ED619C2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Mar 2021 20:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616532868;
        bh=CJtQ0YqmPH0UGdnZOInAW/QgW2WUZi8NUAK05lwNb3E=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=PclGleDBufLUBJBrR8cshgM7FkfAarNPI4vQ0xkmsuAjCIccqZn4P9GaG8AN4oI4M
         ZvJFOV2ipiVHQYBTxrOrbmSQQx3WeuqQ/+P3gSmLzi7/TmT2ln2zr+DMZjenHXH31j
         kxV9z5xi2BVDFWc21V0oC9kNXzhCkEPXTnQOqPkE+QahGpKUxAbL8f/aQuGu2/87mO
         2DSiCuOR3MqvfKKHZ3IZWUaRXwtW/mb2cxpyuXsCfQOWHHIXH7wYY+a8sT1XdfYryc
         dt0D9FO6YPEGwuuo18cG3CwGVA1MZAq/3xrpZ95T4g7MVMWHynDpRNk9gx/1LHFnrU
         +lqGhhEQ3P1Fw==
Message-ID: <5f8b65aef333a40a91b5d62f7d24b1f05ba02849.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: fix kerneldoc copypasta over
 ceph_start_io_direct
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Date:   Tue, 23 Mar 2021 16:54:27 -0400
In-Reply-To: <20210323203326.217781-1-jlayton@kernel.org>
References: <20210323203326.217781-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-03-23 at 16:33 -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/io.c b/fs/ceph/io.c
> index 97602ea92ff4..c456509b31c3 100644
> --- a/fs/ceph/io.c
> +++ b/fs/ceph/io.c
> @@ -118,7 +118,7 @@ static void ceph_block_buffered(struct ceph_inode_info *ci, struct inode *inode)
>  }
>  
>  /**
> - * ceph_end_io_direct - declare the file is being used for direct i/o
> + * ceph_start_io_direct - declare the file is being used for direct i/o
>   * @inode: file inode
>   *
>   * Declare that a direct I/O operation is about to start, and ensure

Disregard the 1/2 in the patch subject. This one is standalone.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

