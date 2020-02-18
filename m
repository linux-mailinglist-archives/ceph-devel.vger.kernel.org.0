Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF010162962
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 16:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgBRP1V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 10:27:21 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:34413 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgBRP1V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 10:27:21 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so22738953iof.1
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 07:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AoHKDNCz8aCmUTFEKnmG83rFkNuvXIbc7FKn/o4mXI4=;
        b=aFpupdTel48jN/1L6iGENhMvLzzXDjPTnMR2VNi1mN9BE8Spao0aVM0qopO6OIFyRA
         eZhv0Xc1M4lrVy69T8azLZVJJnUUQRkNL9AV1qopibQKaCGMFGgb3yhLlSjFUsst+4lg
         OMuaTWpVP+iKX/xaON341F9wtzFn0RidAVgJ1zA6D4c9vv2Vrf/8u4VrLnmCcQ2nGXx0
         xV+GUztVQ8s3PM5qISj/Wv5/eHjU0zvzAZvPkoDdx0ZSNNBYfx4UcLxcb0pIZkrONm/X
         aXn1uwnk/dacR92j6+IXnRRiUMs02uPdO1u99PeKtW0mdlaSoV/ogkzSDRZBCHISnIGF
         UnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AoHKDNCz8aCmUTFEKnmG83rFkNuvXIbc7FKn/o4mXI4=;
        b=SdCREVJAtLHhY/sgg1w2sxtBPhrCACG+DaT7tzqqNgV/MeY8y8bwU/MRfu6jmWgJno
         Gxaf63N56r4ZiR7y9cFdVR5/i+uxUk7PBXqgxA+4/400HqcuevVYTs/9orEVdjjdfdox
         CuYllkZhLiBfRPymrknqdX6ByNhdlJI/ZSS7C10boNO5rsAMWU1gv6AWIF/Jy53Y+D+t
         IYlDv62JgjA/ErezHbPkytXHU1FYTOnZo2YMYTAk/PyqLvghj8Sc26hsSkB1acBrYcvB
         hR5CWiTGG2GS/Zt6nfmy3B2LxYhSgdti0QqFeDXY8sbneP/OayokUi/eAJA0swdMi6Ji
         AMSQ==
X-Gm-Message-State: APjAAAUuJ910XSbXmiuLkxlkFH34yOGhiVxAWQSKRHGOnC3l4n95Ih9a
        +UFj3GPT5uECRSbw/hekacabJ3UQTLdg3XV82Ng=
X-Google-Smtp-Source: APXvYqwk4l7o6wSz8dDXBPzQUUVNoJ28UdUBb2dXITwA3tiXLW0g/FnMDTXw8T2iHiHmTda6a7Hi5VV5UnwySp21ScQ=
X-Received: by 2002:a02:8587:: with SMTP id d7mr16985214jai.39.1582039639788;
 Tue, 18 Feb 2020 07:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20200218141116.26481-1-jlayton@kernel.org>
In-Reply-To: <20200218141116.26481-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 16:27:45 +0100
Message-ID: <CAOi1vP9fKwZ+Q70Q8kcqByRz3A07+75mWqu5GL6CHoGqTwX2YA@mail.gmail.com>
Subject: Re: [PATCH] ceph: move to a dedicated slabcache for mds requests
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 3:11 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On my machine (x86_64) this struct is 952 bytes, which gets rounded up
> to 1024 by kmalloc. Move this to a dedicated slabcache, so we can
> allocate them without the extra 72 bytes of overhead per.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c         | 6 +++---
>  fs/ceph/super.c              | 8 ++++++++
>  include/linux/ceph/libceph.h | 1 +
>  3 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2980e57ca7b9..76655047fca5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -736,7 +736,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>         put_request_session(req);
>         ceph_unreserve_caps(req->r_mdsc, &req->r_caps_reservation);
>         WARN_ON_ONCE(!list_empty(&req->r_wait));
> -       kfree(req);
> +       kmem_cache_free(ceph_mds_request_cachep, req);
>  }
>
>  DEFINE_RB_FUNCS(request, struct ceph_mds_request, r_tid, r_node)
> @@ -2094,8 +2094,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  struct ceph_mds_request *
>  ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>  {
> -       struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
> -
> +       struct ceph_mds_request *req = kmem_cache_alloc(ceph_mds_request_cachep,
> +                                                       GFP_NOFS | __GFP_ZERO);

This can be kmem_cache_zalloc(), less verbose.  Also, I would separate
declaration and assignment here.

Thanks,

                Ilya
