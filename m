Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7007551CC
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfFYOfu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:35:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39598 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfFYOfu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:35:50 -0400
Received: by mail-io1-f68.google.com with SMTP id r185so3515490iod.6;
        Tue, 25 Jun 2019 07:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4FBl2kb9Q12PpnYpa3OFWNOR4QPgL14IwXIkF/APGc=;
        b=AqwXCb4MR2+p96JwYF9xQiAb6f8jOSAJ14XqFgrLKa6BOu9+BQk7J0IYaqxikkKACl
         MpsYVm3Tv07NyhtN88rdYHc6brn73Nei8wOK861KMG4PMMRIcCYs2Yxwj8F3eNZOy9Uw
         s3fVQKbrim/sM5N2/yd7HLOtNkBpWnaGhq48VOG9Zthztr3LrY4NKVx/2kNVL4Ixbn0y
         QK7VX9Ja9cb/SZABcPiFEVLkkKke9HtJuBoPQmApMXHehMTQP4n2nvsDPbUib8qupOqu
         UyMiPrbhKj4TU9IYRXsBZGptM5M7lYvpAlN0UAVW4lA3+yPnfC64wCxjVUaF1kivLTb0
         CgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4FBl2kb9Q12PpnYpa3OFWNOR4QPgL14IwXIkF/APGc=;
        b=dkmaq8UABj7fS+toIvkbcVaqP9r+Yjbw6tNbsfpUaWbdAPH0FNf5aq5RZkXEf6qCC1
         Kjx9Y7Cwl7YL0nBedaigyqDXWIhdGDLlTIE73VYDlPVTVdv8JpLm4hWH0xk9krB56scD
         lqhOFLpzIie5qonfMPm+tm7thPxURJ/e7hsZuyW1xRJVZvlbxRywcfkopz6hqEPwbvMs
         7AfZf0IPo1eY067DPE+9SwD/BCgUDjcrZN8jImi1J110qK+U/vRxsKzEftYCEPXOl6Eb
         qdDCOOUzPkUPoNG9NdLzk//TMN2gVrS2B5jlRu2/WaqL+aOGRr+TU6oib3yxN+W8OTya
         pTZA==
X-Gm-Message-State: APjAAAVGBcaqFT/h6bTQ43zL5Q1491q/oSbnz3/N4S+VKtUZnAtWVma/
        ghRHuR3mqeQP5AexqIDDFl32VMVYjMcG7Hjqeu12bMlT1k4=
X-Google-Smtp-Source: APXvYqzY1wYzaxVeLZGo/x3Ina8bunvFlXLEAzmrewz/4RxLjz3A2w2qU1FGwreXznfAa7UKOq3PfU0/6lpK42MDqfo=
X-Received: by 2002:a05:6638:149:: with SMTP id y9mr110950563jao.76.1561473349281;
 Tue, 25 Jun 2019 07:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190624162726.17413-1-jlayton@kernel.org> <20190624162726.17413-4-jlayton@kernel.org>
In-Reply-To: <20190624162726.17413-4-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 25 Jun 2019 16:35:59 +0200
Message-ID: <CAOi1vP_G9ybNs_QEn34cPvovAa=JB7G9F3FGy33QPH4yfST-iQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] ceph: don't NULL terminate virtual xattrs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        agruenba@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 6:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The convention with xattrs is to not store the termination with string
> data, given that it returns the length. This is how setfattr/getfattr
> operate.
>
> Most of ceph's virtual xattr routines use snprintf to plop the string
> directly into the destination buffer, but snprintf always NULL
> terminates the string. This means that if we send the kernel a buffer
> that is the exact length needed to hold the string, it'll end up
> truncated.
>
> Add a ceph_fmt_xattr helper function to format the string into an
> on-stack buffer that is should always be large enough to hold the whole
> thing and then memcpy the result into the destination buffer. If it does
> turn out that the formatted string won't fit in the on-stack buffer,
> then return -E2BIG and do a WARN_ONCE().
>
> Change over most of the virtual xattr routines to use the new helper. A
> couple of the xattrs are sourced from strings however, and it's
> difficult to know how long they'll be. Just have those memcpy the result
> in place after verifying the length.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 84 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 59 insertions(+), 25 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 9b77dca0b786..37b458a9af3a 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -109,22 +109,49 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
>         return ret;
>  }
>
> +/*
> + * The convention with strings in xattrs is that they should not be NULL
> + * terminated, since we're returning the length with them. snprintf always
> + * NULL terminates however, so call it on a temporary buffer and then memcpy
> + * the result into place.
> + */
> +static int ceph_fmt_xattr(char *val, size_t size, const char *fmt, ...)
> +{
> +       int ret;
> +       va_list args;
> +       char buf[96]; /* NB: reevaluate size if new vxattrs are added */
> +
> +       va_start(args, fmt);
> +       ret = vsnprintf(buf, size ? sizeof(buf) : 0, fmt, args);
> +       va_end(args);
> +
> +       /* Sanity check */
> +       if (size && ret + 1 > sizeof(buf)) {
> +               WARN_ONCE(true, "Returned length too big (%d)", ret);
> +               return -E2BIG;
> +       }
> +
> +       if (ret <= size)
> +               memcpy(val, buf, ret);
> +       return ret;
> +}

Nit: perhaps check size at the top and bail early instead of checking
it at every step?

Thanks,

                Ilya
