Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A044E7ECF7
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2019 08:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389182AbfHBG5E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Aug 2019 02:57:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35628 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389177AbfHBG5E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Aug 2019 02:57:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so54081337qke.2
        for <ceph-devel@vger.kernel.org>; Thu, 01 Aug 2019 23:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iyQuH8z92eM8W0ixGoLiLLANc2nKFnR0UZo57YTTMvw=;
        b=SumGcTXf9zPzZhvfbObFI8CVp3XKGsCDVzmd1PH5roLDCcQo8ChGn76LzBEE5iOsVl
         Yjb0KA0gvP8yYqbNZjraSAbnNWOLU3LhG2u9HLjDydNQFoGbjxia9XgONDYQXDEx/gVa
         1HXBgnhzJ4XQvWqvkTjMamuUOsDERF6KyvSJhD2+Tn5PEiPHcdOeL1FpVkS7FMVDuigx
         Bdisn0fsWvaDY+YrjNMpi6GdL+wkVKeSUtlQuTxValPKJ7lmUv9aMLTVTtrlm7HPZMp+
         SoOdCc3oRd/p5kfwUyTejy/TBlZcU4NS5gZsNHiUCDetqstmFNHtwl9tKzhelV66jWsb
         400Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iyQuH8z92eM8W0ixGoLiLLANc2nKFnR0UZo57YTTMvw=;
        b=C6q6QIy8c7Czd1Ij7ghCYP0whdMq0NsxCwapPEX/nuSK2EN+YMshbR81/u3B3wA598
         92Y0laAKW6QX43akmoI2sDzIS0vOzYHBnD1MLYZc8B6llOiC0yXEvqqxp/7pORQeRbSt
         7gW+JKQJv0ySn+ZOPtJcohKQfh+2y0YaiPn7tymceiaEw9cWyht4XufYuemhuP05863B
         KZB4kS+BlCHvCuomfVGJgfdjIUEzdDn6OdmqrDjkqhXMMLnNV5EJOgqtBLnp88fNAPJY
         C5uAmd7H71aypw0ZHDoTth3lFqBuSjj99YstUhVDZzEF3OE30hDayuSbnvFcyRC3kvO9
         yLWQ==
X-Gm-Message-State: APjAAAWb4196saiEXTQJ6+BN1AK5Lul7UdKpzmboApHPymlHU2gx+hVX
        2P3oqcemvhzA8Rcyp9ufTiDgc5/Mh4a6C+Wrquo=
X-Google-Smtp-Source: APXvYqx7IAHCRU5XSh1a7knGW50foiLQPvAyz67G0k3LxLpiCrj348ceCrY/qp+iIkejYfB2qQFj6OWyFx94zcjM3Ss=
X-Received: by 2002:a37:6397:: with SMTP id x145mr84094417qkb.56.1564729023065;
 Thu, 01 Aug 2019 23:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190801201242.16675-1-jlayton@kernel.org>
In-Reply-To: <20190801201242.16675-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 2 Aug 2019 14:56:51 +0800
Message-ID: <CAAM7YA=WRmQr0R2J3GK_Zv40drm0v9kptmenmDSNUmo=eQ4_Ew@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't freeze during write page faults
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 2, 2019 at 11:14 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Prevent freezing operations during write page faults. This is good
> practice for most filesystems, but especially for ceph since we're
> monkeying with the signal table here.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 563423891a98..731d96f8270d 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1548,6 +1548,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>         if (!prealloc_cf)
>                 return VM_FAULT_OOM;
>
> +       sb_start_pagefault(inode->i_sb);
>         ceph_block_sigs(&oldset);
>
>         if (ci->i_inline_version != CEPH_INLINE_NONE) {
> @@ -1622,6 +1623,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>         ceph_put_cap_refs(ci, got);
>  out_free:
>         ceph_restore_sigs(&oldset);
> +       sb_end_pagefault(inode->i_sb);
>         ceph_free_cap_flush(prealloc_cf);
>         if (err < 0)
>                 ret = vmf_error(err);
> --
> 2.21.0
>

Reviewed-by
