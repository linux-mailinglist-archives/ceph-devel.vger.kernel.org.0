Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E529791DB5
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 09:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfHSHXr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 03:23:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45935 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHSHXq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 03:23:46 -0400
Received: by mail-io1-f65.google.com with SMTP id t3so2021036ioj.12
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 00:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S5E5ktGO+9iDUCJ8MBMXm2glkKvVvXkaFB8tG44weTY=;
        b=JvX0OI09wk5XwishHXW5U63+Bio2O0pXxlycV26PzQRGvEZ+W2JvEChlkmedNKWeCK
         KyKZSESw5AF38NVBJmIXAKAz6nTIg9FBvdNLr2G8wPsa298M/6t5JjUdnaYqwtroUTCc
         uyu93vBWoOjq4GTkBjL8OA04F35pe26n62BHP4YW0Ln24e4GZEp09f/g3mfLqwqHFKsU
         Dg8GUS80/pFlpL8NRBJyJoCHdf2RSZBoS1rHfKknNfpx8DJPZR/CGDHbNoQD7WDDwCyQ
         0ZDxR2bIT0UBNSjcji9XvlMy0FL6kFzSaPVUFVDbhWcu1JQH1wd8PmfutXljASWF9ZnH
         CY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S5E5ktGO+9iDUCJ8MBMXm2glkKvVvXkaFB8tG44weTY=;
        b=CD38ea1hzG+c3mrYNAHJkOflNUZ/s1+5BEzZ3GteaZGjH60DfSr0K4+zgV5iwpuPjX
         3a3BlbXLu7fIbykqY9T7rIii7MTYl7wLjSRd3+G6u2+SRVmbz3dn4Q9i35imNhhRRi/1
         BA2O/kFbliCODZAWXi6GulO1WIhfNVlqThu5Pm7t/7/5njvr2nZs8c3u+BmTehlOh54e
         OoYLKsWtFIG65pT1VqAbVa+iu+6B+g0Sv8WrkUKa8PiJnex+0EvsGxIMzJ8yueXz3RE5
         qyKpxcEm8cCCLzfSFw86ujJ6oQwxgeUPCB+fpoZjeceW+/qK8aXEZKE1qBmOUqsnOFTv
         n4rg==
X-Gm-Message-State: APjAAAV1qiJV/n8v6zxoibX3WR+TsWYkU8ycrGYkCjjHL9najSPH2bd6
        1BpJ0XSpFgd0otKymuEHJga0cUmY3iScsx7wlq4=
X-Google-Smtp-Source: APXvYqwm/zcuw4HDuo1kMbPJgEred1W0xgeZAPQA1HyUHZJmgQgShK32C/Bmz+3Bie98jtmjdO5rsbzq15UgOMIznd8=
X-Received: by 2002:a5d:9945:: with SMTP id v5mr10177430ios.143.1566199426141;
 Mon, 19 Aug 2019 00:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-2-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-2-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 09:26:45 +0200
Message-ID: <CAOi1vP8fFzVmKeQAqbk1om8tZ2fFw0xbT=LPSGJbiDsaaeo4xA@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] libceph: introduce ceph_extract_encoded_string_kvmalloc
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> When we are going to extract the encoded string, there
> would be a large string encoded.
>
> Especially in the journaling case, if we use the default
> journal object size, 16M, there could be a 16M string
> encoded in this object.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  include/linux/ceph/decode.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> index 450384f..555879f 100644
> --- a/include/linux/ceph/decode.h
> +++ b/include/linux/ceph/decode.h
> @@ -104,8 +104,11 @@ static inline bool ceph_has_room(void **p, void *end, size_t n)
>   *     beyond the "end" pointer provided (-ERANGE)
>   *   - memory could not be allocated for the result (-ENOMEM)
>   */
> -static inline char *ceph_extract_encoded_string(void **p, void *end,
> -                                               size_t *lenp, gfp_t gfp)
> +typedef void * (mem_alloc_t)(size_t size, gfp_t flags);
> +extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> +static inline char *extract_encoded_string(void **p, void *end,
> +                                          mem_alloc_t alloc_fn,
> +                                          size_t *lenp, gfp_t gfp)
>  {
>         u32 len;
>         void *sp = *p;
> @@ -115,7 +118,7 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
>         if (!ceph_has_room(&sp, end, len))
>                 goto bad;
>
> -       buf = kmalloc(len + 1, gfp);
> +       buf = alloc_fn(len + 1, gfp);
>         if (!buf)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -133,6 +136,18 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
>         return ERR_PTR(-ERANGE);
>  }
>
> +static inline char *ceph_extract_encoded_string(void **p, void *end,
> +                                               size_t *lenp, gfp_t gfp)
> +{
> +       return extract_encoded_string(p, end, kmalloc, lenp, gfp);
> +}
> +
> +static inline char *ceph_extract_encoded_string_kvmalloc(void **p, void *end,
> +                                                        size_t *lenp, gfp_t gfp)
> +{
> +       return extract_encoded_string(p, end, ceph_kvmalloc, lenp, gfp);
> +}
> +
>  /*
>   * skip helpers
>   */

This is only for replaying, right?

Thanks,

                Ilya
