Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EED91F7F0
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfEOPrJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 11:47:09 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:46292 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOPrJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 11:47:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 5217615F899;
        Wed, 15 May 2019 08:47:08 -0700 (PDT)
Date:   Wed, 15 May 2019 15:47:06 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     David Disseldorp <ddiss@suse.de>
cc:     ceph-devel@vger.kernel.org, ukernel@gmail.com
Subject: Re: [PATCH] ceph: fix "ceph.dir.rctime" vxattr value
In-Reply-To: <20190515145639.5206-1-ddiss@suse.de>
Message-ID: <alpine.DEB.2.11.1905151546250.24522@piezo.novalocal>
References: <20190515145639.5206-1-ddiss@suse.de>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgdekjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinheptggvphhhrdgtohhmnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopehukhgvrhhnvghlsehgmhgrihhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 15 May 2019, David Disseldorp wrote:
> The vxattr value incorrectly places a "09" prefix to the nanoseconds
> field, instead of providing it as a zero-pad width specifier after '%'.
> 
> Link: https://tracker.ceph.com/issues/39943
> Fixes: 3489b42a72a4 ("ceph: fix three bugs, two in ceph_vxattrcb_file_layout()")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> 
> @Yan, Zheng: given that the padding has been broken for so long, another
>              option might be to drop the "09" completely and keep it
>              variable width.

Since the old value was just wrong, I'd just make it correct here and not 
worry about compatibility with a something that wasn't valid anyway.

sage


>  fs/ceph/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 0cc42c8879e9..aeb8550fb863 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -224,7 +224,7 @@ static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
>  static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
>  				       size_t size)
>  {
> -	return snprintf(val, size, "%lld.09%ld", ci->i_rctime.tv_sec,
> +	return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
>  			ci->i_rctime.tv_nsec);
>  }
>  
> -- 
> 2.16.4
> 
> 
> 
