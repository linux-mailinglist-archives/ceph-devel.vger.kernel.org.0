Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB7F14A937
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jan 2020 18:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgA0Rq4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jan 2020 12:46:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:34615 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgA0Rq4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jan 2020 12:46:56 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so10998871iof.1;
        Mon, 27 Jan 2020 09:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0TUavpcHdqXN1KWx9EhrCO9VfvqNW5U75/TKE4ufb8=;
        b=i9m/OGqGzJnRZ6x90WTvzYlcM3OrUbt+EQOTVeSKC8Z+Q01hRuvqVmTL3ZtynkfJk+
         +1OZAMe4ViVd6KS+ZjcTe4kHLSSRoVr5LEWJtWNLEZz7P6GQrbXxkUG3WEW74aYgDit5
         ZLu2lkx5MxJYOvcVra/rzsF6F9IVyietpvGAsTZ628B2Nfgs3t8qrX5QWwWzYpLYOjm5
         yrs++J4Jf1+hsqlpHmz7MphkM36mrEkLO6gREOOQnBlsc3pwFp00fF8muQFN03OA5fPG
         bB5X0VMhVjv5v29U/NOxVI0y7opnBFiUZ+CTuQeoL2jaFGfbfGbzMz1FvOydKOA7TwWU
         Wrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0TUavpcHdqXN1KWx9EhrCO9VfvqNW5U75/TKE4ufb8=;
        b=Z0m7aYWoSCgi8vb0IE1dxCJ64JlEhuLwVVDnLRC0FkIjQW/7ikOkIMkKlteGAoAabO
         3FqkJ/UBY8+1/kOrvg42UMhZ7IvcLITr5IgAoVn6WvE6mnbqP+MyCCY9w+9q+KrC3mOC
         7JowP375wQ53AkoaRO4IRWqHQWTOjIMHU2omr/cqGxH2erYwwj0ZQrFs+pcagfCPtxwE
         RYn2scSJLZOFurPsdjr88lA++v63MBbxc2MDE2z4ZdwYEzQK/cjSDjwYTSOWiCkz8bij
         Lc0qj1YKozuXyOs9hdO5leBKrMYOSTq8UDIZqIQ3u5TbhodaTpqps+VnSY0JectvxiXY
         O2Uw==
X-Gm-Message-State: APjAAAXo4XM0dJAw05VwmY2r3bjC0t3gRGAJV4P1HLHfRe+QuNyXiDl+
        ovhCj3mFXxQNRD6+XaslyehEPnJrZLebKUlRtRXOyUj7Uew=
X-Google-Smtp-Source: APXvYqysuFAWtF0dsHft9617dGcfrQ8/iSuvarOV7N3nLqLhNGsUR6ujVJE2jTwgHkJOXCFHUbdfcXGsbO7wGwCI0io=
X-Received: by 2002:a6b:1781:: with SMTP id 123mr13014734iox.282.1580147215170;
 Mon, 27 Jan 2020 09:46:55 -0800 (PST)
MIME-Version: 1.0
References: <20200127164321.17468-1-lhenriques@suse.com> <20200127164321.17468-2-lhenriques@suse.com>
In-Reply-To: <20200127164321.17468-2-lhenriques@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 27 Jan 2020 18:47:02 +0100
Message-ID: <CAOi1vP9S3w13axR3FYxqFSZ1uF2V=0aMfnkcsMptMKL4W+-wEA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] libceph: add non-blocking version of ceph_osdc_copy_from()
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 5:43 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> A non-blocking version of ceph_osdc_copy_from will allow for callers to
> send 'copy-from' requests in bulk and wait for all of them to complete in
> the end.
>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  include/linux/ceph/osd_client.h | 12 ++++++++
>  net/ceph/osd_client.c           | 54 +++++++++++++++++++++++++--------
>  2 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 5a62dbd3f4c2..7916a178d137 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -537,6 +537,18 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>                         u32 truncate_seq, u64 truncate_size,
>                         u8 copy_from_flags);
>
> +struct ceph_osd_request *ceph_osdc_copy_from_nowait(
> +                       struct ceph_osd_client *osdc,
> +                       u64 src_snapid, u64 src_version,
> +                       struct ceph_object_id *src_oid,
> +                       struct ceph_object_locator *src_oloc,
> +                       u32 src_fadvise_flags,
> +                       struct ceph_object_id *dst_oid,
> +                       struct ceph_object_locator *dst_oloc,
> +                       u32 dst_fadvise_flags,
> +                       u32 truncate_seq, u64 truncate_size,
> +                       u8 copy_from_flags);
> +
>  /* watch/notify */
>  struct ceph_osd_linger_request *
>  ceph_osdc_watch(struct ceph_osd_client *osdc,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..7f984532f37c 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5346,23 +5346,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>         return 0;
>  }
>
> -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> -                       u64 src_snapid, u64 src_version,
> -                       struct ceph_object_id *src_oid,
> -                       struct ceph_object_locator *src_oloc,
> -                       u32 src_fadvise_flags,
> -                       struct ceph_object_id *dst_oid,
> -                       struct ceph_object_locator *dst_oloc,
> -                       u32 dst_fadvise_flags,
> -                       u32 truncate_seq, u64 truncate_size,
> -                       u8 copy_from_flags)
> +struct ceph_osd_request *ceph_osdc_copy_from_nowait(
> +               struct ceph_osd_client *osdc,
> +               u64 src_snapid, u64 src_version,
> +               struct ceph_object_id *src_oid,
> +               struct ceph_object_locator *src_oloc,
> +               u32 src_fadvise_flags,
> +               struct ceph_object_id *dst_oid,
> +               struct ceph_object_locator *dst_oloc,
> +               u32 dst_fadvise_flags,
> +               u32 truncate_seq, u64 truncate_size,
> +               u8 copy_from_flags)
>  {
>         struct ceph_osd_request *req;
>         int ret;
>
>         req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
>         if (!req)
> -               return -ENOMEM;
> +               return ERR_PTR(-ENOMEM);
>
>         req->r_flags = CEPH_OSD_FLAG_WRITE;
>
> @@ -5381,11 +5382,38 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>                 goto out;
>
>         ceph_osdc_start_request(osdc, req, false);
> -       ret = ceph_osdc_wait_request(osdc, req);
> +       return req;
>
>  out:
>         ceph_osdc_put_request(req);
> -       return ret;
> +       return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(ceph_osdc_copy_from_nowait);
> +
> +int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> +                       u64 src_snapid, u64 src_version,
> +                       struct ceph_object_id *src_oid,
> +                       struct ceph_object_locator *src_oloc,
> +                       u32 src_fadvise_flags,
> +                       struct ceph_object_id *dst_oid,
> +                       struct ceph_object_locator *dst_oloc,
> +                       u32 dst_fadvise_flags,
> +                       u32 truncate_seq, u64 truncate_size,
> +                       u8 copy_from_flags)
> +{
> +       struct ceph_osd_request *req;
> +
> +       req = ceph_osdc_copy_from_nowait(osdc,
> +                       src_snapid, src_version,
> +                       src_oid, src_oloc,
> +                       src_fadvise_flags,
> +                       dst_oid, dst_oloc,
> +                       dst_fadvise_flags,
> +                       truncate_seq, truncate_size,
> +                       copy_from_flags);
> +       if (IS_ERR(req))
> +               return PTR_ERR(req);
> +       return ceph_osdc_wait_request(osdc, req);

I don't think we need a blocking version.  Change ceph_osdc_copy_from()
and keep the name -- no need for async or nowait suffixes.

Thanks,

                Ilya
