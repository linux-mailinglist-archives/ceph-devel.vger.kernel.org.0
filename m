Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E6316B39D
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 23:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXWPO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 17:15:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWPO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 17:15:14 -0500
Received: from vulkan (unknown [4.28.11.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27758218AC;
        Mon, 24 Feb 2020 22:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582582513;
        bh=mBp99VyT1gWuj1LiSfqrMLDvLhq0S77OYWBMqGblpHg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wzYnQcV+vDk/c8c4K9MzGXjqG8mr4vD+vMJq0t7dDA9V4REd+8EsXd+29bHjir77y
         a5Wvmd2WH8WtoEP2uEgAvIOGojtyyT4ToFraGDM84dAmMgFEdG69bsAZ0vmV3g7SGV
         Ffuy+eWVOqnMbVZm8xY0V4//p2OGTsr6WuFJ4O7k=
Message-ID: <c406ee08db90c1452c4ba9740b046ca9204c7239.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: re-org copy_file_range and fix some error paths
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 24 Feb 2020 14:15:12 -0800
In-Reply-To: <20200224134432.25888-1-lhenriques@suse.com>
References: <20200224134432.25888-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-24 at 13:44 +0000, Luis Henriques wrote:
> This patch re-organizes copy_file_range, trying to fix a few issues in the
> error handling.  Here's the summary:
> 
> - Abort copy if initial do_splice_direct() returns fewer bytes than
>   requested.
> 
> - Move the 'size' initialization (with i_size_read()) further down in the
>   code, after the initial call to do_splice_direct().  This avoids issues
>   with a possibly stale value if a manual copy is done.
> 
> - Move the object copy loop into a separate function.  This makes it
>   easier to handle errors (e.g, dirtying caps and updating the MDS
>   metadata if only some objects have been copied before an error has
>   occurred).
> 
> - Added calls to ceph_oloc_destroy() to avoid leaking memory with src_oloc
>   and dst_oloc
> 
> - After the object copy loop, the new file size to be reported to the MDS
>   (if there's file size change) is now the actual file size, and not the
>   size after an eventual extra manual copy.
> 
> - Added a few dout() to show the number of bytes copied in the two manual
>   copies and in the object copy loop.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi,
> 
> Just a respin including Jeff's suggestions from initial post.
> 
> Changes since v1:
> 
> - Don't bother trying a second splice once we fail during the remote
>   object copies; let user-space retry instead.
> 
> Cheers,
> --
> Luis
> 
>  fs/ceph/file.c | 173 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 100 insertions(+), 73 deletions(-)
> 

This looks good to me, Luis -- merged into ceph-client/testing.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

