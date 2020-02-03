Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E4150428
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 11:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBCKZK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 05:25:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39702 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgBCKZJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 05:25:09 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so16114910ioh.6
        for <ceph-devel@vger.kernel.org>; Mon, 03 Feb 2020 02:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rzmUpF7/CdTBxvwRQ8cX5vM/iKQO3iJ7nWmS48cGBg=;
        b=X/aEwURK5Ru1TMeI8WU7FSTup6M2ixhN2jDFzw4JcZogGOiyxJWoAu8BJzzUWlJyPe
         Ppq7gDXu53mnfCNVSck5sedw6dUAmkgBHKM1lkmwadt/o7wjRzD1VKufb6AcQ0SW4jGF
         aLIuvatIeMJIJPcKrX9BEhbFFWACi6BEIKGIs6lUblQEq7O/aR4FeoX0Zqx7fkJsGoy9
         WdzyuKT3AqYtK9NpBbpDsmlIcSPERVHZdW1j7OmuPA/SKnbWwOfiWe7KRAkk8x66bAkM
         euwH0f0oBCtQ0u/Eq0tGpNgsavDNesyVX8oGjd4Q5cK4WWzhaXXrwp2KVXA7+n4jfLDM
         XZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rzmUpF7/CdTBxvwRQ8cX5vM/iKQO3iJ7nWmS48cGBg=;
        b=rrpHTwF7ZM19NwtvbIHNiRt30U0yJm4KXQ6zsz6HoS8OORWE3UKdaUsVCZwjErPl6J
         lE8EV/p0ZNkdz2cm5HdnmB4IHqzGnqocbKjJ1ukl/vETLJ4d90cZo6aN+2H898H0qs7R
         vpmUQS+KQR6lO/00CtNE9OcR6xfAi8SYBAE5Ijw7RUuq0m5bBR5FcuLHAchwkXQwCSd+
         mFPWOKX5o9QP9+K8loHN/gCzfsD2p4813h9Ib6GifaqteaqY8uGhdP/SLk8njL8Gl/Th
         3f5mS8q8fw9BpabRnctx4pD2ows7ddGdsK5i+/UbF7/sHUz0HqIaY1esJfbN0eHKYDA7
         D4xA==
X-Gm-Message-State: APjAAAVdauFlO1BEDR5xB5aAbc27fvbUTnrehNJLqnDztkStlFlW3zxh
        WyMlh6FP+KrJjHzMtZlnUFgWGfxxi8DzKjYc5TE=
X-Google-Smtp-Source: APXvYqzi7/l9ero/Md5lSAVb6QIYVgp+6QGC6epn05tt71PZPm8So9pxMQy+Uubme1Uh5yYOs0RfAjUy4aP1cqt+4Yw=
X-Received: by 2002:a6b:1781:: with SMTP id 123mr17591111iox.282.1580725509195;
 Mon, 03 Feb 2020 02:25:09 -0800 (PST)
MIME-Version: 1.0
References: <20200203040133.39319-1-xiubli@redhat.com>
In-Reply-To: <20200203040133.39319-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 11:25:22 +0100
Message-ID: <CAOi1vP-pGZ1dBhr_EY8t=jas-16T887HTmtyJuVz70roKiYW1A@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: fix the debug message for calc_layout
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 3, 2020 at 5:02 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 108c9457d629..6afe36ffc1ba 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -113,10 +113,11 @@ static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
>         if (*objlen < orig_len) {
>                 *plen = *objlen;
>                 dout(" skipping last %llu, final file extent %llu~%llu\n",
> -                    orig_len - *plen, off, *plen);
> +                    orig_len - *plen, off, off + *plen);
>         }
>
> -       dout("calc_layout objnum=%llx %llu~%llu\n", *objnum, *objoff, *objlen);
> +       dout("calc_layout objnum=%llx, object extent %llu~%llu\n", *objnum,
> +            *objoff, *objoff + *objlen);

Hi Xiubo,

offset~length is how extents are printed both on the OSD side and
elsewhere in the kernel client.

Thanks,

                Ilya
