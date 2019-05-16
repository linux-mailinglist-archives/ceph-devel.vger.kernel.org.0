Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575591FD2E
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 03:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEPBqm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 21:46:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41332 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfEPBiH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 21:38:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id y22so2066165qtn.8
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 18:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0dpdtm12MV8pnfanNa6S7/5Y2GXKSwkRJUuSxkgnoWM=;
        b=MJuBushxwMraKarIkQ8vfQlTPT5KSJ8qaRS+/tJADztHkq6Y7xagvdR4mXsGq4Km8r
         vMZW5d2KSjP4x4zDGv+zjAny0n9lmWg/2rdjqghEZqoHO3Q8Ef9XA+rGLp/MSyhygJQg
         gWsjVHCcLceqEEbNlHGzVTN9tOVrW4P3tGsIZthVLCcbFaxoxnAkHEWGGCJEHuSyAcTI
         SIoi7iV7xhXNbuNw8bU7LGusEq6Cuod9BGyCqB2kYpG9FnKw16yHZCj8jaBkoyT1tUW2
         iM2KTtZJTTPqdRt1tPjIHYKjFku+lOEuiC4DVCFOPGq+di3GpKfmJkeg5lWc8XqE0hiL
         ToBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0dpdtm12MV8pnfanNa6S7/5Y2GXKSwkRJUuSxkgnoWM=;
        b=EvzfVKAjm6qqZdqU5xdxDyUqTA1m4YWAHVqb7QgsRleyINrJ1crZWdwYzmCVII0nj6
         qiJJXzq5nfCZ46vbjdUTwqPbb2zDicVoknNRtVt5wliGbCcwJz+yNur2CVHWJGxA4toj
         yWK+dyHw0NYwh3ieJg/0c9eAzY8QSqp2LYLHgIvdpTIw3sOz6Mji49nVYMMQsMg102OM
         qD6d+tQK8VG+Sjdu2BHtPaTfARlNtAmGSI2dVd4av9pyEd8YsdB802P23+AOFQxZDcJx
         6jJ/sUnAwueN07onOrOpdhJ9B9TXxhKf0Qzjcomo4YFUoDnOVmlSCFk+uSRnzrBqcPs1
         RH0Q==
X-Gm-Message-State: APjAAAWg99uNNX4YUjj++wxb9PgHQzuanPqyeaoQ+E6j9u/6Njv4P23T
        OQrhP/5Ll97C6Y0mVNAbfxSeJdSeTQIzNM0QTo7t6Xy8
X-Google-Smtp-Source: APXvYqzDSz1PPtcVynDLpwLATlln9kjf1bxNnvWDvmVkwH/JeayhTgYMDgFeFnWTIq6rxqk3EIq5KMfETI8GmC04ZDw=
X-Received: by 2002:ac8:913:: with SMTP id t19mr38097600qth.72.1557970686304;
 Wed, 15 May 2019 18:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190515145639.5206-1-ddiss@suse.de>
In-Reply-To: <20190515145639.5206-1-ddiss@suse.de>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 16 May 2019 09:37:55 +0800
Message-ID: <CAAM7YAnRUrYRsZPoq_2cj+bdoqs9gLa6nnFHuppiuH1kLAGjJA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix "ceph.dir.rctime" vxattr value
To:     David Disseldorp <ddiss@suse.de>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 15, 2019 at 10:56 PM David Disseldorp <ddiss@suse.de> wrote:
>
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
>
>  fs/ceph/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 0cc42c8879e9..aeb8550fb863 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -224,7 +224,7 @@ static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
>  static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
>                                        size_t size)
>  {
> -       return snprintf(val, size, "%lld.09%ld", ci->i_rctime.tv_sec,
> +       return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
>                         ci->i_rctime.tv_nsec);
>  }
>
> --
> 2.16.4
>

Both patches applied.

Thanks
Yan, Zheng
