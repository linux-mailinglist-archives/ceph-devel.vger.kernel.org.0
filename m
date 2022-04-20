Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89E75089E1
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Apr 2022 15:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244528AbiDTN7t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 09:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbiDTN7t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 09:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C737D43496
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 06:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70540613B3
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 13:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6C1C385A1;
        Wed, 20 Apr 2022 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650463021;
        bh=QcGI7VVwhkeY+nH90FxRmPT9YVyyikDqkl7Z1oZTHm4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I9BBKJKyXvzqIrieHB4BvHIxbY1j6/YjzH2tpN5XlpQJUFB3I99wH7UUycpyM4W6M
         SZj5b5QyDufxK6GDe1MNXjzFdOYw/s2EfYVCwxHjuTAikuZLl/oIfXTbJwkc2dbiOm
         cqixkwbRvSOcZu8RvQuz2lgZkEnNyf7A4hOZL9mkSoB02yFzyPBYDVrFpw7Ktwf7uR
         /zZFBqQRNUv088Su2O3AakqpHtiux1Q0zp8ZlfloCHrAoGlPEKdScUQoiIZ4IcaJY8
         fb6eiEa0RqwDPtZLgTfe+mnGV4OGV3myV2hJCAjNBONknEZXKCOxn52xHl0BFwGLFR
         aMAs45YBI/Jeg==
Message-ID: <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 20 Apr 2022 09:56:59 -0400
In-Reply-To: <20220420052404.1144209-1-xiubli@redhat.com>
References: <20220420052404.1144209-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-04-20 at 13:24 +0800, Xiubo Li wrote:
> Since the cephFS makes no attempt to maintain atime, we shouldn't
> try to update it in mmap and generic read cases and ignore updating
> it in direct and sync read cases.
> 
> And even we update it in mmap and generic read cases we will drop
> it and won't sync it to MDS. And we are seeing the atime will be
> updated and then dropped to the floor again and again.
> 
> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c  | 1 -
>  fs/ceph/super.c | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index aa25bffd4823..02722ac86d73 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  	if (!mapping->a_ops->readpage)
>  		return -ENOEXEC;
> -	file_accessed(file);
>  	vma->vm_ops = &ceph_vmops;
>  	return 0;
>  }
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index e6987d295079..b73b4f75462c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>  	s->s_time_gran = 1;
>  	s->s_time_min = 0;
>  	s->s_time_max = U32_MAX;
> +	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>  
>  	ret = set_anon_super_fc(s, fc);
>  	if (ret != 0)

(cc'ing Greg since he claimed this...)

I confess, I've never dug into the MDS code that should track atime, but
I'm rather surprised that the MDS just drops those updates onto the
floor.

It's obviously updated when the mtime changes. The SETATTR operation
allows the client to set the atime directly, and there is an "atime"
slot in the cap structure that does get populated by the client. I guess
though that it has never been 100% clear what cap the atime should be
governed by so maybe it just always ignores that field?

Anyway, I've no firm objection to this since no one in their right mind
should use the atime anyway, but you may see some complaints if you just
turn it off like this. There are some applications that use it.
Hopefully no one is running those on ceph.

It would be nice to document this somewhere as well -- maybe on the ceph
POSIX conformance page?

    https://docs.ceph.com/en/latest/cephfs/posix/

-- 
Jeff Layton <jlayton@kernel.org>
